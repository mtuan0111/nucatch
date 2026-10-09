import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/display_scale.dart';

void main() {
  test('tablet windows get larger text, phones and foldables do not', () {
    const windows = <String, (Size, double)>{
      'phone portrait': (Size(412, 915), 1.0),
      'phone landscape': (Size(915, 412), 1.0),
      'Fold cover': (Size(384, 896), 1.0),
      'Fold inner (unfolded)': (Size(673, 841), 1.0),
      'iPad split-screen third': (Size(320, 1180), 1.0),
      'iPad mini': (Size(744, 1133), kTabletTextScale),
      'iPad portrait': (Size(820, 1180), kTabletTextScale),
      'iPad landscape': (Size(1180, 820), kTabletTextScale),
      'Android tablet': (Size(1280, 800), kTabletTextScale),
    };
    windows.forEach((name, expected) {
      final (size, scale) = expected;
      expect(textScaleForWindow(size), scale, reason: name);
    });
  });
}
