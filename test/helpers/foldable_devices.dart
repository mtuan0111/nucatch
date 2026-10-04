import 'dart:ui' show DisplayFeature, DisplayFeatureState, DisplayFeatureType;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// A window shape to test layouts against: a logical size plus the hinges
/// and folds the platform would report for it. Sizes are approximate
/// published specs — see `docs/FOLDABLE_SUPPORT_PLAN.md` §1 — and should
/// be re-checked against real devices / emulators before tuning breakpoints.
class FoldableDevice {
  const FoldableDevice(
    this.name,
    this.size, {
    this.devicePixelRatio = 2.625,
    this.features = const [],
  });

  final String name;

  /// Logical size.
  final Size size;
  final double devicePixelRatio;

  /// In logical pixels, window coordinates.
  final List<DisplayFeature> features;

  /// Applies this device to [tester]'s view; resets when the test ends.
  void apply(WidgetTester tester) {
    tester.view
      ..physicalSize = size * devicePixelRatio
      ..devicePixelRatio = devicePixelRatio
      // Logical, like the real view: the engine divides the platform's
      // physical hinge bounds by devicePixelRatio (dart:ui hooks.dart).
      ..displayFeatures = features;
    addTearDown(tester.view.reset);
  }

  @override
  String toString() => name;
}

DisplayFeature _verticalFold(double x, double height, DisplayFeatureState s) =>
    DisplayFeature(
      bounds: Rect.fromLTWH(x, 0, 0, height),
      type: DisplayFeatureType.fold,
      state: s,
    );

DisplayFeature _horizontalFold(double y, double width, DisplayFeatureState s) =>
    DisplayFeature(
      bounds: Rect.fromLTWH(0, y, width, 0),
      type: DisplayFeatureType.fold,
      state: s,
    );

const _flat = DisplayFeatureState.postureFlat;
const _half = DisplayFeatureState.postureHalfOpened;

abstract final class FoldableDevices {
  static const phone = FoldableDevice('Phone portrait', Size(412, 915));
  static const phoneLandscape =
      FoldableDevice('Phone landscape', Size(915, 412));

  static const foldCover = FoldableDevice('Z Fold cover', Size(369, 905));

  static final foldInnerFlat = FoldableDevice(
    'Z Fold inner, flat',
    const Size(707, 823),
    features: [_verticalFold(353.5, 823, _flat)],
  );
  static final foldInnerLandscapeFlat = FoldableDevice(
    'Z Fold inner landscape, flat',
    const Size(823, 707),
    features: [_horizontalFold(353.5, 823, _flat)],
  );
  static final foldBook = FoldableDevice(
    'Z Fold inner, book',
    const Size(707, 823),
    features: [_verticalFold(353.5, 823, _half)],
  );
  static final foldTabletop = FoldableDevice(
    'Z Fold inner, tabletop',
    const Size(823, 707),
    features: [_horizontalFold(353.5, 823, _half)],
  );

  static final flipInnerFlat = FoldableDevice(
    'Z Flip inner, flat',
    const Size(411, 1006),
    features: [_horizontalFold(503, 411, _flat)],
  );
  static final flipFlexMode = FoldableDevice(
    'Z Flip Flex Mode',
    const Size(411, 1006),
    features: [_horizontalFold(503, 411, _half)],
  );
  static const flipCover = FoldableDevice(
    'Z Flip cover (Flex Window)',
    Size(360, 374),
    devicePixelRatio: 2.0,
  );

  static const duoSingle = FoldableDevice(
    'Surface Duo, one screen',
    Size(540, 720),
    devicePixelRatio: 2.5,
  );
  static const duoSpanned = FoldableDevice(
    'Surface Duo, spanned',
    Size(1113.6, 720),
    devicePixelRatio: 2.5,
    features: [
      DisplayFeature(
        bounds: Rect.fromLTWH(540, 0, 33.6, 720),
        type: DisplayFeatureType.hinge,
        state: DisplayFeatureState.unknown,
      ),
    ],
  );

  static const splitScreenShort =
      FoldableDevice('Split-screen, short', Size(412, 300));

  static final all = <FoldableDevice>[
    phone,
    phoneLandscape,
    foldCover,
    foldInnerFlat,
    foldInnerLandscapeFlat,
    foldBook,
    foldTabletop,
    flipInnerFlat,
    flipFlexMode,
    flipCover,
    duoSingle,
    duoSpanned,
    splitScreenShort,
  ];
}
