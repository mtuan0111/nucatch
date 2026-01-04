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
                            duration: const Duration(milliseconds: 300),
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
                                  style:
                                      LayoutConfig(context).displaySmallStyle(
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
          // Result Icon
          Icon(
            isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: kContainerSizeS,
            color: isWinner
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: kSpaceXL),

          // Game End Reason
          Text(
            _getGameEndReason(context, combatState),
            style: LayoutConfig(context).largeBoldStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kSpace4XL),

          // Ready indicators section
          if (combatState.isRestartRequested) ...[
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
            const SizedBox(height: kSpace3XL),
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
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: LayoutConfig(context).contentSectionStyle(
            color: isReady
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
