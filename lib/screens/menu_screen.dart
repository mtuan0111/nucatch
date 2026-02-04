import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/theme_config.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/blocs/objects/user/user_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/widgets/tour_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String? version;
  Difficulty? savedDifficulty;
  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;

  @override
  void initState() {
    super.initState();

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        version = packageInfo.version;
      });
    });

    // Load saved difficulty for instant start button styling
    _loadSavedDifficulty();
  }

  Future<void> _loadSavedDifficulty() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDifficultyName = prefs.getString(
      PreferencesKey.LAST_USED_DIFFICULTY,
    );

    if (savedDifficultyName != null) {
      try {
        final difficulty = Difficulty.values.firstWhere(
          (d) => d.name == savedDifficultyName,
        );
        setState(() {
          savedDifficulty = difficulty;
        });
      } catch (e) {
        // If parsing fails, keep savedDifficulty as null (will use default)
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Scaffold(
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
                          style: AppTextStyles.titleLarge(context),
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
                            style: AppTextStyles.bodyLargeMedium(context),
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

                          // Get color and icon for instant start button based on saved difficulty
                          Color backgroundColor =
                              Theme.of(context).primaryColor;
                          IconData iconData = entry.value['icon'] as IconData;

                          if (entry.key == MenuOption.instantStart &&
                              savedDifficulty != null) {
                            backgroundColor = Helper.getColorIconFromDifficulty(
                              context,
                              savedDifficulty!,
                            );
                            iconData = Helper.getIconFromDifficulty(
                              context,
                              savedDifficulty!,
                            );
                          }

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: AnimatedButton(
                                context,
                                text: (entry.value['text'] as String)
                                    .toUpperCase(),
                                style: AppTextStyles.titleLargeItalic(context),
                                iconData: iconData,
                                backgroundColor: backgroundColor,
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
                        margin: const EdgeInsets.all(kPaddingM),
                        alignment: Alignment.bottomCenter,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${lang(context).version}: ",
                              style: AppTextStyles.bodyLarge(context),
                              // style: LayoutConfig(context).titleSectionStyle(),
                            ),
                            Text(
                              version ?? "",
                              style: AppTextStyles.bodyLarge(context),
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
          floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
}
