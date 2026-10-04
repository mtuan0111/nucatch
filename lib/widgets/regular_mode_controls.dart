// ignore_for_file: unused_import

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/lightning_painter.dart';
import 'package:nucatch/helpers/game_layout.dart';
import 'package:nucatch/helpers/tour_keys.dart';

/// Playing controls widget for Regular (normal) difficulty modes.
///
/// By default (`gamepadSide: null`) displays the full 3x4 numeric keypad
/// (numbers 0-9, Reset, and Main Menu) in a single grid. On tablet
/// landscape, [PlayScreen] instead places two instances of this widget —
/// one with `gamepadSide: GamepadKeypadSide.left`, one with `.right` — at
/// the outer edges of the screen with the challenge/score content centered
/// between them, gamepad-controller style. The middle logical column
/// (digits 2/5/8/0) is duplicated across both halves so either thumb can
/// reach any digit without stretching to the center.
class RegularModeControls extends StatelessWidget {
  final TurnState turnState;
  final Map<KeyboardOption, int> keyboardArray;
  final VoidCallback onMenuPressed;
  final GamepadKeypadSide? gamepadSide;

  const RegularModeControls({
    super.key,
    required this.turnState,
    required this.keyboardArray,
    required this.onMenuPressed,
    this.gamepadSide,
  });

  static const int _totalColumns = 3;
  static const int _rows = 4;

  /// Builds the button for one keypad entry. [applyTourKey] is false for a
  /// gamepad-cluster's duplicate copy of a middle-column button — a
  /// `GlobalKey` (`TourKeys.keypadKeys[...]`) can only back one mounted
  /// widget at a time, so only one on-screen copy of each button may carry
  /// it.
  Widget _buildButton(
    BuildContext context,
    MapEntry<KeyboardOption, int> e, {
    required bool applyTourKey,
  }) {
    final key = applyTourKey ? TourKeys.keypadKeys[e.key] : null;
    const duration = Duration(milliseconds: 200);

    if (e.key == KeyboardOption.reset) {
      return AnimatedButton(
        context,
        key: key,
        iconData: FontAwesomeIcons.arrowsRotate,
        isEnable: turnState.isAbleToReset && turnState.isAbleToTap,
        onPressed: () {
          context.read<TurnBloc>().add(ResetNewNumber(duration: duration));
        },
        backgroundBuilder: (context, borderRadius) {
          return LightningWidget(
              baseColor: Theme.of(context).primaryColor,
              seed: 'Reset'.hashCode,
              borderRadius: borderRadius);
        },
      );
    }
    if (e.key == KeyboardOption.mainMenu) {
      return AnimatedButton(
        context,
        key: key,
        iconData: FontAwesomeIcons.bars,
        onPressed: onMenuPressed,
        backgroundBuilder: (context, borderRadius) {
          return LightningWidget(
              baseColor: Theme.of(context).primaryColor,
              seed: 'Menu'.hashCode,
              borderRadius: borderRadius);
        },
      );
    }
    return AnimatedButton(
      context,
      key: key,
      text: e.value.toString(),
      style: AppTextStyles.displaySmallBold(context),
      isEnable: turnState.isAbleToTap,
      onPressed: () {
        context.read<TurnBloc>().add(Tap(keyValue: e.key));
      },
      backgroundBuilder: (context, borderRadius) {
        return LightningWidget(
            baseColor: Theme.of(context).primaryColor,
            seed: e.value.toString().hashCode,
            borderRadius: borderRadius);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final keys = keyboardArray.entries.toList();

    if (gamepadSide != null) {
      return _buildGamepadCluster(context, keys, gamepadSide!);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final rawWidth = constraints.maxWidth / _totalColumns;
        final rawHeight = constraints.maxHeight / _rows;
        final spacing = keypadSpacing(math.min(rawWidth, rawHeight));
        // Clamp so keypad cells stay roughly square instead of stretching
        // into elongated rectangles — on tablets, where height (an uncapped
        // window-height fraction) can far exceed width (capped by
        // DeviceWrapper), and on any window whose cells would be badly
        // out of proportion (a wide, short tabletop pane). Phones are
        // left untouched — see keypadClampsCells.
        final bool clampCells = keypadClampsCells(context, rawWidth, rawHeight);
        final double cellSize = math
            .min(rawWidth, rawHeight)
            .clamp(0.0, kMaxKeypadButtonSize + spacing);
        final buttonWidth = clampCells ? cellSize : rawWidth;
        final buttonHeight = clampCells ? cellSize : rawHeight;

        List<Widget> columnChildren = [];
        for (int r = 0; r < _rows; r++) {
          List<Widget> rowChildren = [];
          for (int c = 0; c < _totalColumns; c++) {
            int idx = r * _totalColumns + c;
            Widget cell;
            if (idx < keys.length) {
              cell = SizedBox(
                width: buttonWidth - spacing,
                height: buttonHeight - spacing,
                child: _buildButton(context, keys[idx], applyTourKey: true),
              );
            } else {
              cell = SizedBox(
                width: buttonWidth - spacing,
                height: buttonHeight - spacing,
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

        final grid = Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: clampCells ? MainAxisSize.min : MainAxisSize.max,
          children: columnChildren,
        );
        // Clamped cells no longer fill the available region — center them.
        // Unclamped (mobile) stays exactly as before: unwrapped, filling
        // the full parent via spaceEvenly.
        return clampCells ? Center(child: grid) : grid;
      },
    );
  }

  Widget _buildGamepadCluster(
    BuildContext context,
    List<MapEntry<KeyboardOption, int>> keys,
    GamepadKeypadSide side,
  ) {
    final columns = side == GamepadKeypadSide.left ? [0, 1] : [1, 2];
    // The middle column (digits 2/5/8/0) is duplicated across both
    // clusters — the right cluster is the canonical owner of its
    // TourKeys.keypadKeys GlobalKey; the left cluster's copies go keyless.
    final ownsMiddleColumnKey = side == GamepadKeypadSide.right;

    return LayoutBuilder(builder: (context, constraints) {
      final rawWidth = constraints.maxWidth / columns.length;
      final rawHeight = constraints.maxHeight / _rows;
      final spacing = keypadSpacing(math.min(rawWidth, rawHeight));
      final cellSize = math
          .min(rawWidth, rawHeight)
          .clamp(0.0, kMaxKeypadButtonSize + spacing);

      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            for (int r = 0; r < _rows; r++)
              Row(
                // Row fills the cluster's full given width (default
                // MainAxisSize.max) so spaceEvenly has room to distribute
                // gaps — mirrors the full-grid path below. Cell size is
                // cellSize *minus* spacing (not padding added on top of
                // it), same as the full grid: adding padding around an
                // already-clamped cell would push the row's natural width
                // past what the cluster's tight parent width allows.
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (final c in columns)
                    if (r * _totalColumns + c < keys.length)
                      SizedBox(
                        width: cellSize - spacing,
                        height: cellSize - spacing,
                        child: _buildButton(
                          context,
                          keys[r * _totalColumns + c],
                          applyTourKey: c != 1 || ownsMiddleColumnKey,
                        ),
                      ),
                ],
              ),
          ],
        ),
      );
    });
  }
}
