import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
          child: DeviceWrapper(
            child: BlocBuilder<CombatBloc, CombatState>(
              builder: (context, combatState) {
                // Show restart confirmation if restart is requested
                if (combatState.isRestartRequested) {
                  return _buildRestartConfirmation(context, combatState);
                }

                // Show win/lose screen
                return _buildGameEndScreen(context, combatState);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameEndScreen(BuildContext context, CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: kContainerSizeS,
            color: isWinner ? const Color(0xFFFFD700) : Colors.grey,
          ),
          const SizedBox(height: kSpaceXL),
          Text(
            isWinner ? lang(context).youWin : lang(context).youLose,
            style: LayoutConfig(context)
                .displaySmallStyle(
                  isActiveShadow: true,
                )
                .copyWith(
                  fontSize: kFontSize4XL + 3,
                  color: isWinner ? Colors.green : Colors.red,
                ),
          ),
          const SizedBox(height: kSpaceXL),
          Text(
            _getGameEndReason(context, combatState.gameEndReason),
            style: LayoutConfig(context).contentSectionStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: kSpace4XL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomElevatedButton(
                text: lang(context).playAgain,
                shapeAt: RoundedWithShapeAt.all,
                onPressed: () {
                  context.read<CombatBloc>().add(CombatRestartRequested());
                },
              ),
              const SizedBox(width: kSpaceXL),
              CustomElevatedButton(
                text: lang(context).returnToMenu,
                shapeAt: RoundedWithShapeAt.all,
                backgroundColor: Colors.grey,
                onPressed: () {
                  context.read<PlayerNavCubit>().showSelectPlayMode();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRestartConfirmation(
      BuildContext context, CombatState combatState) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.refresh,
            size: kContainerSizeS,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: kSpaceXL),
          Text(
            lang(context).doYouReadyForRestart,
            style: LayoutConfig(context).displaySmallStyle(
              isActiveShadow: true,
            ),
            textAlign: TextAlign.center,
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
            backgroundColor:
                combatState.isPlayerReady ? Colors.orange : Colors.green,
            onPressed: () {
              context.read<CombatBloc>().add(
                    CombatRestartReady(isReady: !combatState.isPlayerReady),
                  );
            },
          ),
          const SizedBox(height: kSpaceXL),
          TextButton(
            onPressed: () {
              context.read<PlayerNavCubit>().showSelectPlayMode();
            },
            child: Text(
              lang(context).cancel,
              style: LayoutConfig(context).contentSectionStyle(),
            ),
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

  String _getGameEndReason(BuildContext context, String? reason) {
    switch (reason) {
      case 'opponent_lives_out':
        return lang(context).opponentRanOutOfLives;
      case 'my_lives_out':
        return lang(context).youRanOutOfLives;
      case 'opponent_disconnected':
        return lang(context).opponentDisconnected;
      default:
        return '';
    }
  }
}
