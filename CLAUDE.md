# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

**NuCatch** is a Flutter mental-math game: players match a target number/expression against a time limit across difficulty levels, with solo and 1-v-1 Combat modes, leaderboards, a two-part onboarding tour, AdMob, and Firebase. State management is the BLoC pattern (`flutter_bloc`). It supports phones, tablets and foldables (Galaxy Z Fold / Flip) in both orientations.

CI pins **Flutter 3.24.5** (`.gitlab-ci.yml`); the Dart SDK constraint is `>=3.2.5 <4.0.0`. The code uses Dart 3 records and patterns.

## Where things are documented

- `CLAUDE.md` (this file) — commands, architecture, conventions, gotchas.
- `.cursor/rules/*.mdc` — the same rules split by area for Cursor: sources of truth, BLoC, onboarding tour, game layout & foldables, localization, testing.
- `.agents/rules/version-release-workflow.mdc` — how a release is cut from the latest `CHANGELOG.md` block (git note, `.github/config/version-config.json`, commit).
- `docs/onboarding-tour/` — how the menu tour + in-game practice work, how to add a step or lesson, and how to test them.
- `docs/FOLDABLE_SUPPORT_PLAN.md` — foldable / dual-screen layout plan and what has shipped (status in §5a/§5b).
- `docs/DEPLOYMENT.md` — Fastlane lanes, signing, `.env_release`. `docs/SNS_LOGIN_SETUP.md` — Google/Apple sign-in setup.

## The skeleton_core dependency (read this first)

The app is a **thin game layer over `skeleton_core`**, a shared game-shell package. Most infrastructure — `SkeletonApp` (the app root, used instead of `MaterialApp` in `lib/main.dart`), `SettingBloc`, `AudioBloc`, `VibrationBloc`, `TourBloc`/`TourStep`, `MenuBloc`, the generic `MenuNav`/`TopScoreNav`, theming (`SeasonalTheme`, `AppTextStyles`, `LayoutConfig`), base widgets (`AlertTemplate`, `CustomElevatedButton`, `AnimatedButton`, `OptionCard`), and foldable helpers (`FoldLayout`, `HingeSplit`) — lives in `skeleton_core`, **not in this repo**.

