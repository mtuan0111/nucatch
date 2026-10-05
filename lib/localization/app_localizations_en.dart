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
  String get lastPlayedLabel => 'Last played';

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
      'A quick tour: first the **menu**, then a short **practice game**. You can skip it anytime.';

  @override
  String get tourStartTitle => 'Start';

  @override
  String get tourStartDesc => 'Tap **Start** to choose how you want to play.';

  @override
  String get tourInstantStartTitle => 'Instant Start';

  @override
  String get tourInstantStartDesc =>
      'Jump straight into a **Solo** game at the difficulty you played last.';

  @override
  String get tourSoloTitle => 'Two Ways to Play';

  @override
  String get tourSoloDesc =>
      '**Solo Mode**: play alone and beat your best score. **Combat Mode**: challenge a friend nearby over **Bluetooth** — one creates a room, the other joins.';

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
  String get tourLeaderboardTitle => 'More to Explore';

  @override
  String get tourLeaderboardDesc =>
      '**Top score** shows the rankings, **Setting** changes your name, theme, sound and language, and **About** explains the rules. Next up: a short **practice game**!';

  @override
  String get tourSettingsTitle => 'Settings - Customize';

  @override
  String get tourSettingsDesc =>
      'Customize everything here! Change your **username**, select a **theme**, adjust **sound/music**, choose your **language**, and manage **privacy settings**. You can restart this tour anytime from here. One last menu stop: **History & Rules**.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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
  String get tourRuleRegularWelcomeTitle => 'Regular Mode';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Memorize the number, then type it back before time runs out. You have **3 lives** — lose them all and the game ends.';

  @override
  String get tourRuleRegularLivesTitle => 'Your Lives';

  @override
  String get tourRuleRegularLivesDesc =>
      'You start with **3 lives**. Losing all of them ends the game — so play carefully!';

  @override
  String get tourRuleRegularMemorizeTitle => 'Memorize It';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Watch closely — the number flashes on screen for just a moment before it hides.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Type It Back';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Now tap the digit you just saw on the keypad.';

  @override
  String get tourRuleRegularScoringTitle => 'Nice!';

  @override
  String get tourRuleRegularScoringDesc =>
      'Keep answering correctly to earn points.';

  @override
  String get tourRuleRegularScoringResult =>
      'You just earned a point! Every correct answer adds to your score.';

  @override
  String get tourRuleRegularTimerTitle => 'Beat the Clock';

  @override
  String get tourRuleRegularTimerDesc =>
      'Watch the timer bar — if it runs out before you finish typing, you\'ll lose a life.';

  @override
  String get tourRuleRegularTimerResult =>
      'Time\'s up! Running out of time costs you a life, just like a wrong tap.';

  @override
  String get tourRuleRegularResetTitle => 'Need a New One?';

  @override
  String get tourRuleRegularResetDesc =>
      'Tap **Reset** to skip a tricky challenge for a fresh one — but it always costs a life.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Leveling Up';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Answer enough turns correctly and you\'ll level up.';

  @override
  String get tourRuleRegularLevelUpResult =>
      'Level up! Numbers get a little harder from here — and completing a level without losing a life earns you a bonus life.';

  @override
  String get tourRuleRegularGameOverTitle => 'Game Over';

  @override
  String get tourRuleRegularGameOverDesc =>
      'With only 1 life left, one more miss ends the game for real. Watch what happens.';

  @override
  String get tourRuleRegularWrapUpTitle => 'That\'s Regular Mode!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Now let\'s try Pick Right mode — a different way to play.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Pick Right Mode';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Here you don\'t type — tap the **right answer**. The other choices are decoys.';

  @override
  String get tourRulePickRightOptionsTitle => 'Choose Wisely';

  @override
  String get tourRulePickRightOptionsDesc =>
      'One of these is correct — the others are decoys.';

  @override
  String get tourRulePickRightCorrectTitle => 'Tap the Right One';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Tap the button you think is correct.';

  @override
  String get tourRulePickRightCorrectResult => 'Correct! You earned a point.';

  @override
  String get tourRulePickRightWrongTitle => 'Oops!';

  @override
  String get tourRulePickRightWrongDesc =>
      'This time, try tapping a different button.';

  @override
  String get tourRulePickRightWrongResult =>
      'Wrong pick — the correct answer is highlighted, and you lose a life.';

  @override
  String get tourRulePickRightTimerTitle => 'This Timer\'s Faster';

  @override
  String get tourRulePickRightTimerDesc =>
      'Pick Right mode\'s timer runs out quickly. Watch what happens if you\'re too slow.';

  @override
  String get tourRulePickRightTimerResult =>
      'Time\'s up again — with no lives left, that\'s Game Over.';

  @override
  String get tourRulePickRightWrapUpTitle => 'That\'s Pick Right!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Now let\'s try Combat Mode — where you play against a real opponent.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Welcome to Combat';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'You and an opponent take turns. This badge shows **whose turn** it is — as host, you go first.';

  @override
  String get tourRuleCombatTurnOrderTitle => 'Whose Turn Is It?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'This badge shows whose turn it is. As host, you go first.';

  @override
  String get tourRuleCombatYourTurnTitle => 'Your Turn';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Tap the digit shown to complete your turn.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Opponent\'s Turn';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Now watch — your opponent takes their turn.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'Your opponent answered correctly! The turn comes right back to you.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'A Life Lost';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Watch what happens when your opponent misses a tap.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Your opponent lost a life — you\'ll see their life count drop, just like yours would.';

  @override
  String get tourRuleCombatTimerTitle => 'Everyone Has a Timer';

  @override
  String get tourRuleCombatTimerDesc =>
      'Your timer works the same way here — miss it and you lose a life too.';

  @override
  String get tourRuleCombatTimerResult =>
      'Time\'s up! Losing a life in Combat works just like Solo mode.';

  @override
  String get tourRuleCombatWinTitle => 'Victory!';

  @override
  String get tourRuleCombatWinDesc =>
      'Watch what happens when your opponent runs out of lives.';

  @override
  String get tourRuleCombatWinResult =>
      'You win! Running your opponent out of lives ends the match in your favor.';

  @override
  String get tourRuleCombatWrapUpTitle => 'Tutorial Complete!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'That\'s everything — Solo, Pick Right, and Combat. Good luck out there!';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';

  @override
  String get accountSectionTitle => 'Account';

  @override
  String get signInTitle => 'Sign in';

  @override
  String get signInSubtitle =>
      'Keep your scores and rank safe — sign in to carry them to a new device.';

  @override
  String get signInWithGoogle => 'Continue with Google';

  @override
  String get signInWithApple => 'Continue with Apple';

  @override
  String get signOut => 'Sign out';

  @override
  String signedInAs(String account) {
    return 'Signed in as $account';
  }

  @override
  String get playingAsGuest => 'Playing as guest';

  @override
  String get signInAction => 'Sign in';

  @override
  String get linkSuccessMessage =>
      'Signed in. Your scores are now saved to your account.';

  @override
  String get linkConflictTitle => 'Account already in use';

  @override
  String get linkConflictMessage =>
      'This account already exists. Switching to it will leave your current guest scores behind.';

  @override
  String get linkConflictSwitch => 'Switch account';

  @override
  String get authError => 'Sign-in failed. Please try again.';

  @override
  String get authErrorCancelled => 'Sign-in cancelled.';

  @override
  String get authErrorNetwork =>
      'No connection. Check your network and try again.';

  @override
  String get authErrorCredentialRejected =>
      'Sign-in was rejected. Please try again.';

  @override
  String get authErrorProviderDisabled =>
      'This sign-in method is not available right now.';

  @override
  String get authErrorAppleUnavailable =>
      'Sign in with Apple is not available on this device.';

  @override
  String get authErrorTooManyRequests =>
      'Too many attempts. Please wait a moment and try again.';

  @override
  String get authErrorAlreadyLinked => 'This account is already linked.';

  @override
  String get authErrorAccountDisabled => 'This account has been disabled.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'That email is already used by another sign-in method.';

  @override
  String get authErrorLinkConflict =>
      'This account already belongs to someone else.';

  @override
  String get opponentPausedTitle => 'Opponent paused';

  @override
  String get opponentPausedBody =>
      'They folded or closed their phone. The round resumes when they\'re back.';

  @override
  String get opponentAwayTooLongBody =>
      'They\'ve been away for over a minute. Claim the win, or keep waiting.';

  @override
  String get claimWin => 'Claim win';

  @override
  String get opponentWasAway => 'Opponent was away too long';

  @override
  String get youWereAway => 'You were away too long';

  @override
  String get tourChapterRegular => 'Regular';

  @override
  String get tourRuleRegularTypeBackResult => 'Correct — that\'s a **point**!';
}
