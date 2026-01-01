import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

/// Combat Mode Setup Screen - Choose to host or join a room
class CombatModeSetupScreen extends StatelessWidget {
  const CombatModeSetupScreen({super.key});

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
              SliverAppBar(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                pinned: true,
                stretch: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
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
                                description: lang(context).soloModeDescription,
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
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  const Expanded(child: Divider(thickness: 2)),
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
