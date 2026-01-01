import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

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
                            // Create Room Option
                            OptionCard(
                              context: context,
                              title: lang(context).createRoom,
                              description: lang(context).createRoomDescription,
                              icon: FontAwesomeIcons.userPlus,
                              color: Colors.blue,
                              onTap: () => _navigateToHostRoom(context),
                            ),
                            // Join Room Option
                            OptionCard(
                              context: context,
                              title: lang(context).joinRoom,
                              description: lang(context).joinRoomDescription,
                              icon: FontAwesomeIcons.rightToBracket,
                              color: Colors.green,
                              onTap: () => _navigateToJoinRoom(context),
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
