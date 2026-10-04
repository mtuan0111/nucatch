import 'package:flutter/material.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show DeviceWrapper, HingeSplit, kSpaceS;

import 'package:nucatch/helpers/const.dart' show GamepadKeypadSide;
import 'package:nucatch/helpers/game_layout.dart';

/// The game area shared by [PlayScreen] and [CombatPlayScreen]: [header]
/// (timer, score, lives, challenge) and the controls from [controlsBuilder],
/// arranged per [GameLayout.of].
///
/// Fills the window and applies its own [SafeArea]s — put it directly in a
/// full-window [Scaffold] body (behind any background decoration), not
/// inside a [SafeArea]: `HingeSplit` needs the window's own coordinates to
/// find the hinge.
///
/// [header] is placed in exactly one slot per layout, so the `TourKeys`
/// GlobalKeys inside it are reparented, never duplicated, when the device
/// folds or unfolds mid-game.
class GameLayoutBody extends StatelessWidget {
  const GameLayoutBody({
    super.key,
    required this.header,
    required this.controlsBuilder,
    this.headerFlex = 1,
    this.controlsFlex = 2,
  });

  final Widget header;

  /// Builds the full controls when `side` is null, or one edge cluster of
  /// the [GameLayoutMode.gamepad] split.
  final Widget Function(GamepadKeypadSide? side) controlsBuilder;

  /// Header/controls height ratio in the stacked layouts.
  final int headerFlex;
  final int controlsFlex;

  @override
  Widget build(BuildContext context) {
    final mode = GameLayout.of(context);
    return HingeSplit(
      minPaneExtent: GameLayout.minSplitPaneExtent,
      first: SafeArea(child: DeviceWrapper(child: header)),
      second: SafeArea(child: DeviceWrapper(child: controlsBuilder(null))),
      child: SafeArea(child: _singlePane(mode)),
    );
  }

  /// Every layout that doesn't split across a fold. [GameLayoutMode.tabletop]
  /// and [GameLayoutMode.twoPane] only reach here when `HingeSplit` can't
  /// split (it isn't filling the window), and fall back to stacked.
  Widget _singlePane(GameLayoutMode mode) {
    switch (mode) {
      case GameLayoutMode.gamepad:
        // Gamepad-style split: two control clusters pinned to the screen's
        // outer edges, the header centered between them — either thumb
        // reaches every control without stretching to the middle.
        return DeviceWrapper(
          maxWidth: double.infinity,
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: controlsBuilder(GamepadKeypadSide.left),
              ),
              Expanded(flex: 5, child: header),
              Expanded(
                flex: 2,
                child: controlsBuilder(GamepadKeypadSide.right),
              ),
            ],
          ),
        );
      case GameLayoutMode.compactSquare:
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: kSpaceS),
          child: _stacked(),
        );
      case GameLayoutMode.stacked:
      case GameLayoutMode.tabletop:
      case GameLayoutMode.twoPane:
        return DeviceWrapper(child: _stacked());
    }
  }

  Widget _stacked() => Column(
        children: [
          Expanded(flex: headerFlex, child: header),
          Expanded(flex: controlsFlex, child: controlsBuilder(null)),
        ],
      );
}
