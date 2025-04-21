import 'dart:math';

import 'package:url_launcher/url_launcher.dart';

class Helper {
  generateRandomNumber(int length) {
    var randomNumber = "";

    for (int i = 0; i < length; i++) {
      randomNumber += (Random().nextInt(9)).toString();
    }

    return randomNumber;
  }

  static Future<void> launchURL(String url,
      {String? fallbackUrl, String? scheme}) async {
    final Uri uri = Uri.tryParse(
        scheme != null ? url.replaceFirst('https://', '$scheme://') : url)!;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else if (fallbackUrl != null) {
      final Uri fallbackUri = Uri.tryParse(fallbackUrl)!;
      if (await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri);
      }
    }
  }
}
