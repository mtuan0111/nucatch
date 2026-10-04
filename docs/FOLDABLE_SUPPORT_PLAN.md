# Foldable & Dual-Screen Support Plan

Goal: Nucatch plays well and keeps game state on every foldable form factor:
Galaxy Z Fold (cover + inner screen), Galaxy Z Flip (inner + Flex Window cover
screen), dual-screen Android (Surface Duo), and a future foldable iPhone.

---

## 1. Target devices & the screen shapes they produce

All sizes are approximate logical pixels (dp). Confirm them on emulators or
Samsung Remote Test Lab before tuning breakpoints.

| Device / state | Logical size (portrait) | Aspect | Hinge reported in `MediaQuery.displayFeatures` | What the app sees today |
|---|---|---|---|---|
| Z Fold, cover screen | ~344–373 × ~800–880 | ~22:9, very tall and narrow | none | `mobile`; narrow keypad |
| Z Fold, inner, flat | ~840–880 × ~700–750 (landscape-ish) | ~1.2:1, near-square | `fold`, vertical, `postureFlat`, zero width | `tablet` (shortestSide ≥ 600) |
| Z Fold, inner, half-open (**book**) | same | same | `fold`, vertical, `postureHalfOpened` | ignored |
| Z Fold, inner rotated, half-open (**tabletop**) | same | same | `fold`, horizontal, `postureHalfOpened` | ignored |
| Z Flip, inner, flat | ~412 × ~990 | 22:9 | `fold`, horizontal, `postureFlat` | `mobile` portrait |
| Z Flip, half-open (**Flex Mode / tabletop**) | same | same | `fold`, horizontal, `postureHalfOpened` | ignored; keypad straddles the crease |
| Z Flip 5+ cover (Flex Window) | ~3.4"–4", ~1:1.1 | **near-square** | none | `mobile`, and it can report **landscape**, which triggers the gamepad split in tiny clusters ⚠️ |
| Surface Duo, single screen | ~540 × ~720 | 3:4 | none | `mobile` |
| Surface Duo, **spanned** | ~1114 × ~720 (incl. hinge) | — | `hinge`, vertical, **non-zero width** (physical gap) | content centered on the hinge ⚠️ |
| Foldable iPhone (unreleased or unconfirmed specs) | unknown | likely book-style near-square inner + phone cover | **none**: iOS has no public hinge or posture API | handled by size alone |
| Android split-screen / freeform / iPad Stage Manager | arbitrary, can be ~300 dp tall | any | none | untested |

> "iPhone duo" isn't a shipping device. This plan treats it as two things:
> **Surface Duo** (dual-screen Android, discontinued but the reference device
> for the `hinge` API) and the **foldable iPhone** (size-only support, no hinge API).

---

## 2. Current-state audit (what's already right, what breaks)

### Already in good shape
- `android/app/src/main/AndroidManifest.xml`: `resizeableActivity="true"`, and
  `configChanges` already includes
  `screenSize|smallestScreenSize|screenLayout|density|orientation`. Folding and
  unfolding therefore does **not** recreate the Activity, so the Flutter engine
  and all BLoC state survive.
- There are no `SystemChrome.setPreferredOrientations` locks anywhere in the
  app or `skeleton_core`, so all orientations are allowed.
- `ios/Runner/Info.plist` supports portrait and both landscapes on iPhone, plus
  all four orientations on iPad, and has no `UIRequiresFullScreen`. That's
  correct for a foldable iPhone and for iPad multitasking.
- Game state is fully in BLoCs (`TurnBloc`, `CombatBloc`), not in widget state.
- Flutter's `showDialog` and modal routes already wrap content in
  `DisplayFeatureSubScreen`, so stock dialogs avoid a hinge automatically.

