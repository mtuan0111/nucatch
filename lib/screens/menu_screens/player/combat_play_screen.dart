import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

class CombatPlayScreen extends StatefulWidget {
  const CombatPlayScreen({super.key});

  @override
  State<CombatPlayScreen> createState() => _CombatPlayScreenState();
}

class _CombatPlayScreenState extends State<CombatPlayScreen> {
  @override
  void initState() {
    super.initState();

    // Game is already initialized by host/guest before navigating here
    // No need to call CombatGameStarted again
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CombatBloc, CombatState>(
      builder: (context, combatState) {
        return Scaffold(
          body: Container(
            decoration: LayoutConfig(context).gradientDecoration,
            child: SafeArea(
              child: DeviceWrapper(
                child: Column(
                  children: [
                    // Header with turn info and scores
                    _buildHeader(combatState),

                    // Game area
                    Expanded(
                      child: _buildGameArea(combatState),
                    ),

                    // Controls
                    if (combatState.canTap) _buildKeyboard(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(CombatState combatState) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // My info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You',
                  style: LayoutConfig(context)
                      .titleSectionStyle()
                      .copyWith(fontSize: 16),
                ),
                Text(
                  'Score: ${combatState.point}',
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
                Text(
                  'Lives: ${combatState.lifeRemaining}',
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
              ],
            ),
          ),

          // Turn indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: combatState.isMyTurn ? Colors.green : Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              combatState.isMyTurn
                  ? lang(context).yourTurn
                  : lang(context).opponentTurn,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Opponent info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Opponent',
                  style: LayoutConfig(context)
                      .titleSectionStyle()
                      .copyWith(fontSize: 16),
                ),
                Text(
                  'Score: ${combatState.opponentScore}',
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
                Text(
                  'Lives: ${combatState.opponentLives}',
                  style: LayoutConfig(context).contentSectionStyle(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameArea(CombatState combatState) {
    if (combatState.hasGameEnded) {
      return _buildGameEndScreen(combatState);
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Challenge text
          if (combatState.requirementString != null) ...[
            Text(
              'Solve:',
              style: LayoutConfig(context).contentSectionStyle(),
            ),
            const SizedBox(height: 20),
            Text(
              combatState.requirementString!,
              style: LayoutConfig(context)
                  .displaySmallStyle(
                    isActiveShadow: true,
                    isItalic: false,
                  )
                  .copyWith(fontSize: 48),
            ),
            const SizedBox(height: 30),
          ],

          // Input area
          if (combatState.expect != null) ...[
            Text(
              'Answer:',
              style: LayoutConfig(context).contentSectionStyle(),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              child: Text(
                combatState.typing.isEmpty
                    ? '_' * combatState.expect!.length
                    : combatState.typing,
                style: LayoutConfig(context).displaySmallStyle().copyWith(
                      fontSize: 36,
                      letterSpacing: 4,
                    ),
              ),
            ),
          ],

          const SizedBox(height: 30),

          // Status messages
          if (combatState.isWaitingForOpponent)
            Text(
              lang(context).waitingForOpponent,
              style: LayoutConfig(context).contentSectionStyle().copyWith(
                    color: Colors.yellow,
                  ),
            )
          else if (combatState.isOpponentActive)
            Text(
              lang(context).watchingOpponent,
              style: LayoutConfig(context).contentSectionStyle().copyWith(
                    color: Colors.orange,
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildGameEndScreen(CombatState combatState) {
    final isWinner = combatState.isWinner ?? false;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isWinner ? Icons.emoji_events : Icons.sentiment_dissatisfied,
            size: 100,
            color: isWinner ? const Color(0xFFFFD700) : Colors.grey,
          ),
          const SizedBox(height: 20),
          Text(
            isWinner ? lang(context).youWin : lang(context).youLose,
            style: LayoutConfig(context)
                .displaySmallStyle(
                  isActiveShadow: true,
                )
                .copyWith(
                  fontSize: 48,
                  color: isWinner ? Colors.green : Colors.red,
                ),
          ),
          const SizedBox(height: 20),
          Text(
            _getGameEndReason(combatState.gameEndReason),
            style: LayoutConfig(context).contentSectionStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          CustomElevatedButton(
            text: 'Return to Menu',
            shapeAt: RoundedWithShapeAt.all,
            onPressed: () {
              // Just navigate to menu - game state will be reset on next game start
              context.read<PlayerNavCubit>().showSelectPlayMode();
            },
          ),
        ],
      ),
    );
  }

  String _getGameEndReason(String? reason) {
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

  Widget _buildKeyboard() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keys = keyboardArray.entries.toList();
          const columns = 3;
          const rows = 4;
          final buttonWidth = constraints.maxWidth / columns;
          final buttonHeight = 80.0;
          const buttonSpacing = 10.0;

          List<TableRow> tableRows = [];
          for (int r = 0; r < rows; r++) {
            List<Widget> rowChildren = [];
            for (int c = 0; c < columns; c++) {
              int idx = r * columns + c;
              Widget cell;
              if (idx < keys.length) {
                final e = keys[idx];
                Widget button;
                if (e.key == KeyboardOption.reset) {
                  button = AnimatedButton(
                    context,
                    iconData: FontAwesomeIcons.arrowsRotate,
                    isEnable: context.watch<CombatBloc>().state.isAbleToReset &&
                        context.watch<CombatBloc>().state.canTap,
                    onPressed: () {
                      context.read<CombatBloc>().add(
                            CombatNumberReset(
                                duration: const Duration(milliseconds: 200)),
                          );
                    },
                  );
                } else if (e.key == KeyboardOption.mainMenu) {
                  button = AnimatedButton(
                    context,
                    iconData: FontAwesomeIcons.bars,
                    onPressed: () {
                      // Handle menu button - maybe show dialog to end game
                    },
                  );
                } else {
                  button = AnimatedButton(
                    context,
                    text: e.value.toString(),
                    style: LayoutConfig(context).boldedStyle,
                    isEnable: context.watch<CombatBloc>().state.canTap,
                    onPressed: () {
                      context.read<CombatBloc>().add(
                            CombatPlayerTapped(keyValue: e.key),
                          );
                    },
                  );
                }
                cell = SizedBox(
                  width: buttonWidth - buttonSpacing,
                  height: buttonHeight - buttonSpacing,
                  child: button,
                );
              } else {
                cell = SizedBox(
                  width: buttonWidth - buttonSpacing,
                  height: buttonHeight - buttonSpacing,
                );
              }
              rowChildren.add(cell);
            }
            tableRows.add(TableRow(children: rowChildren));
          }

          return Table(
            children: tableRows,
          );
        },
      ),
    );
  }
}
