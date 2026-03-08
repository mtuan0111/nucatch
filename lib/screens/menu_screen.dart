import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/widgets/tour_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:skeleton_core/skeleton_core.dart' as skeleton;
import 'package:skeleton_core/skeleton_core.dart' hide MenuScreen;

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  Difficulty? savedDifficulty;
  MenuBloc get menuBloc => context.read<MenuBloc>();
  MenuState get menuState => menuBloc.state;

  @override
  void initState() {
    super.initState();
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
      if (mounted) {
        setState(() {
          savedDifficulty = difficulty;
        });
      }
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
        if (menuState is Menu) {
          _loadSavedDifficulty();
        }
      },
      child: skeleton.MenuScreen(
        title: '', // Custom logo is provided in headerIcon
        headerIcon: const MainLogo(),
        floatingActionButton: const Padding(
          padding: EdgeInsets.only(left: 30),
          child: TourButton(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        menuItems: menuArray(context).entries.map((entry) {
          Color backgroundColor = Theme.of(context).primaryColor;
          IconData iconData = entry.value['icon'] as IconData;

          if (entry.key == MenuOption.instantStart) {
            backgroundColor = Helper.getColorIconFromDifficulty(
              context,
              savedDifficulty,
            );
            iconData = Helper.getIconFromDifficulty(
              context,
              savedDifficulty,
            );
          }

          return Align(
            alignment: Alignment.centerLeft,
            child: skeleton.AnimatedButton(
              context,
              text: (entry.value['text'] as String).toUpperCase(),
              style: AppTextStyles.titleLargeItalic(context),
              iconData: iconData,
              backgroundColor: backgroundColor,
              onPressed: () => menuBloc.add(
                SelectOption(option: entry.key),
              ),
              buttonSize: skeleton.ButtonSize.small,
              backgroundBuilder: (context, borderRadius) {
                return CustomPaint(
                  painter: LightningPainter(
                    baseColor:
                        backgroundColor, // Use the button's background color
                    seed: (entry.value['text'] as String)
                        .hashCode, // Distinct seed based on button text
                  ),
                  size: Size.infinite,
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
