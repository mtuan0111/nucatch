import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:io' show Platform;

import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/ui_constants.dart';

/// A reusable widget that displays a Google AdMob banner ad.
///
/// This widget handles the lifecycle of the banner ad including:
/// - Loading the ad
/// - Displaying the ad
/// - Disposing the ad when the widget is removed
///
/// **IMPORTANT**: Currently using TEST ad unit IDs because the AdMob account
/// is not yet approved. Once approved, change [useTestAds] to false.
class AdMobBanner extends StatefulWidget {
  /// The AdMob ad unit ID for this banner (production)
  final String adUnitId;

  /// Optional custom size for the banner. Defaults to standard banner size.
  final AdSize adSize;

  /// Whether to use test ads. Set to false once AdMob account is approved.
  /// Default: true (using test ads)
  final bool useTestAds;

  const AdMobBanner({
    super.key,
    required this.adUnitId,
    this.adSize = AdSize.banner,
    this.useTestAds = true, // Default to test ads until account is approved
  });

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  /// Get the appropriate ad unit ID based on platform and test mode
  String get _adUnitId {
    if (widget.useTestAds) {
      // Google's official test ad unit IDs
      if (Platform.isAndroid) {
        return AdMobConfig.androidGameOverBannerId; // Android test banner
      } else if (Platform.isIOS) {
        return AdMobConfig.iosGameOverBannerId; // iOS test banner
      }
    }
    // Use production ad unit ID based on platform when account is approved
    if (Platform.isAndroid) {
      return widget.adUnitId; // Android production ID
    } else if (Platform.isIOS) {
      // For iOS, we need to pass the iOS-specific ID
      // The widget should receive the iOS ID when on iOS
      return widget.adUnitId; // iOS production ID
    }
    return widget.adUnitId;
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    final adUnitId = _adUnitId;
    print(
        '📱 Loading AdMob Banner with ID: $adUnitId (Test mode: ${widget.useTestAds})');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _isAdLoaded = true;
            });
          }
          print('✅ AdMob Banner loaded successfully');
        },
        onAdFailedToLoad: (ad, error) {
          print('❌ AdMob Banner failed to load: $error');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isAdLoaded = false;
            });
          }
        },
        onAdOpened: (ad) {
          print('📱 AdMob Banner opened');
        },
        onAdClosed: (ad) {
          print('🔒 AdMob Banner closed');
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      // Show a placeholder while the ad is loading
      return SizedBox(
        height: widget.adSize.height.toDouble(),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
          ),
        ),
      );
    }

    return Container(
        padding: const EdgeInsets.all(kPaddingS),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          borderRadius: Helper.getBorderRadius(
            radius:
                kPaddingS, // Optional, defaults to LayoutConfig.layoutBorderRadius
            shapeAt: RoundedWithShapeAt.bottom,
            // adjustment: kPaddingS, // Optional adjustment to radius
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: SizedBox(
            height: widget.adSize.height.toDouble() - kPaddingS,
            width: widget.adSize.width.toDouble() - kPaddingS,
            child: AdWidget(ad: _bannerAd!)));
  }
}
