import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nucatch/helpers/display_scale.dart';
import 'package:nucatch/helpers/admob_config.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide UpdateCheckerWrapper, MenuNav, TopScoreNav;
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/blocs/objects/tutorial/tutorial_cubit.dart';
import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:nucatch/screens/wrappers/update_checker_wrapper.dart';
import 'package:nucatch/widgets/global_tour_wrapper.dart';
import 'package:nucatch/services/fcm_service.dart';

import 'package:nucatch/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }
  BaseAdMobConfig.register(AdMobConfig.instance);

  // Typography: one cohesive family across the whole app. Hierarchy comes from
  // size / weight / line-height, not from swapping font families. Baloo Bhai 2
  // ships Regular→ExtraBold weights, so every AppTextStyles role stays in-family
  // (primary + secondary + handwriting all resolve to it — no Dancing Script /
  // mono mixing).
  SkeletonConfig.primaryFontFamily = 'Baloo Bhai';
  SkeletonConfig.secondaryFontFamily = 'Baloo Bhai';
  SkeletonConfig.handwritingFontFamily = 'Baloo Bhai';

  final app = SkeletonApp(
    title: 'Nucatch',

    // ----- Async initialization -----
    onInit: () async {
      // Firebase
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        debugPrint('✅ Firebase initialized successfully');

        try {
          final firestore = FirebaseFirestore.instance;
          firestore.settings = const Settings(
            persistenceEnabled: true,
            cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
          );
          debugPrint('✅ Firestore offline persistence enabled');
        } catch (e) {
          debugPrint('⚠️ Failed to enable Firestore persistence: $e');
        }
      } catch (e) {
        debugPrint('⚠️ Firebase initialization failed (offline mode): $e');
      }

      // Dotenv
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        debugPrint('⚠️ Failed to load .env file: $e');
      }

      // Firebase Cloud Messaging
      try {
        await FcmService().init();
        debugPrint('✅ FCM Service initialized successfully');
      } catch (e) {
        debugPrint('⚠️ Failed to initialize FCM Service: $e');
      }
    },

    // ----- Localization -----
    localizationsDelegates: const [
      AppLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,

    // ----- Theme -----
    themeBuilder: (context, state) {
      // On a tablet-sized window all text is a step larger (see
      // display_scale.dart); the in-app font-size setting still applies on
      // top. Reading the window size here rebuilds the theme on resize.
      final tabletScale =
          textScaleForWindow(MediaQuery.maybeSizeOf(context) ?? Size.zero);
      return ThemeData(
        // One cohesive family (see SkeletonConfig above). Fallback is limited to
        // Roboto Mono for the few numeric/monospace readouts; the old six-font
        // fallback chain was the "excessive font variation" we're removing.
        fontFamily: 'Baloo Bhai',
        fontFamilyFallback: const [
          "Roboto Mono",
        ],
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: (0.5 + (state.fontSize / 20)) * tabletScale,
              fontSizeDelta: (1 + (state.fontSize / 10)) * tabletScale,
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
        colorScheme: SeasonalTheme.config.getColorScheme(),
        useMaterial3: true,
        primaryColor: SeasonalTheme.config.primaryColor,
        secondaryHeaderColor: SeasonalTheme.config.secondaryColor,
        cardColor: SeasonalTheme.config.cardColor ??
            SeasonalTheme.config.tertiaryColor,
        // Subtle separator instead of the old harsh pure-gold rule (#FFD700):
        // dividers should whisper structure, not slice the layout into blocks.
        dividerColor: Colors.white.withValues(alpha: 0.16),
        scaffoldBackgroundColor: Colors.white,
      );
    },

    // ----- App-specific blocs -----
    appBlocProviders: [
      BlocProvider(
        create: (context) => TurnRecordedListBloc(
          TurnRecordedListState(
            numberOfTopBoard:
                context.read<SettingBloc>().state.numberOfTopBoard,
          ),
        ),
      ),
      BlocProvider(create: (context) => TutorialCubit()),
    ],

    // ----- Wrappers -----
    tourWrapperBuilder: (context, child) => GlobalTourWrapper(child: child),
    updateCheckerBuilder: (context, child) =>
        UpdateCheckerWrapper(child: child),

    // ----- Navigation -----
    menuNavBuilder: (context) => const MenuNav(),
  );

  await app.launch();
}
