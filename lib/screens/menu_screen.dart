import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../helpers/theme_config.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/widgets/tour_button.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';

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
          NucatchPreferencesKey.LAST_USED_DIFFICULTY,
        ) ??
        Difficulty.easy.name;

    try {
      final difficulty = Difficulty.values.firstWhere(
        (d) => d.name == savedDifficultyName,
      );
      if (mounted)
        setState(() {
          savedDifficulty = difficulty;
        });
    } catch (e) {
      // If parsing fails, keep savedDifficulty as null (will use default)
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload saved difficulty whenever the screen becomes active
    // This ensures the Instant Start button updates when user changes difficulty
    _loadSavedDifficulty();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MenuBloc, MenuState>(
      listener: (context, menuState) {
        // Reload saved difficulty whenever we navigate to the menu
        if (menuState is Menu) {
          _loadSavedDifficulty();
        }
      },
      child: BlocBuilder<UserBloc, UserState>(
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
                                ? coreLang(context).welcomeUser(state.username!)
                                : coreLang(context).welcome,
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

                            if (entry.key == MenuOption.instantStart) {
                              backgroundColor =
                                  Helper.getColorIconFromDifficulty(
                                context,
                                savedDifficulty,
                              );
                              iconData = Helper.getIconFromDifficulty(
                                context,
                                savedDifficulty,
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
                                  style:
                                      AppTextStyles.titleLargeItalic(context),
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
                                "${coreLang(context).version}: ",
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
            floatingActionButtonLocation:
                FloatingActionButtonLocation.startFloat,
          );
        },
      ),
    );
  }

  String _getHolidayMessage(BuildContext context) {
    final currentTheme = SeasonalTheme.current;

    switch (currentTheme) {
      case ThemeType.newYear:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayNewYear,
          coreLang(context).greetingNewYear,
        );
      case ThemeType.lunarNewYear:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayLunarNewYear,
          coreLang(context).greetingLunarNewYear,
        );
      case ThemeType.valentine:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayValentine,
          coreLang(context).greetingValentine,
        );
      case ThemeType.holi:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHoli,
          coreLang(context).greetingHoli,
        );
      case ThemeType.earthDay:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayEarthDay,
          coreLang(context).greetingEarthDay,
        );
      case ThemeType.easter:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayEaster,
          coreLang(context).greetingEaster,
        );
      case ThemeType.pride:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayPride,
          coreLang(context).greetingPride,
        );
      case ThemeType.halloween:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHalloween,
          coreLang(context).greetingHalloween,
        );
      case ThemeType.diwali:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayDiwali,
          coreLang(context).greetingDiwali,
        );
      case ThemeType.hanukkah:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayHanukkah,
          coreLang(context).greetingHanukkah,
        );
      case ThemeType.christmas:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayChristmas,
          coreLang(context).greetingChristmas,
        );
      case ThemeType.kwanzaa:
        return coreLang(context).holidayNotification(
          coreLang(context).holidayKwanzaa,
          coreLang(context).greetingKwanzaa,
        );
      default:
        return '';
    }
  }
}
