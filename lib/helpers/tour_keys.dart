import 'package:flutter/widgets.dart';
import 'package:nucatch/helpers/const.dart';

/// Static [GlobalKey]s used to spotlight real UI elements during the in-game
/// rule tutorial (see `tutorial_overlay.dart`).
///
/// [PlayScreen] and [CombatPlayScreen] are never mounted simultaneously, so a
/// single shared key per concept (score/life panel) is safe to reuse across
/// both — same reasoning [scoreKey]/[heartKey] already relied on when they
/// were private fields used only for particle-position lookups.
class TourKeys {
  static GlobalKey scoreKey = GlobalKey();
  static GlobalKey heartKey = GlobalKey();
  static GlobalKey opponentScoreKey = GlobalKey();
  static GlobalKey opponentHeartKey = GlobalKey();

  /// The number/expression display + typed-answer placeholders area.
  static GlobalKey challengeAreaKey = GlobalKey();

  /// Combat's header row (my score/level + opponent name), as a single
  /// spotlight target for the "welcome to combat" lesson.
  static GlobalKey combatHeaderKey = GlobalKey();

  /// One key per keypad button (0-9, reset, main menu). Shared by
  /// `RegularModeControls` and `CombatPlayScreen._buildKeyboard` — both
  /// build their own 3x4 grid from the same `keyboardArray`.
  ///
  /// Note: `KeyboardOption.eleven` is the entry that displays "7" in
  /// `const.dart`'s `keyboardArray` (almost certainly a pre-existing typo
  /// for `seven` — out of scope to rename here).
  static Map<KeyboardOption, GlobalKey> keypadKeys = {
    for (final option in KeyboardOption.values) option: GlobalKey(),
  };

  static GlobalKey get resetKey => keypadKeys[KeyboardOption.reset]!;
  static GlobalKey get menuKey => keypadKeys[KeyboardOption.mainMenu]!;

  /// One key per Pick Right equation button (always length 3).
  static List<GlobalKey> pickRightButtonKeys =
      List.generate(3, (_) => GlobalKey());

  static GlobalKey combatStatusBadgeKey = GlobalKey();
  static GlobalKey countdownBarKey = GlobalKey();

  /// Regenerates every key. Integration tests that call `app.main()` more
  /// than once within a single test binary reuse stale `GlobalKey`s across
  /// fresh widget trees, which Flutter can silently fail to reattach — call
  /// this before each such relaunch.
  static void reset() {
    scoreKey = GlobalKey();
    heartKey = GlobalKey();
    opponentScoreKey = GlobalKey();
    opponentHeartKey = GlobalKey();
    challengeAreaKey = GlobalKey();
    combatHeaderKey = GlobalKey();
    keypadKeys = {
      for (final option in KeyboardOption.values) option: GlobalKey(),
    };
    pickRightButtonKeys = List.generate(3, (_) => GlobalKey());
    combatStatusBadgeKey = GlobalKey();
    countdownBarKey = GlobalKey();
  }
}

/// Unions the global bounding rects of every key in [keys]. Returns
/// `Rect.zero` if none of them currently resolve to a mounted, sized
/// `RenderBox` (e.g. the target hasn't been laid out yet).
Rect getRectForKeys(List<GlobalKey> keys) {
  double minX = double.infinity;
  double minY = double.infinity;
  double maxX = double.negativeInfinity;
  double maxY = double.negativeInfinity;

  bool found = false;

  for (final key in keys) {
    try {
      // Wrapped as a whole, not just around `localToGlobal`: a `GlobalKey`
      // can still resolve `currentContext` for an element that has just
      // been deactivated (mid-removal from the tree, e.g. the previous
      // screen tearing down during a tutorial hand-off), and
      // `findRenderObject()` itself throws for an inactive element —
      // `box.hasSize` isn't even reached at that point. Similarly,
      // `box.hasSize` being true only guarantees the box itself is laid
      // out; an ancestor (a page-transition's RenderTransform) can still
      // be mid-layout for this frame, and `localToGlobal` throws walking
      // up through it.
      final RenderBox? box =
          key.currentContext?.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) continue;
      final position = box.localToGlobal(Offset.zero);
      minX = minX < position.dx ? minX : position.dx;
      minY = minY < position.dy ? minY : position.dy;
      maxX = maxX > position.dx + box.size.width
          ? maxX
          : position.dx + box.size.width;
      maxY = maxY > position.dy + box.size.height
          ? maxY
          : position.dy + box.size.height;
      found = true;
    } catch (_) {
      // Skip this key for this frame; the overlay will retry on the next
      // rebuild once the transition settles.
      continue;
    }
  }

  if (!found) return Rect.zero;
  return Rect.fromLTRB(minX, minY, maxX, maxY);
}