### Gaps
| # | Location | Problem on foldables |
|---|---|---|
| G1 | `skeleton_core/lib/src/helpers/device_type.dart` | Classification is only `shortestSide` (600 / 1200) plus `orientation`. There's no aspect ratio, no window-size class, and no posture or hinge awareness. |
| G2 | `lib/screens/menu_screens/player/play_screen.dart:254-840`, `combat_play_screen.dart:263-350` | Layout choice is `isLandscapeOrientation`, so a near-square screen (Flip cover, Fold inner) that's 1 dp wider than tall gets the gamepad 3-column split. Tabletop and spanned postures put the keypad across the crease or hinge. The two screens duplicate this branching. |
| G3 | `lib/widgets/regular_mode_controls.dart:123`, `combat_play_screen.dart:1115`, `pick_right_mode_controls.dart:94` | Square-cell clamping is keyed on `context.isTablet` rather than on the actual constraints, so cells stretch on Flip inner and Fold cover (tall, narrow, `mobile`). |
| G4 | `skeleton_core` `DeviceWrapper` (`template_widgets.dart:1362`) | Centers a ≤800 px column on the full window. On a spanned Duo, that column sits directly over the hinge. |
| G5 | `tour_spotlight_overlay.dart:41-50`, `tutorial_overlay.dart:109`, `tour_keys.dart:94` | Spotlight rects come from `localToGlobal` at build time. Nothing re-measures on a fold or unfold during a tour, and tooltips can land on the hinge. |
| G6 | `play_screen.dart:1032`, `combat_play_screen.dart:1366` | The animation fallback anchor is `size.width/2, size.height/3`, which is on the hinge on a spanned Duo. |
| G7 | Whole app (no `WidgetsBindingObserver` / `AppLifecycleListener`) | Closing a Flip, or folding a Fold when "continue on cover screen" is off, backgrounds the app while the **turn timer keeps running**. The player loses lives while the phone is shut. |
| G8 | `skeleton_core/lib/src/widgets/admob_banner.dart:131` | Fixed `AdSize.banner`. It isn't re-requested when the width changes by 2× on unfold. |
| G9 | `play_screen.dart:43`, `combat_play_screen.dart:36` | `screenWidth => max(width, kMinScreenWidth)` is unused (only referenced in commented-out code). Remove it so nobody builds on a wrong number. |
| G10 | `integration_test/screen_walkthrough.dart:90`, `tour_guide_test.dart:125` | Device profiles cover only phone and iPad. There are no foldable sizes and no simulated `displayFeatures`. |

---

## 3. Design: one layout vocabulary for the whole app

Add a single, testable abstraction in **`skeleton_core`**, because `o_an_quan`
and `mind_compass` share the package and benefit from it too.

### 3.1 `skeleton_core/lib/src/helpers/screen_posture.dart` (new)

```dart
enum WindowWidthClass { compact, medium, expanded }   // <600, 600–839, ≥840 (Material 3)
enum WindowHeightClass { compact, medium, expanded }  // <480, 480–899, ≥900

enum ScreenPosture {
  normal,     // no fold, or flat fold with zero-width crease
  tabletop,   // horizontal fold/hinge, half-opened (Flip Flex Mode, Fold rotated)
  book,       // vertical fold, half-opened (Fold held like a book)
  spanned,    // any hinge with a non-zero occlusion (Surface Duo spanned)
}

extension ScreenPostureContext on BuildContext {
  WindowWidthClass get windowWidthClass;
  WindowHeightClass get windowHeightClass;
  double get aspectRatio;            // long side / short side
  bool get isNearSquare;             // aspectRatio < 1.3 (Flip cover, Fold inner)
  DisplayFeature? get foldFeature;   // first hinge/fold from MediaQuery.displayFeatures
  ScreenPosture get posture;
  Axis? get foldAxis;                // horizontal / vertical / null
  /// Rects of the usable panes on each side of the fold (1 or 2).
  List<Rect> get panes;
}
```

Rules:
- Use `MediaQuery.displayFeaturesOf(context)` and keep only the `hinge` and
  `fold` types; drop `cutout`.
- `tabletop` / `book` require `state == DisplayFeatureState.postureHalfOpened`.
  A flat Fold should **not** split the UI, because a flat Fold inner screen is
  a tablet.
