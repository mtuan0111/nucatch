import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/helpers/const.dart';

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
          context
              .read<MenuBloc>()
              .add(SelectOption(option: MenuOption.start));
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
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Barrier to prevent interaction
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal
              child: Container(color: Colors.transparent),
            ),
          ),
          // Tour content using AlertTemplate
          Center(
            child: AlertTemplate(
              title: _getTitleForStep(tourState.currentTourStep),
              headerContent: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: kSpaceM),
                  _buildDescriptionText(
                    _getDescriptionForStep(tourState.currentTourStep),
                    context,
                  ),
                  // Skip button at top left
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () {
                        _removeTourOverlay();
                        context.read<TourBloc>().add(TourSkipped());
                      },
                      child: Text(
                        lang(context).tourSkip,
                        style: AppTextStyles.withColor(
                            AppTextStyles.bodyMediumBold(context),
                            Theme.of(context).colorScheme.secondary),
                      ),
                    ),
                  ),
                  const SizedBox(height: kSpaceXL),
                  // Progress indicator
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      '${tourState.displayStepNumber} / ${tourState.totalSteps}',
                      style: AppTextStyles.withColor(
                          AppTextStyles.bodySmall(context),
                          Theme.of(context).colorScheme.secondary.getDarker()),
                    ),
                  ),
                ],
              ),
              negativeButtonLabel:
                  tourState.isFirstStep ? null : lang(context).tourPrevious,
              onNegativeButtonPressed: tourState.isFirstStep
                  ? null
                  : () {
                      _removeTourOverlay();
                      context.read<TourBloc>().add(TourStepBack());
                    },
              // Always "Next", never "Finish" — this dialog never actually
              // ends the tour anymore. `about` (the last dialog step) always
              // advances into the in-game rule tutorial next; the tour only
              // truly finishes from that tutorial's own Finish button.
              possitiveButtonLabel: lang(context).tourNext,
              onPossitiveButtonPressed: () {
                _removeTourOverlay();
                // TourJumpToStep instead of TourStepCompleted(): skeleton_core's
                // TourState.isLastStep special-cases iOS to stop at `settings`
                // (skipping `about` and the whole game-tutorial tail) and, on
                // other platforms, only stops at the enum's actual last value
                // (gameTutorialStep5) — meaning TourStepCompleted() would
                // either end the tour too early (iOS) or walk into the
                // unhandled gameTutorialStep2-5 dead steps (elsewhere).
                // Jumping to an explicit index sidesteps both bugs without
                // touching the shared skeleton_core package.
                context
                    .read<TourBloc>()
                    .add(TourJumpToStep(tourState.currentStep + 1));
              },
            ),
          ),
        ],
      ),
    );
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

  Widget _buildDescriptionText(String text, BuildContext context) {
    final parts = <TextSpan>[];
    final regex = RegExp(r'\*\*(.*?)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add normal text before the bold part
      if (match.start > lastIndex) {
        parts.add(TextSpan(
          text: text.substring(lastIndex, match.start),
        ));
      }
      // Add bold text
      parts.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.bold),
      ));
      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      parts.add(TextSpan(
        text: text.substring(lastIndex),
      ));
    }

    return RichText(
      text: TextSpan(
        style: AppTextStyles.withColor(AppTextStyles.bodyLargeBold(context),
            Theme.of(context).colorScheme.primary.getDarker()),
        children: parts,
      ),
    );
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
