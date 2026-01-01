import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

class SelectPlayModeScreen extends StatelessWidget {
  const SelectPlayModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                              context: context,
                              title: lang(context).soloMode,
                              description: lang(context).soloModeDescription,
                              icon: FontAwesomeIcons.user,
                              color: Colors.blue,
                              onTap: () {
                                context
                                    .read<PlayerNavCubit>()
                                    .selectPlayMode(PlayMode.solo);
                              },
                            ),
                            // Combat Mode Option
                            OptionCard(
                              context: context,
                              title: lang(context).combatMode,
                              description: lang(context).combatModeDescription,
                              icon: FontAwesomeIcons.userGroup,
                              color: Colors.orange,
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
    );
  }
}
