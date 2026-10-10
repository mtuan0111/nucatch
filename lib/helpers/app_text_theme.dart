import 'package:flutter/material.dart';

/// The app's one font family. Hierarchy comes from size / weight /
/// line-height, not from swapping families.
const String kAppFontFamily = 'Baloo Bhai';

/// Roboto Mono only for the few numeric/monospace readouts.
const List<String> kAppFontFamilyFallback = ['Roboto Mono'];

/// The app's text theme, built from the ambient [base] one.
///
/// [base] comes from the platform typography, which names a family (Roboto
/// on Android, SF on iOS) on every style. `ThemeData(fontFamily:)` does not
/// override a family that a passed-in text theme already names, so the
/// family is applied here explicitly. Without it, anything styled straight
/// from the text theme (e.g. a [CustomElevatedButton] label with no `style`)
/// rendered in Roboto instead of Baloo Bhai.
TextTheme appTextTheme(
  TextTheme base, {
  double fontSizeFactor = 1.0,
  double fontSizeDelta = 0.0,
}) {
  return base.apply(
    fontFamily: kAppFontFamily,
    fontFamilyFallback: kAppFontFamilyFallback,
    fontSizeFactor: fontSizeFactor,
    fontSizeDelta: fontSizeDelta,
    bodyColor: Colors.white,
    displayColor: Colors.white,
  );
}
