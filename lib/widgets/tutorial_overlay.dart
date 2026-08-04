import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tutorial_localization.dart';
import 'package:nucatch/helpers/tutorial_script.dart';
import 'package:nucatch/widgets/tour_spotlight.dart';

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
  final SuperTooltipController _controller = SuperTooltipController();
  String? _shownToken;

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
        // Hide the tooltip while a real animation/consequence is mid-flight
        // (phase == acting) — nothing to read yet, and the spotlight hole
        // would otherwise sit still while the actual UI is changing under it.
        final hideForAnimation = tutorial.phase == TutorialPhase.acting;
        final targetRect = _targetRect(lesson, tutorial.phase);
        final token =
            '${tutorial.lessonIndex}-${tutorial.phase}-${tutorial.seedToken}';

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          if (hideForAnimation) {
            if (_shownToken != null) {
              _shownToken = null;
              _controller.hideTooltip();
            }
          } else if (_shownToken != token) {
            _shownToken = token;
            _controller.showTooltip();
          }
        });

        final screenSize = MediaQuery.of(context).size;
        final tooltipAnchor = targetRect == Rect.zero
            ? Rect.fromCenter(
                center: screenSize.center(Offset.zero), width: 10, height: 10)
            : targetRect;

        return Stack(
          children: [
            Positioned.fill(
              child: TourHoleBlocker(
                holeRect: targetRect,
                holeIsInteractive: !hideForAnimation && targetRect != Rect.zero,
                child: CustomPaint(
                  painter: TourSpotlightPainter(targetRect: targetRect),
                ),
              ),
            ),
            if (!hideForAnimation)
              Positioned.fromRect(
                rect: tooltipAnchor,
                child: SuperTooltip(
                  key: ValueKey(token),
                  controller: _controller,
                  interactionConfig: const InteractionConfiguration(
                    showOnTap: false,
                    hideOnTap: false,
                    hideOnBarrierTap: false,
                  ),
                  barrierConfig: const BarrierConfiguration(show: false),
                  positionConfig: const PositionConfiguration(
                    preferredDirection: TooltipDirection.down,
                    snapsFarAwayVertically: true,
                  ),
                  arrowConfig: const ArrowConfiguration(length: 0, baseWidth: 0),
                  closeButtonConfig: const CloseButtonConfiguration(show: false),
                  style: TooltipStyle(
                    borderWidth: 0,
                    borderRadius: 16,
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  content: _TutorialCard(tutorial: tutorial, lesson: lesson),
                  child: const SizedBox.shrink(),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TutorialCard extends StatelessWidget {
  final TutorialState tutorial;
  final TutorialLessonData lesson;

  const _TutorialCard({required this.tutorial, required this.lesson});

  @override
  Widget build(BuildContext context) {
    // A "Next" button only appears when the player isn't expected to
    // interact with the spotlighted UI directly (`interaction == next`) or
    // once a result beat has finished explaining what just happened —
    // `tapKey`/`tapButton`/`watch` lessons advance themselves via the host
    // screen's own listener reacting to the real bloc.
    final showNextButton = tutorial.phase == TutorialPhase.result ||
        (tutorial.phase == TutorialPhase.explain &&
            lesson.interaction == TutorialInteraction.next);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280),
      child: Padding(
        padding: const EdgeInsets.all(kPaddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tutorialLessonTitle(context, lesson),
              style: AppTextStyles.titleMediumBold(context)
                  .copyWith(color: Colors.white),
            ),
            const SizedBox(height: kSpaceS),
            Text(
              tutorialLessonDescription(context, lesson, tutorial.phase),
              style:
                  AppTextStyles.bodyMedium(context).copyWith(color: Colors.white),
            ),
            const SizedBox(height: kSpaceM),
            Text(
              '${tutorial.displayNumber} / ${tutorial.totalLessons}',
              style: AppTextStyles.bodySmall(context)
                  .copyWith(color: Colors.white70),
            ),
            const SizedBox(height: kSpaceM),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kSpaceXS),
                    ),
                    onPressed: () {
                      if (tutorial.isFirstLesson) {
                        // Back out of the in-game tutorial entirely, into
                        // the last main-menu tour step — mirrors how the
                        // menu tour's own Previous button behaves.
                        context.read<TourBloc>().add(TourStepBack());
                      } else {
                        context.read<TutorialCubit>().previous();
                      }
                    },
                    child: Text(
                      lang(context).tourPrevious,
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Flexible(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding:
                          const EdgeInsets.symmetric(horizontal: kSpaceXS),
                    ),
                    onPressed: () => context.read<TutorialCubit>().finish(),
                    child: Text(
                      lang(context).tourSkip,
                      style: const TextStyle(color: Colors.white70),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                if (showNextButton)
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => context.read<TutorialCubit>().next(),
                      child: Text(
                        tutorial.isLastLesson
                            ? lang(context).tourFinish
                            : lang(context).tourNext,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
