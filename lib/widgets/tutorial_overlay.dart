import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart';
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

  /// Rebuilds once more if the spotlight target ended up somewhere other
  /// than where [build] measured it. [build] reads the target's position
  /// from the previous frame's layout, so when the board itself moves —
  /// fold/unfold, a posture change, rotation — the hole (the only place
  /// taps get through) would otherwise stay over where the key used to be,
  /// and a tap-the-key lesson could never be completed.
  void _settleTargetRect(
    TutorialLessonData lesson,
    TutorialPhase phase,
    Rect measured,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_targetRect(lesson, phase) != measured) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    // Re-measure whenever the window or its hinge changes; see
    // [_settleTargetRect].
    MediaQuery.sizeOf(context);
    MediaQuery.displayFeaturesOf(context);
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
        final targetRect = _targetRect(lesson, tutorial.phase);
        _settleTargetRect(lesson, tutorial.phase, targetRect);
        final token =
            '${tutorial.lessonIndex}-${tutorial.phase}-${tutorial.seedToken}';

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
              Positioned.fill(
                child: _CardPlacement(
                  // Rebuilt per lesson/phase so each card fades in fresh.
                  key: ValueKey(token),
                  targetRect: targetRect,
                  child: _TutorialCard(tutorial: tutorial, lesson: lesson),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Lays the tutorial card out next to the spotlight — below it when there's
/// more room there, above it otherwise, centered on screen for
/// [TutorialSpotlight.wholeScreen] (a [Rect.zero] target).
///
/// Positioned from [targetRect] directly (the same global rect the
/// spotlight hole is painted from) rather than through an overlay-entry
/// tooltip: those snapshot the anchor's position once, when the entry is
/// created, so a card built while its host screen was still settling into
/// place stayed stuck off-screen for the whole lesson.
class _CardPlacement extends StatelessWidget {
  final Rect targetRect;
  final Widget child;

  const _CardPlacement({
    super.key,
    required this.targetRect,
    required this.child,
  });

  static const double _maxCardWidth = 380;
  static const double _minCardWidth = 260;
  static const double _gap = kSpaceM;

  /// Below this much height above/below the spotlight (a tall keypad
  /// highlight) a portrait card goes beside the spotlight instead.
  static const double _minVerticalSpace = 200;

  /// The pane (sub-screen between hinges) the card goes in: the whole
  /// window when there's no hinge, else the pane overlapping [targetRect]
  /// least, the larger one on a tie.
  Rect _pickPane(List<Rect> panes) {
    double overlap(Rect pane) {
      if (targetRect == Rect.zero || !pane.overlaps(targetRect)) return 0;
      final r = pane.intersect(targetRect);
      return r.width * r.height;
    }

    double area(Rect r) => r.width * r.height;
    return panes.reduce((a, b) {
      final oa = overlap(a), ob = overlap(b);
      if (oa != ob) return oa < ob ? a : b;
      return area(a) >= area(b) ? a : b;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = mediaQuery.padding;
    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest;
      // On a half-opened foldable (or a dual-screen device) keep the card
      // inside one pane — the one overlapping the spotlight least — so it
      // never straddles the hinge.
      final pane = _pickPane(
        DisplayFeatureSubScreen.subScreensInBounds(
          Offset.zero & size,
          DisplayFeatureSubScreen.avoidBounds(mediaQuery),
        ).toList(),
      );
      final safe = Rect.fromLTRB(
        math.max(pane.left, padding.left) + kPaddingL,
        math.max(pane.top, padding.top) + kSpaceM,
        math.min(pane.right, size.width - padding.right) - kPaddingL,
        math.min(pane.bottom, size.height - padding.bottom) - kSpaceM,
      );
      final fullWidth = safe.width.clamp(0.0, _maxCardWidth);

      final card = TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 200),
        builder: (context, opacity, child) =>
            Opacity(opacity: opacity, child: child),
        child: child,
      );

      Widget place(Rect area, {required Alignment alignment}) {
        final width = area.width.clamp(0.0, fullWidth);
        return Stack(children: [
          Positioned.fromRect(
            rect: area,
            child: Align(
              alignment: alignment,
              child: SizedBox(
                width: width,
                // Caps the card at the free space; _TutorialCard then
                // scrolls its body text, never its title or buttons.
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: area.height),
                  child: card,
                ),
              ),
            ),
          ),
        ]);
      }

      if (targetRect == Rect.zero) {
        return place(safe, alignment: Alignment.center);
      }
      if (!targetRect.overlaps(safe)) {
        // The spotlight is in the other pane: sit level with it.
        final y = ((targetRect.center.dy - safe.top) / safe.height * 2 - 1)
            .clamp(-1.0, 1.0);
        return place(safe, alignment: Alignment(0, y));
      }

      final below = Rect.fromLTRB(
          safe.left, targetRect.bottom + _gap, safe.right, safe.bottom);
      final above =
          Rect.fromLTRB(safe.left, safe.top, safe.right, targetRect.top - _gap);
      final vertical = below.height >= above.height ? below : above;
      final verticalAlign = identical(vertical, below)
          ? Alignment.topCenter
          : Alignment.bottomCenter;

      final right = Rect.fromLTRB(
          targetRect.right + _gap, safe.top, safe.right, safe.bottom);
      final left = Rect.fromLTRB(
          safe.left, safe.top, targetRect.left - _gap, safe.bottom);
      final side = right.width >= left.width ? right : left;
      final sideFits = side.width >= _minCardWidth;
      final verticalFits = vertical.height >= _minVerticalSpace;

      // Landscape has width to spare and little height, so beside the
      // spotlight is tried first; portrait is the other way round.
      final landscape = safe.width > safe.height;
      if (landscape ? sideFits : !verticalFits && sideFits) {
        return place(side, alignment: Alignment.center);
      }
      if (verticalFits || sideFits) {
        return place(vertical, alignment: verticalAlign);
      }
      // Nowhere beside the spotlight has room for the title and buttons
      // (e.g. a spotlight filling most of a landscape phone): overlapping
      // it beats squeezing the card until it overflows.
      return place(safe, alignment: Alignment.center);
    });
  }
}

