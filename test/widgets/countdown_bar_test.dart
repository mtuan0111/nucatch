import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/widgets/countdown_bar.dart';

Widget _bar({required bool isPaused}) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SizedBox(
          width: 400,
          child: CountDownBar(
            timerDuration: 10,
            tapTimerRemaining: 5,
            isPlaying: true,
            isPaused: isPaused,
          ),
        ),
      ),
    );

/// The fill's share of the bar, from the flex of its first Expanded.
int _fillPercent(WidgetTester tester) =>
    tester.widgetList<Expanded>(find.byType(Expanded)).first.flex;

void main() {
  // The bar's Countdown keeps its own clock; while the game's timer is held
  // (menu, background, fold change) it must stand still instead of draining
  // and then jumping back on resume.
  testWidgets('a paused bar holds at the remaining time', (tester) async {
    await tester.pumpWidget(_bar(isPaused: true));
    expect(_fillPercent(tester), 50);

    await tester.pump(const Duration(seconds: 3));
    expect(_fillPercent(tester), 50);
  });

  testWidgets('a running bar drains', (tester) async {
    await tester.pumpWidget(_bar(isPaused: false));
    await tester.pump(const Duration(seconds: 3));
    expect(_fillPercent(tester), lessThan(50));

    // Let the countdown finish so no timer is left pending.
    await tester.pump(const Duration(seconds: 3));
  });
}
