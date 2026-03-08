import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/widgets/pick_right_buttons.dart';

/// Playing controls widget for Pick Right difficulty mode
/// Displays equation buttons and control buttons (Reset & Main Menu)
class PickRightModeControls extends StatelessWidget {
  final TurnState turnState;
  final GlobalKey animationKey;
  final VoidCallback onMenuPressed;

  const PickRightModeControls({
    super.key,
    required this.turnState,
    required this.animationKey,
    required this.onMenuPressed,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate button sizes for consistent spacing
        final buttonHeight =
            constraints.maxHeight / 3; // 3 rows: 2 for buttons, 1 for controls
        const buttonSpacing = 20.0;

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Equation buttons
            SizedBox(
              height: buttonHeight * 2 - buttonSpacing,
              child: PickRightButtons(
                key: ValueKey(turnState.equations?.join(',')),
                equations: turnState.equations ?? [],
                selectedOption: turnState.selectedOption,
                isEnabled: turnState.isAbleToTap,
                isCorrectAnimating: turnState.pickRightJustCorrect,
                onButtonTap: (buttonIndex, position) {
                  context.read<TurnBloc>().add(
                        PickRightButtonTap(buttonIndex: buttonIndex),
                      );

                  // Trigger firework animation at button position if correct
                  if (position != null) {
                    // Delay slightly to allow state update
                    Future.delayed(const Duration(milliseconds: 100), () {
                      if (!context.mounted) return;
                      final turnState = context.read<TurnBloc>().state;
                      final expectedButton =
                          int.tryParse(turnState.expect!) ?? -1;
                      if (buttonIndex == expectedButton) {
                        final animState = animationKey.currentState;
                        if (animState != null) {
                          (animState as dynamic).triggers.onAddPoint(position);
                        }
                      }
                    });
                  }
                },
              ),
            ),
            // Control buttons (Reset & Main Menu)
            SizedBox(
              height: buttonHeight - buttonSpacing,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reset button
                  AnimatedButton(
                    context,
                    iconData: FontAwesomeIcons.arrowsRotate,
                    isEnable: turnState.isAbleToReset && turnState.isAbleToTap,
                    onPressed: () {
                      context.read<TurnBloc>().add(
                            ResetNewNumber(
                                duration: const Duration(milliseconds: 200)),
                          );
                    },
                  ),
                  // Main Menu button
                  AnimatedButton(
                    context,
                    iconData: FontAwesomeIcons.bars,
                    onPressed: onMenuPressed,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
