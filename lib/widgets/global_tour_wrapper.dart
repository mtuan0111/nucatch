import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/helpers/ui_constants.dart';

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
          // Tour content using AlertTemplate
          Center(
            child: AlertTemplate(
              title: _getTitleForStep(tourState.currentTourStep),
              content: Column(
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
              possitiveButtonLabel: tourState.isLastStep
                  ? lang(context).tourFinish
                  : lang(context).tourNext,
              onPossitiveButtonPressed: () {
                _removeTourOverlay();
                context.read<TourBloc>().add(TourStepCompleted());
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
        style: AppTextStyles.withColor(AppTextStyles.bodyLarge(context),
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
