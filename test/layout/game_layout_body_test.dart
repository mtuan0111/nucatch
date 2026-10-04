import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/const.dart' show GamepadKeypadSide;
import 'package:nucatch/helpers/game_layout.dart';
import 'package:nucatch/widgets/game_layout_body.dart';
import 'package:skeleton_core/skeleton_core.dart' show FoldLayout;

import '../helpers/foldable_devices.dart';

const _headerKey = ValueKey('header');

/// Stand-in for the real keypad: a 3x4 grid (or one 2-column gamepad
/// cluster) of keyed, tappable cells that fill whatever they're given.
class _FakeKeypad extends StatelessWidget {
  const _FakeKeypad(this.side);

  final GamepadKeypadSide? side;

  @override
  Widget build(BuildContext context) {
    final columns = side == null ? 3 : 2;
    return Column(
      children: [
        for (var r = 0; r < 4; r++)
          Expanded(
            child: Row(
              children: [
                for (var c = 0; c < columns; c++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: ElevatedButton(
                        key: ValueKey('key-${side?.name ?? 'full'}-$r-$c'),
                        onPressed: () {},
                        child: const SizedBox.shrink(),
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

Future<void> _pump(WidgetTester tester, FoldableDevice device) async {
  device.apply(tester);
  await tester.pumpWidget(MaterialApp(
    home: Scaffold(
      body: GameLayoutBody(
        header: const SizedBox.expand(key: _headerKey),
        controlsBuilder: (side) => _FakeKeypad(side),
      ),
    ),
  ));
}

List<Rect> _keyRects(WidgetTester tester) => [
      for (final element in find
          .byWidgetPredicate((w) =>
              w is ElevatedButton &&
              (w.key as ValueKey<String>?)?.value.startsWith('key-') == true)
          .evaluate())
        tester.getRect(find.byWidget(element.widget)),
    ];

void main() {
  group('GameLayoutBody on every device', () {
    for (final device in FoldableDevices.all) {
      testWidgets('$device: no overflow, nothing on the hinge', (tester) async {
        await _pump(tester, device);
        expect(tester.takeException(), isNull);

        final fold = FoldLayout.fromData(device.size, device.features);
        final header = tester.getRect(find.byKey(_headerKey));
        final keys = _keyRects(tester);

        expect(header.isEmpty, isFalse, reason: 'header was laid out');
        expect(keys, isNotEmpty);
        expect(fold.straddlesSeparator(header), isFalse,
            reason: 'header $header crosses ${fold.separator}');
        for (final key in keys) {
          expect(fold.straddlesSeparator(key), isFalse,
              reason: 'key $key crosses ${fold.separator}');
          expect(key.top, greaterThanOrEqualTo(0));
          expect(key.bottom, lessThanOrEqualTo(device.size.height + 0.01));
        }
      });
    }
  });

  testWidgets('tabletop: header in the top pane, keypad in the bottom',
      (tester) async {
    final device = FoldableDevices.flipFlexMode;
    await _pump(tester, device);
    final fold = FoldLayout.fromData(device.size, device.features);
    final header = tester.getRect(find.byKey(_headerKey));
    expect(header.bottom, lessThanOrEqualTo(fold.separator!.top));
    for (final key in _keyRects(tester)) {
      expect(key.top, greaterThanOrEqualTo(fold.separator!.bottom));
    }
  });

  testWidgets('Duo spanned: header left of the hinge, keypad right of it',
      (tester) async {
    final device = FoldableDevices.duoSpanned;
    await _pump(tester, device);
    final hinge = FoldLayout.fromData(device.size, device.features).separator!;
    expect(tester.getRect(find.byKey(_headerKey)).right,
        lessThanOrEqualTo(hinge.left));
    for (final key in _keyRects(tester)) {
      expect(key.left, greaterThanOrEqualTo(hinge.right));
    }
  });

  testWidgets('gamepad: two edge clusters around the header', (tester) async {
    await _pump(tester, FoldableDevices.phoneLandscape);
    expect(find.byKey(const ValueKey('key-left-0-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('key-right-0-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('key-full-0-0')), findsNothing);
  });

  testWidgets('unfolding mid-game keeps a single header mounted',
      (tester) async {
    // Fold cover (stacked) → inner book (two panes) → back.
    await _pump(tester, FoldableDevices.foldCover);
    expect(find.byKey(_headerKey), findsOneWidget);

    FoldableDevices.foldBook.apply(tester);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byKey(_headerKey), findsOneWidget);
    expect(
        GameLayout.resolve(
            FoldableDevices.foldBook.size, FoldableDevices.foldBook.features),
        GameLayoutMode.twoPane);

    FoldableDevices.foldCover.apply(tester);
    await tester.pump();
    expect(tester.takeException(), isNull);
    expect(find.byKey(_headerKey), findsOneWidget);
  });
}
