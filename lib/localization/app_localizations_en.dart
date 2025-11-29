// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => 'Welcome!!';

  @override
  String welcomeUser(String username) {
    return 'Welcome $username!!';
  }

  @override
  String get mainMenu => 'Main Menu';

  @override
  String get start => 'Start';

  @override
  String get topScore => 'Top score';

  @override
  String get setting => 'Setting';

  @override
  String get about => 'About';

  @override
  String get exit => 'Exit';

  @override
  String get version => 'Version';

  @override
  String get anonymous => 'Anonymous';

  @override
  String get level => 'Level';

  @override
  String get score => 'Score';

  @override
  String get ready => 'Ready';

  @override
  String get go => 'Go';

  @override
  String get gameOver => 'Game Over';

  @override
  String get difficultySetting => 'Difficulty Setting';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get veryHard => 'Very Hard';

  @override
  String get extreme => 'Extreme';

  @override
  String get selectDifficulty => 'Select difficulty';

  @override
  String get selectLevel => 'Select level';

  @override
  String get selectLevelMessage =>
      'Choose the level you want to play. The higher the level, the more difficult it becomes.';

  @override
  String get yourScoreIs => 'Your score currently is';

  @override
  String get theCorrectIs => 'The correct is';

  @override
  String get name => 'Name';

  @override
  String get fontSize => 'Font size';

  @override
  String get volume => 'Volume';

  @override
  String get vibrate => 'Vibrate';

  @override
  String get numberOfTopScores => 'Number of top scores';

  @override
  String get language => 'Language';

  @override
  String get thankYou => 'Thank you for playing';

  @override
  String get thankYouMessage =>
      'Thank you for playing our game. We hope you enjoyed it. If you have any feedback or suggestions, please let us know.';

  @override
  String get authorName => 'Author';

  @override
  String get connectWithUs => 'Connect with us';

  @override
  String get connectWithUsMessage =>
      'If you have any questions or feedback, feel free to reach out to us on our social media channels.';

  @override
  String get introductionContent =>
      'NuCatch is a fun and engaging brain game designed to sharpen your memory and improve focus. Challenge yourself to quickly catch numbers in a short time, helping you remember things like OTPs, phone numbers, birthdays, and more. Enjoy the experience and boost your memory skills!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'Join #NuCatch with $username! Explore it now at $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Explore #NuCatch now at $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Experience with #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Experience with $username at #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username was got the $point points at $timeCreated. Let\'\'s join #NuCatch with $username!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'A player got $point points at $timeCreated. Join #NuCatch now!!';
  }

  @override
  String get confirmExit => 'Are you sure you want to exit?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Yes';

  @override
  String get insertedSuccess => 'Recorded your turn successfully';

  @override
  String get insertedFailed => 'Recorded your turn failed';

  @override
  String get scanQrToViewDetails => 'Scan the QR code to view details';

  @override
  String get doYouWantToExit => 'Do you want to exit?';

  @override
  String get difficultyEasyDescription =>
      'Generates a random number with a slightly increased level for simple challenges.';

  @override
  String get difficultyMediumDescription =>
      'Produces a plus/minus calculation expression for moderate difficulty.';

  @override
  String get difficultyHardDescription =>
      'Creates a multiplication/division calculation expression for advanced difficulty.';

  @override
  String get difficultyExtremeDescription =>
      'Randomly selects between generating a complex plus/minus calculation, a higher-level random number, or a multiplication/division calculation for the most challenging experience.';

  @override
  String get difficultyEasyTitle => 'Easy Mode';

  @override
  String get difficultyMediumTitle => 'Medium Mode';

  @override
  String get difficultyHardTitle => 'Hard Mode';

  @override
  String get difficultyExtremeTitle => 'Extreme Mode';

  @override
  String get confirmChangeDifficulty =>
      'Your turn will be reset. Are you sure you want to change the difficulty?';

  @override
  String get areYouSure => 'Are you sure?';

  @override
  String get no_turn_yet => 'No turns yet';

  @override
  String get daily => 'In a day';

  @override
  String get dailyDescription => 'Rankings based on turns recorded today.';

  @override
  String get weekly => 'In a week';

  @override
  String get weeklyDescription =>
      'Rankings based on turns recorded in the past 7 days.';

  @override
  String get allTime => 'All time';

  @override
  String get allTimeDescription => 'Rankings based on all recorded turns.';

  @override
  String get updateRequired => 'Update Required';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get currentVersion => 'Current Version';

  @override
  String get newVersion => 'New Version';

  @override
  String get whatsNew => 'What\'s New';

  @override
  String get forceUpdateMessage =>
      'This update is required to continue using the app. Please update now.';

  @override
  String get later => 'Later';

  @override
  String get updateNow => 'Update Now';

  @override
  String get update => 'Update';

  @override
  String get checkForUpdates => 'Check for Updates';

  @override
  String get appUpdates => 'App Updates';

  @override
  String get tapToCheckUpdates =>
      'Tap the button below to check for app updates.';

  @override
  String get checkingForUpdates => 'Checking for updates...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'New version $version is available! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'This update is required.';

  @override
  String get usingLatestVersion => 'You\'re using the latest version!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Unable to check for updates. $error';
  }

  @override
  String get tryAgainLater => 'Please try again later.';

  @override
  String get updatePostponed => 'Update available but postponed.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'You have $totalSeconds seconds to tap a number. The bar changes color as time runs out: green (more than ${halfSeconds}s), orange ($quarterSeconds-${halfSeconds}s), red (less than ${quarterSeconds}s).';
  }
}
