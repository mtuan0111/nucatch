import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/widgets/mode_card.dart';
import 'package:skeleton_core/skeleton_core.dart';

void main() {
  // ModeCard puts its own Row inside CustomElevatedButton with an unbounded
  // minWidth; it must take the slot's width and wrap its description rather
  // than overflow, from a narrow phone column to a wide tablet cell.
  for (final width in [280.0, 420.0, 900.0]) {
    testWidgets('lays out and taps at width $width', (tester) async {
      tester.view.physicalSize = const Size(1200, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var taps = 0;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: width,
              child: ModeCard(
                title: 'Combat Mode',
                description:
                    'Play with another player via Bluetooth connection and '
                    'take turns',
                icon: FontAwesomeIcons.userGroup,
                color: Colors.pink,
                onTap: () => taps++,
              ),
            ),
          ),
        ),
      ));
      await tester.pump();

      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(ModeCard)).width, width);

      await tester.tap(find.text('Combat Mode'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(taps, 1);
    });
  }
}
