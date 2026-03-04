import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:skeleton_core/skeleton_core.dart' hide UpdateCheckerWrapper;
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_bloc.dart';
import 'package:nucatch/blocs/objects/turnRecordedList/turn_recorded_list_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/theme_config.dart';
import 'package:nucatch/localization/app_localizations.dart';
import 'package:nucatch/navs/menu_nav.dart';
import 'package:nucatch/screens/wrappers/update_checker_wrapper.dart';
import 'package:nucatch/widgets/global_tour_wrapper.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nucatch/firebase_options.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Try to initialize Firebase, but continue without it if offline
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized successfully');

    // Enable offline persistence for Firestore
    try {
      final firestore = FirebaseFirestore.instance;

      // Enable persistence settings
      firestore.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      print('✅ Firestore offline persistence enabled');
    } catch (e) {
      print('⚠️ Failed to enable Firestore persistence: $e');
      // Continue anyway - persistence might already be enabled
    }
  } catch (e) {
    print('⚠️ Firebase initialization failed (offline mode): $e');
    // Continue without Firebase - BLE-only mode will still work
  }

  // final settingsController = SettingsController(
  //   SettingsService(),
  // );

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  // await settingsController.loadSettings();

  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print('⚠️ Failed to load .env file: $e');
    // Continue without .env file
  }

  // Initialize Google Mobile Ads SDK
  try {
    await MobileAds.instance.initialize();
    print('✅ Google Mobile Ads initialized successfully');
  } catch (e) {
    print('⚠️ Failed to initialize Google Mobile Ads: $e');
    // Continue without ads
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({
    super.key,
    // required this.settingsController,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // final SettingsController settingsController;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => SettingBloc(),
        ),
        BlocProvider(
          create: (context) => AppVersionBloc(),
        ),
        BlocProvider(
          create: (context) => TourBloc(),
        ),
      ],
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return state.isLoading
                ? const LoadingWidget()
                : MaterialApp(
                    debugShowCheckedModeBanner: false,
                    title: 'Nucatch',
                    localizationsDelegates: const [
                      AppLocalizations.delegate,
                      CoreLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    locale: Locale(state.locale),
                    supportedLocales: AppLocalizations.supportedLocales,
                    theme: ThemeData(
                      // This is the theme of your application.
                      //
                      // TRY THIS: Try running your application with "flutter run". You'll see
                      // the application has a purple toolbar. Then, without quitting the app,
                      // try changing the seedColor in the colorScheme below to Colors.green
                      // and then invoke "hot reload" (save your changes or press the "hot
                      // reload" button in a Flutter-supported IDE, or press "r" if you used
                      // the command line to start the app).
                      //
                      // Notice that the counter didn't reset back to zero; the application
                      // state is not lost during the reload. To reset the state, use hot
                      // restart instead.
                      //
                      // This works for code too, not just values: Most code changes can be
                      // tested with just a hot reload.

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
                            bodyColor:
                                Colors.white, // White text for better contrast
                            displayColor:
                                Colors.white, // White for display text
                          ),
                      colorScheme: SeasonalTheme.config.getColorScheme(),
                      useMaterial3: true,
                      primaryColor: SeasonalTheme.config.primaryColor,
                      secondaryHeaderColor: SeasonalTheme.config.secondaryColor,
                      cardColor: SeasonalTheme.config.cardColor ??
                          SeasonalTheme.config.tertiaryColor,
                      dividerColor: const Color(0xFFFFD700), // Gold dividers
                      scaffoldBackgroundColor:
                          Colors.white, // White background for contrast
                      // primaryTextTheme: Typography().white
                      // textTheme: Typography(platform: TargetPlatform.iOS).white,
                    ),
                    home: MultiBlocProvider(
                      providers: [
                        BlocProvider<MenuBloc>(
                          create: (context) => MenuBloc(Menu()),
                        ),
                        BlocProvider(
                          create: (context) => UserBloc(UnAuthenticatedUser()),
                        ),
                        BlocProvider(
                          create: (context) => TurnRecordedListBloc(
                            TurnRecordedListState(
                              numberOfTopBoard: context
                                  .read<SettingBloc>()
                                  .state
                                  .numberOfTopBoard,
                            ),
                          ),
                        ),
                      ],
                      child: Container(
                        decoration: LayoutConfig(context).gradientDecoration,
                        child: GlobalTourWrapper(
                          child: const UpdateCheckerWrapper(
                            child: MenuNav(),
                          ),
                        ),
                      ),
                    ),
                    themeMode: state.themeMode,
                  );
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