- `spanned` = `bounds.width > 0 || bounds.height > 0`, whatever the posture
  state is. Content must never be drawn under a physical hinge.
- Use `MediaQuery.sizeOf`, `displayFeaturesOf` and similar aspect-specific
  accessors so widgets only rebuild for what they read.

### 3.2 `GameLayoutMode`: one decision function for both game screens

```dart
enum GameLayoutMode {
  stacked,      // header over controls (phones, Flip inner, Fold cover)
  compactSquare,// near-square & small (Flip cover): slim header, controls fill the rest
  gamepad,      // landscape with aspect ≥ 1.3 and enough height: split keypad on edges
  tabletop,     // header in top pane, controls in bottom pane, split AT the fold
  twoPane,      // book/spanned: header in one pane, controls in the other
}

GameLayoutMode resolveGameLayout(BuildContext context);
```

Decision order: `spanned/book → twoPane`, `tabletop → tabletop`,
`isNearSquare && windowWidthClass == compact → compactSquare`,
`landscape && aspectRatio ≥ 1.3 && height ≥ 320 → gamepad`, otherwise `stacked`.

### 3.3 `FoldAwareSplit` widget (new, `skeleton_core`)

`FoldAwareSplit({required Widget first, required Widget second, Axis? axis, double flexFallback})`
- When a fold or hinge exists along `axis`, it sizes `first` and `second`
  exactly to the two panes and inserts a `SizedBox` equal to the hinge
  thickness.
- Without a fold, it falls back to `Flex` with the given ratio, which keeps
  today's look.
- Write this instead of adding the `dual_screen` package (Microsoft,
  low-maintenance since Duo was discontinued). It's ~80 lines on top of
  `displayFeatures`.

---

## 4. Work breakdown

### Phase 0: Test bench (½–1 day)
1. Create Android emulators: **7.6" Fold-in with outer display**, **6.7"
   Horizontal Fold-in** (Flip), **8" Fold-out**, **Resizable (Experimental)**,
   and the **Surface Duo emulator** image from Microsoft.
2. Book Samsung Remote Test Lab sessions for a real Z Fold and Z Flip with a
   Flex Window cover screen. The cover screen can't be emulated faithfully.
3. Add `test/helpers/foldable_harness.dart`. It pumps a widget with
   `tester.view.physicalSize`, `devicePixelRatio` and a
   `MediaQuery(displayFeatures: [...])` override for each posture in
   section 1. Every later phase uses it.

### Phase 1: Foundation in `skeleton_core` (2 days) → fixes G1, G4
1. Implement `screen_posture.dart` (section 3.1) and export it from
   `skeleton_core.dart`.
2. Implement `FoldAwareSplit` (section 3.3).
3. Make `DeviceWrapper` hinge-aware. In `spanned`/`book`, constrain and center
   the child **inside the pane the content belongs to**, or render it with
   `DisplayFeatureSubScreen` so it picks a side. Expose
   `DeviceWrapper.pane(int index)` for screens that want to choose.
4. Keep the `isTablet`, `isLandscapeOrientation` and `isTabletLandscape`
   names, since `o_an_quan` depends on them. Mark the orientation-only ones as
   "prefer `windowWidthClass` / `aspectRatio`" in their doc comments.
5. Unit-test every getter against the device matrix (section 1).

### Phase 2: Gameplay screens (3–4 days) → fixes G2, G3, G6
1. Extract the duplicated `isLandscape ? Row : Column` block from
   `play_screen.dart` and `combat_play_screen.dart` into
   `lib/widgets/game_layout.dart`:
   `GameLayout({header, controlsBuilder(GamepadKeypadSide?)})` switches on
   `resolveGameLayout`.
