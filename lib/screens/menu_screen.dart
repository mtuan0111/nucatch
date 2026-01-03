import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/theme_config.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/objects/tour/tour_bloc.dart';
import 'package:nucatch/blocs/objects/tour/tour_event.dart';
import 'package:nucatch/blocs/objects/tour/tour_state.dart';
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/widgets/tour_button.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? version;
  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;

  // GlobalKeys for tour targeting
  final Map<TourStep, GlobalKey> _tourKeys = {
    TourStep.startButton: GlobalKey(),
    TourStep.leaderboard: GlobalKey(),
    TourStep.settings: GlobalKey(),
  };

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
        log("version: ");
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
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
                  slivers: [
                    SliverAppBar(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      surfaceTintColor: Colors.transparent,
                      pinned: true,
                      flexibleSpace: const Center(
                        child: MainLogo(),
                      ),
                      expandedHeight: 240,
                      toolbarHeight: 80,
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: Center(
                          child: Text(
                            state.username != null
                                ? lang(context).welcomeUser(state.username!)
                                : lang(context).welcome,
                            style: LayoutConfig(context).titleSectionStyle(),
                          ),
                        ),
                      ),
                    ),
                    if (SeasonalTheme.current != ThemeType.defaultTheme)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            bottom: 10,
                            left: 20,
                            right: 20,
                          ),
                          child: Center(
                            child: Text(
                              _getHolidayMessage(context),
                              style: LayoutConfig(context)
                                  .titleSectionStyle()
                                  .copyWith(
                                    fontSize: kFontSizeM,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final entry =
                                menuArray(context).entries.elementAt(index);

                            // Assign GlobalKey based on menu option
                            GlobalKey? buttonKey;
                            switch (entry.key) {
                              case MenuOption.start:
                                buttonKey = _tourKeys[TourStep.startButton];
                                break;
                              case MenuOption.topScore:
                                buttonKey = _tourKeys[TourStep.leaderboard];
                                break;
                              case MenuOption.setting:
                                buttonKey = _tourKeys[TourStep.settings];
                                break;
                              default:
                                buttonKey = null;
                            }

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: AnimatedButton(
                                  context,
                                  key:
                                      buttonKey, // Assign key for tour targeting
                                  text: (entry.value['text'] as String)
                                      .toUpperCase(),
                                  style: LayoutConfig(context)
                                      .titleSectionStyle()
                                      .copyWith(
                                        fontWeight: FontWeight.w900,
                                        fontStyle: FontStyle.italic,
                                      ),
                                  iconData: entry.value['icon'] as IconData,
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  // textDirection: TextDirection.rtl,
                                  // color: Colors.black87,
                                  onPressed: () => menuBloc.add(
                                    SelectOption(
                                      option: entry.key,
                                    ),
                                  ),
                                  buttonSize: ButtonSize.small,
                                ),
                              ),
                            );
                          },
                          childCount: menuArray(context).length,
                        ),
                      ),
                    ),
                    if (version?.isNotEmpty ?? false)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: Container(
                          margin: const EdgeInsets.all(10),
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "${lang(context).version}: ",
                                style:
                                    LayoutConfig(context).contentSectionStyle(),
                                // style: LayoutConfig(context).titleSectionStyle(),
                              ),
                              Text(
                                version ?? "",
                                style:
                                    LayoutConfig(context).contentSectionStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Tour button positioned on the left
            floatingActionButton: const Padding(
              padding: EdgeInsets.only(left: 30),
              child: TourButton(),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          ),
        );
      },
    );
  }

  String _getHolidayMessage(BuildContext context) {
    final currentTheme = SeasonalTheme.current;

    switch (currentTheme) {
      case ThemeType.newYear:
        return lang(context).holidayNotification(
          lang(context).holidayNewYear,
          lang(context).greetingNewYear,
        );
      case ThemeType.lunarNewYear:
        return lang(context).holidayNotification(
          lang(context).holidayLunarNewYear,
          lang(context).greetingLunarNewYear,
        );
      case ThemeType.valentine:
        return lang(context).holidayNotification(
          lang(context).holidayValentine,
          lang(context).greetingValentine,
        );
      case ThemeType.holi:
        return lang(context).holidayNotification(
          lang(context).holidayHoli,
          lang(context).greetingHoli,
        );
      case ThemeType.earthDay:
        return lang(context).holidayNotification(
          lang(context).holidayEarthDay,
          lang(context).greetingEarthDay,
        );
      case ThemeType.easter:
        return lang(context).holidayNotification(
          lang(context).holidayEaster,
          lang(context).greetingEaster,
        );
      case ThemeType.pride:
        return lang(context).holidayNotification(
          lang(context).holidayPride,
          lang(context).greetingPride,
        );
      case ThemeType.halloween:
        return lang(context).holidayNotification(
          lang(context).holidayHalloween,
          lang(context).greetingHalloween,
        );
      case ThemeType.diwali:
        return lang(context).holidayNotification(
          lang(context).holidayDiwali,
          lang(context).greetingDiwali,
        );
      case ThemeType.hanukkah:
        return lang(context).holidayNotification(
          lang(context).holidayHanukkah,
          lang(context).greetingHanukkah,
        );
      case ThemeType.christmas:
        return lang(context).holidayNotification(
          lang(context).holidayChristmas,
          lang(context).greetingChristmas,
        );
      case ThemeType.kwanzaa:
        return lang(context).holidayNotification(
          lang(context).holidayKwanzaa,
          lang(context).greetingKwanzaa,
        );
      default:
        return '';
    }
  }

  void _showTooltipForStep(TourState tourState) {
    final currentStep = tourState.currentTourStep;

    // Only show tooltips for steps on menu screen: startButton, leaderboard, settings
    if (currentStep == TourStep.startButton ||
        currentStep == TourStep.leaderboard ||
        currentStep == TourStep.settings) {
      // Wait for widget to be built
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          final targetKey = _tourKeys[currentStep];
          if (targetKey != null && targetKey.currentContext != null) {
            _showTooltip(targetKey, tourState);
          }
        }
      });
    } else if (currentStep == TourStep.soloMode ||
        currentStep == TourStep.combatMode) {
      // Navigate to SelectPlayMode screen for these steps
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          menuBloc.add(SelectOption(option: MenuOption.start));
        }
      });
    }
  }

  void _showTooltip(GlobalKey targetKey, TourState tourState) {
    String title, description;

    switch (tourState.currentTourStep) {
      case TourStep.startButton:
        title = lang(context).tourStartTitle;
        description = lang(context).tourStartDesc;
        break;
      case TourStep.leaderboard:
        title = lang(context).tourLeaderboardTitle;
        description = lang(context).tourLeaderboardDesc;
        break;
      case TourStep.settings:
        title = lang(context).tourSettingsTitle;
        description = lang(context).tourSettingsDesc;
        break;
      default:
        return;
    }

    // Show tooltip using dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (dialogContext) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // Prevent dismissal
              child: Container(color: Colors.transparent),
            ),
          ),
          _buildTooltipContent(dialogContext, title, description, tourState),
        ],
      ),
    );
  }

  Widget _buildTooltipContent(BuildContext dialogContext, String title,
      String description, TourState tourState) {
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
              style: Theme.of(dialogContext).textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: Theme.of(dialogContext).textTheme.bodyMedium?.copyWith(
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
                      Navigator.of(dialogContext).pop();
                      if (mounted) {
                        dialogContext.read<TourBloc>().add(TourStepBack());
                      }
                    },
                    child: Text(
                      lang(dialogContext).tourPrevious,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  )
                else
                  const SizedBox.shrink(),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (mounted) {
                      dialogContext.read<TourBloc>().add(TourSkipped());
                    }
                  },
                  child: Text(
                    lang(dialogContext).tourSkip,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (mounted) {
                      dialogContext.read<TourBloc>().add(TourStepCompleted());
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Theme.of(dialogContext).primaryColor,
                  ),
                  child: Text(
                    tourState.isLastStep
                        ? lang(dialogContext).tourFinish
                        : lang(dialogContext).tourNext,
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
