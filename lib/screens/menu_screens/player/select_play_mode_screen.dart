import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/widgets/mode_card.dart';

class SelectPlayModeScreen extends StatefulWidget {
  const SelectPlayModeScreen({super.key});

  @override
  State<SelectPlayModeScreen> createState() => _SelectPlayModeScreenState();
}

class _SelectPlayModeScreenState extends State<SelectPlayModeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              CustomSliverAppBar(
                title: lang(context).selectPlayMode,
                onBackPressed: () {
                  context.read<MenuBloc>().add(ShowMenu());
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
                        // Any landscape (not just tablet) gives the
                        // ResponsiveGrid below room for a 2-column layout.
                        maxWidth: context.isLandscapeOrientation ? 1200 : null,
                        child: Center(
                          // Centred and capped, so on a tablet the two
                          // cards sit side by side mid-screen instead of
                          // hugging the top-left corner.
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                                maxWidth: kModeCardsMaxWidth),
                            child: ResponsiveGrid(
                              spacing: kSpaceXL,
                              runSpacing: kSpaceXL,
                              minItemWidth: 340,
                              children: [
                                ModeCard(
                                  key: TourKeys.soloModeCardKey,
                                  title: lang(context).soloMode,
                                  description:
                                      lang(context).soloModeDescription,
                                  icon: FontAwesomeIcons.solidUser,
                                  color: Theme.of(context).colorScheme.primary,
                                  onTap: () {
                                    context
                                        .read<PlayerNavCubit>()
                                        .selectPlayMode(PlayMode.solo);
                                  },
                                ),
                                ModeCard(
                                  key: TourKeys.combatModeCardKey,
                                  title: lang(context).combatMode,
                                  description:
                                      lang(context).combatModeDescription,
                                  icon: FontAwesomeIcons.userGroup,
                                  color: Theme.of(context).colorScheme.error,
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