2. Per-mode layouts:
   - **stacked**: keep today's portrait layout (flex 1:2). The Fold inner
     screen uses this layout in **both** orientations (section 6.2), with
     keypad cells clamped square and centered.
   - **compactSquare** (Flip cover): one-line header (timer bar, score, lives
     inline), challenge text auto-shrinks with `FittedBox`, keypad fills the
     rest, and the quick-settings overlay collapses to one icon.
   - **gamepad**: keep today's landscape layout, but only when
     `aspectRatio ≥ 1.3`.
   - **tabletop** (Flip/Fold half-open): `FoldAwareSplit(axis: vertical)` puts
     the header and challenge in the top pane (the "screen") and the keypad in
     the bottom pane (the "keyboard"). Make this the showcase mode.
   - **twoPane** (Duo spanned or Fold book): header left, keypad right, and no
     button within the hinge rect.
3. Replace `clampCells = context.isTablet` in `regular_mode_controls.dart:123`,
   `combat_play_screen.dart:1115` and `pick_right_mode_controls.dart:94` with a
   constraint-based rule: clamp to square whenever
   `rawHeight / rawWidth > 1.25` or the reverse. Enforce a **48 dp minimum hit
   target**. If cells would fall below that (tiny split-screen), go to the
   "window too small" state (Phase 4.4).
4. Replace the `size/2, size/3` animation fallbacks (G6) with
   `context.panes.first.center` or the pane holding the header.
5. `CountdownOverlay` and the game-over transition: wrap them in
   `DisplayFeatureSubScreen` so the 3-2-1 renders in one pane, not on the
   crease.
6. Delete the dead `screenWidth` getters (G9).

### Phase 3: Menus, result and room screens (2–3 days)
Screens: `menu_screen.dart:151`, `top_score_screen.dart:150-299`,
`select_play_mode_screen.dart:46`, `set_difficult_screen.dart:160`,
`gameover_screen.dart:77-179`, `combat_mode_setup_screen.dart:57`,
`host_room_screen.dart:329-494`, `join_room_screen.dart:324-620`,
`combat_game_end_screen.dart:74-255`, `about_screen.dart:227`.

1. Replace `context.isTablet || context.isLandscapeOrientation` with
   `context.windowWidthClass != WindowWidthClass.compact`. Replace
   `isLandscapeOrientation ? 1200 : null` with a width-class lookup.
2. `ResponsiveGrid` (`skeleton_core/.../responsive_layout.dart`): choose
   columns from width class, not orientation. On `spanned`, force exactly one
   column per pane so no card straddles the hinge.
3. Opportunistic two-pane (book/spanned or expanded width):
   - **Top score → Top score details**: list in pane 1, details in pane 2, so
     there's no push navigation.
   - **Host / Join room**: room list or QR in pane 1, lobby/players in pane 2.
   - **Game over / Combat end**: summary in pane 1, leaderboard in pane 2.
4. Dialogs and sheets: audit the 11 `showDialog`/`showModalBottomSheet` call
   sites plus `combat_dialogs.dart`. Stock routes are hinge-safe. Any custom
   `Overlay`/`Stack` popups must be wrapped in `DisplayFeatureSubScreen`.

### Phase 4: Continuity & lifecycle (2 days) → fixes G5, G7
1. **Auto-pause on fold or close.** Add an `AppLifecycleListener` in
   `PlayScreen` and `CombatPlayScreen`:
   - `onInactive` / `onHide` / `onPause` → `TapTimerPause` /
     `CombatTapTimerPause` (they already exist; reuse them).
   - `onResume` / `onShow` → show the existing `CountdownOverlay` 3-2-1, then
     resume.
2. **Pause on fold-state change.** A Fold continuing from cover to inner stays
   `resumed` but the layout jumps. Detect a `GameLayoutMode` change during
   `TurnStatus.playing` with `didChangeDependencies` comparison and apply the
   same pause → countdown → resume. This prevents a lost tap during the
   re-layout.
