import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi')
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'new_flutter_template'**
  String get appTitle;

  /// Welcome the user to the application
  ///
  /// In en, this message translates to:
  /// **'Welcome!!'**
  String get welcome;

  /// Welcome the user to the application
  ///
  /// In en, this message translates to:
  /// **'Welcome {username}!!'**
  String welcomeUser(String username);

  /// Tiêu đề của trang chính
  ///
  /// In en, this message translates to:
  /// **'Main Menu'**
  String get mainMenu;

  /// Start button label
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// Label for the top score
  ///
  /// In en, this message translates to:
  /// **'Top score'**
  String get topScore;

  /// Settings menu label
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// About menu label
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// Exit button label
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// The version label of the application
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Label for anonymous user
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get anonymous;

  /// Label for game level
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// Label for game score
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// Ready status label
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// Go status label
  ///
  /// In en, this message translates to:
  /// **'Go'**
  String get go;

  /// Game over message
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get gameOver;

  /// Label for difficulty setting in the game
  ///
  /// In en, this message translates to:
  /// **'Difficulty Setting'**
  String get difficultySetting;

  /// Difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// Easy difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// Medium difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Hard difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// Very hard difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get veryHard;

  /// Extreme difficulty level of the game
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get extreme;

  /// Prompt for user to select the game difficulty
  ///
  /// In en, this message translates to:
  /// **'Select difficulty'**
  String get selectDifficulty;

  /// Prompt for user to select the game level
  ///
  /// In en, this message translates to:
  /// **'Select level'**
  String get selectLevel;

  /// Message guiding the user to select a level
  ///
  /// In en, this message translates to:
  /// **'Choose the level you want to play. The higher the level, the more difficult it becomes.'**
  String get selectLevelMessage;

  /// Thông báo điểm số của người chơi
  ///
  /// In en, this message translates to:
  /// **'Your score currently is'**
  String get yourScoreIs;

  /// Message indicating the correct answer
  ///
  /// In en, this message translates to:
  /// **'The correct is'**
  String get theCorrectIs;

  /// Label for name input
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Label for font size setting
  ///
  /// In en, this message translates to:
  /// **'Font size'**
  String get fontSize;

  /// Label for volume setting
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// Label for vibration setting
  ///
  /// In en, this message translates to:
  /// **'Vibrate'**
  String get vibrate;

  /// Label for number of top scores setting
  ///
  /// In en, this message translates to:
  /// **'Number of top scores'**
  String get numberOfTopScores;

  /// Label for language setting
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Thank you message
  ///
  /// In en, this message translates to:
  /// **'Thank you for playing'**
  String get thankYou;

  /// Detailed thank you message
  ///
  /// In en, this message translates to:
  /// **'Thank you for playing our game. We hope you enjoyed it. If you have any feedback or suggestions, please let us know.'**
  String get thankYouMessage;

  /// Label for author name
  ///
  /// In en, this message translates to:
  /// **'Author'**
  String get authorName;

  /// Label for connect with us section
  ///
  /// In en, this message translates to:
  /// **'Connect with us'**
  String get connectWithUs;

  /// Message encouraging users to connect on social media
  ///
  /// In en, this message translates to:
  /// **'If you have any questions or feedback, feel free to reach out to us on our social media channels.'**
  String get connectWithUsMessage;

  /// Introduction content for the application
  ///
  /// In en, this message translates to:
  /// **'NuCatch is a fun and engaging brain game designed to sharpen your memory and improve focus. Challenge yourself to quickly catch numbers in a short time, helping you remember things like OTPs, phone numbers, birthdays, and more. Enjoy the experience and boost your memory skills!'**
  String get introductionContent;

  /// Message for sharing the app with username and profile URL
  ///
  /// In en, this message translates to:
  /// **'Join #NuCatch with {username}! Explore it now at {profileUrl}'**
  String messageShareIntroWIthUsername(String username, String profileUrl);

  /// Message for sharing the app with profile URL
  ///
  /// In en, this message translates to:
  /// **'Explore #NuCatch now at {profileUrl}'**
  String messageShareIntro(String profileUrl);

  /// Subject of the message for sharing the score
  ///
  /// In en, this message translates to:
  /// **'Experience with #NuCatch'**
  String get messageSharePlayedLeaderSubject;

  /// Subject of the message for sharing the score with username
  ///
  /// In en, this message translates to:
  /// **'Experience with {username} at #NuCatch'**
  String messageSharePlayedLeaderSubjectWithUsername(String username);

  /// Message for sharing the score of a player
  ///
  /// In en, this message translates to:
  /// **'{username} was got the {point} points at {timeCreated}. Let\'\'s join #NuCatch with {username}!!'**
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated);

  /// Message for sharing the score when username is not available
  ///
  /// In en, this message translates to:
  /// **'A player got {point} points at {timeCreated}. Join #NuCatch now!!'**
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated);

  /// Warning when the user presses the exit button
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit?'**
  String get confirmExit;

  /// No button in the confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Yes button in the confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// Notification when data is added successfully
  ///
  /// In en, this message translates to:
  /// **'Recorded your turn successfully'**
  String get insertedSuccess;

  /// Notification when data addition fails
  ///
  /// In en, this message translates to:
  /// **'Recorded your turn failed'**
  String get insertedFailed;

  /// Instruction to scan QR code for details
  ///
  /// In en, this message translates to:
  /// **'Scan the QR code to view details'**
  String get scanQrToViewDetails;

  /// Prompt asking the user if they want to exit
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit?'**
  String get doYouWantToExit;

  /// Description for easy difficulty level logic
  ///
  /// In en, this message translates to:
  /// **'Generates a random number with a slightly increased level for simple challenges.'**
  String get difficultyEasyDescription;

  /// Description for medium difficulty level logic
  ///
  /// In en, this message translates to:
  /// **'Produces a plus/minus calculation expression for moderate difficulty.'**
  String get difficultyMediumDescription;

  /// Description for hard difficulty level logic
  ///
  /// In en, this message translates to:
  /// **'Creates a multiplication/division calculation expression for advanced difficulty.'**
  String get difficultyHardDescription;

  /// Description for extreme difficulty level logic
  ///
  /// In en, this message translates to:
  /// **'Randomly selects between generating a complex plus/minus calculation, a higher-level random number, or a multiplication/division calculation for the most challenging experience.'**
  String get difficultyExtremeDescription;

  /// Title for easy difficulty mode
  ///
  /// In en, this message translates to:
  /// **'Easy Mode'**
  String get difficultyEasyTitle;

  /// Title for medium difficulty mode
  ///
  /// In en, this message translates to:
  /// **'Medium Mode'**
  String get difficultyMediumTitle;

  /// Title for hard difficulty mode
  ///
  /// In en, this message translates to:
  /// **'Hard Mode'**
  String get difficultyHardTitle;

  /// Title for extreme difficulty mode
  ///
  /// In en, this message translates to:
  /// **'Extreme Mode'**
  String get difficultyExtremeTitle;

  /// Warning when the user changes the difficulty
  ///
  /// In en, this message translates to:
  /// **'Your turn will be reset. Are you sure you want to change the difficulty?'**
  String get confirmChangeDifficulty;

  /// Warning when the user performs an important action
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get areYouSure;

  /// Notification when there are no turns yet
  ///
  /// In en, this message translates to:
  /// **'No turns yet'**
  String get no_turn_yet;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
