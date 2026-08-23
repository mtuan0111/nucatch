import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screen_walkthrough.dart';

/// iPad portrait pass — see `screen_walkthrough.dart` for what this
/// actually exercises. Uses the iPad Air 11" (M4) logical/physical profile
/// (Apple's published 820x1180pt @ 2.0 DPR) and prefixes screenshots with
/// `ipad_` so they land alongside, not on top of, the phone suite's.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Every reachable screen renders and adapts correctly on iPad (portrait)',
      (tester) async {
    await runScreenWalkthrough(
      tester,
      binding,
      landscape: false,
      physicalSize: const Size(1640, 2360),
      devicePixelRatio: 2.0,
      devicePrefix: 'ipad_',
    );
  });
}
