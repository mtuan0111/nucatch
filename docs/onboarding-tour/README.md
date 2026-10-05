# Onboarding tour

The first-run tour has **23 steps in four parts**: a short tour of the main
menu, then hands-on practice of the three ways to play. Every step dims the
screen, highlights the element it talks about and shows the same card beside
it, so the player always knows where to look and which part they're in.

| Part | Steps | Driven by | Rendered by |
|---|---|---|---|
| Main Menu | 5 | skeleton_core `TourBloc` | `GlobalTourWrapper` (an `OverlayEntry`) |
| Regular | 8 | `TutorialCubit` + `TutorialScript` | `TutorialOverlay` on PlayScreen / GameOverScreen |
| Pick Right | 5 | 〃 | 〃 |
| Combat | 5 | 〃 | `TutorialOverlay` on CombatPlayScreen / CombatGameEndScreen |

The card footer shows the part and the position within it:
`Main Menu · 2 / 5`, `Regular · 3 / 8` (`lib/helpers/tour_progress.dart`).

## Files

| File | Role |
|---|---|
| `lib/helpers/tour_progress.dart` | Menu step order (`menuSteps`), Next/Previous targets, progress labels |
| `lib/widgets/global_tour_wrapper.dart` | Menu part: listens to `TourBloc`, navigates, shows the card, maps steps → titles, texts, targets |
| `lib/helpers/tutorial_script.dart` | The 18 practice lessons: host screen, spotlight, interaction, seeds, result beats |
| `lib/helpers/tutorial_seeds.dart` | `TutorialTurnSeed` / `TutorialCombatSeed` — the game state a lesson sets up |
| `lib/helpers/combat_tutorial_script.dart` | Scripted opponent actions for the Combat lessons |
| `lib/blocs/objects/tutorial/` | `TutorialCubit` (lesson pointer, phases, Previous rules) and `TutorialState` |
| `lib/widgets/tutorial_overlay.dart` | Practice part: resolves each lesson's target and builds its card |
| `lib/widgets/tour_card.dart` | Shared UI: `TourSpotlightLayer`, `TourCardPlacement`, `TourCard`, `tourBoldSpans` |
| `lib/widgets/tour_spotlight.dart` | `TourSpotlightPainter` (the dim + hole) and `TourHoleBlocker` (tap blocking) |
| `lib/helpers/tour_keys.dart` | `GlobalKey`s of every highlightable element; `getRectForKeys` |
| `lib/helpers/tutorial_localization.dart` | Lesson key → localized title / description / result text |
| `lib/navs/player_nav.dart`, `lib/navs/combat_nav.dart` | Move between a lesson's host screens |
| `lib/screens/wrappers/update_checker_wrapper.dart` | Holds an optional update prompt until the tour ends |

Old, unused tour code: `widgets/tour_overlay.dart`,
`widgets/tour_spotlight_overlay.dart`, `widgets/tour_mode_wrapper.dart`,
`helpers/tour_content.dart`, `examples/`.

## Part 1 — Main Menu

| # | `TourStep` | Title | Highlights | Screen |
|---|---|---|---|---|
| 1 | `welcome` | Welcome to NuCatch! | nothing (centered card) | Menu |
| 2 | `startButton` | Start | Start button | Menu |
| 3 | `soloMode` | Two Ways to Play | Solo + Combat cards | Select Play Mode |
| 4 | `instantStart` | Instant Start | Instant Start button | Menu |
| 5 | `leaderboard` | More to Explore | Top Score + Settings + About | Menu |

- skeleton_core's `TourStep` enum has more values (combatMode, createRoom,
  joinRoom, settings, about, gameTutorialStep2…5). Only the five above are
  used; `TourProgress.nextAfter` also moves a step saved by an older version
  on to the next listed one.
- Next / Previous jump with `TourJumpToStep(TourProgress.nextAfter(step))` /
  `previousBefore(step)`. Don't use `TourStepCompleted()` / `TourStepBack()`:
  they walk the full enum and skeleton_core stops early on iOS.
- Next on step 5 jumps to `gameTutorialStep1`, which starts the practice
  (`TutorialCubit.start()` + `MenuBloc` → Play).
- The highlighted menu element can't be tapped; only the card's buttons work.
  If the element is scrolled out of view it's scrolled into view first and
  the spotlight re-measures when the scroll ends.

## Parts 2–4 — practice

