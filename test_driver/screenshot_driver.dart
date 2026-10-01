import 'dart:io';

import 'package:integration_test/integration_test_driver_extended.dart';

/// `flutter drive` driver for the store-screenshot capture run
/// (`integration_test/store_screenshots_test.dart`).
///
/// The shared `test_driver/integration_test.dart` shim already handles the
/// smoke suites' screenshots by writing them into `fastlane/screenshots/…`.
/// This dedicated driver keeps the store capture separate: it writes each
/// screenshot to `$NUCATCH_SHOT_DIR/[name].png` so `tool/screenshots/capture.sh`
/// can point every device at its own raw folder under `build/screenshots/` and
/// afterward sort the iPhone / iPad / phone / tablet frames into the layouts
/// Fastlane's `deliver` (iOS) and `supply` (Android) upload from.
///
/// Run indirectly via:
///   `NUCATCH_SHOT_DIR=build/screenshots/DEVICE flutter drive`
///   `  --driver=test_driver/screenshot_driver.dart`
///   `  --target=integration_test/store_screenshots_test.dart -d DEVICE_ID`
Future<void> main() => integrationDriver(
      onScreenshot:
          (String name, List<int> image, [Map<String, Object?>? args]) async {
        final dir = Platform.environment['NUCATCH_SHOT_DIR'] ??
            'build/screenshots/default';
        final file = File('$dir/$name.png')..createSync(recursive: true);
        file.writeAsBytesSync(image);
        stdout.writeln('📸  wrote ${file.path} (${image.length} bytes)');
        return true;
      },
    );
