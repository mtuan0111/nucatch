import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';

import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/widgets/mode_card.dart';

/// Combat Mode Setup Screen - Choose to host or join a room
class CombatModeSetupScreen extends StatefulWidget {
  const CombatModeSetupScreen({super.key});

  @override
  State<CombatModeSetupScreen> createState() => _CombatModeSetupScreenState();
}

class _CombatModeSetupScreenState extends State<CombatModeSetupScreen> {
  void _navigateToHostRoom(BuildContext context) {
    context.read<CombatNavCubit>().showHostRoom();
  }

  void _navigateToJoinRoom(BuildContext context) {
    context.read<CombatNavCubit>().showJoinRoom();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              CustomSliverAppBar(
                title: lang(context).combatMode,
                onBackPressed: () {
                  context.read<PlayerNavCubit>().showSelectPlayMode();
                },
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
                        // Any landscape (not just tablet) gives the inner
                        // Create/Join ResponsiveGrid room for a 2-column
                        // layout.
                        maxWidth: context.isLandscapeOrientation ? 1200 : null,
                        // The mode was already chosen on the previous
                        // screen (the title says so), so Create / Join lead
                        // instead of sitting below a repeat of that choice.
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: kModeCardsMaxWidth),
                            child: Column(
                              children: [
                                Text(
                                  lang(context).combatModeDescription,
                                  style:
                                      AppTextStyles.bodyLarge(context).copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimary
                                        .withValues(alpha: 0.85),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: kSpace2XL),
                                ResponsiveGrid(
                                  spacing: kSpaceXL,
                                  runSpacing: kSpaceXL,
                                  minItemWidth: 340,
                                  children: [
                                    ModeCard(
                                      title: lang(context).createRoom,
                                      description:
                                          lang(context).createRoomDescription,
                                      icon: FontAwesomeIcons.userPlus,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      onTap: () => _navigateToHostRoom(context),
                                    ),
                                    ModeCard(
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
                              ],
                            ),
                          ),
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
    );
  }
}
