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

  @override
  String get selectPlayMode => 'Select Play Mode';

  @override
  String get soloMode => 'Solo Mode';

  @override
  String get soloModeDescription =>
      'Play alone and challenge yourself to beat your high score';

  @override
  String get combatMode => 'Combat Mode';

  @override
  String get combatModeDescription =>
      'Play with another player via Bluetooth connection and take turns';

  @override
  String get createRoom => 'Create Room';

  @override
  String get createRoomDescription =>
      'Host a new game and wait for another player to join';

  @override
  String get joinRoom => 'Join Room';

  @override
  String get joinRoomDescription =>
      'Enter a room code to join an existing game';

  @override
  String get hostRoom => 'Host Room';

  @override
  String get roomCode => 'Room Code';

  @override
  String get shareCodeWithPlayer => 'Share this code with another player';

  @override
  String get enterRoomCode => 'Enter Room Code';

  @override
  String get connect => 'Connect';

  @override
  String get searchingForPlayers => 'Searching for players...';

  @override
  String pairedWith(String playerName) {
    return 'Paired with $playerName!';
  }

  @override
  String get bluetoothPermissionRequired => 'Bluetooth Permission Required';

  @override
  String get bluetoothPermissionMessage =>
      'Combat Mode requires Bluetooth permissions to connect with other players. Please grant Bluetooth permissions in your device settings.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Bluetooth permissions were previously denied. To use Combat Mode, you need to enable Bluetooth permissions in your device settings.\n\nPlease go to Settings > NuCatch > Permissions and enable Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth Disabled';

  @override
  String get bluetoothDisabledMessage =>
      'Combat Mode requires Bluetooth to be enabled. Please enable Bluetooth in your device settings.';

  @override
  String get cancel => 'Cancel';

  @override
  String get grantPermission => 'Grant Permission';

  @override
  String get checkAgain => 'Check Again';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get yourTurn => 'Your Turn';

  @override
  String get opponentTurn => 'Opponent\'s Turn';

  @override
  String get waitingForOpponent => 'Waiting for opponent...';

  @override
  String get watchingOpponent => 'Watch your opponent';

  @override
  String get youWin => 'You Win!';

  @override
  String get youLose => 'You Lose!';

  @override
  String get opponentDisconnected => 'Opponent Disconnected';

  @override
  String get opponentRanOutOfLives => 'Opponent ran out of lives';

  @override
  String get opponentGaveUp => 'Your opponent gave up';

  @override
  String get confirmEndCombat =>
      'Are you sure you want to end this game? Your opponent will win.';

  @override
  String get youRanOutOfLives => 'You ran out of lives';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Today is $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'New Year';

  @override
  String get greetingNewYear => 'Happy New Year!';

  @override
  String get holidayLunarNewYear => 'Lunar New Year';

  @override
  String get greetingLunarNewYear => '新年快乐! (Xīn Nián Kuài Lè!)';

  @override
  String get holidayValentine => 'Valentine\'s Day';

  @override
  String get greetingValentine => 'Happy Valentine\'s Day!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => 'होली की शुभकामनाएं! (Holi Ki Shubhkamnayein!)';

  @override
  String get holidayEarthDay => 'Earth Day';

  @override
  String get greetingEarthDay => 'Happy Earth Day! Protect our planet!';

  @override
  String get holidayEaster => 'Easter';

  @override
  String get greetingEaster => 'Happy Easter!';

  @override
  String get holidayPride => 'Pride Month';

  @override
  String get greetingPride => 'Happy Pride! Love is Love!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => 'Happy Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali =>
      'दीपावली की शुभकामनाएं! (Deepavali Ki Shubhkamnayein!)';

  @override
  String get holidayHanukkah => 'Hanukkah';

  @override
  String get greetingHanukkah => 'חג חנוכה שמח! (Chag Hanukkah Sameach!)';

  @override
  String get holidayChristmas => 'Christmas';

  @override
  String get greetingChristmas => 'Merry Christmas!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => 'Habari Gani!';

  @override
  String get playAgain => 'Play Again';

  @override
  String get returnToMenu => 'Return to Menu';

  @override
  String get doYouReadyForRestart => 'Do you ready for restart?';

  @override
  String get notReady => 'Not Ready';

  @override
  String get you => 'You';

  @override
  String get opponent => 'Opponent';

  @override
  String get waiting => 'Waiting';

  @override
  String get youWillTakeFirst => 'You will take first turn!';

  @override
  String get opponentWillTakeFirst => 'Opponent will take first turn';

  @override
  String get advertisingRoomWaiting =>
      'Advertising room! Waiting for opponent...';

  @override
  String get opponentJoinedReady =>
      'Opponent joined! Press Ready when you\'re prepared.';

  @override
  String get opponentReady => 'Opponent Ready!';

  @override
  String get ok => 'OK';

  @override
  String get bothPlayersReady => 'Both Players Ready!';

  @override
  String get searchingForHosts => 'Searching for hosts...';

  @override
  String connectingToHost(String hostName) {
    return 'Connecting to $hostName...';
  }

  @override
  String get hostReady => 'Host Ready!';

  @override
  String get theHostIsReady => '✅ The host is ready!';

  @override
  String get pressReadyWhenPrepared =>
      'Press Ready when you\'re prepared to start.';

  @override
  String get yourOpponentIsReady => '✅ Your opponent is ready!';

  @override
  String get gameIsStarting => 'Game is starting...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'Waiting for host to select difficulty...';

  @override
  String get failedToInitializeNearby =>
      'Failed to initialize Nearby Connections. Please grant location permissions.';

  @override
  String get nearbyNotInitialized => 'Nearby Connections is not initialized';

  @override
  String failedToStartAdvertising(String error) {
    return 'Failed to start advertising: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Failed to set ready: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Failed to start game: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Advertising room...\nWaiting for opponent to discover and connect.';

  @override
  String get opponentConnectedStatus =>
      'Opponent connected!\nPress Ready when both players are ready.';

  @override
  String get bothPlayersReadyStatus => 'Both players ready! Starting game...';

  @override
  String get settingUpDifficulty => 'Setting up game difficulty...';

  @override
  String get advertisingAs => 'Advertising as:';

  @override
  String get connectedViaNearby => 'Connected via Nearby';

  @override
  String get advertising => 'Advertising...';

  @override
  String get selectHostToConnect => 'Select a host to connect';

  @override
  String availableHosts(int count) {
    return 'Available Hosts ($count)';
  }

  @override
  String get tapToConnect => 'Tap to connect';

  @override
  String get noHostsFoundNearby => 'No hosts found nearby';

  @override
  String get makeSureFriendHosting =>
      'Make sure a friend is hosting\nand both devices are close together';

  @override
  String get discovering => 'Discovering...';

  @override
  String get notDiscovering => 'Not discovering';

  @override
  String get distanceWarning =>
      'Make sure devices are within 10 meters distance';

  @override
  String get tourButtonLabel => 'Start Tour';

  @override
  String get tourStartTitle => 'Let\'s Get Started!';

  @override
  String get tourStartDesc =>
      'This button opens both Solo and Combat modes. Tap it and I\'ll explain more inside!';

  @override
  String get tourSoloTitle => 'Solo Mode';

  @override
  String get tourSoloDesc =>
      'Challenge yourself! Tap numbers to solve math problems or match sequences. The faster you are, the higher your score. Each correct answer levels you up with harder challenges!';

  @override
  String get tourCombatTitle => 'Combat Mode';

  @override
  String get tourCombatDesc =>
      'Battle against friends in real-time using Bluetooth! No internet required. Two players solve the same challenges simultaneously - the fastest wins!';

  @override
  String get tourCreateRoomTitle => 'Create Room';

  @override
  String get tourCreateRoomDesc =>
      'Host a game for your friend! Choose your difficulty level and share your room code. Your opponent can join using Nearby Connections or by scanning your QR code.';

  @override
  String get tourJoinRoomTitle => 'Join Room';

  @override
  String get tourJoinRoomDesc =>
      'Join a friend\'s game! Enter their room code or scan their QR code to connect. Make sure you\'re within Bluetooth range for the best experience.';

  @override
  String get tourLeaderboardTitle => 'Top Scores';

  @override
  String get tourLeaderboardDesc =>
      'Check out the best players! View high scores, track your progress, and compete to reach the top. Can you beat the current champions?';

  @override
  String get tourSettingsTitle => 'Settings';

  @override
  String get tourSettingsDesc =>
      'Customize your experience! Adjust sound, change language, modify difficulty, and personalize the app to your liking. You can also restart this tour anytime from here.';

  @override
  String get tourNext => 'Next';

  @override
  String get tourPrevious => 'Previous';

  @override
  String get tourSkip => 'Skip Tour';

  @override
  String get tourFinish => 'Finish';

  @override
  String get tourRestartFromSettings => 'Restart Tour';
}