/// The tutorial card, built from the same pieces as the app's dialogs
/// (`AlertTemplate`, and so the menu tour in `GlobalTourWrapper`): a
/// gradient title bar, a body panel, and the red-Previous / green-Next
/// [CustomElevatedButton] pair — so the in-game lessons read as the
/// continuation of that tour rather than a different UI.
class _TutorialCard extends StatelessWidget {
  final TutorialState tutorial;
  final TutorialLessonData lesson;

  const _TutorialCard({required this.tutorial, required this.lesson});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buttonTheme = CustomButtonTheme.of(context);

    // A "Next" button only appears when the player isn't expected to
    // interact with the spotlighted UI directly (`interaction == next`) or
    // once a result beat has finished explaining what just happened —
    // `tapKey`/`tapButton`/`watch` lessons advance themselves via the host
    // screen's own listener reacting to the real bloc.
    final showNextButton = tutorial.phase == TutorialPhase.result ||
        (tutorial.phase == TutorialPhase.explain &&
            lesson.interaction == TutorialInteraction.next);

    // Same resolution as AlertTemplate's title and body.
    final titleBackgroundColor = buttonTheme?.dialogTitleBackgroundColor;
    final bodyBackgroundColor =
        buttonTheme?.dialogBackgroundColor ?? theme.scaffoldBackgroundColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomElevatedButton(
          text: tutorialLessonTitle(context, lesson),
          buttonSize: ButtonSize.small,
          shapeAt:
              buttonTheme?.dialogTitleShapeAt ?? RoundedWithShapeAt.topLeft,
          color: titleBackgroundColor?.getSmartColor(context) ??
              theme.colorScheme.onPrimary,
          backgroundColor: titleBackgroundColor,
          gradient: titleBackgroundColor == null
              ? LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [theme.primaryColor, theme.secondaryHeaderColor],
                )
              : null,
        ),
        Flexible(
          // At the largest font sizes, or in the little height phone
          // landscape leaves, only the description scrolls — the title and
          // the Previous/Next buttons always stay on screen.
          child: SingleChildScrollView(
            child: CustomElevatedButton(
              backgroundColor: bodyBackgroundColor,
              color: bodyBackgroundColor.getSmartColor(context),
              shapeAt: RoundedWithShapeAt.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    kPaddingL, kSpaceM, kPaddingL, kSpaceXS),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Same treatment as the menu tour's description.
                    Text.rich(
                      TextSpan(
                        style: AppTextStyles.withColor(
                            AppTextStyles.bodyLargeBold(context),
                            theme.colorScheme.primary.getDarker()),
                        children: _boldSpans(tutorialLessonDescription(
                            context, lesson, tutorial.phase)),
                      ),
                    ),
                    const SizedBox(height: kSpaceS),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            '${tutorial.displayNumber} / ${tutorial.totalLessons}',
                            style: AppTextStyles.withColor(
                                AppTextStyles.bodySmall(context),
                                theme.colorScheme.secondary.getDarker()),
                          ),
                        ),
                        Flexible(
                          child: TextButton(
                            onPressed: () =>
                                context.read<TutorialCubit>().finish(),
                            child: Text(
                              lang(context).tourSkip,
                              textAlign: TextAlign.end,
                              style: AppTextStyles.withColor(
                                  AppTextStyles.bodyMediumBold(context),
                                  theme.colorScheme.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: lang(context).tourPrevious,
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
                  color: theme.colorScheme.onError,
                  backgroundColor: theme.colorScheme.error,
                  buttonSize: ButtonSize.small,
                  shapeAt: RoundedWithShapeAt.topRight,
                ),
              ),
              if (showNextButton) ...[
                const SizedBox(width: kSpaceM),
                Expanded(
                  child: CustomElevatedButton(
                    text: tutorial.isLastLesson
                        ? lang(context).tourFinish
                        : lang(context).tourNext,
                    onPressed: () => context.read<TutorialCubit>().next(),
                    color: theme.colorScheme.onPrimary,
                    backgroundColor: theme.primaryColor,
                    buttonSize: ButtonSize.small,
                    shapeAt: RoundedWithShapeAt.topLeft,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// Splits [text] on `**bold**` markers (used throughout the lesson strings)
/// into plain and bold spans, so the markers never render literally.
List<TextSpan> _boldSpans(String text) {
  final spans = <TextSpan>[];
  var lastIndex = 0;
  for (final match in RegExp(r'\*\*(.*?)\*\*').allMatches(text)) {
    if (match.start > lastIndex) {
      spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
    }
    spans.add(TextSpan(
      text: match.group(1),
      style: const TextStyle(fontWeight: FontWeight.bold),
    ));
    lastIndex = match.end;
  }
  if (lastIndex < text.length) {
    spans.add(TextSpan(text: text.substring(lastIndex)));
  }
  return spans;
}
