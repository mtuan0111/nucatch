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
            child: BlocListener<CombatBloc, CombatState>(
              listenWhen: (previous, current) =>
                  !previous.isRestartRequested && current.isRestartRequested,
              listener: (context, state) {
                // Navigate to restart confirmation screen when restart is requested
                context.read<CombatNavCubit>().showRestartConfirmation();
              },
              child: BlocBuilder<CombatBloc, CombatState>(
                builder: (context, combatState) {
                  return _buildGameEndScreen(context, combatState);
                },
              ),
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
              Flexible(
                child: CustomElevatedButton(
                  text: lang(context).playAgain,
                  shapeAt: RoundedWithShapeAt.all,
                  onPressed: () {
                    context.read<CombatBloc>().add(CombatRestartRequested());
                  },
                ),
              ),
              const SizedBox(width: kSpaceXL),
              Flexible(
                child: CustomElevatedButton(
                  text: lang(context).returnToMenu,
                  shapeAt: RoundedWithShapeAt.all,
                  backgroundColor: Colors.grey,
                  onPressed: () {
                    // Reset CombatBloc to fresh initial state
                    context.read<CombatBloc>().add(CombatBlocReset());
                    
                    // Reset CombatNavCubit to initial state
                    context.read<CombatNavCubit>().reset();
                    
                    // Navigate back to select play mode
                    context.read<PlayerNavCubit>().showSelectPlayMode();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
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
