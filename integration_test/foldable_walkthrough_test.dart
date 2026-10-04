import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nucatch/helpers/game_layout.dart';

import 'screen_walkthrough.dart';

/// Foldable layout smoke run: walks every screen at the connected
/// emulator/device's *native* window — a Fold folded or unfolded, a Flip
/// open or on its cover screen, a Surface Duo spanned — including its real
/// hinge/fold display features, which a forced test viewport can't fake.
///
/// Fold/unfold the device (or set its posture) before starting, then run
/// with layout-only flags:
///
///   flutter test integration_test/foldable_walkthrough_test.dart \
///     -d DEVICE --dart-define=SKIP_SHOTS=true \
///     --dart-define=COLLECT_OVERFLOWS=true
///
/// See `docs/FOLDABLE_SUPPORT_PLAN.md` Phase 6.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('walks every screen on a foldable window', (tester) async {
    // What the platform actually reports — the thing a forced viewport fakes.
    final view = tester.view;
    final size = view.physicalSize / view.devicePixelRatio;
    debugPrint('TEST_STEP: window $size, features ${view.displayFeatures}, '
        'layout ${GameLayout.resolve(size, view.displayFeatures).name}');
    await runScreenWalkthrough(
      tester,
      binding,
      landscape: false,
      nativeViewport: true,
    );
  });
}
