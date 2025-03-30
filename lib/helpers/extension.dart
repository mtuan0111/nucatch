import 'package:intl/intl.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';

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
}
