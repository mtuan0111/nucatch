# Testing the tour and the game layouts

## Unit and widget tests

```bash
flutter test                                         # everything under test/
flutter test test/blocs/tutorial_cubit_test.dart     # lesson pointer, Previous rules
flutter test test/helpers/tour_progress_test.dart    # menu order, labels
flutter test test/layout/keypad_spacing_test.dart    # keys never touch
```

| File | Covers |
|---|---|
| `test/blocs/tutorial_cubit_test.dart` | start / next / previous / finish / `backToMenuTour`, re-seeding, Previous always landing on a lesson that sets the game up |
| `test/helpers/tour_progress_test.dart` | 5 menu steps, Next/Previous order, old saved steps, per-part lesson counts |
| `test/helpers/combat_tutorial_script_test.dart` | scripted opponent timings |
| `test/layout/game_layout_test.dart` | `GameLayout.resolve` for every window profile |
| `test/layout/game_layout_body_test.dart` | header + keypad placement, nothing across a hinge |
| `test/layout/game_pause_guard_test.dart` | pause / 3-2-1 resume on lifecycle and layout changes |
| `test/layout/keypad_spacing_test.dart` | real keypad on phone, tablet, Fold tabletop pane, Flip cover — full grid and both gamepad clusters: ≥ 2 pt between keys, all keys inside their area |

Window profiles (phones, Fold cover / inner / book / tabletop, Flip, tablets)
are in `test/helpers/foldable_devices.dart`.

## The full-tour integration test

`integration_test/tour_guide_test.dart` walks the **whole tour forwards and
back** on a real device or simulator:

- **every step**: the card's title and "Part · n / N" label; the card fully on
  screen with its buttons tappable; the highlighted element on screen and
  less than half covered by the card;
- **every step after the first**: taps Previous, checks where it lands
  (`TourProgress.previousBefore` / `TutorialCubit.previousSeededIndex`),
  then plays forward again;
- **every lesson that sets the game up**: the real `TurnBloc` / `CombatBloc`
  holds that lesson's number / question, whether reached with Next or
  Previous;
- any `RenderFlex overflowed` fails the run.

Lessons are completed from `TutorialScript` (tap Next, the required key or
answer, or wait for the real timer / scripted opponent), so the test needs
no edits when lessons are added, removed or reordered. It takes about two
minutes.

```bash
flutter test integration_test/tour_guide_test.dart -d <deviceId>
```

