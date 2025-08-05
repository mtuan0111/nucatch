import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:nucatch/screens/menu_screens/player/play_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class Helper {
  String generateRandomNumber(int length, {int minLengthOfNumber = 1}) {
    var randomNumber = "";

    for (int i = 0; i < length; i++) {
      int min =
          minLengthOfNumber > 0 ? pow(10, minLengthOfNumber - 1).toInt() : 0;
      int max = pow(10, minLengthOfNumber).toInt() - 1;
      randomNumber += (Random().nextInt(max - min + 1) + min).toString();
    }

    return randomNumber;
  }

  String randomCalculatorWithResult(int lengthOfExpect,
      {int numberCount = 2, int? maxNum}) {
    Random random = Random();
    List<int> numbers = [];
    List<String> operators = [];

    // Generate the expected result as a repeated digit number (e.g., 100, 1000)
    int digit = random.nextInt(9) + 1; // 1-9
    int target = int.parse(List.filled(lengthOfExpect, digit).join());

    int result = target;

    for (int i = 0; i < numberCount - 1; i++) {
      bool isPlus = random.nextBool();
      int nextNum;

      if (isPlus) {
        // Addition: result = prev + nextNum => prev = result - nextNum
        nextNum = random.nextInt(result) + 1;
        operators.add('+');
        numbers.add(nextNum);
        result -= nextNum;
      } else {
        // Subtraction: result = prev - nextNum => prev = result + nextNum
        int upper = maxNum ?? target * 2;
        int maxSub = upper - result;
        if (maxSub < 1) maxSub = 1;
        nextNum = random.nextInt(maxSub) + 1;
        operators.add('-');
        numbers.add(nextNum);
        result += nextNum;
      }
    }

    // The first number is the starting value so that the expression evaluates to target
    numbers.insert(0, result);

    // Build the expression string
    String expression = numbers[0].toString();
    for (int i = 0; i < operators.length; i++) {
      expression += ' ${operators[i]} ${numbers[i + 1]}';
    }

    return expression;
  }

  /// Generates an addition or subtraction expression where the result is a repeated digit number.
  /// For example:
  /// lengthOfExpect: 3, numberCount: 2 => expect: 111, expression: "50 + 61" or "120 - 9"
  Map<String, String> randomCalculatorWithPlusMinus(
    int lengthOfExpect, {
    int numberCount = 2,
  }) {
    Random random = Random();

    while (true) {
      // Generate the expected result as a random number with the specified length
      int min = pow(10, lengthOfExpect - 1).toInt();
      int max = pow(10, lengthOfExpect).toInt() - 1;
      int expect = random.nextInt(max - min + 1) + min;

      List<int> numbers = [];
      List<String> operators = [];

      int result = expect;

      for (int i = 0; i < numberCount - 1; i++) {
        bool isPlus = random.nextBool();
        int nextNum;

        if (isPlus) {
          // Addition: result = prev + nextNum => prev = result - nextNum
          if (result > 1) {
            nextNum = random.nextInt(result) + 1;
          } else {
            nextNum = 1;
          }
          operators.add('+');
          numbers.add(nextNum);
          result -= nextNum;
        } else {
          // Subtraction: result = prev - nextNum => prev = result + nextNum
          int upper = expect * 2;
          int maxSub = upper - result;
          if (maxSub < 1) maxSub = 1;
          nextNum = random.nextInt(maxSub) + 1;
          operators.add('-');
          numbers.add(nextNum);
          result += nextNum;
        }
      }

      numbers.insert(0, result);

      // If all numbers except the first are zero, or if only one number, regenerate
      if (operators.isEmpty || numbers.length < 2) {
        continue;
      }

      // Avoid trivial expressions like "596" (no operator)
      String expression = numbers[0].toString();
      for (int i = 0; i < operators.length; i++) {
        expression += ' ${operators[i]} ${numbers[i + 1]}';
      }

      // If the expression is just the expect value, try again
      if (expression.trim() == expect.toString()) {
        continue;
      }

      return {
        'expression': expression,
        'expect': expect.toString(),
      };
    }
  }

  /// Generates a multiplication or division expression where the result is a repeated digit number.
  /// For example:
  /// lengthOfExpect: 3, numberCount: 2 => expect: 888, expression: "1776 / 2" or "111 * 8"
  /// Generates a multiplication or division expression where the result is a random number with the specified length.
  /// Ensures the expression is not just a single number (e.g., "7") and avoids trivial cases.
  Map<String, String> randomCalculatorWithMulDiv(
    int lengthOfExpect, {
    int numberCount = 2,
  }) {
    Random random = Random();

    // Generate the expected result as a random number with the specified length
    int min = pow(10, lengthOfExpect - 1).toInt();
    int max = pow(10, lengthOfExpect).toInt() - 1;
    int expect = random.nextInt(max - min + 1) + min;

    // Helper to get factors > 1 and < n
    List<int> getValidFactors(int n) {
      List<int> factors = [];
      for (int i = 2; i <= sqrt(n).toInt(); i++) {
        if (n % i == 0) {
          factors.add(i);
          if (i != n ~/ i && n ~/ i != n) {
            factors.add(n ~/ i);
          }
        }
      }
      return factors.where((f) => f > 1 && f < n).toList();
    }

    if (numberCount == 2) {
      // Find all factor pairs for multiplication, avoiding 1 and expect
      List<List<int>> factorPairs = [];
      for (int i = 2; i <= sqrt(expect).toInt(); i++) {
        if (expect % i == 0) {
          int j = expect ~/ i;
          if (i != expect && j != expect && i != 1 && j != 1) {
            factorPairs.add([i, j]);
          }
        }
      }
      if (factorPairs.isEmpty) {
        // fallback: use "2 * ${expect ~/ 2}" if possible, else "2 * expect"
        if (expect % 2 == 0 && expect ~/ 2 > 1) {
          return {
            'expression': "2 * ${expect ~/ 2}",
            'expect': expect.toString(),
          };
        }
        // fallback: pick two random numbers > 1 whose product is not expect, but at least not trivial
        int a = random.nextInt(8) + 2;
        int b = expect ~/ a;
        if (a * b == expect && a != expect && b != expect && a != 1 && b != 1) {
          return {
            'expression': "$a * $b",
            'expect': expect.toString(),
          };
        }
        // fallback: generate a non-trivial multiplication
        return {
          'expression': "2 * $expect",
          'expect': (2 * expect).toString(),
        };
      }
      List<int> selectedPair = factorPairs[random.nextInt(factorPairs.length)];
      String expression = "${selectedPair[0]} * ${selectedPair[1]}";
      int result = selectedPair[0] * selectedPair[1];
      // Avoid expressions like "7" (single number)
      if (expression == expect.toString()) {
        expression = "2 * ${expect ~/ 2}";
        result = expect;
      }
      return {
        'expression': expression,
        'expect': result.toString(),
      };
    } else {
      // For more than 2 numbers, build a chain of multiplications that result in expect, avoiding 1
      int result = expect;
      List<int> numbers = [];
      List<String> operators = [];

      for (int i = 0; i < numberCount - 1; i++) {
        List<int> factors = getValidFactors(result);
        if (factors.isEmpty) {
          // fallback: break and fill remaining with random numbers > 1
          while (numbers.length < numberCount - 1) {
            int randNum = random.nextInt(8) + 2; // 2-9
            numbers.add(randNum);
            operators.add('*');
          }
          break;
        }
        int nextNum = factors[random.nextInt(factors.length)];
        operators.add('*');
        numbers.add(nextNum);
        result = result ~/ nextNum;
      }
      // Avoid 1 in the first number as well
      if (result == 1) {
        // Try to swap with a previous number if possible
        for (int i = numbers.length - 1; i >= 0; i--) {
          if (numbers[i] > 2) {
            numbers[i] = numbers[i] - 1;
            result = 2;
            break;
          }
        }
      }
      numbers.insert(0, result);

      // If any number is 1, replace with random 2-9
      for (int i = 0; i < numbers.length; i++) {
        if (numbers[i] == 1) {
          numbers[i] = random.nextInt(8) + 2;
        }
      }

      // Avoid expressions like "7" (single number)
      if (numbers.length == 1) {
        numbers.insert(0, 2);
        operators.insert(0, '*');
      }

      String expression = numbers[0].toString();
      for (int i = 0; i < operators.length; i++) {
        expression += ' ${operators[i]} ${numbers[i + 1]}';
      }
      return {
        'expression': expression,
        'expect': expect.toString(),
      };
    }
  }

  // lengthOfExpect: 3
  // numberCount: 2
  // generate the expect is 100,100,100
  // Generates an expression like "1 * 100"| "25 * 4" | "50 * 2" with the result being

  // lengthOfExpect: 4
  // numberCount: 2
  // generate the expect is 1000
  // Generates an expression like "10 * 100"| "200 * 5" | "50 * 20" with the result being

  /// Generates a multiplication expression where the result is a repeated digit number.
  /// For example:
  /// lengthOfExpect: 3, numberCount: 2 => expect: 100, expression: "1 * 100" or "25 * 4"
  /// lengthOfExpect: 4, numberCount: 2 => expect: 1000, expression: "10 * 100" or "200 * 5"
  // Map<String, String> randomCalculatorWithMulDiv(
  //   int lengthOfExpect, {
  //   int numberCount = 2,
  // }) {
  //   Random random = Random();

  //   // Generate the expected result as a repeated digit number (e.g., 100, 1000)
  //   int digit = random.nextInt(9) + 1; // 1-9
  //   int expect = int.parse(List.filled(lengthOfExpect, digit).join());

  //   // Find all factor pairs for multiplication
  //   List<List<int>> factorPairs = [];
  //   for (int i = 1; i <= expect; i++) {
  //     if (expect % i == 0) {
  //       int j = expect ~/ i;
  //       factorPairs.add([i, j]);
  //     }
  //   }

  //   // Randomly pick a factor pair
  //   List<int> selectedPair = factorPairs[random.nextInt(factorPairs.length)];
  //   String expression = "${selectedPair[0]} * ${selectedPair[1]}";

  //   return {
  //     'expression': expression,
  //     'expect': expect.toString(),
  //   };
  // }

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

  static Future<bool> pressMainMenu(BuildContext context) async {
    TurnRecordedListBloc turnRecordedListBloc =
        context.read<TurnRecordedListBloc>();
    TurnRecordedListState turnRecordedListState = turnRecordedListBloc.state;

    TurnBloc turnBloc = context.read<TurnBloc>();
    TurnState turnState = turnBloc.state;

    // MenuBloc menuBloc = context.read<MenuBloc>();

    int? rankTemporary = turnRecordedListState.rankOfPoint(turnState.point);
    bool confirmExit = true;

    if (rankTemporary != null) {
      confirmExit = await showDialog<bool>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              if (turnRecordedListState.isLoading) {
                return const LoadingWidget();
              }

              return CustomeAlert(
                point: turnState.point,
                rank: rankTemporary,
              );
            },
          ) ??
          true;
    }

    return confirmExit;
  }
}
