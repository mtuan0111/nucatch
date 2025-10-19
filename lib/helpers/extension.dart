import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/models/turn_record_model.dart';

extension DateTimeExtensions on DateTime {
  String formatClient() {
    return DateFormat(timeDateClient).format(this);
  }

  String formatServer() {
    return DateFormat(timeDateServer).format(this);
  }

  toseconds() {
    return millisecondsSinceEpoch ~/ 1000;
  }
}

extension ListOfTurnRecordedModel on List<TurnRecordedModel> {
  int? indexOfTurn(TurnRecordedModel item) {
    if (isEmpty) return null;

    if (!containsTurnId(item.turnId)) return null;

    return indexOfTurnId(item.turnId);
  }

  bool containsTurnId(String turnId) {
    if (isEmpty) return false;

    for (var element in this) {
      if (element.turnId == turnId) {
        return true;
      }
    }
    return false;
  }

  int? indexOfTurnId(String turnId) {
    if (isEmpty) return null;

    for (var element in this) {
      if (element.turnId == turnId) {
        return indexOf(element) + 1;
      }
    }
    return -1;
  }
}

extension StringExtensions on String {
  DateTime toDate() {
    try {
      return DateFormat(timeDateClient).parse(this);
    } catch (e) {
      try {
        return DateFormat(timeDateServer).parse(this);
      } catch (e) {
        try {
          return DateFormat().parse(this);
        } catch (e) {
          return DateTime.fromMicrosecondsSinceEpoch(0);
        }
      }
    }
  }

  // Add quotes to the keys of a JSON string
  // Example: {key: value} -> {"key": value}
  // This is useful for parsing JSON strings that are not properly formatted
  // as valid JSON
  // Note: This function assumes that the input string is a valid JSON string
  // with keys that are not quoted
  // and that the values are not strings that contain colons
  // Example: {key: "value: with colon"} -> {"key": "value: with colon"}
  // This function will not work for nested JSON objects
  String fixJsonString() {
    final regex = RegExp(r'(\w+):\s*([^,{}\[\]]+)');
    return replaceAllMapped(
      regex,
      (match) {
        final key = match.group(1);
        final value = match.group(2);
        if (value != null &&
            !value.startsWith('"') &&
            !RegExp(r'^\d+$').hasMatch(value)) {
          return '"$key": "$value"';
        }
        return '"$key": $value';
      },
    );
  }

  String decodedSortedEvenOddKey() {
    String evenString = "";
    String oddString = "";

    for (int i = 0; i < length; i++) {
      if (i % 2 == 0) {
        evenString += this[i];
      } else {
        oddString += this[i];
      }
    }

    return evenString + oddString;
  }

  String snakeCaseToCamel() {
    if (isEmpty) return this;

    List<String> parts = split('_');
    String camelCaseString = parts[0];

    for (int i = 1; i < parts.length; i++) {
      String part = parts[i];
      if (part.isNotEmpty) {
        camelCaseString +=
            part[0].toUpperCase() + part.substring(1).toLowerCase();
      }
    }

    return camelCaseString;
  }
}

extension ColorCustome on Color {
  Color getDarker({int percentage = 50}) {
    int r =
        (((this.r * 255.0).round() & 0xff) * (100 - percentage) / 100).round();
    int g =
        (((this.g * 255.0).round() & 0xff) * (100 - percentage) / 100).round();
    int b =
        (((this.b * 255.0).round() & 0xff) * (100 - percentage) / 100).round();
    int a = (this.a * 255.0).round() & 0xff;
    return Color.fromARGB(a, r, g, b);
  }

  Color getLighter({int percentage = 50}) {
    int r = (((this.r * 255.0).round() & 0xff) +
            ((255 - ((this.r * 255.0).round() & 0xff)) * percentage / 100))
        .round();
    int g = (((this.g * 255.0).round() & 0xff) +
            ((255 - ((this.g * 255.0).round() & 0xff)) * percentage / 100))
        .round();
    int b = (((this.b * 255.0).round() & 0xff) +
            ((255 - ((this.b * 255.0).round() & 0xff)) * percentage / 100))
        .round();
    int a = (this.a * 255.0).round() & 0xff;
    return Color.fromARGB(a, r, g, b);
  }
}
