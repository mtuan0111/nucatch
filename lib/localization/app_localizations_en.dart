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
  String get instantStart => 'Instant Start';

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
  String get whichOneIsCorrect => 'Which one is correct?';

  @override
  String get numberOfTopScores => 'Number of top scores';

  @override
  String get onlyShowMyRecorded => 'Only show my recorded';

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
  String get restartGame => 'Restart Game';

  @override
  String get confirmRestart => 'Are you sure you want to restart the game?';

  @override
  String get insertedSuccess => 'Recorded your turn successfully';

  @override
  String get insertedFailed => 'Recorded your turn failed';

  @override
  String get scanQrToViewDetails => 'Scan the QR code to view details';

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
  String get pickRightDescription =>
      'Choose the correct equation! Fast-paced selection game with 5-second timer.';

  @override
  String get difficultyEasyTitle => 'Easy Mode';

  @override
  String get difficultyMediumTitle => 'Medium Mode';

  @override
  String get difficultyHardTitle => 'Hard Mode';

  @override
  String get difficultyExtremeTitle => 'Extreme Mode';

  @override
  String get pickRightTitle => 'Pick Right';

  @override
  String get confirmChangeDifficulty =>
      'Your turn will be reset. Are you sure you want to change the difficulty?';

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
  String get doYouReadyForRestart => 'Do you ready for restart?';

  @override
  String get notReady => 'Not Ready';

  @override
  String get you => 'You';

  @override
  String get opponent => 'Opponent';

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
  String get tourWelcomeTitle => 'Welcome to NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Welcome! This quick tour will help you get started smoothly with **NuCatch**. We\'ll show you all the **main features** so you can dive right in and start playing. Let\'s begin!';

  @override
  String get tourStartTitle => 'Start - Begin Your Game';

  @override
  String get tourStartDesc =>
      'Tap the **Start button** to begin. You\'ll then choose between **Solo Mode** for single-player mathematical challenges, or **Combat Mode** for real-time **Bluetooth** multiplayer battles. Let\'s explore both options!';

  @override
  String get tourInstantStartTitle => 'Instant Start - Quick Play';

  @override
  String get tourInstantStartDesc =>
      'Want to jump right in? Tap the **Instant Start button** to begin a solo game immediately with the same difficulty level you played last time. It\'s the fastest way to continue your progress!';

  @override
  String get tourSoloTitle => 'Solo Mode - Play Alone';

  @override
  String get tourSoloDesc =>
      'In **Solo Mode**, challenge yourself with mathematical equations! Choose from **4 difficulty levels** (Easy to Extremely Hard). You start with **3 lives** - each wrong answer or timeout costs 1 life. **Higher difficulty** means more points! Now let\'s look at the multiplayer option.';

  @override
  String get tourCombatTitle => 'Combat Mode - Bluetooth Multiplayer';

  @override
  String get tourCombatDesc =>
      '**Combat Mode** lets you battle a friend via **Bluetooth**! **Two players** take turns solving equations - **no WiFi needed**, just stay within **10 meters**. The host plays first initially, but in rematches the loser goes first. You have two ways to start a match:';

  @override
  String get tourCreateRoomTitle => 'Combat Mode → Create Room';

  @override
  String get tourCreateRoomDesc =>
      'First option: **Create Room** makes you the **host**! After granting **Bluetooth permissions**, you\'ll wait for a guest to join your room, then choose the **difficulty level**. As host, you **play first** in the initial match. Or you can join someone else\'s game:';

  @override
  String get tourJoinRoomTitle => 'Combat Mode → Join Room';

  @override
  String get tourJoinRoomDesc =>
      'Second option: **Join Room** makes you the **guest**! After granting permissions, you\'ll **scan** for nearby rooms, select one, and tap **ready**. The host chooses difficulty, and you\'ll **play second** in the initial match. Now let\'s check the other menu features.';

  @override
  String get tourLeaderboardTitle => 'Top Score - Leaderboards';

  @override
  String get tourLeaderboardDesc =>
      'Track your progress here! View **global rankings**, your **personal records**, and **statistics** including games played, win rate, accuracy, and scores by difficulty level. Compare with friends and see how you improve over time. Finally, let\'s visit Settings.';

  @override
  String get tourSettingsTitle => 'Settings - Customize';

  @override
  String get tourSettingsDesc =>
      'Customize everything here! Change your **username**, select a **theme**, adjust **sound/music**, choose your **language**, and manage **privacy settings**. You can restart this tour anytime from here. That\'s it - you\'re ready to play!';

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

  @override
  String get tourResetMessage =>
      'Tour has been reset. Return to the main menu to start.';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';
}
