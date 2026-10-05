import 'dart:math' as math;
import 'dart:ui' show DisplayFeature;

import 'package:flutter/widgets.dart';
import 'package:skeleton_core/skeleton_core.dart'
    show FoldLayout, ResponsiveContext;

/// How [PlayScreen] and [CombatPlayScreen] arrange the header (timer, score,
/// lives, challenge) against the controls (keypad or Pick Right answers).
/// See `docs/FOLDABLE_SUPPORT_PLAN.md` §3.2.
enum GameLayoutMode {
  /// Header above controls — phones, a Flip opened flat, a Fold's cover
  /// screen, and a Fold's inner screen in either orientation.
  stacked,

  /// [stacked] for a small, near-square window (a Flip's cover screen): the
  /// same arrangement without [DeviceWrapper]'s gutters, which would
  /// otherwise eat a fifth of the keypad width.
  compactSquare,

  /// Clearly-wider-than-tall window: the keypad split into two clusters on
  /// the outer edges, header centered between them.
  gamepad,

  /// Half-opened with a horizontal fold (Flip Flex Mode, a Fold rotated on
  /// a table): header in the top pane, controls in the bottom pane.
  tabletop,

  /// A vertical fold half-opened like a book, or a Surface Duo spanned:
  /// header in the left pane, controls in the right pane.
  twoPane,
}

abstract final class GameLayout {
  /// Width/height at or above which the window gets the [GameLayoutMode.gamepad]
  /// split. A Fold's inner screen held sideways (~1.2) stays [stacked] —
  /// decided in the plan, §6.2.
  static const double gamepadMinAspect = 1.3;

  /// Longest/shortest side below which a window counts as near-square.
  static const double squareMaxAspect = 1.3;

  /// A near-square window is only [GameLayoutMode.compactSquare] while its
  /// longest side is under this — a Fold's inner screen is near-square too,
  /// but has room for the regular gutters.
  static const double compactMaxLongestSide = 600;

  /// Each pane of a split must be at least this wide (book) or tall
  /// (tabletop); passed to `HingeSplit.minPaneExtent` so its fallback and
  /// [resolve] agree.
  static const double minSplitPaneExtent = 240;

  static GameLayoutMode resolve(
    Size size,
    Iterable<DisplayFeature> features,
  ) {
    if (size.isEmpty) return GameLayoutMode.stacked;

    final fold = FoldLayout.fromData(size, features);
    final panes = fold.panes;
    if (fold.hasSeparator && panes.length == 2) {
      final isBook = fold.isBook;
      final roomy = panes.every(
        (p) => (isBook ? p.width : p.height) >= minSplitPaneExtent,
      );
      if (roomy) {
        return isBook ? GameLayoutMode.twoPane : GameLayoutMode.tabletop;
      }
    }

    final aspect = size.longestSide / size.shortestSide;
    if (aspect < squareMaxAspect && size.longestSide < compactMaxLongestSide) {
      return GameLayoutMode.compactSquare;
    }
    if (size.width / size.height >= gamepadMinAspect) {
      return GameLayoutMode.gamepad;
    }
    return GameLayoutMode.stacked;
  }

  /// [resolve] for the window [context] sees. Read it in `build` so the
  /// screen rebuilds on fold, unfold, rotation and resize.
  static GameLayoutMode of(BuildContext context) => resolve(
        MediaQuery.sizeOf(context),
        MediaQuery.displayFeaturesOf(context),
      );
}

/// Gap between keypad buttons on a regular phone.
const double kKeypadButtonSpacing = 20.0;

/// Keypad gap for cells of [rawCellExtent] (the smaller of a cell's raw
/// width and height): [kKeypadButtonSpacing] on every phone, shrinking on
/// cramped windows (a Flip's cover screen) so the buttons keep their size
/// instead of the gaps.
double keypadSpacing(double rawCellExtent) =>
    math.min(kKeypadButtonSpacing, rawCellExtent * 0.25);

/// Keypad gap for clamped cells (see [keypadClampsCells]): tighter than
/// [keypadSpacing] on short cells — in a Fold's tabletop pane a 20-ish gap
/// would take a quarter of each row away from the keys — and the same
/// [kKeypadButtonSpacing] once cells are tablet-sized.
double clampedKeypadSpacing(double rawCellExtent) =>
    math.min(kKeypadButtonSpacing, rawCellExtent * 0.12);

/// How much wider than tall a clamped keypad cell may grow — enough to use
/// a wide, short region's spare width without turning keys into bars.
const double kKeypadMaxCellAspect = 1.5;

/// Inner padding for a keypad key whose shorter side is [keyExtent]. The
/// label is scaled down to fit inside it, so a fixed padding (the button's
/// default 20 on every side) would shrink the digit on small keys to a few
/// pixels; scaling it keeps the digit large on every window.
double keypadKeyPadding(double keyExtent) =>
    (keyExtent * 0.12).clamp(4.0, 20.0);

/// Whether keypad cells should be clamped square rather than stretched to
/// fill their region: always on tablet-class windows, and on any window
/// whose cells would otherwise be more than 1.5× as long one way as the
/// other (e.g. the wide, short bottom pane of a Fold in tabletop posture).
/// Phones, a Flip opened flat and a Fold's cover screen sit well under
/// that, so they keep today's full-bleed keypad.
bool keypadClampsCells(
  BuildContext context,
  double rawWidth,
  double rawHeight,
) {
  if (context.isTablet) return true;
  final shorter = math.min(rawWidth, rawHeight);
  if (shorter <= 0) return false;
  return math.max(rawWidth, rawHeight) / shorter > 1.5;
}
