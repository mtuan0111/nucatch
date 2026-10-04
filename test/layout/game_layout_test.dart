import 'dart:ui' show DisplayFeature;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/game_layout.dart';

import '../helpers/foldable_devices.dart';

void main() {
  group('GameLayout.resolve', () {
    final expected = <FoldableDevice, GameLayoutMode>{
      FoldableDevices.phone: GameLayoutMode.stacked,
      FoldableDevices.phoneLandscape: GameLayoutMode.gamepad,
      FoldableDevices.foldCover: GameLayoutMode.stacked,
      FoldableDevices.foldInnerFlat: GameLayoutMode.stacked,
      // Plan §6.2: the Fold's near-square inner screen stays stacked
      // sideways too, rather than taking the gamepad split.
      FoldableDevices.foldInnerLandscapeFlat: GameLayoutMode.stacked,
      FoldableDevices.foldBook: GameLayoutMode.twoPane,
      FoldableDevices.foldTabletop: GameLayoutMode.tabletop,
      FoldableDevices.flipInnerFlat: GameLayoutMode.stacked,
      FoldableDevices.flipFlexMode: GameLayoutMode.tabletop,
      // Plan §6.3: the Flex Window is fully playable.
      FoldableDevices.flipCover: GameLayoutMode.compactSquare,
      FoldableDevices.duoSingle: GameLayoutMode.stacked,
      FoldableDevices.duoSpanned: GameLayoutMode.twoPane,
      FoldableDevices.splitScreenShort: GameLayoutMode.gamepad,
    };

    test('covers every device in the matrix', () {
      expect(expected.keys.toSet(), FoldableDevices.all.toSet());
    });

    for (final MapEntry(key: device, value: mode) in expected.entries) {
      test('$device → ${mode.name}', () {
        expect(GameLayout.resolve(device.size, device.features), mode);
      });
    }

    test('a fold lying flat never splits', () {
      expect(
        GameLayout.resolve(
          FoldableDevices.flipInnerFlat.size,
          FoldableDevices.flipInnerFlat.features,
        ),
        GameLayoutMode.stacked,
      );
    });

    test('a half-open fold with a pane under the minimum does not split', () {
      final device = FoldableDevices.flipFlexMode;
      // Fold moved near the top edge: top pane only 100 tall.
      final lopsided = [
        DisplayFeature(
          bounds: Rect.fromLTWH(0, 100, device.size.width, 0),
          type: device.features.single.type,
          state: device.features.single.state,
        ),
      ];
      expect(
        GameLayout.resolve(device.size, lopsided),
        GameLayoutMode.stacked,
      );
    });

    test('an empty window resolves without dividing by zero', () {
      expect(GameLayout.resolve(Size.zero, const []), GameLayoutMode.stacked);
    });
  });

  group('keypadSpacing', () {
    test('keeps the 20dp phone gap for phone-sized cells', () {
      // Phone portrait cells are ~90-130dp; gamepad clusters ~80-90dp.
      for (final extent in [80.0, 93.0, 127.0, 200.0]) {
        expect(keypadSpacing(extent), kKeypadButtonSpacing, reason: '$extent');
      }
    });

    test('shrinks on cramped cells so buttons keep their size', () {
      expect(keypadSpacing(56), lessThan(kKeypadButtonSpacing));
      expect(56 - keypadSpacing(56), greaterThanOrEqualTo(42));
    });
  });

  group('keypadClampsCells', () {
    Future<bool> clamps(
      WidgetTester tester,
      FoldableDevice device,
      double w,
      double h,
    ) async {
      device.apply(tester);
      late bool result;
      await tester.pumpWidget(MaterialApp(
        home: Builder(builder: (context) {
          result = keypadClampsCells(context, w, h);
          return const SizedBox();
        }),
      ));
      return result;
    }

    testWidgets('leaves a phone keypad full-bleed', (tester) async {
      expect(await clamps(tester, FoldableDevices.phone, 110, 140), isFalse);
    });

    testWidgets('clamps a wide, short tabletop pane', (tester) async {
      // Fold tabletop bottom pane on a phone-class width: 3 cols x 4 rows.
      expect(await clamps(tester, FoldableDevices.flipCover, 140, 60), isTrue);
    });

    testWidgets('always clamps on tablet-class windows', (tester) async {
      expect(
        await clamps(tester, FoldableDevices.foldInnerFlat, 200, 190),
        isTrue,
      );
    });
  });
}
