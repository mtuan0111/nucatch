import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_th.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('ja'),
    Locale('th'),
    Locale('vi'),
    Locale('zh')
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

  /// Daily leaderboard
  ///
  /// In en, this message translates to:
  /// **'In a day'**
  String get daily;

  /// Description for daily leaderboard
  ///
  /// In en, this message translates to:
  /// **'Rankings based on turns recorded today.'**
  String get dailyDescription;

  /// Weekly leaderboard
  ///
  /// In en, this message translates to:
  /// **'In a week'**
  String get weekly;

  /// Description for weekly leaderboard
  ///
  /// In en, this message translates to:
  /// **'Rankings based on turns recorded in the past 7 days.'**
  String get weeklyDescription;

  /// All-time leaderboard
  ///
  /// In en, this message translates to:
  /// **'All time'**
  String get allTime;

  /// Description for all-time leaderboard
  ///
  /// In en, this message translates to:
  /// **'Rankings based on all recorded turns.'**
  String get allTimeDescription;

  /// Title for force update dialog
  ///
  /// In en, this message translates to:
  /// **'Update Required'**
  String get updateRequired;

  /// Title for optional update dialog
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// Label for current app version
  ///
  /// In en, this message translates to:
  /// **'Current Version'**
  String get currentVersion;

  /// Label for new available version
  ///
  /// In en, this message translates to:
  /// **'New Version'**
  String get newVersion;

  /// Label for release notes section
  ///
  /// In en, this message translates to:
  /// **'What\'s New'**
  String get whatsNew;

  /// Message for force update requirement
  ///
  /// In en, this message translates to:
  /// **'This update is required to continue using the app. Please update now.'**
  String get forceUpdateMessage;

  /// Button to postpone optional update
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get later;

  /// Button to proceed with update
  ///
  /// In en, this message translates to:
  /// **'Update Now'**
  String get updateNow;

  /// Button to update app
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// Button to check for app updates
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// Section title for app updates
  ///
  /// In en, this message translates to:
  /// **'App Updates'**
  String get appUpdates;

  /// Message prompting user to check for updates
  ///
  /// In en, this message translates to:
  /// **'Tap the button below to check for app updates.'**
  String get tapToCheckUpdates;

  /// Message while checking for updates
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get checkingForUpdates;

  /// Message when new version is available
  ///
  /// In en, this message translates to:
  /// **'New version {version} is available! {forceMessage}'**
  String newVersionAvailable(String version, String forceMessage);

  /// Message for force update
  ///
  /// In en, this message translates to:
  /// **'This update is required.'**
  String get thisUpdateRequired;

  /// Message when app is up to date
  ///
  /// In en, this message translates to:
  /// **'You\'re using the latest version!'**
  String get usingLatestVersion;

  /// Error message when update check fails
  ///
  /// In en, this message translates to:
  /// **'Unable to check for updates. {error}'**
  String unableToCheckUpdates(String error);

  /// Default error message
  ///
  /// In en, this message translates to:
  /// **'Please try again later.'**
  String get tryAgainLater;

  /// Message when user dismissed update
  ///
  /// In en, this message translates to:
  /// **'Update available but postponed.'**
  String get updatePostponed;

  /// Tooltip explaining the tap timer progress bar
  ///
  /// In en, this message translates to:
  /// **'You have {totalSeconds} seconds to tap a number. The bar changes color as time runs out: green (more than {halfSeconds}s), orange ({quarterSeconds}-{halfSeconds}s), red (less than {quarterSeconds}s).'**
  String tapTimerTooltip(int totalSeconds, int halfSeconds, int quarterSeconds);

  /// Title for play mode selection screen
  ///
  /// In en, this message translates to:
  /// **'Select Play Mode'**
  String get selectPlayMode;

  /// Title for solo play mode
  ///
  /// In en, this message translates to:
  /// **'Solo Mode'**
  String get soloMode;

  /// Description for solo play mode
  ///
  /// In en, this message translates to:
  /// **'Play alone and challenge yourself to beat your high score'**
  String get soloModeDescription;

  /// Title for combat/multiplayer play mode
  ///
  /// In en, this message translates to:
  /// **'Combat Mode'**
  String get combatMode;

  /// Description for combat play mode
  ///
  /// In en, this message translates to:
  /// **'Play with another player via Bluetooth connection and take turns'**
  String get combatModeDescription;

  /// Button to create a new game room
  ///
  /// In en, this message translates to:
  /// **'Create Room'**
  String get createRoom;

  /// Description for create room option
  ///
  /// In en, this message translates to:
  /// **'Host a new game and wait for another player to join'**
  String get createRoomDescription;

  /// Button to join an existing game room
  ///
  /// In en, this message translates to:
  /// **'Join Room'**
  String get joinRoom;

  /// Description for join room option
  ///
  /// In en, this message translates to:
  /// **'Enter a room code to join an existing game'**
  String get joinRoomDescription;

  /// Title for host room screen
  ///
  /// In en, this message translates to:
  /// **'Host Room'**
  String get hostRoom;

  /// Label for room code
  ///
  /// In en, this message translates to:
  /// **'Room Code'**
  String get roomCode;

  /// Instruction to share room code
  ///
  /// In en, this message translates to:
  /// **'Share this code with another player'**
  String get shareCodeWithPlayer;

  /// Label for entering room code
  ///
  /// In en, this message translates to:
  /// **'Enter Room Code'**
  String get enterRoomCode;

  /// Button to connect to a room
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Status message while searching for players
  ///
  /// In en, this message translates to:
  /// **'Searching for players...'**
  String get searchingForPlayers;

  /// Message when successfully paired with another player
  ///
  /// In en, this message translates to:
  /// **'Paired with {playerName}!'**
  String pairedWith(String playerName);

  /// Title for Bluetooth permission dialog
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Permission Required'**
  String get bluetoothPermissionRequired;

  /// Message explaining why Bluetooth permission is needed
  ///
  /// In en, this message translates to:
  /// **'Combat Mode requires Bluetooth permissions to connect with other players. Please grant Bluetooth permissions in your device settings.'**
  String get bluetoothPermissionMessage;

  /// Message when Bluetooth permission is permanently denied
  ///
  /// In en, this message translates to:
  /// **'Bluetooth permissions were previously denied. To use Combat Mode, you need to enable Bluetooth permissions in your device settings.\n\nPlease go to Settings > NuCatch > Permissions and enable Bluetooth.'**
  String get bluetoothPermissionPermanentlyDeniedMessage;

  /// Title for Bluetooth disabled dialog
  ///
  /// In en, this message translates to:
  /// **'Bluetooth Disabled'**
  String get bluetoothDisabled;

  /// Message when Bluetooth is disabled
  ///
  /// In en, this message translates to:
  /// **'Combat Mode requires Bluetooth to be enabled. Please enable Bluetooth in your device settings.'**
  String get bluetoothDisabledMessage;

  /// Button to cancel action
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Button to grant permission
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// Button to check again
  ///
  /// In en, this message translates to:
  /// **'Check Again'**
  String get checkAgain;

  /// Button to open app settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Indicates it's the player's turn in combat mode
  ///
  /// In en, this message translates to:
  /// **'Your Turn'**
  String get yourTurn;

  /// Indicates it's the opponent's turn in combat mode
  ///
  /// In en, this message translates to:
  /// **'Opponent\'s Turn'**
  String get opponentTurn;

  /// Status message while waiting for opponent's move
  ///
  /// In en, this message translates to:
  /// **'Waiting for opponent...'**
  String get waitingForOpponent;

  /// Instruction to watch opponent's moves
  ///
  /// In en, this message translates to:
  /// **'Watch your opponent'**
  String get watchingOpponent;

  /// Victory message in combat mode
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get youWin;

  /// Defeat message in combat mode
  ///
  /// In en, this message translates to:
  /// **'You Lose!'**
  String get youLose;

  /// Message when opponent disconnects
  ///
  /// In en, this message translates to:
  /// **'Opponent Disconnected'**
  String get opponentDisconnected;

  /// Reason for winning when opponent loses all lives
  ///
  /// In en, this message translates to:
  /// **'Opponent ran out of lives'**
  String get opponentRanOutOfLives;

  /// Reason for winning when opponent gives up
  ///
  /// In en, this message translates to:
  /// **'Your opponent gave up'**
  String get opponentGaveUp;

  /// Confirmation message for ending combat game
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to end this game? Your opponent will win.'**
  String get confirmEndCombat;

  /// Reason for losing when player loses all lives
  ///
  /// In en, this message translates to:
  /// **'You ran out of lives'**
  String get youRanOutOfLives;

  /// Holiday event notification with greeting
  ///
  /// In en, this message translates to:
  /// **'Today is {holidayName}, {greeting}'**
  String holidayNotification(String holidayName, String greeting);

  /// New Year holiday name
  ///
  /// In en, this message translates to:
  /// **'New Year'**
  String get holidayNewYear;

  /// New Year greeting
  ///
  /// In en, this message translates to:
  /// **'Happy New Year!'**
  String get greetingNewYear;

  /// Lunar New Year holiday name
  ///
  /// In en, this message translates to:
  /// **'Lunar New Year'**
  String get holidayLunarNewYear;

  /// Lunar New Year greeting in Chinese
  ///
  /// In en, this message translates to:
  /// **'新年快乐! (Xīn Nián Kuài Lè!)'**
  String get greetingLunarNewYear;

  /// Valentine's Day holiday name
  ///
  /// In en, this message translates to:
  /// **'Valentine\'s Day'**
  String get holidayValentine;

  /// Valentine's Day greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Valentine\'s Day!'**
  String get greetingValentine;

  /// Holi holiday name
  ///
  /// In en, this message translates to:
  /// **'Holi'**
  String get holidayHoli;

  /// Holi greeting in Hindi
  ///
  /// In en, this message translates to:
  /// **'होली की शुभकामनाएं! (Holi Ki Shubhkamnayein!)'**
  String get greetingHoli;

  /// Earth Day holiday name
  ///
  /// In en, this message translates to:
  /// **'Earth Day'**
  String get holidayEarthDay;

  /// Earth Day greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Earth Day! Protect our planet!'**
  String get greetingEarthDay;

  /// Easter holiday name
  ///
  /// In en, this message translates to:
  /// **'Easter'**
  String get holidayEaster;

  /// Easter greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Easter!'**
  String get greetingEaster;

  /// Pride Month name
  ///
  /// In en, this message translates to:
  /// **'Pride Month'**
  String get holidayPride;

  /// Pride Month greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Pride! Love is Love!'**
  String get greetingPride;

  /// Halloween holiday name
  ///
  /// In en, this message translates to:
  /// **'Halloween'**
  String get holidayHalloween;

  /// Halloween greeting
  ///
  /// In en, this message translates to:
  /// **'Happy Halloween!'**
  String get greetingHalloween;

  /// Diwali holiday name
  ///
  /// In en, this message translates to:
  /// **'Diwali'**
  String get holidayDiwali;

  /// Diwali greeting in Hindi
  ///
  /// In en, this message translates to:
  /// **'दीपावली की शुभकामनाएं! (Deepavali Ki Shubhkamnayein!)'**
  String get greetingDiwali;

  /// Hanukkah holiday name
  ///
  /// In en, this message translates to:
  /// **'Hanukkah'**
  String get holidayHanukkah;

  /// Hanukkah greeting in Hebrew
  ///
  /// In en, this message translates to:
  /// **'חג חנוכה שמח! (Chag Hanukkah Sameach!)'**
  String get greetingHanukkah;

  /// Christmas holiday name
  ///
  /// In en, this message translates to:
  /// **'Christmas'**
  String get holidayChristmas;

  /// Christmas greeting
  ///
  /// In en, this message translates to:
  /// **'Merry Christmas!'**
  String get greetingChristmas;

  /// Kwanzaa holiday name
  ///
  /// In en, this message translates to:
  /// **'Kwanzaa'**
  String get holidayKwanzaa;

  /// Kwanzaa greeting in Swahili
  ///
  /// In en, this message translates to:
  /// **'Habari Gani!'**
  String get greetingKwanzaa;

  /// Button to restart the game
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// Button to return to main menu
  ///
  /// In en, this message translates to:
  /// **'Return to Menu'**
  String get returnToMenu;

  /// Question asking if player is ready to restart the match
  ///
  /// In en, this message translates to:
  /// **'Do you ready for restart?'**
  String get doYouReadyForRestart;

  /// Button label when player is ready and wants to cancel
  ///
  /// In en, this message translates to:
  /// **'Not Ready'**
  String get notReady;

  /// Label for current player
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// Label for opponent player
  ///
  /// In en, this message translates to:
  /// **'Opponent'**
  String get opponent;

  /// Waiting status text
  ///
  /// In en, this message translates to:
  /// **'Waiting'**
  String get waiting;

  /// Notice shown during countdown when player will go first
  ///
  /// In en, this message translates to:
  /// **'You will take first turn!'**
  String get youWillTakeFirst;

  /// Notice shown during countdown when opponent will go first
  ///
  /// In en, this message translates to:
  /// **'Opponent will take first turn'**
  String get opponentWillTakeFirst;

  /// Snackbar message when host starts advertising the room
  ///
  /// In en, this message translates to:
  /// **'Advertising room! Waiting for opponent...'**
  String get advertisingRoomWaiting;

  /// Snackbar message when opponent joins the room
  ///
  /// In en, this message translates to:
  /// **'Opponent joined! Press Ready when you\'re prepared.'**
  String get opponentJoinedReady;

  /// Dialog title when opponent is ready
  ///
  /// In en, this message translates to:
  /// **'Opponent Ready!'**
  String get opponentReady;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Dialog title when both players are ready
  ///
  /// In en, this message translates to:
  /// **'Both Players Ready!'**
  String get bothPlayersReady;

  /// Snackbar message when searching for hosts
  ///
  /// In en, this message translates to:
  /// **'Searching for hosts...'**
  String get searchingForHosts;

  /// Snackbar message when connecting to a host
  ///
  /// In en, this message translates to:
  /// **'Connecting to {hostName}...'**
  String connectingToHost(String hostName);

  /// Dialog title when host is ready
  ///
  /// In en, this message translates to:
  /// **'Host Ready!'**
  String get hostReady;

  /// Message in dialog when host is ready
  ///
  /// In en, this message translates to:
  /// **'✅ The host is ready!'**
  String get theHostIsReady;

  /// Instruction to press ready button
  ///
  /// In en, this message translates to:
  /// **'Press Ready when you\'re prepared to start.'**
  String get pressReadyWhenPrepared;

  /// Message in dialog when opponent is ready
  ///
  /// In en, this message translates to:
  /// **'✅ Your opponent is ready!'**
  String get yourOpponentIsReady;

  /// Message when game is about to start
  ///
  /// In en, this message translates to:
  /// **'Game is starting...'**
  String get gameIsStarting;

  /// Message when waiting for host to choose difficulty
  ///
  /// In en, this message translates to:
  /// **'Waiting for host to select difficulty...'**
  String get waitingForHostToSelectDifficulty;

  /// Error message when Nearby Connections fails to initialize
  ///
  /// In en, this message translates to:
  /// **'Failed to initialize Nearby Connections. Please grant location permissions.'**
  String get failedToInitializeNearby;

  /// Error message when trying to use Nearby before initialization
  ///
  /// In en, this message translates to:
  /// **'Nearby Connections is not initialized'**
  String get nearbyNotInitialized;

  /// Error message when advertising fails to start
  ///
  /// In en, this message translates to:
  /// **'Failed to start advertising: {error}'**
  String failedToStartAdvertising(String error);

  /// Error message when setting ready status fails
  ///
  /// In en, this message translates to:
  /// **'Failed to set ready: {error}'**
  String failedToSetReady(String error);

  /// Error message when game fails to start
  ///
  /// In en, this message translates to:
  /// **'Failed to start game: {error}'**
  String failedToStartGame(String error);

  /// Status message while waiting for opponent
  ///
  /// In en, this message translates to:
  /// **'Advertising room...\nWaiting for opponent to discover and connect.'**
  String get advertisingRoomStatus;

  /// Status message when opponent connects
  ///
  /// In en, this message translates to:
  /// **'Opponent connected!\nPress Ready when both players are ready.'**
  String get opponentConnectedStatus;

  /// Status message when both players are ready
  ///
  /// In en, this message translates to:
  /// **'Both players ready! Starting game...'**
  String get bothPlayersReadyStatus;

  /// Status message while setting up game
  ///
  /// In en, this message translates to:
  /// **'Setting up game difficulty...'**
  String get settingUpDifficulty;

  /// Label showing host name
  ///
  /// In en, this message translates to:
  /// **'Advertising as:'**
  String get advertisingAs;

  /// Status message when connected via Nearby Connections
  ///
  /// In en, this message translates to:
  /// **'Connected via Nearby'**
  String get connectedViaNearby;

  /// Status message when advertising for connections
  ///
  /// In en, this message translates to:
  /// **'Advertising...'**
  String get advertising;

  /// Message when hosts are discovered
  ///
  /// In en, this message translates to:
  /// **'Select a host to connect'**
  String get selectHostToConnect;

  /// Title showing number of discovered hosts
  ///
  /// In en, this message translates to:
  /// **'Available Hosts ({count})'**
  String availableHosts(int count);

  /// Subtitle hint for host list items
  ///
  /// In en, this message translates to:
  /// **'Tap to connect'**
  String get tapToConnect;

  /// Empty state message when no hosts discovered
  ///
  /// In en, this message translates to:
  /// **'No hosts found nearby'**
  String get noHostsFoundNearby;

  /// Helper text for no hosts found
  ///
  /// In en, this message translates to:
  /// **'Make sure a friend is hosting\nand both devices are close together'**
  String get makeSureFriendHosting;

  /// Status when discovering nearby devices
  ///
  /// In en, this message translates to:
  /// **'Discovering...'**
  String get discovering;

  /// Status when not discovering
  ///
  /// In en, this message translates to:
  /// **'Not discovering'**
  String get notDiscovering;

  /// Warning about device proximity for Nearby Connections
  ///
  /// In en, this message translates to:
  /// **'Make sure devices are within 10 meters distance'**
  String get distanceWarning;

  /// Label for the tour button
  ///
  /// In en, this message translates to:
  /// **'Start Tour'**
  String get tourButtonLabel;

  /// Title for the welcome tour step
  ///
  /// In en, this message translates to:
  /// **'Welcome to NuCatch!'**
  String get tourWelcomeTitle;

  /// Description for the welcome tour step
  ///
  /// In en, this message translates to:
  /// **'Welcome! This quick tour will help you get started smoothly with **NuCatch**. We\'ll show you all the **main features** so you can dive right in and start playing. Let\'s begin!'**
  String get tourWelcomeDesc;

  /// Title for the start button tour step
  ///
  /// In en, this message translates to:
  /// **'Start - Begin Your Game'**
  String get tourStartTitle;

  /// Description for the start button tour step
  ///
  /// In en, this message translates to:
  /// **'Tap the **Start button** to begin. You\'ll then choose between **Solo Mode** for single-player mathematical challenges, or **Combat Mode** for real-time **Bluetooth** multiplayer battles. Let\'s explore both options!'**
  String get tourStartDesc;

  /// Title for solo mode tour step
  ///
  /// In en, this message translates to:
  /// **'Solo Mode - Play Alone'**
  String get tourSoloTitle;

  /// Description for solo mode tour step
  ///
  /// In en, this message translates to:
  /// **'In **Solo Mode**, challenge yourself with mathematical equations! Choose from **4 difficulty levels** (Easy to Extremely Hard). You start with **3 lives** - each wrong answer or timeout costs 1 life. **Higher difficulty** means more points! Now let\'s look at the multiplayer option.'**
  String get tourSoloDesc;

  /// Title for combat mode tour step
  ///
  /// In en, this message translates to:
  /// **'Combat Mode - Bluetooth Multiplayer'**
  String get tourCombatTitle;

  /// Description for combat mode tour step
  ///
  /// In en, this message translates to:
  /// **'**Combat Mode** lets you battle a friend via **Bluetooth**! **Two players** take turns solving equations - **no WiFi needed**, just stay within **10 meters**. The host plays first initially, but in rematches the loser goes first. You have two ways to start a match:'**
  String get tourCombatDesc;

  /// Title for create room tour step
  ///
  /// In en, this message translates to:
  /// **'Combat Mode → Create Room'**
  String get tourCreateRoomTitle;

  /// Description for create room tour step
  ///
  /// In en, this message translates to:
  /// **'First option: **Create Room** makes you the **host**! After granting **Bluetooth permissions**, you\'ll wait for a guest to join your room, then choose the **difficulty level**. As host, you **play first** in the initial match. Or you can join someone else\'s game:'**
  String get tourCreateRoomDesc;

  /// Title for join room tour step
  ///
  /// In en, this message translates to:
  /// **'Combat Mode → Join Room'**
  String get tourJoinRoomTitle;

  /// Description for join room tour step
  ///
  /// In en, this message translates to:
  /// **'Second option: **Join Room** makes you the **guest**! After granting permissions, you\'ll **scan** for nearby rooms, select one, and tap **ready**. The host chooses difficulty, and you\'ll **play second** in the initial match. Now let\'s check the other menu features.'**
  String get tourJoinRoomDesc;

  /// Title for leaderboard tour step
  ///
  /// In en, this message translates to:
  /// **'Top Score - Leaderboards'**
  String get tourLeaderboardTitle;

  /// Description for leaderboard tour step
  ///
  /// In en, this message translates to:
  /// **'Track your progress here! View **global rankings**, your **personal records**, and **statistics** including games played, win rate, accuracy, and scores by difficulty level. Compare with friends and see how you improve over time. Finally, let\'s visit Settings.'**
  String get tourLeaderboardDesc;

  /// Title for settings tour step
  ///
  /// In en, this message translates to:
  /// **'Settings - Customize'**
  String get tourSettingsTitle;

  /// Description for settings tour step
  ///
  /// In en, this message translates to:
  /// **'Customize everything here! Change your **username**, select a **theme**, adjust **sound/music**, choose your **language**, and manage **privacy settings**. You can restart this tour anytime from here. That\'s it - you\'re ready to play!'**
  String get tourSettingsDesc;

  /// Next button in tour
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tourNext;

  /// Previous button in tour
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get tourPrevious;

  /// Skip tour button
  ///
  /// In en, this message translates to:
  /// **'Skip Tour'**
  String get tourSkip;

  /// Finish tour button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get tourFinish;

  /// Restart tour option in settings
  ///
  /// In en, this message translates to:
  /// **'Restart Tour'**
  String get tourRestartFromSettings;

  /// Message shown when tour is reset
  ///
  /// In en, this message translates to:
  /// **'Tour has been reset. Return to the main menu to start.'**
  String get tourResetMessage;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'de',
        'en',
        'es',
        'fr',
        'hi',
        'id',
        'ja',
        'th',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'ja':
      return AppLocalizationsJa();
    case 'th':
      return AppLocalizationsTh();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
