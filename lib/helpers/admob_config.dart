import 'package:skeleton_core/skeleton_core.dart';

/// AdMob configuration for Hasto (Hanoi Tower).
///
/// Register the singleton at startup in `main.dart`:
/// ```dart
/// BaseAdMobConfig.register(AdMobConfig.instance);
/// ```
///
/// Then use the instance at call sites:
/// ```dart
/// AdMobBanner(
///   adUnitId: Platform.isIOS
///       ? AdMobConfig.instance.iosGameOverBannerId
///       : AdMobConfig.instance.androidGameOverBannerId,
/// )
/// ```
// AdMob Configuration
class AdMobConfig extends BaseAdMobConfig {
  AdMobConfig._();

  /// Singleton instance — register at app startup:
  /// ```dart
  /// BaseAdMobConfig.register(AdMobConfig.instance);
  /// ```
  static final AdMobConfig instance = AdMobConfig._();

  // ── App IDs (AndroidManifest.xml / Info.plist) ───────────────────────────
  static const String androidAppId = 'ca-app-pub-7979935537603411~2676193632';
  static const String iosAppId = 'ca-app-pub-7979935537603411~5942915481';

  // ── BaseAdMobConfig overrides ────────────────────────────────────────────

  @override
  bool get useTestAds => false; // Set to false once AdMob account is approved.

  @override
  String get androidGameOverBannerId =>
      'ca-app-pub-7979935537603411/6405949912';

  @override
  String get iosGameOverBannerId => 'ca-app-pub-7979935537603411/5196375251';

  @override
  String get androidTopScoreBannerId =>
      'ca-app-pub-7979935537603411/3370267625';

  @override
  String get iosTopScoreBannerId => 'ca-app-pub-7979935537603411/1322679044';
}