Screen shape via `--dart-define` (the test forces the size and clears the
device's own hinge):

| Define | Screen |
|---|---|
| *(none)* | phone portrait, 1080×2400 @ 2.625 |
| `LANDSCAPE=true` | rotate whichever screen is chosen |
| `IPAD=true` | iPad, 1640×2360 @ 2 |
| `FOLD_COVER=true` | Galaxy Z Fold7 cover screen, 1080×2520 @ 2.8125 |
| `FONT_SIZE=<n>` | the app's font-size setting |
| `NUCATCH_LOCALE=<code>` | run the whole tour in that language (`de`, `ja`, …); buttons are tapped by their translated labels |
| `SHOT_DIR=<absolute path>` | save a PNG of every card the test checks |

All 10 languages, with a screenshot of every card (iPhone portrait passed
2026-10-09):

```bash
for loc in en de es fr hi id ja th vi zh; do
  flutter test integration_test/tour_guide_test.dart -d $IPHONE \
    --dart-define=NUCATCH_LOCALE=$loc --dart-define=SHOT_DIR=/abs/path/tour/$loc
done
```

The matrix that should pass before a release:

```bash
IPHONE=<iPhone simulator id>; IPAD=<iPad simulator id>; ANDROID=emulator-5554
flutter test integration_test/tour_guide_test.dart -d $IPHONE
flutter test integration_test/tour_guide_test.dart -d $IPHONE --dart-define=LANDSCAPE=true
flutter test integration_test/tour_guide_test.dart -d $IPAD --dart-define=IPAD=true
flutter test integration_test/tour_guide_test.dart -d $IPAD --dart-define=IPAD=true --dart-define=LANDSCAPE=true
flutter test integration_test/tour_guide_test.dart -d $ANDROID --dart-define=FOLD_COVER=true
```

## Foldables at their native window

`integration_test/foldable_walkthrough_test.dart` walks every screen at the
device's own window and hinge. On the `Foldable_7_6` emulator set the posture
first:

```bash
adb -s emulator-5554 emu posture 3   # opened  → no fold reported → stacked
adb -s emulator-5554 emu posture 2   # half-opened → 0.3 dp hinge → twoPane
adb -s emulator-5554 emu posture 1   # closed — still reports the INNER display
flutter test integration_test/foldable_walkthrough_test.dart -d emulator-5554 \
  --dart-define=SKIP_SHOTS=true --dart-define=COLLECT_OVERFLOWS=true
```

- The emulator's "closed" posture doesn't switch the app to the cover
  screen; test the cover screen with `FOLD_COVER=true` instead.
- `cmd device_state state N` does **not** change what apps see; use
  `adb emu posture`.
- Real Samsung hardware reports half-open as a zero-width `fold`, not the
  emulator's 0.3 dp `hinge` — confirm on a device.
- To check switching postures mid-game, cycle `adb emu posture 2/1/3` every
  ~12 s while a test runs; the tour must still pass and the spotlight must
  follow the moved keys.

## Seeing what the test saw

Integration tests draw to Flutter's test surface, not the simulator screen:
`xcrun simctl io … screenshot` returns a blank "Test starting…" image.
Capture inside the test instead:

```dart
final rv = tester.binding.renderViews.first;
final image = await (rv.debugLayer! as OffsetLayer)
    .toImage(rv.paintBounds, pixelRatio: 1);
final png = await image.toByteData(format: ui.ImageByteFormat.png);
// iOS simulator: write straight to a host path.
// Android: write to (await getExternalStorageDirectory())!.path, then
//   adb pull /sdcard/Android/data/bomnguyen.nucatch/files/<dir>
```

## Every screen in every language (readability audit)

`integration_test/screenshot_test.dart` walks all 13 reachable screens. Two
opt-in flags turn it into a localization / readability check:

```bash
for loc in en de es fr hi id ja th vi zh; do
  flutter test integration_test/screenshot_test.dart -d <iPhone simulator id> \
    --dart-define=NUCATCH_LOCALE=$loc --dart-define=SKIP_SHOTS=true \
    --dart-define=COLLECT_OVERFLOWS=true --dart-define=AUDIT_TEXT=true \
    --dart-define=SHOT_DIR=/absolute/path/shots/$loc
done
```

- `SHOT_DIR` saves a PNG of every screen straight from the test (no
  `flutter drive`, whose screenshot channel can hang on the iOS simulator).
- `AUDIT_TEXT` logs every visible text as
  `TEXTAUDIT|<screen>|<rendered size>|<text>|font=… textScale=… transform=…`.
  Flag sizes under 12 pt, and English text in a non-English run.
- `COLLECT_OVERFLOWS` records every overflow (`OVERFLOW_FOUND`) instead of
  stopping at the first.
- Known blind spot: the header's shrink-to-fit title (`CustomSliverAppBar`)
  isn't reflected in the logged size — check titles in the screenshots.

Fixes from the 2026-10-09 pass (all 10 languages, 13 screens, no overflow,
no text under 12 pt): leaderboard period tabs wrap to two lines and the
"only show mine" label wraps; Game Over buttons use `ButtonSize.small` in a
`Wrap`; the combat turn badge stays on one line (scaling down only if
needed); `CustomElevatedButton` labels never wrap (Hindi / CJK fall back to
system fonts whose measured width runs short); `menuGreeting` translated.

## Troubleshooting

- **"No space left on device"** during a build — clear
  `.dart_tool/flutter_build`, `build/` and `~/Library/Developer/Xcode/DerivedData`
  (all regenerate).
- **A tap does nothing** — use `.hitTestable()` finders; a covered widget
  (e.g. the update dialog's "Later" under the tour card) takes the tap
  otherwise.
- **A layout check fails right after navigation** — wait for the card to stop
  moving (pages slide in) and for the highlight to resolve; the test's
  `settleCard()` / `settleTarget()` do this.
- **A watch lesson's explain card was never seen** — short real timers
  (~1.2–1.5 s) can move on first; the test logs and skips that check.
