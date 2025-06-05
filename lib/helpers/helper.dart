import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

    await launchUrl(uri);

    if (fallbackUrl != null) {
      final Uri? fallbackUri = Uri.tryParse(fallbackUrl);
      if (fallbackUri != null && await canLaunchUrl(fallbackUri)) {
        await launchUrl(fallbackUri);
      }
    }
  }

  static Future capture(GlobalKey key) async {
    RenderRepaintBoundary? boundary =
        key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    final image = await boundary?.toImage(pixelRatio: 3);
    final byteData = await image?.toByteData(format: ImageByteFormat.png);
    // final pngByte = byteData.buffer.asUint8List();

    return byteData;
  }
}
