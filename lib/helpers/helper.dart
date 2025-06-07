import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
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

  static String generateSecureLink(
    String username,
    String point,
    DateTime timeCreated,
  ) {
    final int? pointInt = int.tryParse(point);
    if (pointInt == null || pointInt == 0) return "";

    final String timeCreatedString =
        timeCreated.millisecondsSinceEpoch.toString();

    final int timeCode =
        ((int.parse(timeCreatedString) / pointInt) * luckyNumber).round();

    final Map<String, dynamic> material = {
      "username": username,
      "point": point,
      "timeCode": timeCode,
      "key": encodedKey,
    };

    final String fromJson = material.toString();
    String confirmString = md5.convert(utf8.encode(fromJson)).toString();

    final int iterations = pointInt * luckyNumber;
    for (int i = 0; i < iterations; i++) {
      confirmString = confirmString.decodedSortedEvenOddKey();
    }

    final String sufferBeginEnd =
        md5.convert(utf8.encode(confirmString)).toString();

    final String finalConfirmKey = sufferBeginEnd.substring(0, luckyNumber) +
        confirmString +
        sufferBeginEnd.substring(sufferBeginEnd.length - luckyNumber);

    String generatingUrl = profileUrlShareWithKey(dotenv.env['PROFILE_URL']!);

    generatingUrl = generatingUrl.replaceAll(
        "%username%", Uri.encodeQueryComponent(username));
    generatingUrl =
        generatingUrl.replaceAll("%point%", Uri.encodeQueryComponent(point));
    generatingUrl = generatingUrl.replaceAll(
        "%timeCreated%", Uri.encodeQueryComponent(timeCreatedString));
    generatingUrl = generatingUrl.replaceAll(
        "%md5Key%", Uri.encodeQueryComponent(finalConfirmKey));

    // Fix the URL to use '?' for the first query parameter
    if (generatingUrl.contains('&') && !generatingUrl.contains('?')) {
      final idx = generatingUrl.indexOf('&');
      generatingUrl = generatingUrl.replaceFirst('&', '?', idx);
    }

    return generatingUrl;
  }
}
