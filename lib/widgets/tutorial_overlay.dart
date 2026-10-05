import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tour_progress.dart';
import 'package:nucatch/helpers/tutorial_localization.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/widgets/tour_card.dart';

/// The in-game rule tutorial's spotlight + tooltip. Mounted as the LAST
/// child in the `Stack` of every screen that can host a lesson
/// (`PlayScreen`, `GameOverScreen`, `CombatPlayScreen`, `CombatGameEndScreen`)
/// so it sits on top of everything and can block taps outside its
/// highlight.
///
/// Host-bloc-agnostic by design: it watches only [TutorialCubit] (never
/// `TurnBloc`/`CombatBloc` directly), resolving every spotlight target
/// through [TourKeys] instead — the same static `GlobalKey`s work
/// regardless of which real bloc/screen is currently active. Renders
/// nothing when the tutorial isn't active, so it's always safe to mount.
class TutorialOverlay extends StatefulWidget {
  const TutorialOverlay({super.key});

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay> {
  Rect _targetRect(TutorialLessonData lesson, TutorialPhase phase) {
    final useResult =
        phase == TutorialPhase.result && lesson.resultSpotlight != null;
    final spotlight = useResult ? lesson.resultSpotlight! : lesson.spotlight;

    switch (spotlight) {
      case TutorialSpotlight.requirementArea:
      case TutorialSpotlight.typingArea:
        return getRectForKeys([TourKeys.challengeAreaKey]);
      case TutorialSpotlight.scorePanel:
        return getRectForKeys([TourKeys.scoreKey]);
      case TutorialSpotlight.lifePanel:
        return getRectForKeys([TourKeys.heartKey]);
      case TutorialSpotlight.timerBar:
        return getRectForKeys([TourKeys.countdownBarKey]);
      case TutorialSpotlight.keypad:
        return getRectForKeys(TourKeys.keypadKeys.values.toList());
      case TutorialSpotlight.keypadKey:
        final key = lesson.spotlightKey;
        if (key == null) return Rect.zero;
        return getRectForKeys([TourKeys.keypadKeys[key]!]);
      case TutorialSpotlight.resetButton:
        return getRectForKeys([TourKeys.resetKey]);
      case TutorialSpotlight.pickRightOptions:
        return getRectForKeys(TourKeys.pickRightButtonKeys);
      case TutorialSpotlight.pickRightOption:
        final index = lesson.spotlightButtonIndex;
        if (index == null || index >= TourKeys.pickRightButtonKeys.length) {
          return Rect.zero;
        }
        return getRectForKeys([TourKeys.pickRightButtonKeys[index]]);
      case TutorialSpotlight.combatHeader:
        return getRectForKeys([TourKeys.combatHeaderKey]);
      case TutorialSpotlight.statusBadge:
        return getRectForKeys([TourKeys.combatStatusBadgeKey]);
      case TutorialSpotlight.opponentPanel:
        return getRectForKeys(
            [TourKeys.opponentScoreKey, TourKeys.opponentHeartKey]);
      case TutorialSpotlight.opponentLifePanel:
        return getRectForKeys([TourKeys.opponentHeartKey]);
      case TutorialSpotlight.wholeScreen:
        return Rect.zero;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TutorialCubit, TutorialState>(
      builder: (context, tutorial) {
        if (!tutorial.isActive) {
          return const SizedBox.shrink();
        }

        final lesson = tutorial.lesson;
        // Hide the card while a real animation/consequence is mid-flight
        // (phase == acting) — nothing to read yet, and the spotlight hole
        // would otherwise sit still while the actual UI is changing under it.
        final hideForAnimation = tutorial.phase == TutorialPhase.acting;

        // A "Next" button only appears when the player isn't expected to
        // interact with the spotlighted UI directly (`interaction == next`)
        // or once a result beat has finished explaining what just happened
        // — `tapKey`/`tapButton`/`watch` lessons advance themselves via the
        // host screen's own listener reacting to the real bloc.
        final showNextButton = tutorial.phase == TutorialPhase.result ||
            (tutorial.phase == TutorialPhase.explain &&
                lesson.interaction == TutorialInteraction.next);

        return TourSpotlightLayer(
          measureTarget: () => _targetRect(lesson, tutorial.phase),
          holeIsInteractive: true,
          showCard: !hideForAnimation,
          cardToken:
              '${tutorial.lessonIndex}-${tutorial.phase}-${tutorial.seedToken}',
          card: TourCard(
            title: tutorialLessonTitle(context, lesson),
            description:
                tutorialLessonDescription(context, lesson, tutorial.phase),
            progress: TourProgress.lessonLabel(tutorial.lessonIndex),
            onSkip: () => context.read<TutorialCubit>().finish(),
            onPrevious: () {
              if (tutorial.isFirstLesson) {
                // Back out of the in-game tutorial entirely, into the last
                // main-menu tour step — mirrors how the menu tour's own
                // Previous button behaves.
                context.read<TourBloc>().add(TourStepBack());
              } else {
                context.read<TutorialCubit>().previous();
              }
            },
            onNext: showNextButton
                ? () => context.read<TutorialCubit>().next()
                : null,
            nextLabel: tutorial.isLastLesson ? lang(context).tourFinish : null,
          ),
        );
      },
    );
  }
}
