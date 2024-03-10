import 'dart:math';

class Helper {
  generateRandomNumber(int length) {
    var randomNumber = "";

    for (int i = 0; i < length; i++) {
      randomNumber += (Random().nextInt(9)).toString();
    }

    return randomNumber;
  }
}
