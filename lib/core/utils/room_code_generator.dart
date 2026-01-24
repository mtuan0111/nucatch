import 'dart:math';

class RoomCodeGenerator {
  static String generate() {
    final random = Random();
    final code = random.nextInt(9000) + 1000; // Generates 1000-9999
    return code.toString();
  }
}
