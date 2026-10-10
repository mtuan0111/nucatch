import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart'
    show Difficulty;
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/widgets/tour_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:skeleton_core/skeleton_core.dart' as skeleton;
import 'package:skeleton_core/skeleton_core.dart' hide MenuScreen;
import 'package:nucatch/services/ai_greeting_service.dart';

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

    final userBloc = context.read<skeleton.UserBloc>();
    if (userBloc.state.greetingMessage == null) {
      userBloc.add(
        skeleton.GetGreetingMessage(
          fetchGreeting: () => AiGreetingService.getGreeting(
            context,
            lang(context).menuGreeting,
          ),
        ),
      );
    }
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
        // Wide windows (tablet, landscape) build their own grid below the
        // hero button in [_buildMenuItems], so the shell's grid stays off.
        enableLandscapeSplit: false,
        greetingMessage: BlocBuilder<skeleton.UserBloc, skeleton.UserState>(
          builder: (context, userState) {
            return Padding(
              // Grid alignment (§2): use the 24-pt spacing token, not a stray
              // literal, so the greeting sits on the same rhythm as everything
              // else on the page.
              padding: const EdgeInsets.symmetric(
                  horizontal: kSpace2XL, vertical: kSpaceSM),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  userState.greetingMessage ?? lang(context).menuGreeting,
                  key: ValueKey(userState.greetingMessage),
                  style: skeleton.AppTextStyles.bodyLarge(context).copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
        menuItems: _buildMenuItems(context),
      ),
    );
  }

  /// Instant Start is the main action, so it leads as a larger hero button.
  /// The rest share one width and sit centred under it: a single column on
  /// phones, a grid on wide windows (tablet, landscape).
  List<Widget> _buildMenuItems(BuildContext context) {
    final bool isWide = context.isTablet || context.isLandscapeOrientation;
    final entries = menuArray(context).entries.toList();

    final hero = _buildMenuButton(
      context,
      entries.first,
      isHero: true,
    );
    final others = [
      for (final entry in entries.skip(1)) _buildMenuButton(context, entry),
    ];
    // In the menu, after the last option, rather than floating over it: on
    // shorter phones (e.g. 1080x1920) a floating button covered "Exit".
    const tourButton = Center(child: TourButton());

    if (isWide) {
      return [
        hero,
        ResponsiveGrid(
          minItemWidth: 260,
          spacing: kSpaceM,
          runSpacing: kSpaceM,
          children: others,
        ),
        tourButton,
      ];
    }
    return [
      hero,
      ...others.map(
        (button) => Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: _kPhoneMenuMaxWidth),
            child: button,
          ),
        ),
      ),
      tourButton,
    ];
  }

  Widget _buildMenuButton(
    BuildContext context,
    MapEntry<MenuOption, Map<String, dynamic>> entry, {
    bool isHero = false,
  }) {
    Color backgroundColor = Theme.of(context).primaryColor;
    FaIconData iconData = entry.value['icon'] as FaIconData;

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

    final button = AnimatedButton(
      context,
      key: TourKeys.menuOptionKeys[entry.key],
      text: (entry.value['text'] as String).toUpperCase(),
      style: isHero
          ? AppTextStyles.titleMediumBold(context)
          : AppTextStyles.titleSmallBold(context),
      iconData: iconData,
      backgroundColor: backgroundColor,
      onPressed: () => menuBloc.add(
        SelectOption(option: entry.key),
      ),
      buttonSize:
          isHero ? skeleton.ButtonSize.medium : skeleton.ButtonSize.small,
      // Every button fills its slot (the centred column on phones, a grid
      // cell on wide windows), so the labels' lengths no longer give the
      // menu a ragged edge. `double.infinity` relies on the bounded parent
      // clamping it to the real available width.
      minWidth: double.infinity,
      backgroundBuilder: (context, borderRadius) {
        return LightningWidget(
          baseColor: backgroundColor, // Use the button's background color
          seed: (entry.value['text'] as String)
              .hashCode, // Distinct seed based on button text
          borderRadius: borderRadius,
        );
      },
    );

    if (!isHero) return button;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: (context.isTablet || context.isLandscapeOrientation)
              ? _kWideHeroMaxWidth
              : _kPhoneMenuMaxWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: kSpaceS),
          child: button,
        ),
      ),
    );
  }
}

/// Widest a menu button gets on a phone, so they don't stretch edge to edge
/// on large phones.
const double _kPhoneMenuMaxWidth = 440;

/// Widest the Instant Start hero gets above the wide-window grid.
const double _kWideHeroMaxWidth = 560;
