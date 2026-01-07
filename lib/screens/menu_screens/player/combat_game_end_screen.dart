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
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';

class CombatGameEndScreen extends StatelessWidget {
  const CombatGameEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: BlocListener<CombatBloc, CombatState>(
            listenWhen: (previous, current) =>
                previous.combatStatus != current.combatStatus &&
                current.combatStatus == CombatStatus.intro,
            listener: (context, state) {
              // Navigate to playing screen when restart countdown begins
              context.read<CombatNavCubit>().showPlaying();
            },
            child: BlocBuilder<CombatBloc, CombatState>(
              builder: (context, combatState) {
                final isWinner = combatState.isWinner ?? false;

                return CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.transparent,
                      pinned: true,
                      stretch: true,
                      flexibleSpace: LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                          final double appBarHeight =
                              constraints.biggest.height;
                          final bool isCollapsed = appBarHeight <=
                              kToolbarHeight +
                                  MediaQuery.of(context).padding.top;

                          return AnimatedContainer(
                            duration: const Duration(
                                milliseconds: kAnimationDurationMedium),
                            color: isCollapsed
                                ? Theme.of(context).primaryColor
                                : Colors.transparent,
                            child: FlexibleSpaceBar(
                              centerTitle: true,
                              titlePadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.all(kPaddingM),
                                child: Text(
                                  isWinner
                                      ? lang(context).youWin
                                      : lang(context).youLose,
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.displaySmallTitleScreen(
                                      context),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      leading: IconButton(
                        onPressed: () {
                          // Reset CombatBloc to fresh initial state
                          context.read<CombatBloc>().add(CombatBlocReset());

                          // Reset CombatNavCubit to initial state
                          context.read<CombatNavCubit>().reset();

                          // Navigate back to select play mode
                          context.read<PlayerNavCubit>().showSelectPlayMode();
                        },
                        icon: const Icon(FontAwesomeIcons.chevronLeft),
                      ),
                      expandedHeight: 100,
                    ),
                    SliverToBoxAdapter(
                      child: DeviceWrapper(
                        child: _buildGameEndScreen(context, combatState),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameEndScreen(BuildContext context, CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;

    return Container(
      padding: const EdgeInsets.all(kPaddingXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Ranking Widget - Winner (position 1) or Loser (position 4)
          RankingSortingWidget(
            position: isWinner ? 1 : 4,
            size: kContainerSizeS,
            childElement: Icon(
              isWinner ? FontAwesomeIcons.trophy : FontAwesomeIcons.faceFrown,
              color: Theme.of(context).scaffoldBackgroundColor,
              size: kIconSizeL,
            ),
          ),
          const SizedBox(height: kSpaceXL),

          // Expected String Display
          if (combatState.expect != null && combatState.expect!.isNotEmpty) ...[
            Text(
              lang(context).theCorrectIs,
              style: AppTextStyles.bodyMediumBold(context),
            ),
            const SizedBox(height: kSpaceS),
            Text(
              combatState.expect!,
              style: AppTextStyles.forChallenge(
                combatState.expect!.length,
                context,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: kSpaceXL),
          ],

          // Game End Reason
          Text(
            _getGameEndReason(context, combatState),
            style: AppTextStyles.titleMediumBold(context),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kSpace4XL),

          // Ready indicators section - wrapped in styled container
          if (combatState.isRestartRequested) ...[
            Container(
              padding: const EdgeInsets.all(kPaddingL),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(LayoutConfig.layoutBorderRadius / 5),
                  topRight: Radius.circular(LayoutConfig.layoutBorderRadius),
                  bottomLeft: Radius.circular(LayoutConfig.layoutBorderRadius),
                  bottomRight: Radius.circular(LayoutConfig.layoutBorderRadius),
                ),
                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.2),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                  const SizedBox(height: kSpaceXL),
                  CustomElevatedButton(
                    text: combatState.isPlayerReady
                        ? lang(context).notReady
                        : '${lang(context).ready} - ${lang(context).playAgain}',
                    buttonSize: ButtonSize.small,
                    shapeAt: RoundedWithShapeAt.topRight,
                    backgroundColor: combatState.isPlayerReady
                        ? Theme.of(context).colorScheme.error
                        : Theme.of(context).colorScheme.tertiary,
                    onPressed: () {
                      context.read<CombatBloc>().add(
                            CombatRestartReady(
                              isReady: !combatState.isPlayerReady,
                            ),
                          );
                    },
                  ),
                ],
              ),
            ),
          ] else ...[
            CustomElevatedButton(
              text: lang(context).playAgain,
              buttonSize: ButtonSize.small,
              shapeAt: RoundedWithShapeAt.topRight,
              onPressed: () {
                context.read<CombatBloc>().add(CombatRestartRequested());
              },
            ),
          ],
          const SizedBox(height: kSpace3XL),

          // Return to menu button at bottom
          CustomElevatedButton(
            text: lang(context).returnToMenu,
            buttonSize: ButtonSize.small,
            shapeAt: RoundedWithShapeAt.bottomLeft,
            backgroundColor: Theme.of(context).colorScheme.onSurfaceVariant,
            onPressed: () {
              // Reset CombatBloc to fresh initial state
              context.read<CombatBloc>().add(CombatBlocReset());

              // Reset CombatNavCubit to initial state
              context.read<CombatNavCubit>().reset();

              // Navigate back to select play mode
              context.read<PlayerNavCubit>().showSelectPlayMode();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildReadyIndicator(
    BuildContext context, {
    required String label,
    required bool isReady,
  }) {
    return Column(
      children: [
        Container(
          width: 70.0, // Smaller size for ready indicators
          height: 70.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady
                ? Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.3)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withValues(alpha: 0.3),
            border: Border.all(
              color: isReady
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              width: kStrokeWidthMedium,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: kIconSizeM,
            color: isReady
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: kSpaceS),
        Text(
          label,
          style: AppTextStyles.bodyMedium(context),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: AppTextStyles.withColor(
            AppTextStyles.bodySmall(context),
            isReady
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  String _getGameEndReason(BuildContext context, CombatState combatState) {
    final reason = combatState.gameEndReason;

    switch (reason) {
      case GameEndReason.opponentLivesOut:
        return lang(context).opponentRanOutOfLives;
      case GameEndReason.myLivesOut:
        return lang(context).youRanOutOfLives;
      case GameEndReason.opponentDisconnected:
        return lang(context).opponentDisconnected;
      case GameEndReason.timeout:
        return lang(context).youRanOutOfLives; // Timeout is treated as losing
      case null:
        return '';
    }
  }
}
