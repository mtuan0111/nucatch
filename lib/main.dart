import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skeleton_core/skeleton_core.dart'
    hide UpdateCheckerWrapper, MenuNav, TopScoreNav;
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/theme_config.dart';
import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:nucatch/screens/wrappers/update_checker_wrapper.dart';
import 'package:nucatch/widgets/global_tour_wrapper.dart';

import 'package:nucatch/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  final app = SkeletonApp(
    title: 'Nucatch',

    // ----- Async initialization -----
    onInit: () async {
      // Firebase
      try {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
        print('✅ Firebase initialized successfully');

        try {
          final firestore = FirebaseFirestore.instance;
          firestore.settings = const Settings(
            persistenceEnabled: true,
            cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
          );
          print('✅ Firestore offline persistence enabled');
        } catch (e) {
          print('⚠️ Failed to enable Firestore persistence: $e');
        }
      } catch (e) {
        print('⚠️ Firebase initialization failed (offline mode): $e');
      }

      // Dotenv
      try {
        await dotenv.load(fileName: ".env");
      } catch (e) {
        print('⚠️ Failed to load .env file: $e');
      }

      // Google Mobile Ads
      try {
        await MobileAds.instance.initialize();
        print('✅ Google Mobile Ads initialized successfully');
      } catch (e) {
        print('⚠️ Failed to initialize Google Mobile Ads: $e');
      }
    },

    // ----- Localization -----
    localizationsDelegates: const [
      AppLocalizations.delegate,
    ],
    supportedLocales: AppLocalizations.supportedLocales,

    // ----- Theme -----
    themeBuilder: (context, state) => ThemeData(
      fontFamily: 'Inter',
      fontFamilyFallback: const [
        "Baloo Bhai",
        "Roboto Mono",
        "Charmonman",
        "Dancing Script",
        "Xanh Mono",
        "JetBrains Mono",
      ],
      textTheme: Theme.of(context).textTheme.apply(
            fontSizeFactor: 0.5 + (state.fontSize / 20),
            fontSizeDelta: 1 + (state.fontSize / 10),
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
      colorScheme: SeasonalTheme.config.getColorScheme(),
      useMaterial3: true,
      primaryColor: SeasonalTheme.config.primaryColor,
      secondaryHeaderColor: SeasonalTheme.config.secondaryColor,
      cardColor:
          SeasonalTheme.config.cardColor ?? SeasonalTheme.config.tertiaryColor,
      dividerColor: const Color(0xFFFFD700),
      scaffoldBackgroundColor: Colors.white,
    ),

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
