import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/helpers/app_text_theme.dart';
import 'package:skeleton_core/skeleton_core.dart';

void main() {
  // A CustomElevatedButton with no `style` takes its label from the text
  // theme's displayLarge. The platform typography names Roboto on every
  // style, so unless appTextTheme applies the family these labels ("Main
  // Menu", "Play Again"…) rendered in Roboto italic instead of Baloo Bhai.
  testWidgets('default button labels use the app font family', (tester) async {
    await tester.pumpWidget(Builder(builder: (context) {
      return MaterialApp(
        theme: ThemeData(
          fontFamily: kAppFontFamily,
          textTheme: appTextTheme(Theme.of(context).textTheme),
        ),
        home: Scaffold(
          body: Center(
            child: CustomElevatedButton(
              text: 'Main Menu',
              buttonSize: ButtonSize.small,
              onPressed: () {},
            ),
          ),
        ),
      );
    }));

    final label = tester.widget<RichText>(find.descendant(
      of: find.text('Main Menu'),
      matching: find.byType(RichText),
    ));
    expect(label.text.style?.fontFamily, kAppFontFamily);
  });
}
