import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';

import 'package:nucatch/helpers/const.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/lightning_painter.dart';

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
                        child: Column(
                          spacing: 20,
                          children: [
                            // Show parent selection context (disabled options)
                            Opacity(
                              opacity: 0.5,
                              child: OptionCard(
                                context: context,
                                title: lang(context).soloMode,
                                description: lang(context).soloModeDescription,
                                icon: FontAwesomeIcons.user,
                                color: Theme.of(context).colorScheme.primary,
                                onTap: () {
                                  // Disabled - navigate back to select mode
                                  context
                                      .read<PlayerNavCubit>()
                                      .showSelectPlayMode();
                                },
                                backgroundBuilder: (context, borderRadius) {
                                  return LightningWidget(
                                    baseColor:
                                        Theme.of(context).colorScheme.primary,
                                    seed: lang(context).soloMode.hashCode,
                                    borderRadius: borderRadius,
                                  );
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
                                  backgroundBuilder: (context, borderRadius) {
                                    return LightningWidget(
                                      baseColor:
                                          Theme.of(context).colorScheme.error,
                                      seed: lang(context).combatMode.hashCode,
                                      borderRadius: borderRadius,
                                    );
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
                                              .withValues(alpha: 0.5),
                                          blurRadius: 8,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: kIconSizeM,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Divider to show hierarchy
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kPaddingM),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider(thickness: 2)),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: kPaddingL),
                                    child: Text(
                                      lang(context).combatMode,
                                      style: AppTextStyles.withColor(
                                          AppTextStyles.titleLarge(context),
                                          Theme.of(context).colorScheme.error),
                                    ),
                                  ),
                                  const Expanded(child: Divider(thickness: 2)),
                                ],
                              ),
                            ),

                            // Sub-options for Combat Mode
                            Padding(
                              padding: const EdgeInsets.only(left: kPaddingXL),
                              child: Column(
                                spacing: kSpaceXL,
                                children: [
                                  // Create Room Option
                                  OptionCard(
                                    context: context,
                                    title: lang(context).createRoom,
                                    description:
                                        lang(context).createRoomDescription,
                                    icon: FontAwesomeIcons.userPlus,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    onTap: () => _navigateToHostRoom(context),
                                    backgroundBuilder: (context, borderRadius) {
                                      return LightningWidget(
                                        baseColor: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        seed: lang(context).createRoom.hashCode,
                                        borderRadius: borderRadius,
                                      );
                                    },
                                  ),
                                  // Join Room Option
                                  OptionCard(
                                    context: context,
                                    title: lang(context).joinRoom,
                                    description:
                                        lang(context).joinRoomDescription,
                                    icon: FontAwesomeIcons.rightToBracket,
                                    color:
                                        Theme.of(context).colorScheme.tertiary,
                                    onTap: () => _navigateToJoinRoom(context),
                                    backgroundBuilder: (context, borderRadius) {
                                      return LightningWidget(
                                        baseColor: Theme.of(context)
                                            .colorScheme
                                            .tertiary,
                                        seed: lang(context).joinRoom.hashCode,
                                        borderRadius: borderRadius,
                                      );
                                    },
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
    );
  }
}
