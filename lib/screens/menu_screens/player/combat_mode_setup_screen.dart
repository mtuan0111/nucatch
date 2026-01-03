import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

/// Combat Mode Setup Screen - Choose to host or join a room
class CombatModeSetupScreen extends StatefulWidget {
  const CombatModeSetupScreen({super.key});

  @override
  State<CombatModeSetupScreen> createState() => _CombatModeSetupScreenState();
}

class _CombatModeSetupScreenState extends State<CombatModeSetupScreen> {
  // GlobalKeys for tour targeting
  final GlobalKey _createRoomKey = GlobalKey();
  final GlobalKey _joinRoomKey = GlobalKey();

  void _navigateToHostRoom(BuildContext context) {
    context.read<CombatNavCubit>().showHostRoom();
  }

  void _navigateToJoinRoom(BuildContext context) {
    context.read<CombatNavCubit>().showJoinRoom();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TourBloc, TourState>(
      listener: (context, tourState) {
        if (tourState.isTourActive) {
          _showTooltipForStep(tourState);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: LayoutConfig(context).gradientDecoration,
          child: SafeArea(
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      final double appBarHeight = constraints.biggest.height;
                      final bool isCollapsed = appBarHeight <=
                          kToolbarHeight + MediaQuery.of(context).padding.top;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        color: isCollapsed
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        child: FlexibleSpaceBar(
                          centerTitle: true,
                          titlePadding: EdgeInsets.zero,
                          title: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              lang(context).combatMode,
                              textAlign: TextAlign.center,
                              style: LayoutConfig(context).displaySmallStyle(
                                isActiveShadow: true,
                                isItalic: true,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  leading: IconButton(
                    onPressed: () {
                      context.read<PlayerNavCubit>().showSelectPlayMode();
                    },
                    icon: const Icon(FontAwesomeIcons.chevronLeft),
                  ),
                  expandedHeight: 100,
                ),
                DecoratedSliver(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  sliver: SliverPadding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 50,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: SafeArea(
                        child: DeviceWrapper(
                          child: Column(
                            spacing: 20,
                            children: [
                              // Show parent selection context (disabled options)
                              Opacity(
                                opacity: 0.5,
                                child: OptionCard(
                                  context: context,
                                  title: lang(context).soloMode,
                                  description:
                                      lang(context).soloModeDescription,
                                  icon: FontAwesomeIcons.user,
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () {
                                    // Disabled - navigate back to select mode
                                    context
                                        .read<PlayerNavCubit>()
                                        .showSelectPlayMode();
                                  },
                                ),
                              ),
                              // Combat Mode - Selected/Marked
                              Stack(
                                children: [
                                  OptionCard(
                                    context: context,
                                    title: lang(context).combatMode,
                                    description:
                                        lang(context).combatModeDescription,
                                    icon: FontAwesomeIcons.userGroup,
                                    color: Theme.of(context).colorScheme.error,
                                    onTap: () {
                                      // Already selected - navigate back
                                      context
                                          .read<PlayerNavCubit>()
                                          .showSelectPlayMode();
                                    },
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color:
                                            Theme.of(context).colorScheme.error,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .error
                                                .withOpacity(0.5),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              // Divider to show hierarchy
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  children: [
                                    const Expanded(
                                        child: Divider(thickness: 2)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: kPaddingL),
                                      child: Text(
                                        lang(context).combatMode,
                                        style: LayoutConfig(context)
                                            .titleSectionStyle()
                                            .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .error,
                                            ),
                                      ),
                                    ),
                                    const Expanded(
                                        child: Divider(thickness: 2)),
                                  ],
                                ),
                              ),

                              // Sub-options for Combat Mode
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: kPaddingXL),
                                child: Column(
                                  spacing: kSpaceXL,
                                  children: [
                                    // Create Room Option
                                    OptionCard(
                                      key: _createRoomKey,
                                      context: context,
                                      title: lang(context).createRoom,
                                      description:
                                          lang(context).createRoomDescription,
                                      icon: FontAwesomeIcons.userPlus,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onTap: () => _navigateToHostRoom(context),
                                    ),
                                    // Join Room Option
                                    OptionCard(
                                      key: _joinRoomKey,
                                      context: context,
                                      title: lang(context).joinRoom,
                                      description:
                                          lang(context).joinRoomDescription,
                                      icon: FontAwesomeIcons.rightToBracket,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                      onTap: () => _navigateToJoinRoom(context),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTooltipForStep(TourState tourState) {
    final currentStep = tourState.currentTourStep;

    // Only show tooltips for steps 4 (createRoom) and 5 (joinRoom)
    if (currentStep == TourStep.createRoom ||
        currentStep == TourStep.joinRoom) {
      // Wait for widget to be built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final targetKey = currentStep == TourStep.createRoom
              ? _createRoomKey
              : _joinRoomKey;
          if (targetKey.currentContext != null) {
            _showTooltip(targetKey, tourState);
          }
        }
      });
    }
  }

  void _showTooltip(GlobalKey targetKey, TourState tourState) {
    final stepData = tourState.currentTourStep == TourStep.createRoom
        ? (
            title: lang(context).tourCreateRoomTitle,
            desc: lang(context).tourCreateRoomDesc
          )
        : (
            title: lang(context).tourJoinRoomTitle,
            desc: lang(context).tourJoinRoomDesc
          );

    // Show tooltip using overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildTooltipContent(stepData.title, stepData.desc, tourState),
        ],
      ),
    );
  }

  Widget _buildTooltipContent(
      String title, String description, TourState tourState) {
    return Center(
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
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!tourState.isFirstStep)
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (mounted) {
                        context.read<TourBloc>().add(TourStepBack());
                      }
                    },
                    child: Text(
                      lang(context).tourPrevious,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (mounted) {
                      context.read<TourBloc>().add(TourSkipped());
                      // Navigate back to menu
                      context.read<PlayerNavCubit>().showSelectPlayMode();
                    }
                  },
                  child: Text(
                    lang(context).tourSkip,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    if (mounted) {
                      context.read<TourBloc>().add(TourStepCompleted());
                      // If this is the last step on this screen, navigate back to menu
                      if (tourState.currentStep == 4) {
                        // joinRoom is step 5, after that go back
                        // Stay on this screen for next step
                      } else {
                        // Navigate back to menu for leaderboard/settings steps
                        context.read<PlayerNavCubit>().showSelectPlayMode();
                      }
                    }
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
    );
  }
}
