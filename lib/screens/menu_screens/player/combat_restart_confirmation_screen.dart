import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

class CombatRestartConfirmationScreen extends StatelessWidget {
  const CombatRestartConfirmationScreen({super.key});

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
                          lang(context).doYouReadyForRestart,
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
            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              sliver: SliverToBoxAdapter(
                child: DeviceWrapper(
                  child: BlocListener<CombatBloc, CombatState>(
                    listenWhen: (previous, current) =>
                        (previous.isRestartRequested &&
                            !current.isRestartRequested),
                    listener: (context, state) {
                      // Navigate to difficulty selection when restart is complete
                      context.read<CombatNavCubit>().showSetDifficulty();
                    },
                    child: BlocBuilder<CombatBloc, CombatState>(
                      builder: (context, combatState) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: kSpace4XL),
                            Icon(
                              Icons.refresh,
                              size: kContainerSizeS,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: kSpace4XL),
                            // Ready status indicators
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildReadyIndicator(
                                  context,
                                  label: lang(context).you,
                                  isReady: combatState.isPlayerReady,
                                ),
                                const SizedBox(width: kSpace4XL),
                                _buildReadyIndicator(
                                  context,
                                  label: lang(context).opponent,
                                  isReady: combatState.isOpponentReady,
                                ),
                              ],
                            ),
                            const SizedBox(height: kSpace4XL),
                            // Ready button
                            CustomElevatedButton(
                              text: combatState.isPlayerReady
                                  ? lang(context).notReady
                                  : lang(context).ready,
                              shapeAt: RoundedWithShapeAt.all,
                              backgroundColor: combatState.isPlayerReady
                                  ? Colors.orange
                                  : Colors.green,
                              onPressed: () {
                                context.read<CombatBloc>().add(
                                      CombatRestartReady(
                                          isReady: !combatState.isPlayerReady),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildReadyIndicator(
    BuildContext context, {
    required String label,
    required bool isReady,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady ? Colors.green : Colors.grey.withOpacity(0.3),
            border: Border.all(
              color: isReady ? Colors.green : Colors.grey,
              width: 3,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: 40,
            color: isReady ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: kSpaceM),
        Text(
          label,
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: LayoutConfig(context).contentSectionStyle(
            color: isReady ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
