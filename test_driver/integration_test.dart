import 'dart:io';
import 'package:integration_test/integration_test_driver_extended.dart';

Future<void> main() async {
  await integrationDriver(
    onScreenshot: (String screenshotName, List<int> screenshotBytes,
        [Map<String, Object?>? args]) async {
      final String? subDir = Platform.environment['SCREENSHOT_DIR'];
      final String path = (subDir != null && subDir.isNotEmpty)
          ? 'fastlane/screenshots/$subDir/$screenshotName.png'
          : 'fastlane/screenshots/$screenshotName.png';
      final File image = await File(path).create(recursive: true);
      image.writeAsBytesSync(screenshotBytes);
      return true;
    },
  );
}