3. **Combat: pause both players over BLE** (decided, section 6.1).
   - Protocol: add `pause` and `resume` messages to `combat_ble_service.dart`
     and `combat_room_service.dart`. Each carries the sender id and a
     monotonically increasing pause sequence number, so duplicate or
     out-of-order packets are ignored.
   - `CombatBloc`: the local pause dispatches `CombatTapTimerPause` and sends
     `pause`. A received `pause` dispatches `CombatTapTimerPause` and shows an
     "Opponent paused (folded their phone)" banner. The round resumes only
     when **both** sides are resumed. The host then broadcasts a start
     timestamp for a shared 3-2-1, so both timers restart together.
   - Timeouts: if a paused player doesn't come back within **60 s**, the
     other player can claim the win. If the BLE link drops while paused,
     follow the existing disconnect handling.
   - Every pause trigger goes through this path: lifecycle (4.1),
     layout-mode change (4.2), and window too small (4.4).
4. **Window too small.** If the available height is under ~360 dp or keypad
   cells are under 48 dp (split-screen, freeform), show a "Make the window
   bigger to keep playing" card and auto-pause.
5. **Tour and tutorial re-measure (G5).** In `tour_spotlight_overlay.dart`,
   `tutorial_overlay.dart` and `tour_keys.dart`, recompute target rects in a
   post-frame callback whenever `MediaQuery.sizeOf` or `displayFeaturesOf`
   changes. Place the tooltip in the pane containing the target, flipping
   above/below or left/right so it never overlaps the hinge rect.
6. **GlobalKey safety.** Switching layout modes reparents widgets that hold
   `TourKeys` GlobalKeys. Verify there are never two mounted owners during the
   transition, especially in gamepad mode with duplicated keypad columns. Add
   a widget test that flips the posture mid-game.
7. **Ads (G8).** In `admob_banner.dart`, use
   `AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width)` and
   reload when the width changes by more than ~20%.

### Phase 5: Platform configuration (½ day)
**Android**
- Keep `resizeableActivity="true"` and the current `configChanges` (verified
  complete). Don't add `maxAspectRatio`/`minAspectRatio` or a fixed
  `screenOrientation`. With `targetSdk 36`, Android 16 ignores orientation and
  resizability restrictions on large screens (sw ≥ 600 dp) anyway.
- Hinge data comes from `androidx.window`, which Flutter's Android embedding
  already bundles. No new plugin is needed. Verify that `displayFeatures` is
  populated on the Fold emulator in a debug build.
- **Flex Window (Flip cover):** check Samsung's current Flex Window developer
  guidance for any manifest opt-in or allow-list requirement. Rules have
  changed between Flip 5, 6 and 7. Make sure the launcher icon and splash
  render correctly on a ~1:1 screen.
- Cover ↔ main continuity: test with "Continue apps on cover screen" both
  **on** and **off**.

**iOS / foldable iPhone**
- No hinge or posture API exists, so support is size-driven. Phases 1–3
  already cover it, because posture falls back to `normal` and width class or
  aspect ratio do the work.
- Keep `UIRequiresFullScreen` absent. That also gives iPad Split View and
  Stage Manager support, a good proxy for arbitrary iPhone-fold sizes.
- Optional: add `UIInterfaceOrientationPortraitUpsideDown` to the iPhone
  orientation list. It's harmless and may matter for a book-style inner
  display.
- When Apple publishes the device and simulator, add it to the screenshot
  matrix (Phase 6).

### Phase 6: Automated tests & screenshots (2 days) → fixes G10
1. **Widget tests** (`test/layout/`) using the Phase 0 harness, covering each
   row of the section 1 table:
   - assert the `resolveGameLayout` result
   - assert no `RenderFlex` overflow
   - assert no tappable keypad widget's global rect intersects the hinge rect
   - assert all keypad cells are ≥ 48 dp
2. **Golden tests** for `PlayScreen` (regular and pick-right) and
   `CombatPlayScreen` in: Fold cover, Fold inner flat, Fold tabletop, Flip
   inner, Flip tabletop, Flip cover, Duo spanned.
3. **Integration**: extend the `screen_walkthrough.dart` profile list
   (currently `Size(1080, 2400) @ 2.625`) with foldable profiles. Add a
   `store_screenshots_test.dart` variant for the Play Console
   foldable/large-screen listing.
