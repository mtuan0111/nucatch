import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:super_tooltip/super_tooltip.dart';

class SelectPlayModeScreen extends StatefulWidget {
  const SelectPlayModeScreen({super.key});

  @override
  State<SelectPlayModeScreen> createState() => _SelectPlayModeScreenState();
}

class _SelectPlayModeScreenState extends State<SelectPlayModeScreen> {
  // GlobalKeys for tour targeting
  final GlobalKey _soloModeKey = GlobalKey();
  final GlobalKey _combatModeKey = GlobalKey();
  SuperTooltipController? _tooltipController;

  @override
  void dispose() {
    _tooltipController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TourBloc, TourState>(
      listener: (context, tourState) {
        if (tourState.isTourActive) {
          // Show tooltip for current step if on this screen
          _showTooltipForStep(tourState);
        }
      },
      child: Scaffold(
        body: Container(
          decoration: LayoutConfig(context).gradientDecoration,
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
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
                            padding: const EdgeInsets.all(kPaddingM),
                            child: Text(
                              lang(context).selectPlayMode,
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
                      context.read<MenuBloc>().add(ShowMenu());
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
                              // Solo Mode Option
                              OptionCard(
                                key: _soloModeKey,
                                context: context,
                                title: lang(context).soloMode,
                                description: lang(context).soloModeDescription,
                                icon: FontAwesomeIcons.user,
                                color: Theme.of(context).colorScheme.primary,
                                onTap: () {
                                  context
                                      .read<PlayerNavCubit>()
                                      .selectPlayMode(PlayMode.solo);
                                },
                              ),
                              // Combat Mode Option
                              OptionCard(
                                key: _combatModeKey,
                                context: context,
                                title: lang(context).combatMode,
                                description:
                                    lang(context).combatModeDescription,
                                icon: FontAwesomeIcons.userGroup,
                                color: Theme.of(context).colorScheme.error,
                                onTap: () {
                                  context
                                      .read<PlayerNavCubit>()
                                      .selectPlayMode(PlayMode.combat);
                                },
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

    // Only show tooltips for steps 2 (soloMode) and 3 (combatMode)
    if (currentStep == TourStep.soloMode ||
        currentStep == TourStep.combatMode) {
      // Hide previous tooltip
      _tooltipController?.dispose();
      _tooltipController = null;

      // Determine which key to use
      final targetKey =
          currentStep == TourStep.soloMode ? _soloModeKey : _combatModeKey;

      // Wait for widget to be built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && targetKey.currentContext != null) {
          _showTooltip(targetKey, tourState);
        }
      });
    }
  }

  void _showTooltip(GlobalKey targetKey, TourState tourState) {
    _tooltipController = SuperTooltipController();

    final stepData = tourState.currentTourStep == TourStep.soloMode
        ? (title: lang(context).tourSoloTitle, desc: lang(context).tourSoloDesc)
        : (
            title: lang(context).tourCombatTitle,
            desc: lang(context).tourCombatDesc
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