| # | Lesson key | Host screen | Highlights | Player does | Sets up game | Result card highlights |
|---|---|---|---|---|---|---|
| R1 | RegularWelcome | play | lives | Next | yes | — |
| R2 | RegularMemorize | play | the number | watches | yes | — |
| R3 | RegularTypeBack | play | key "8" | taps it | — | score |
| R4 | RegularTimer | play | timer bar | watches | yes | lives |
| R5 | RegularReset | play | Reset key | taps it | yes | — |
| R6 | RegularLevelUp | play | key "2" | taps it | yes | score |
| R7 | RegularGameOver | play | lives | watches | yes | — |
| R8 | RegularWrapUp | game over | nothing | Next | — | — |
| P1 | PickRightWelcome | play | the answer choices | Next | yes | — |
| P2 | PickRightCorrect | play | answer "8" | taps it | yes | score |
| P3 | PickRightWrong | play | answer "9" | taps it | yes | (same answer) |
| P4 | PickRightTimer | play | timer bar | watches | yes | Game Over summary |
| P5 | PickRightWrapUp | game over | nothing | Next | — | — |
| C1 | CombatWelcome | combat play | turn badge | Next | yes | — |
| C2 | CombatYourTurn | combat play | key "4" | taps it | yes | — |
| C3 | CombatOpponentTurn | combat play | opponent panel | watches | — | (same) |
| C4 | CombatWin | combat play | opponent lives | watches | yes | "You Win!" result |
| C5 | CombatWrapUp | combat end | nothing | Finish | — | — |

### How a lesson runs
1. `TutorialCubit` moves to the lesson (`phase: explain`). If it has a
   `turnSeed`/`combatSeed`, `seedToken` changes and the host screen applies
   the seed to the real `TurnBloc`/`CombatBloc` (`SeedTutorialTurn` /
   `SeedTutorialCombat`). A Combat lesson with `opponentScript` plays it.
2. The player acts on the real game (`tapKey`/`tapButton`), or a real timer /
   scripted opponent acts (`watch`). The host screen watches the bloc and
   calls `onActionResolved()` when the consequence has landed.
3. With `hasResultBeat`, the card switches to its result text
   (`phase: result`, highlighting `resultSpotlight` if set) and waits for
   Next; otherwise the next lesson starts straight away.

### Previous
- A lesson **without** a seed continues the state the lesson before it left
  (R3 needs the "8" R2 flashed; C3 needs your turn to have just passed; a
  wrap-up needs the game that just ended). So `TutorialCubit.previous()`
  lands on the nearest earlier lesson that sets the game up itself
  (`previousSeededIndex`): R4 → R2, C4 → C2, P1 → R7, C1 → P4.
- Previous on R1 calls `backToMenuTour()` and jumps the menu tour to step 5.
  It ends the practice with `backedOutToMenuTour: true`, so the teardown
  listeners reset the game but don't complete the tour.
- If the lesson's host screen differs from what's showing (e.g. Previous
  from P4's result on GameOverScreen), `PlayerNav` / `CombatNav` navigate
  back to the game screen.

## The card and the spotlight (`widgets/tour_card.dart`)
- `TourCard` is built from the app's dialog pieces (`AlertTemplate` look):
  gradient title bar, white body with the description, footer with the
  progress label and **Skip Tour**, red **Previous** / green **Next**
  (`CustomElevatedButton`s). A null callback hides that button.
- Descriptions support `**bold**` and `\n`: each line is its own paragraph.
  Only the body scrolls, so the title and buttons always stay on screen.
- `TourSpotlightLayer` measures the target in its own coordinates and keeps
  re-measuring for 800 ms after every build, so the hole follows a page
  sliding in, a scroll, fold/unfold or rotation.
- `TourCardPlacement` puts the card above/below the target in portrait,
  beside it in landscape, centered when nothing fits or nothing is
  highlighted, and always inside one pane on a hinged device.
- `getRectForKeys` ignores elements on a covered route, so a card never
  frames something hidden under another screen.

## Changing the tour
- **Add/remove a menu step**: edit `TourProgress.menuSteps`; give the step a
  title, description and target in `GlobalTourWrapper`
  (`_getTitleForStep`, `_getDescriptionForStep`, `_targetKeysForStep`), and
  key the element (`TourKeys` + the widget).
- **Add a lesson**: add `TutorialLessonData` to `TutorialScript` (give it a
  seed unless it must continue the previous lesson), add its
  `tourRule<Key>Title/Desc` (+ `Result`) strings to all ARB files and cases in
  `tutorial_localization.dart`, and teach the host screen to call
  `onActionResolved()` for it (`play_screen.dart` / `combat_play_screen.dart`
  switch on the lesson key). Progress labels and the integration test adapt
  automatically.
- **New highlight target**: key in `TourKeys` (and `reset()`), the key on the
  widget, a `TutorialSpotlight` value, a case in
  `TutorialOverlay._targetRect`.
- **Text**: menu strings are translated in all 10 locales; `tourRule*`
  lesson strings are English everywhere. Put separate points on separate
  lines.
- Then run `integration_test/tour_guide_test.dart` (see `TESTING.md`).
