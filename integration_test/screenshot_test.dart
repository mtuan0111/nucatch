import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'screen_walkthrough.dart';

/// Portrait pass — see `screen_walkthrough.dart` for what this actually
/// exercises and why the portrait/landscape passes are split across two
/// files instead of two `testWidgets` bodies in one.
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      'Every reachable screen renders after a Flutter/dependency upgrade (portrait)',
      (tester) async {
    await runScreenWalkthrough(tester, binding, landscape: false);
  });
}
