import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show ResponsiveContext, kMaxEquationButtonWidth, kSpaceM;
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart'
    show KeyboardOption, GamepadKeypadSide;
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/tour_keys.dart';
import 'package:nucatch/widgets/pick_right_buttons.dart';
import 'package:nucatch/helpers/lightning_painter.dart';

/// Playing controls widget for Pick Right difficulty mode
/// Displays equation buttons and control buttons (Reset & Main Menu)
class PickRightModeControls extends StatelessWidget {
  final TurnState turnState;
  final GlobalKey animationKey;
  final VoidCallback onMenuPressed;

  /// Mirrors `RegularModeControls.gamepadSide`. When set, this instance
  /// renders as one half of a gamepad-style split: the *entire* set of
  /// answer buttons (not a partial column — there's no natural left/right
  /// split of 3 equations the way there is for a 0-9 keypad), duplicated
  /// across both halves so either thumb can pick any answer without
  /// stretching to the middle, plus one control button — Reset on the
  /// left half, Main Menu on the right — matching where those sit in
  /// RegularModeControls' own left/right clusters.
  final GamepadKeypadSide? gamepadSide;

  const PickRightModeControls({
    super.key,
    required this.turnState,
    required this.animationKey,
    required this.onMenuPressed,
    this.gamepadSide,
  });

  void _onEquationTap(BuildContext context, int buttonIndex, Offset? position) {
    context.read<TurnBloc>().add(
          PickRightButtonTap(buttonIndex: buttonIndex),
        );

    // Trigger firework animation at button position if correct
    if (position != null) {
      // Delay slightly to allow state update
      Future.delayed(const Duration(milliseconds: 100), () {
        if (!context.mounted) return;
        final turnState = context.read<TurnBloc>().state;
        final expectedButton = int.tryParse(turnState.expect!) ?? -1;
        if (buttonIndex == expectedButton) {
          final animState = animationKey.currentState;
          if (animState != null) {
            (animState as dynamic).triggers.onAddPoint(position);
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (gamepadSide != null) {
      return _buildGamepadCluster(context, gamepadSide!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate button sizes for consistent spacing
        final buttonHeight =
            constraints.maxHeight / 3; // 3 rows: 2 for buttons, 1 for controls
        const buttonSpacing = 20.0;

        Widget equationButtons = SizedBox(
          height: buttonHeight * 2 - buttonSpacing,
          child: PickRightButtons(
            key: ValueKey(turnState.equations?.join(',')),
            buttonKeys: TourKeys.pickRightButtonKeys,
            equations: turnState.equations ?? [],
            selectedOption: turnState.selectedOption,
            isEnabled: turnState.isAbleToTap,
            isCorrectAnimating: turnState.pickRightJustCorrect,
            showCorrectAnswer: turnState.pickRightShowCorrect,
            correctIndex: turnState.correctIndex,
            onButtonTap: (buttonIndex, position) =>
                _onEquationTap(context, buttonIndex, position),
          ),
        );
        // On tablet, DeviceWrapper is widened past 800px in landscape —
        // clamp equation buttons so they don't stretch into unreadably
        // wide pills. Mobile is left untouched.
        if (context.isTablet) {
          equationButtons = Center(
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: kMaxEquationButtonWidth),
              child: equationButtons,
            ),
          );
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Equation buttons
            equationButtons,
            // Control buttons (Reset & Main Menu)
            SizedBox(
              height: buttonHeight - buttonSpacing,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Reset button
                  AnimatedButton(
                    context,
                    key: TourKeys.keypadKeys[KeyboardOption.reset],
                    iconData: FontAwesomeIcons.arrowsRotate,
                    isEnable: turnState.isAbleToReset && turnState.isAbleToTap,
                    onPressed: () {
                      context.read<TurnBloc>().add(
                            ResetNewNumber(
                                duration: const Duration(milliseconds: 200)),
                          );
                    },
                    backgroundBuilder: (context, borderRadius) {
                      return LightningWidget(
                          baseColor: Theme.of(context).primaryColor,
                          seed: 'Reset'.hashCode,
                          borderRadius: borderRadius);
                    },
                  ),
                  // Main Menu button
                  AnimatedButton(
                    context,
                    key: TourKeys.keypadKeys[KeyboardOption.mainMenu],
                    iconData: FontAwesomeIcons.bars,
                    onPressed: onMenuPressed,
                    backgroundBuilder: (context, borderRadius) {
                      return LightningWidget(
                          baseColor: Theme.of(context).primaryColor,
                          seed: 'Menu'.hashCode,
                          borderRadius: borderRadius);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGamepadCluster(BuildContext context, GamepadKeypadSide side) {
    final isLeft = side == GamepadKeypadSide.left;
    // Only one copy owns the tutorial-spotlight keys — a GlobalKey can
    // only back one mounted widget at a time. The right cluster is the
    // canonical owner, mirroring RegularModeControls' duplicated
    // middle-column convention.
    final ownsButtonKeys = !isLeft;

    final equationButtons = Expanded(
      child: PickRightButtons(
        key: ValueKey('${side.name}-${turnState.equations?.join(',')}'),
        buttonKeys: ownsButtonKeys ? TourKeys.pickRightButtonKeys : null,
        equations: turnState.equations ?? [],
        selectedOption: turnState.selectedOption,
        isEnabled: turnState.isAbleToTap,
        isCorrectAnimating: turnState.pickRightJustCorrect,
        showCorrectAnswer: turnState.pickRightShowCorrect,
        correctIndex: turnState.correctIndex,
        onButtonTap: (buttonIndex, position) =>
            _onEquationTap(context, buttonIndex, position),
      ),
    );

    // Reset lives on the left, Main Menu on the right — matching where
    // RegularModeControls' own left/right clusters place them (reset is
    // keyboardArray's column 0, main menu is column 2).
    final controlButton = isLeft
        ? AnimatedButton(
            context,
            key: TourKeys.keypadKeys[KeyboardOption.reset],
            iconData: FontAwesomeIcons.arrowsRotate,
            isEnable: turnState.isAbleToReset && turnState.isAbleToTap,
            onPressed: () {
              context.read<TurnBloc>().add(
                    ResetNewNumber(duration: const Duration(milliseconds: 200)),
                  );
            },
            backgroundBuilder: (context, borderRadius) {
              return LightningWidget(
                  baseColor: Theme.of(context).primaryColor,
                  seed: 'Reset'.hashCode,
                  borderRadius: borderRadius);
            },
          )
        : AnimatedButton(
            context,
            key: TourKeys.keypadKeys[KeyboardOption.mainMenu],
            iconData: FontAwesomeIcons.bars,
            onPressed: onMenuPressed,
            backgroundBuilder: (context, borderRadius) {
              return LightningWidget(
                  baseColor: Theme.of(context).primaryColor,
                  seed: 'Menu'.hashCode,
                  borderRadius: borderRadius);
            },
          );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kSpaceM),
      child: Column(
        children: [
          equationButtons,
          const SizedBox(height: kSpaceM),
          controlButton,
        ],
      ),
    );
  }
}
