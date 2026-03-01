import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/app_text_styles.dart';
import 'package:nucatch/helpers/helper.dart';

import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
import 'package:nucatch/widgets/custom_sliver_app_bar.dart';

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
            CustomSliverAppBar(
              title: lang(context).doYouReadyForRestart,
              onBackPressed: () {
                context.read<PlayerNavCubit>().showSelectPlayMode();
              },
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
                                  ? Theme.of(context).colorScheme.error
                                  : Theme.of(context).colorScheme.tertiary,
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
          width: kContainerSizeS,
          height: kContainerSizeS,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady
                ? Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.3),
            border: Border.all(
              color: isReady
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              width: kStrokeWidthMedium,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: kIconSizeL,
            color: isReady
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: kSpaceM),
        Text(
          label,
          style: AppTextStyles.bodyLarge(context),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: AppTextStyles.withColor(
            AppTextStyles.bodyLarge(context),
            isReady
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
