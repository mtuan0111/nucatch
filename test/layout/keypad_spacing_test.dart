import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart'
    show GamepadKeypadSide, keyboardArray;
import 'package:nucatch/widgets/regular_mode_controls.dart';
import 'package:skeleton_core/skeleton_core.dart' show AnimatedButton;

/// The real keypad must leave a visible gap between every pair of
/// neighbouring keys — in rows and in columns — whatever room it gets: a
/// phone fills its region and spreads the keys out, but a tablet, a Fold
/// pane or a gamepad cluster shrinks the grid to fit, which once stacked
/// the rows flush against each other.
void main() {
  const regions = <String, Size>{
    'phone': Size(390, 430),
    'tablet': Size(720, 640),
    'fold tabletop pane': Size(761, 304),
    'flip cover': Size(250, 190),
  };

  for (final MapEntry(key: name, value: size) in regions.entries) {
    for (final side in <GamepadKeypadSide?>[null, ...GamepadKeypadSide.values]) {
      final label = '$name, ${side?.name ?? 'full grid'}';
      testWidgets('keys never touch: $label', (tester) async {
        // The window decides phone vs tablet sizing; give it a size that
        // matches the region's kind.
        tester.view.physicalSize =
            name == 'tablet' ? const Size(1024, 1366) : const Size(412, 915);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox.fromSize(
                key: const ValueKey('region'),
                size: side == null ? size : Size(size.width / 3, size.height),
                child: RegularModeControls(
                  turnState: const TurnState(),
                  keyboardArray: keyboardArray,
                  onMenuPressed: () {},
                  gamepadSide: side,
                ),
              ),
            ),
          ),
        ));
        await tester.pump();

        final region = tester.getRect(find.byKey(const ValueKey('region')));
        final keys = [
          for (final e in find.byType(AnimatedButton).evaluate())
            tester.getRect(find.byWidget(e.widget)),
        ];
        expect(keys, hasLength(side == null ? 12 : 8));

        for (final key in keys) {
          expect(region.inflate(0.5).contains(key.topLeft), isTrue,
              reason: '$label: key $key outside $region');
          expect(region.inflate(0.5).contains(key.bottomRight), isTrue,
              reason: '$label: key $key outside $region');
        }
        for (var i = 0; i < keys.length; i++) {
          for (var j = i + 1; j < keys.length; j++) {
            // At least 2 logical pixels between any two keys.
            expect(keys[i].inflate(1).overlaps(keys[j]), isFalse,
                reason: '$label: keys ${keys[i]} and ${keys[j]} touch');
          }
        }
      });
    }
  }
}
