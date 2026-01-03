import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
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

  void _showTourDialog(TourState tourState) {
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
      case TourStep.leaderboard:
      case TourStep.settings:
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
          // Tour content
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    _getTitleForStep(tourState.currentTourStep),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  // Description
                  Text(
                    _getDescriptionForStep(tourState.currentTourStep),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 20),
                  // Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Previous button
                      if (!tourState.isFirstStep)
                        TextButton(
                          onPressed: () {
                            _removeTourOverlay();
                            context.read<TourBloc>().add(TourStepBack());
                          },
                          child: Text(
                            lang(context).tourPrevious,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        )
                      else
                        const SizedBox.shrink(),
                      // Skip button
                      TextButton(
                        onPressed: () {
                          _removeTourOverlay();
                          context.read<TourBloc>().add(TourSkipped());
                        },
                        child: Text(
                          lang(context).tourSkip,
                          style: const TextStyle(color: Colors.white70),
                        ),
                      ),
                      // Next/Finish button
                      ElevatedButton(
                        onPressed: () {
                          _removeTourOverlay();
                          context.read<TourBloc>().add(TourStepCompleted());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                        ),
                        child: Text(
                          tourState.isLastStep
                              ? lang(context).tourFinish
                              : lang(context).tourNext,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Progress indicator
                  Center(
                    child: Text(
                      '${tourState.currentStep + 1} / ${tourState.totalSteps}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
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
    }
  }

  String _getDescriptionForStep(TourStep step) {
    switch (step) {
      case TourStep.welcome:
        return lang(context).tourWelcomeDesc;
      case TourStep.startButton:
        return lang(context).tourStartDesc;
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
