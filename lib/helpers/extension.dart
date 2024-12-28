import 'package:intl/intl.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';

extension DateTimeExtensions on DateTime {
  String formatClient() {
    return DateFormat(timeDateClient).format(this);
  }

  String formatServer() {
    return DateFormat(timeDateServer).format(this);
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
}
