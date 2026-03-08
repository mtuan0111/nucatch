// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/const.dart';

/// Playing controls widget for Regular (normal) difficulty modes
/// Displays 3x4 numeric keypad with numbers 0-9, Reset, and Main Menu buttons
class RegularModeControls extends StatelessWidget {
  final TurnState turnState;
  final Map<KeyboardOption, int> keyboardArray;
  final VoidCallback onMenuPressed;

  const RegularModeControls({
    super.key,
    required this.turnState,
    required this.keyboardArray,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Prepare 3x4 grid
        final keys = keyboardArray.entries.toList();
        const columns = 3;
        const rows = 4;
        final buttonWidth = constraints.maxWidth / columns;
        final buttonHeight = constraints.maxHeight / rows;
        const buttonSpacing = 20.0;

        List<Widget> columnChildren = [];
        for (int r = 0; r < rows; r++) {
          List<Widget> rowChildren = [];
          for (int c = 0; c < columns; c++) {
            int idx = r * columns + c;
            Widget cell;
            if (idx < keys.length) {
              final e = keys[idx];
              Duration duration = const Duration(milliseconds: 200);
              Widget button;

              if (e.key == KeyboardOption.reset) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.arrowsRotate,
                  isEnable: turnState.isAbleToReset && turnState.isAbleToTap,
                  onPressed: () {
                    context.read<TurnBloc>().add(
                          ResetNewNumber(duration: duration),
                        );
                  },
                );
              } else if (e.key == KeyboardOption.mainMenu) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.bars,
                  onPressed: onMenuPressed,
                );
              } else {
                button = AnimatedButton(
                  context,
                  text: e.value.toString(),
                  style: AppTextStyles.displayLarge(context),
                  isEnable: turnState.isAbleToTap,
                  onPressed: () {
                    context.read<TurnBloc>().add(
                          Tap(keyValue: e.key),
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

          columnChildren.add(
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: rowChildren,
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: columnChildren,
        );
      },
    );
  }
}