4. **Lifecycle test**: start a timed turn, simulate
   `AppLifecycleState.paused`, advance the clock, resume, and assert that no
   life was lost and the countdown played.

### Phase 7: Manual QA checklist (1–2 days, real devices)
For each of: Z Fold (cover, inner flat, book, tabletop), Z Flip (inner,
Flex Mode, cover), Surface Duo (single, spanned, both orientations), Android
split-screen at 1/3 and 1/2, iPad Stage Manager smallest window:
- [ ] Solo regular mode: whole round, every key reachable, none on the crease or hinge
- [ ] Solo pick-right mode
- [ ] Combat host + join over BLE, folding one device mid-round
- [ ] Fold or unfold mid-round: game pauses, 3-2-1, resumes, score intact
- [ ] Close a Flip mid-round, then reopen: paused, no lives lost
- [ ] Tour / tutorial: spotlight follows the target after a fold change
- [ ] Every dialog: stays in one pane
- [ ] Banner ad: re-sized after unfold
- [ ] Text scale at max font setting: no overflow in compactSquare
- [ ] Rotation in each state

### Phase 8: Store & release (½ day)
- Play Console: review the **large-screen app quality** guidelines (tier 2
  "optimized") and upload foldable or tablet screenshots. The
  `tenInchScreenshots` folder already exists.
- Mention the tabletop / Flex Mode keypad in release notes as a feature.
- Bump the `skeleton_core` `deployment_production` ref, then smoke-test
  `o_an_quan` and `mind_compass`, since they inherit the new
  `DeviceWrapper`/`ResponsiveGrid` behavior.

---

## 5. Estimate & sequencing

| Phase | Effort | Depends on |
|---|---|---|
| 0 Test bench | 0.5–1 d | — |
| 1 skeleton_core foundation | 2 d | 0 |
| 2 Gameplay screens | 3–4 d | 1 |
| 3 Menus / two-pane | 2–3 d | 1 |
| 4 Lifecycle & continuity (incl. BLE pause protocol) | 3–4 d | 2 |
| 5 Platform config | 0.5 d | — (parallel) |
| 6 Tests & screenshots | 2 d | 2, 3 |
| 7 Manual QA | 1–2 d | all |
| 8 Release | 0.5 d | 7 |
| **Total** | **~15–20 dev-days** | |

Suggested release slicing:
1. **v-next (must-have):** Phases 1, 2 (stacked/compactSquare/gamepad fixes +
   tabletop), 4.1–4.4 **including the BLE pause protocol**, and 5. This fixes
   broken play on the Flip cover and the Fold, and stops the timer running
   while the phone is closed. The BLE protocol has to ship with the lifecycle
   pause: pausing only one side of a combat would desync the two timers.
2. **v-next+1:** spanned/book two-pane gameplay, the Phase 3 two-pane screens,
   and tour re-measure.

## 5a. Progress (2026-10-02)

The `skeleton_core` foundation (Phase 1) already exists, built during the
`o_an_quan` foldable work. It is still **uncommitted** in `skeleton_core`.
The names differ from section 3:

| Plan name | Actual in `skeleton_core` |
|---|---|
| `screen_posture.dart`, `ScreenPosture` | `helpers/fold_layout.dart`: `FoldLayout`, `FoldPosture { flat, book, tabletop }`, `panes`, `straddlesSeparator`, `LocalDisplayFeatures` |
| `WindowWidthClass` / `WindowHeightClass` | `helpers/window_size_class.dart`: `WindowSizeClass`, `context.windowWidthClass` / `windowHeightClass` |
| `FoldAwareSplit` | `widgets/hinge_split.dart`: `HingeSplit` (gives each pane its own `MediaQuery`) |
| `DeviceWrapper` / `ResponsiveGrid` / banner fixes | narrow-window gutters, `ResponsiveGrid._wideColumns`, `AdMobBanner(adaptive: true)` |

Done in nucatch:
- **Phase 0:** `test/helpers/foldable_devices.dart` covers 13 window profiles,
  with hinges and folds in logical pixels like the real engine. The AVDs
  `Foldable_7_6` and `Flip_6_7` are created.
