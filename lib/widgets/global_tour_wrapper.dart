import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/helpers/tour_progress.dart';
import 'package:nucatch/widgets/tour_card.dart';

/// Global tour wrapper that manages all tour dialogs from the root level
/// This eliminates dialog stacking issues and centralizes tour logic
class GlobalTourWrapper extends StatefulWidget {
  final Widget child;

  const GlobalTourWrapper({
    super.key,
    required this.child,
  });

  @override
  State<GlobalTourWrapper> createState() => _GlobalTourWrapperState();
}

class _GlobalTourWrapperState extends State<GlobalTourWrapper> {
  OverlayEntry? _currentTourOverlay;
  TourStep? _lastShownStep;

  @override
  void dispose() {
    _removeTourOverlay();
    super.dispose();
  }

  void _removeTourOverlay() {
    _currentTourOverlay?.remove();
    _currentTourOverlay = null;
    _lastShownStep = null;
  }

  Future<void> _showTourDialog(TourState tourState) async {
    // Don't show if already showing the same step
    if (_lastShownStep == tourState.currentTourStep &&
        _currentTourOverlay != null) {
      return;
    }

    // Remove previous overlay
    _removeTourOverlay();

    // A menu step that's no longer part of the tour (e.g. saved mid-tour by
    // an older version) moves on to the next one that is.
    final step = tourState.currentTourStep;
    if (!step.name.startsWith('gameTutorial') &&
        !TourProgress.menuSteps.contains(step)) {
      context
          .read<TourBloc>()
          .add(TourJumpToStep(TourProgress.nextAfter(step).index));
      return;
    }

    // Update last shown step
    _lastShownStep = tourState.currentTourStep;

    // Handle navigation if needed
    _handleTourNavigation(tourState.currentTourStep);

    // The in-game rule tutorial (TutorialOverlay, mounted inside PlayScreen /
    // GameOverScreen / CombatPlayScreen / CombatGameEndScreen) owns every
    // gameTutorial* step's UI — this dialog-based wrapper renders nothing for
    // them so the two overlays never compete for the same taps.
    if (tourState.currentTourStep.name.startsWith('gameTutorial')) {
      return;
    }

    // Create and insert new overlay after navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && tourState.isTourActive) {
        _currentTourOverlay = OverlayEntry(
          builder: (overlayContext) =>
              _buildTourDialog(overlayContext, tourState),
        );
        Overlay.of(context).insert(_currentTourOverlay!);
        _revealTarget(tourState.currentTourStep);
      }
    });
  }

  void _handleTourNavigation(TourStep step) {
    if (!mounted) return;

    switch (step) {
      case TourStep.welcome:
      case TourStep.startButton:
      case TourStep.instantStart:
      case TourStep.leaderboard:
      case TourStep.settings:
      case TourStep.about:
        // These steps are on menu screen - navigate to menu if not there
        _navigateToMenu();
        break;
      case TourStep.soloMode:
      case TourStep.combatMode:
      case TourStep.createRoom:
      case TourStep.joinRoom:
        // All these steps stay on SelectPlayMode screen to explain options
        _navigateToSelectPlayMode();
        break;
      case TourStep.gameTutorialStep1:
        // The single slot the entire in-game rule tutorial occupies (see the
        // tour guide plan's architecture decision 1: TutorialCubit's lesson
        // pointer isn't persisted across relaunches, so parking all coarse
        // tour progress on one slot keeps a mid-tutorial relaunch
        // unambiguous). Force the menu into the Play branch so PlayerNav
        // mounts, then start the fine-grained tutorial.
        try {
          context.read<MenuBloc>().add(SelectOption(option: MenuOption.start));
          context.read<TutorialCubit>().start();
        } catch (e) {
          // Blocs might not be available in all contexts
        }
        break;
      case TourStep.gameTutorialStep2:
      case TourStep.gameTutorialStep3:
      case TourStep.gameTutorialStep4:
      case TourStep.gameTutorialStep5:
      case TourStep.gameTutorialWaiting:
        // Unreachable in practice: the whole in-game tutorial lives on
        // gameTutorialStep1 and TourCompleted() fires (from inside the
        // tutorial's own UI) before TourBloc would ever advance past it.
        // No-op rather than throw, in case it's ever reached anyway.
        break;
    }
  }

  void _navigateToMenu() {
    // Navigate back to menu if not already there
    try {
      context.read<MenuBloc>().add(ShowMenu());
    } catch (e) {
      // MenuBloc might not be available in all contexts
    }
  }

  void _navigateToSelectPlayMode() {
    try {
      context.read<MenuBloc>().add(SelectOption(option: MenuOption.start));
    } catch (e) {
      // Ignore if navigation fails
    }
  }

  Widget _buildTourDialog(BuildContext overlayContext, TourState tourState) {
    final step = tourState.currentTourStep;
    // Same spotlight + card as the in-game lessons that follow: the element
    // each step describes is highlighted, the rest of the screen dimmed and
    // blocked, and the card sits beside it.
    return Material(
      type: MaterialType.transparency,
      child: TourSpotlightLayer(
        measureTarget: () => _targetRectForStep(step),
        cardToken: step,
        card: TourCard(
          title: _getTitleForStep(step),
          description: _getDescriptionForStep(step),
          progress: TourProgress.menuLabel(context, step),
          onSkip: () {
            _removeTourOverlay();
            context.read<TourBloc>().add(TourSkipped());
          },
          onPrevious: TourProgress.previousBefore(step) == null
              ? null
              : () {
                  _removeTourOverlay();
                  context.read<TourBloc>().add(
                      TourJumpToStep(TourProgress.previousBefore(step)!.index));
                },
          // Always "Next", never "Finish" — this dialog never actually
          // ends the tour anymore. The last menu step always
          // advances into the in-game rule tutorial next; the tour only
          // truly finishes from that tutorial's own Finish button.
          onNext: () {
            _removeTourOverlay();
            // TourJumpToStep instead of TourStepCompleted(): skeleton_core's
            // TourState.isLastStep special-cases iOS to stop at `settings`
            // (skipping `about` and the whole game-tutorial tail) and, on
            // other platforms, only stops at the enum's actual last value
            // (gameTutorialStep5) — meaning TourStepCompleted() would
            // either end the tour too early (iOS) or walk into the
            // unhandled gameTutorialStep2-5 dead steps (elsewhere).
            // Jumping to an explicit index sidesteps both bugs without
            // touching the shared skeleton_core package — and lets the tour
            // use only the steps in TourProgress.menuSteps.
            context
                .read<TourBloc>()
                .add(TourJumpToStep(TourProgress.nextAfter(step).index));
          },
        ),
      ),
    );
  }

  /// The keys of the on-screen elements [step] describes — empty for the
  /// welcome step (nothing to point at yet — the card is centered).
  List<GlobalKey> _targetKeysForStep(TourStep step) {
    switch (step) {
      case TourStep.startButton:
        return [TourKeys.menuOptionKeys[MenuOption.start]!];
      case TourStep.instantStart:
        return [TourKeys.menuOptionKeys[MenuOption.instantStart]!];
      case TourStep.soloMode:
        // "Two ways to play": both play-mode cards.
        return [TourKeys.soloModeCardKey, TourKeys.combatModeCardKey];
      case TourStep.leaderboard:
        // "More to explore": Top Score, Settings and About together.
        return [
          TourKeys.menuOptionKeys[MenuOption.topScore]!,
          TourKeys.menuOptionKeys[MenuOption.setting]!,
          TourKeys.menuOptionKeys[MenuOption.about]!,
        ];
      default:
        // welcome, the menu steps folded into the two above (see
        // TourProgress.menuSteps), and the in-game steps — never rendered
        // here, see _showTourDialog.
        return const [];
    }
  }

  Rect _targetRectForStep(TourStep step) {
    final keys = _targetKeysForStep(step);
    return keys.isEmpty ? Rect.zero : getRectForKeys(keys);
  }

  /// Scrolls [step]'s element into view (the menu list scrolls in
  /// landscape and at large font sizes) so the spotlight never points
  /// off-screen.
  void _revealTarget(TourStep step) {
    final keys = _targetKeysForStep(step);
    final targetContext = keys.isEmpty ? null : keys.first.currentContext;
    if (targetContext == null) return;
    Scrollable.ensureVisible(
      targetContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 300),
      alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
    ).then((_) {
      // Scrolling moves the target without rebuilding the overlay (it lives
      // in a different subtree), so re-measure the spotlight once it lands.
      _currentTourOverlay?.markNeedsBuild();
    });
  }

  String _getTitleForStep(TourStep step) {
    switch (step) {
      case TourStep.welcome:
        return lang(context).tourWelcomeTitle;
      case TourStep.startButton:
        return lang(context).tourStartTitle;
      case TourStep.instantStart:
        return lang(context).tourInstantStartTitle;
      case TourStep.soloMode:
        return lang(context).tourSoloTitle;
      case TourStep.combatMode:
        return lang(context).tourCombatTitle;
      case TourStep.createRoom:
        return lang(context).tourCreateRoomTitle;
      case TourStep.joinRoom:
        return lang(context).tourJoinRoomTitle;
      case TourStep.leaderboard:
        return lang(context).tourLeaderboardTitle;
      case TourStep.settings:
        return lang(context).tourSettingsTitle;
      case TourStep.about:
        return lang(context).tourAboutTitle;
      case TourStep.gameTutorialStep1:
      case TourStep.gameTutorialStep2:
      case TourStep.gameTutorialStep3:
      case TourStep.gameTutorialStep4:
      case TourStep.gameTutorialStep5:
      case TourStep.gameTutorialWaiting:
        // Never actually rendered — _showTourDialog returns before building
        // this dialog for any gameTutorial* step (see its doc comment).
        return '';
    }
  }

  String _getDescriptionForStep(TourStep step) {
    switch (step) {
      case TourStep.welcome:
        return lang(context).tourWelcomeDesc;
      case TourStep.startButton:
        return lang(context).tourStartDesc;
      case TourStep.instantStart:
        return lang(context).tourInstantStartDesc;
      case TourStep.soloMode:
        return lang(context).tourSoloDesc;
      case TourStep.combatMode:
        return lang(context).tourCombatDesc;
      case TourStep.createRoom:
        return lang(context).tourCreateRoomDesc;
      case TourStep.joinRoom:
        return lang(context).tourJoinRoomDesc;
      case TourStep.leaderboard:
        return lang(context).tourLeaderboardDesc;
      case TourStep.settings:
        return lang(context).tourSettingsDesc;
      case TourStep.about:
        return lang(context).tourAboutDesc;
      case TourStep.gameTutorialStep1:
      case TourStep.gameTutorialStep2:
      case TourStep.gameTutorialStep3:
      case TourStep.gameTutorialStep4:
      case TourStep.gameTutorialStep5:
      case TourStep.gameTutorialWaiting:
        // Never actually rendered — see _getTitleForStep.
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TourBloc, TourState>(
      listener: (context, tourState) {
        if (tourState.isTourActive) {
          _showTourDialog(tourState);
        } else {
          _removeTourOverlay();
        }
      },
      child: widget.child,
    );
  }
}
