import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:url_launcher/url_launcher.dart';

import '../blocs/navs/player/player_nav_state.dart';

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

      // If any member of the calculator is 0, regenerate
      if (numbers.contains(0)) {
        continue;
      }

      return {
        'expression': expression,
        'expect': expect.toString(),
      };
    }
  }

  /// Generates a multiplication or division expression where the result is a random number with the specified length.
  /// Tries to randomize the first number, then finds the second to match the expected result.
  Map<String, String> randomCalculatorWithMulDiv(
    int lengthOfExpect, {
    int numberCount = 2,
  }) {
    Random random = Random();

    while (true) {
      int minimum = pow(10, lengthOfExpect - 1).toInt();
      int maximum = pow(10, lengthOfExpect).toInt() - 1;
      int expect = random.nextInt(maximum - minimum + 1) + minimum;

      if (random.nextInt(10) % 2 == 0) {
        // Try multiplication first: expect = a * b
        int a = random.nextInt(expect - 1) + 2; // a >= 2
        if (expect % a == 0) {
          int b = expect ~/ a;
          if (b > 1 && a > 1 && a != expect && b != expect) {
            return {
              'expression': "$a * $b",
              'expect': expect.toString(),
            };
          }
        }

        // Try division: expect = a / b
        int bDiv = random.nextInt(8) + 2; // bDiv >= 2
        int aDiv = expect * bDiv;
        if (aDiv > 1 && bDiv > 1 && aDiv != expect && bDiv != expect) {
          return {
            'expression': "$aDiv / $bDiv",
            'expect': expect.toString(),
          };
        }

        // If can't find, try again
        continue;
      } else {
        // For more than 2 numbers, build a chain: expect = a * b * c...
        List<int> numbers = [];
        List<String> operators = [];
        int result = expect;

        bool valid = true;
        for (int i = 0; i < numberCount - 1; i++) {
          int factorMin = 2;
          int factorMax = max(2, result ~/ 2);
          if (factorMax < factorMin) {
            valid = false;
            break;
          }
          int factor = random.nextInt(factorMax - factorMin + 1) + factorMin;
          while (result % factor != 0 && factor > factorMin) {
            factor--;
          }
          if (result % factor != 0 || factor < 2) {
            valid = false;
            break;
          }
          numbers.add(factor);
          operators.add('*');
          result = result ~/ factor;
        }
        if (!valid || result < 2) {
          continue;
        }
        numbers.insert(0, result);

        // Avoid 1s in the numbers
        if (numbers.any((n) => n == 1)) {
          continue;
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

  static Future<dynamic> pressMainMenu(BuildContext buildContext) async {
    TurnRecordedListBloc turnRecordedListBloc =
        buildContext.read<TurnRecordedListBloc>();
    TurnRecordedListState turnRecordedListState = turnRecordedListBloc.state;

    TurnBloc turnBloc = buildContext.read<TurnBloc>();
    TurnState turnState = turnBloc.state;

    PlayerNavCubit playerNavCubit = buildContext.read<PlayerNavCubit>();

    // MenuBloc menuBloc = context.read<MenuBloc>();

    int? rankTemporary = turnRecordedListState.rankOfPoint(turnState.point);
    dynamic confirmExit = true;

    // if (rankTemporary != null) {
    confirmExit = await showDialog<bool>(
          barrierDismissible: false,
          context: buildContext,
          builder: (BuildContext context) {
            if (turnRecordedListState.isLoading) {
              return const LoadingWidget();
            }

            return MenuAlert(
              rank: rankTemporary,
              point: turnState.point,
              turnState: turnState,
              turnBloc: turnBloc,
              playerNavCubit: playerNavCubit,
            );
          },
        ) ??
        true;
    // }

    return confirmExit;
  }

  static IconData getIconFromDifficulty(
      BuildContext context, Difficulty? difficulty) {
    IconData difficultyIcon = FontAwesomeIcons.flag;
    switch (difficulty) {
      // case Difficulty.easy:
      //   difficultyIcon = FontAwesomeIcons.faceSmileBeam;
      //   break;
      case Difficulty.medium:
        difficultyIcon = FontAwesomeIcons.faceMeh;
        break;
      case Difficulty.hard:
        difficultyIcon = FontAwesomeIcons.faceFrownOpen;
        break;
      case Difficulty.extreme:
        difficultyIcon = FontAwesomeIcons.skullCrossbones;
        break;
      default:
        difficultyIcon = FontAwesomeIcons.faceSmileBeam;
    }
    return difficultyIcon;
  }

  static String getDescriptionFromDifficulty(
      BuildContext context, Difficulty? difficultyModel) {
    switch (difficultyModel) {
      case Difficulty.easy:
        return lang(context).difficultyEasyDescription;
      case Difficulty.medium:
        return lang(context).difficultyMediumDescription;
      case Difficulty.hard:
        return lang(context).difficultyHardDescription;
      case Difficulty.extreme:
        return lang(context).difficultyExtremeDescription;
      default:
        return lang(context).difficultyEasyDescription;
    }
  }

  static String getTitleFromDifficulty(
      BuildContext context, Difficulty? difficulty) {
    switch (difficulty) {
      case Difficulty.easy:
        return lang(context).difficultyEasyTitle;
      case Difficulty.medium:
        return lang(context).difficultyMediumTitle;
      case Difficulty.hard:
        return lang(context).difficultyHardTitle;
      case Difficulty.extreme:
        return lang(context).difficultyExtremeTitle;
      default:
        return lang(context).difficultyEasyTitle;
    }
  }

  bool randomBool() {
    return Random().nextBool();
  }
}