- **Phase 2:**
  - `lib/helpers/game_layout.dart` holds `GameLayoutMode` and
    `GameLayout.resolve`, plus the keypad spacing and clamp rules.
  - `lib/widgets/game_layout_body.dart` replaces the duplicated
    `isLandscape ? Row : Column` block in both `PlayScreen` and
    `CombatPlayScreen`. It splits across the fold with `HingeSplit`.
  - Keypad cells clamp square based on the space available, not
    `isTablet`, and the button gap shrinks on cramped windows.
  - The `CountdownOverlay` circle stays off the hinge.
  - The dead `screenWidth` getters are removed (G9).
- **Phase 4.1/4.2 (solo):**
  - `TimerPauseReason` / `TimerPauseHolds` hold pause reasons in `TurnBloc`
    and `CombatBloc`, so the menu and the app lifecycle can't unpause each
    other.
  - `GamePauseGuard` pauses `PlayScreen` on background or on a layout-mode
    change, then resumes after a 3-2-1.
- **Tests:** `test/layout/*` (resolver matrix, `GameLayoutBody` on every
  profile with hinge-straddle checks, pause guard) and
  `test/blocs/timer_pause_test.dart`.

- **Phase 4.3 (combat BLE pause):**
  - The `pause_update` message carries `{paused, seq}`, and the receiver
    ignores stale or duplicate sequence numbers.
  - `CombatPlayScreen` uses `GamePauseGuard`. Its away and resuming hooks send
    the update.
  - The opponent sees `OpponentPausedOverlay`, then the same 3-2-1. Both
    timers are held by `TimerPauseReason.opponent` until it ends.
  - After 60 s, "Claim win" ends the game with `GameEndReason.opponentAway`,
    which the other device sees as `myAway`.
  - New strings are added in all 10 locales.
  - Tests: `test/blocs/combat_pause_sync_test.dart`.
- **Emulator runs:** `integration_test/foldable_walkthrough_test.dart` on
  `Foldable_7_6` gave zero overflows on every screen in both postures:
  - Open: the app sees no fold, so the layout is `stacked`.
  - Half-open: the app sees a hinge, so the layout is `twoPane`.

  Set the posture with `adb emu posture 2` or `adb emu posture 3`. The
  `cmd device_state state N` override does **not** change what apps see.
  The emulator reports half-open as a 0.3 dp `hinge` with state
  `postureFlat`. Real Samsung hardware should report a zero-width `fold` with
  state `postureHalfOpened`; confirm this on a device.

Not yet done:
- **Flip checks:** the Flip cover screen (`compactSquare`) and Flip Flex Mode
  haven't been run. The Flip_6_7 AVD has no cover display. A real Z Flip4 is
  available for testing.
- **Two-device BLE test:** the pause sync is unit-tested only. No real
  two-device run yet.
- Tour/tutorial re-measure (4.5), window-too-small (4.4), Phase 3 screens,
  Phase 5–8.

## 6. Decisions (resolved 2026-10-02)
1. **Combat pause semantics:** when either player's device pauses (folded,
   closed, backgrounded, or a layout-mode change mid-round), **both players
   pause over BLE**. Both then resume through a shared 3-2-1 countdown. See
   Phase 4.3.
2. **Fold inner screen in landscape** (aspect ~1.2) uses the **`stacked`**
   layout, not the gamepad split. The `aspectRatio ≥ 1.3` gate in section 3.2
   gives this result automatically. Add a widget test that pins it.
3. **Flex Window (Flip cover screen)** is **fully playable**, using the
   `compactSquare` layout in Phase 2.2. A "Open your phone to play" prompt is
   only for windows below the Phase 4.4 minimum.
4. **`screen_posture.dart`, `FoldAwareSplit`, and the hinge-aware
   `DeviceWrapper`/`ResponsiveGrid` ship in `skeleton_core`.** Before bumping
   the `deployment_production` ref, smoke-test `o_an_quan` and `mind_compass`
   (Phase 8).