`pubspec.yaml` pins it to a git ref (`deployment_production`) but `dependency_overrides` redirects it to a **local sibling checkout at `../skeleton_core`**. That directory is the real source for anything imported from `package:skeleton_core/...` — edit and read it there when behavior comes from the shell. **Release builds resolve the git ref, not the local checkout**: any skeleton_core change the app relies on must be committed and pushed to `deployment_production` before building (e.g. `CustomElevatedButton`/`AnimatedButton`'s `padding` parameter, and `CustomElevatedButton` applying `FittedBox(scaleDown)` only to its icon+label row, never to a caller-supplied `child`).

Because of this, `flutter_bloc`, `firebase_core`, `flutter_dotenv`, `google_mobile_ads`, `audioplayers`, and `vibration` are **transitive** dependencies (via skeleton_core) even though they're imported directly in app code — they are not (and should not need to be) listed under `dependencies:` in `pubspec.yaml`.

**The override/wrap pattern:** app files import skeleton_core while `hide`-ing the classes they replace, then supply game-specific builders. See `lib/navs/menu_nav.dart` — it `hide`s `MenuScreen`, `MenuNav`, `SettingScreen`, etc., imports the core `MenuNav` with a prefix (`import 'package:skeleton_core/src/navs/menu_nav.dart' as core_nav;`), and delegates to it with NuCatch screen builders. Follow this same pattern when overriding shell behavior.

## Commands

```bash
flutter pub get                       # install deps (resolves ../skeleton_core override)
flutter analyze                       # lint (CI gate)
dart format --set-exit-if-changed .   # format check (CI gate — CI fails on unformatted code)
flutter test                          # all unit/widget tests under test/
flutter test test/blocs/timer_pause_test.dart          # single test file
flutter test --plain-name "substring of test name"      # single test by name
flutter gen-l10n                      # regenerate localizations from lib/localization/*.arb
flutter run                           # run on a connected device/simulator
```

`generate: true` in `pubspec.yaml` means localizations are also regenerated automatically on every build; run `flutter gen-l10n` manually after editing an `.arb` to refresh the generated Dart immediately.

Builds (CI): `flutter build appbundle --release`, `flutter build apk --release`, `flutter build ios --release --no-codesign`. Release builds use the commands in the latest `CHANGELOG.md` block (see `.agents/rules/version-release-workflow.mdc`).

### Integration tests

Integration tests live in `integration_test/` — **one `testWidgets` per file** (`app.main()` sets up process-wide singletons that don't tear down between calls). Run them with `flutter test <file> -d <deviceId>`:

```bash
# Full onboarding tour, every step forwards AND back (layout + behaviour checks)
flutter test integration_test/tour_guide_test.dart -d <deviceId>
# …same, forced to another screen: IPAD / LANDSCAPE / FOLD_COVER (Z Fold7 cover) / FONT_SIZE
flutter test integration_test/tour_guide_test.dart -d <deviceId> \
  --dart-define=IPAD=true --dart-define=LANDSCAPE=true
# Every screen at a foldable emulator's native window (set its posture first)
flutter test integration_test/foldable_walkthrough_test.dart -d emulator-5554 \
  --dart-define=SKIP_SHOTS=true --dart-define=COLLECT_OVERFLOWS=true
```

Store-screenshot automation uses `flutter drive` with drivers in `test_driver/`, output wired to `fastlane/screenshots/`:
```bash
SCREENSHOT_DIR=portrait flutter drive \
  --driver=test_driver/screenshot_driver.dart \
  --target=integration_test/store_screenshots_test.dart -d <deviceId>
```
`test_driver/integration_test.dart` is the generic driver for the other `integration_test/*` targets. Details and the device matrix: `docs/onboarding-tour/TESTING.md`.

## Architecture

`lib/main.dart` configures a `SkeletonApp`: async `onInit` (Firebase + Firestore offline persistence, dotenv, FCM), localization delegates, a `themeBuilder`, app-specific `appBlocProviders`, and wrappers (`GlobalTourWrapper`, `UpdateCheckerWrapper`). The whole typography is forced to one family (`Baloo Bhai`) via `SkeletonConfig`.

**Layout under `lib/`:**
- `blocs/objects/` — game-domain BLoCs owned by this app: `turn/` (core solo-game controller), `combat/` (multiplayer match), `turnRecorded/` + `turnRecordedList/` (leaderboard records), `tutorial/` (`TutorialCubit` — the in-game practice), `timer_pause.dart` (`TimerPauseReason` holds shared by `TurnBloc`/`CombatBloc`). `tour/` just re-exports `TourBloc`/`TourState` from skeleton_core.
- `blocs/navs/` — navigation cubits (`player/`, `combat/`) that drive stacked flows.
- `navs/` — `StatelessWidget`s (`MenuNav`, `PlayerNav`, `SoloNav`, `CombatNav`, `TopScoreNav`) that compose screens and wire per-flow `BlocProvider`s, delegating to skeleton_core's generic navs where applicable. `PlayerNav`/`CombatNav` also route the in-game practice between its host screens.
- `screens/` — UI. Solo play (`menu_screens/player/play_screen.dart`, `gameover_screen.dart`, `set_difficult_screen.dart`, `level_select_screen.dart`, `select_play_mode_screen.dart`) and Combat (`combat_play_screen.dart`, `combat_game_end_screen.dart`, `host_room_screen.dart`, `join_room_screen.dart`, …).
- `services/` — `turn_services.dart` (leaderboard: Firestore + local SQLite via `sqflite`), `combat_ble_service.dart` + `combat_room_service.dart` (Combat transport: BLE via `ble_plat_services` and Firestore rooms, with `core/utils/room_code_generator.dart`), `fcm_service.dart`, `ai_greeting_service.dart` (`google_generative_ai`).
- `helpers/` — game math generators (`Helper`), constants (`const.dart`, incl. `keyboardArray`), `game_layout.dart` (layout modes + keypad sizing), the tour data (`tour_keys.dart`, `tour_progress.dart`, `tutorial_script.dart`, `tutorial_seeds.dart`, `tutorial_localization.dart`, `combat_tutorial_script.dart`).
- `widgets/` — leaf widgets: keypads (`regular_mode_controls.dart`, `pick_right_mode_controls.dart`, `pick_right_buttons.dart`), `game_layout_body.dart`, `game_pause_guard.dart`, `countdown_overlay.dart`, the tour UI (`global_tour_wrapper.dart`, `tutorial_overlay.dart`, `tour_card.dart`, `tour_spotlight.dart`), game-over result widgets, AdMob banner.
- `localization/` — ARB sources + generated `AppLocalizations` (see below).
- `lib/data/` and `lib/domain/` are **empty clean-architecture scaffolding** — not currently used; don't assume a repository/entity layer exists. `widgets/tour_overlay.dart`, `widgets/tour_spotlight_overlay.dart`, `widgets/tour_mode_wrapper.dart`, `helpers/tour_content.dart` and `examples/` are **unused leftovers** of an older tour.

### Game modes
- **Solo** has two sub-modes selected via `PlayMode`: regular (type the expression result on a keypad) and "pick-right" (choose the correct option). Difficulty (Easy/Medium/Hard/Extreme) sets time limit, expression length, points, and turns per level; higher levels generate longer numbers/results. Expression generation lives in the `Helper` math generators.
- **Combat** is a 1-v-1 match over BLE and/or Firestore rooms, with pause/resume sync (`pause_update {paused, seq}`, `OpponentPausedOverlay`, claim-win after 60 s), a setup flow, and dedicated end/restart screens.

### Onboarding tour (two layers, one look)
Full write-up: `docs/onboarding-tour/README.md`.
- **Part 1 — main menu**, driven by skeleton_core's `TourBloc` and rendered by `GlobalTourWrapper` (an `OverlayEntry`). Only the five steps in `TourProgress.menuSteps` are used (Welcome, Start, Two Ways to Play, Instant Start, More to Explore); Next/Previous jump with `TourJumpToStep` via `TourProgress.nextAfter`/`previousBefore` — never `TourStepCompleted()`/`TourStepBack()`, which follow skeleton_core's full enum (and stop early on iOS).
- **Parts 2–4 — hands-on practice** (Regular, Pick Right, Combat), driven by `TutorialCubit` over the lesson list in `TutorialScript`, rendered by `TutorialOverlay`, which is mounted last in the `Stack` of `PlayScreen`, `GameOverScreen`, `CombatPlayScreen` and `CombatGameEndScreen`. The whole practice occupies one tour slot, `TourStep.gameTutorialStep1`.
- Both parts render the same `TourSpotlightLayer` + `TourCard` (`widgets/tour_card.dart`): dimmed screen, a hole around the element (resolved through `TourKeys` `GlobalKey`s), and an `AlertTemplate`-styled card placed beside it (never across a hinge). Progress labels come from `TourProgress` ("Main Menu · 2 / 5", "Regular · 3 / 8").
- Lessons that set the game up carry a `turnSeed`/`combatSeed`; the host screen applies it to the real `TurnBloc`/`CombatBloc` when `seedToken` changes. **Previous** (`TutorialCubit.previous`) lands on the nearest lesson that sets the game up itself, so data never leaks from the lesson the player came from. Previous on the first lesson calls `backToMenuTour()` (ends the practice without completing the tour).
- An optional app-update prompt waits until the tour ends (`UpdateCheckerWrapper`), so it never shows through the spotlight.

### Game layout & foldables
- `GameLayout.resolve(size, displayFeatures)` picks a `GameLayoutMode` (`stacked`, `compactSquare`, `gamepad`, `tabletop`, `twoPane`); `GameLayoutBody` lays the header and keypad out for it, splitting across the fold with `HingeSplit`. Read the mode in `build` (`GameLayout.of(context)`) so screens rebuild on fold/unfold/rotation.
- `GamePauseGuard` (mixin on both game screens) pauses the turn timer when the app leaves the foreground or the layout mode changes mid-round, then resumes through a 3-2-1. Pause reasons are separate holds (`TimerPauseReason`), so the menu and the lifecycle can't unpause each other.
- **Keypad sizing** (`helpers/game_layout.dart`, used by both `RegularModeControls` and `CombatPlayScreen._buildKeyboard`): phones stretch cells to fill; tablets / Fold panes / gamepad clusters clamp them (`keypadClampsCells`, max `kMaxKeypadButtonSize`, up to `kKeypadMaxCellAspect` wider than tall, tighter `clampedKeypadSpacing`). Every row gets `spacing / 2` padding top and bottom so rows never touch; key inner padding scales with key size (`keypadKeyPadding`) so labels stay readable. `test/layout/keypad_spacing_test.dart` guards the gaps.

### BLoC conventions (still authoritative)
- **No UI concerns in BLoCs** — no `BuildContext`, toasts, dialogs, or navigation inside a BLoC. BLoCs emit pure immutable state; the UI reacts via `BlocListener`/`BlocBuilder`.
- **Communicate between BLoCs by events**, not direct service/method calls (e.g. `audioBloc.add(PlayTapAudio())`, not `audioService.playTap()`). One documented exception: `SettingBloc.audioBloc` is set so `ToggleMute` can reach the active `AudioBloc` (see `lib/navs/menu_nav.dart`).
- **State is immutable** — mutate only through `copyWith` and `emit`.
- `TutorialCubit`/`TutorialState` hold **no bloc references**; screens observe it and seed/navigate themselves.

### Localization
`l10n.yaml` sets `arb-dir: lib/localization` (note: **not** `lib/l10n`). Templates are `app_en.arb` (template) plus `de, es, fr, hi, id, ja, th, vi, zh`. Add a key to every `.arb`, then regenerate. Missing translations are written to `untranslated_messages.txt`. Access strings via the generated `AppLocalizations` — never hardcode user-facing strings.
- Menu-tour strings (`tour*`) are translated in every locale; in-game lesson strings (`tourRule*`) are **English in every locale** (never translated yet) — keep that parity when editing them.
- Tour card descriptions support `**bold**` markers and `\n` paragraph breaks (one paragraph per point).

### Firebase
Firestore holds leaderboard records (`turn_services.dart`) and an `app_versions` collection powering the in-app force/optional update prompt (`UpdateCheckerWrapper`; see `APP_VERSION_UPDATE_GUIDE.md`). Auth is anonymous sign-in on launch (see `README.md` top + `FIREBASE_AUTH_SETUP.md`). FCM push is set up in `fcm_service.dart`. `.env` (loaded by dotenv, bundled as an asset) holds keys such as the Generative AI key — see `.env.example`.

## Notes & gotchas

- **`copilot-instructions.md` (repo root) is partially stale.** Its BLoC architecture rules and game-difficulty math remain accurate and useful, but it predates the skeleton_core refactor: it lists `flutter_bloc`/`audioplayers`/`vibration` as direct deps and references `Equatable`, which is not used here. Trust `pubspec.yaml` + `../skeleton_core` over it for dependency/wiring facts.
- The repo root is cluttered with many one-off `*.md` design docs and large `*_log.txt`/`logs_*.log` build-log dumps from past sessions — these are historical, not current specs.
- `README.md` is mostly the default GitLab template; only the Firebase anonymous-auth section at the top is project-specific.
- `pubspec.yaml` version (`2.0.0+30`) lags the shipped version in `CHANGELOG.md` — treat CHANGELOG/build flags as the source of truth for released version numbers, not pubspec.
- **Format only the files you touch** (`dart format <file>`), not whole folders — several older files aren't formatted and a folder-wide run buries the real change in whitespace diffs.
- **Integration tests don't paint to the simulator screen** — `xcrun simctl io … screenshot` comes back blank ("Test starting…"). Capture inside the test (`(renderView.debugLayer as OffsetLayer).toImage(...)`), writing to a host path on iOS simulators or to `getExternalStorageDirectory()` + `adb pull` on Android.
- **Foldable emulator (`Foldable_7_6`)**: set postures with `adb emu posture 1|2|3` (closed / half-opened / opened). Its "closed" posture keeps reporting the inner display to the app, so the cover screen is tested with `--dart-define=FOLD_COVER=true` instead. Half-open reports a 0.3 dp `hinge` (real Samsung hardware reports a zero-width `fold`).
- **Disk space**: repeated integration runs fill `.dart_tool/flutter_build`, `build/` and Xcode DerivedData; "No space left on device" during a build means clear those caches (they regenerate).
- An optional update prompt (`UpdateNoticeDialog`) can appear during tests; integration tests dismiss it only when it's actually on top (`find.text('Later').hitTestable()`) — a covered "Later" sits under the tour's "Previous".
