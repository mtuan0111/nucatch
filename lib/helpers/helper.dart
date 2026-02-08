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
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_bloc.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/extension.dart';
import 'package:nucatch/helpers/template/custome_alert.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:url_launcher/url_launcher.dart';

/// Enum to specify which corner(s) should have a smaller radius
enum RoundedWithShapeAt {
  topLeft,
  topRight,
  bottomLeft,
  bottomRight,
  top,
  bottom,
  left,
  right,
  all,
}

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
        int maxA = expect - 2;
        if (maxA < 1) {
          continue;
        }
        int a = random.nextInt(maxA) + 2; // a >= 2, maxA >= 1
        if (expect % a == 0) {
          int b = expect ~/ a;
          if (b > 1 && a > 1 && a != expect && b != expect) {
            return {
              'expression': "$a × $b",
              'expect': expect.toString(),
            };
          }
        }

        // Try division: expect = a / b
        int maxBDiv = 8;
        if (maxBDiv < 1) {
          continue;
        }
        int bDiv = random.nextInt(maxBDiv) + 2; // bDiv >= 2
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
          int range = factorMax - factorMin + 1;
          if (range < 1) {
            valid = false;
            break;
          }
          int factor = random.nextInt(range) + factorMin;
          while (result % factor != 0 && factor > factorMin) {
            factor--;
          }
          if (result % factor != 0 || factor < 2) {
            valid = false;
            break;
          }
          numbers.add(factor);
          operators.add('×');
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

  /// Generates equations for Pick Right mode with 3 options (1 true, 2 false)
  /// Returns a map with:
  /// - trueEquation: The correct equation
  /// - falseEquation1: First incorrect equation
  /// - falseEquation2: Second incorrect equation
  /// - correctIndex: Index of the correct button (0, 1, or 2)
  /// - equations: List of equations in display order
  Map<String, dynamic> generatePickRightEquations(int level) {
    final random = Random();

    // Generate random numbers based on level
    // Level 1-2: max 100 (two-digit numbers)
    // Level 3-4: max 1000 (three-digit numbers)
    // Level 5-6: max 10000 (four-digit numbers)
    // Level 7-8: max 100000 (five-digit numbers)
    int maxNumber;
    if (level <= 2) {
      maxNumber = 20 + level * 20; // 40-60
    } else if (level <= 4) {
      maxNumber = 100 + (level - 2) * 200; // 300-500
    } else if (level <= 6) {
      maxNumber = 1000 + (level - 4) * 2000; // 3000-5000
    } else if (level <= 8) {
      maxNumber = 10000 + (level - 6) * 20000; // 30000-50000
    } else {
      maxNumber = 100000; // Cap at 100000
    }
    final a = random.nextInt(maxNumber) + 1;
    final b = random.nextInt(maxNumber) + 1;

    // Choose operator
    final operators = ['+', '-', '×'];
    final operator = operators[random.nextInt(operators.length)];

    // Calculate correct result
    int correctResult;
    switch (operator) {
      case '+':
        correctResult = a + b;
        break;
      case '-':
        correctResult = a - b;
        break;
      case '×':
        correctResult = a * b;
        break;
      default:
        correctResult = a + b;
    }

    final trueEq = '$a $operator $b = $correctResult';

    // Helper function to generate false equation
    // Cumulative difficulty progression:
    // Level 1: Large (20-70)
    // Level 2: Medium (1-10) + Level 1
    // Level 3: (5-9)*10 = 50-90 + Level 2
    // Level 4: (1-2)*10 = 10-20 + Level 3
    // Level 5: (5-9)*100 = 500-900 + Level 4
    // Level 6: (1-2)*100 = 100-200 + Level 5
    // And so on...
    String generateFalseEquation(List<int> usedA, List<int> usedB) {
      int aFalse, bFalse;
      String opFalse;
      int correctResFalse;
      int falseRes;

      do {
        aFalse = random.nextInt(maxNumber) + 1;
        bFalse = random.nextInt(maxNumber) + 1;
      } while (usedA.contains(aFalse) && usedB.contains(bFalse));

      // Operator selection based on level
      List<String> availableOps;
      if (level <= 2) {
        availableOps = ['+', '-']; // Basic operators for beginners
      } else {
        availableOps = ['+', '-', '×']; // All operators for higher levels
      }
      opFalse = availableOps[random.nextInt(availableOps.length)];

      switch (opFalse) {
        case '+':
          correctResFalse = aFalse + bFalse;
          break;
        case '-':
          correctResFalse = aFalse - bFalse;
          break;
        case '×':
          correctResFalse = aFalse * bFalse;
          break;
        default:
          correctResFalse = aFalse + bFalse;
      }

      // Build cumulative deviation pool based on level
      List<int> deviationPool = [];

      // Level 1: Large (20-70)
      if (level >= 1) {
        for (int i = 20; i <= 70; i++) {
          deviationPool.add(i);
          deviationPool.add(-i);
        }
      }

      // Level 2: Medium (1-10)
      if (level >= 2) {
        for (int i = 1; i <= 10; i++) {
          deviationPool.add(i);
          deviationPool.add(-i);
        }
      }

      // Level 3: (5-9) * 10 = 50-90
      if (level >= 3) {
        for (int i = 5; i <= 9; i++) {
          deviationPool.add(i * 10);
          deviationPool.add(-i * 10);
        }
      }

      // Level 4: (1-2) * 10 = 10-20
      if (level >= 4) {
        for (int i = 1; i <= 2; i++) {
          deviationPool.add(i * 10);
          deviationPool.add(-i * 10);
        }
      }

      // Level 5: (5-9) * 100 = 500-900
      if (level >= 5) {
        for (int i = 5; i <= 9; i++) {
          deviationPool.add(i * 100);
          deviationPool.add(-i * 100);
        }
      }

      // Level 6: (1-2) * 100 = 100-200
      if (level >= 6) {
        for (int i = 1; i <= 2; i++) {
          deviationPool.add(i * 100);
          deviationPool.add(-i * 100);
        }
      }

      // Level 7+: (5-9) * 1000 = 5000-9000
      if (level >= 7) {
        for (int i = 5; i <= 9; i++) {
          deviationPool.add(i * 1000);
          deviationPool.add(-i * 1000);
        }
      }

      // Level 8+: (1-2) * 1000 = 1000-2000
      if (level >= 8) {
        for (int i = 1; i <= 2; i++) {
          deviationPool.add(i * 1000);
          deviationPool.add(-i * 1000);
        }
      }

      // Pick a random deviation from the pool
      final deviation = deviationPool[random.nextInt(deviationPool.length)];
      falseRes = correctResFalse + deviation;

      // Ensure false result is different from correct and positive
      if (falseRes == correctResFalse) {
        falseRes = correctResFalse + (random.nextBool() ? 1 : -1);
      }
      if (falseRes < 0) {
        falseRes = correctResFalse + deviation.abs();
      }

      usedA.add(aFalse);
      usedB.add(bFalse);
      return '$aFalse $opFalse $bFalse = $falseRes';
    }

    List<int> usedA = [a];
    List<int> usedB = [b];
    final falseEq1 = generateFalseEquation(usedA, usedB);
    final falseEq2 = generateFalseEquation(usedA, usedB);

    // Randomly assign correct position (0, 1, or 2)
    final correctIndex = random.nextInt(3);

    // Create list of equations in display order
    List<String> equations = ['', '', ''];
    equations[correctIndex] = trueEq;

    // Fill remaining positions with false equations
    int falseIdx = 0;
    List<String> falseEquations = [falseEq1, falseEq2];
    for (int i = 0; i < 3; i++) {
      if (i != correctIndex) {
        equations[i] = falseEquations[falseIdx++];
      }
    }

    return {
      'trueEquation': trueEq,
      'falseEquation': falseEq1, // Keep for backward compatibility
      'falseEquation1': falseEq1,
      'falseEquation2': falseEq2,
      'isLeftCorrect': correctIndex == 0, // Keep for backward compatibility
      'correctIndex': correctIndex,
      'equations': equations,
    };
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
    Difficulty difficulty,
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
      "difficulty": difficulty.name,
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
        "%difficulty%", Uri.encodeQueryComponent(difficulty.name));
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
      case Difficulty.pickRight:
        difficultyIcon = FontAwesomeIcons.handPointer;
        break;
      default:
        difficultyIcon = FontAwesomeIcons.faceSmileBeam;
    }
    return difficultyIcon;
  }

  static Color getColorIconFromDifficulty(
      BuildContext context, Difficulty? difficulty) {
    Color difficultyColor = Theme.of(context).colorScheme.primary;
    switch (difficulty) {
      case Difficulty.easy:
        difficultyColor = Colors.green;
        break;
      case Difficulty.medium:
        difficultyColor = Colors.orange;
        break;
      case Difficulty.hard:
        difficultyColor = Colors.red;
        break;
      case Difficulty.extreme:
        difficultyColor = Colors.purple;
        break;
      case Difficulty.pickRight:
        difficultyColor = Colors.blue;
        break;
      default:
        difficultyColor = Theme.of(context).colorScheme.primary;
    }
    return difficultyColor;
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
      case Difficulty.pickRight:
        return lang(context).pickRightDescription;
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
      case Difficulty.pickRight:
        return lang(context).pickRightTitle;
      default:
        return lang(context).difficultyEasyTitle;
    }
  }

  /// Creates a BorderRadius with customizable corner shapes
  ///
  /// [radius] - Base radius for all corners (defaults to LayoutConfig.layoutBorderRadius)
  /// [shapeAt] - Which corner(s) to apply a smaller radius to (1/5 of base radius)
  /// [adjustment] - Additional adjustment to add to the base radius
  ///
  /// Returns a BorderRadius with the specified configuration
  static BorderRadius getBorderRadius({
    double? radius,
    RoundedWithShapeAt? shapeAt,
    double adjustment = 0,
  }) {
    double adjustedRadius =
        (radius ?? LayoutConfig.layoutBorderRadius) + adjustment;
    BorderRadius baseRadius = BorderRadius.only(
      topLeft: Radius.circular(adjustedRadius),
      topRight: Radius.circular(adjustedRadius),
      bottomLeft: Radius.circular(adjustedRadius),
      bottomRight: Radius.circular(adjustedRadius),
    );

    switch (shapeAt) {
      case RoundedWithShapeAt.topLeft:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.topRight:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomLeft:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottomRight:
        baseRadius = baseRadius.copyWith(
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.top:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
          topRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.bottom:
        baseRadius = baseRadius.copyWith(
          bottomLeft: Radius.circular(adjustedRadius / 5),
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.left:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius / 5),
          bottomLeft: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.right:
        baseRadius = baseRadius.copyWith(
          topRight: Radius.circular(adjustedRadius / 5),
          bottomRight: Radius.circular(adjustedRadius / 5),
        );
      case RoundedWithShapeAt.all:
        baseRadius = baseRadius.copyWith(
          topLeft: Radius.circular(adjustedRadius),
          topRight: Radius.circular(adjustedRadius),
          bottomLeft: Radius.circular(adjustedRadius),
          bottomRight: Radius.circular(adjustedRadius),
        );
      default:
        break;
    }

    return baseRadius;
  }

  bool randomBool() {
    return Random().nextBool();
  }
}
