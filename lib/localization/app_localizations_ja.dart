// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get instantStart => 'インスタントスタート';

  @override
  String get selectLevel => 'レベルを選択';

  @override
  String get selectLevelMessage => 'プレイしたいレベルを選んでください。レベルが高いほど難しくなります。';

  @override
  String get yourScoreIs => '現在のスコアは';

  @override
  String get theCorrectIs => '正解は';

  @override
  String get whichOneIsCorrect => 'どちらが正しい？';

  @override
  String get numberOfTopScores => 'ハイスコア表示数';

  @override
  String get onlyShowMyRecorded => '自分の記録のみ表示';

  @override
  String get introductionContent =>
      'NuCatchは、記憶力を高め、集中力を向上させるために設計された楽しく魅力的な脳トレゲームです。短時間で数字を素早くキャッチすることに挑戦し、OTP、電話番号、誕生日などを覚えるのに役立ちます。体験を楽しんで、記憶力を向上させましょう！';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return '$usernameと一緒に#NuCatchに参加しましょう！今すぐ $profileUrl でチェック';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return '#NuCatchを $profileUrl で今すぐチェック';
  }

  @override
  String get messageSharePlayedLeaderSubject => '#NuCatch 体験';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return '#NuCatch での $username との体験';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username が $timeCreated に $point 点を獲得しました。$username と一緒に #NuCatch に参加しましょう！！';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'プレイヤーが $timeCreated に $point 点を獲得しました。今すぐ #NuCatch に参加しましょう！！';
  }

  @override
  String get restartGame => 'ゲームをリスタート';

  @override
  String get confirmRestart => '本当にゲームを再起動しますか？';

  @override
  String get insertedSuccess => 'ターンの記録に成功しました';

  @override
  String get insertedFailed => 'ターンの記録に失敗しました';

  @override
  String get scanQrToViewDetails => 'QRコードをスキャンして詳細を表示';

  @override
  String get difficultyEasyDescription => 'レベルが少し高いランダムな数字を生成する、シンプルなチャレンジです。';

  @override
  String get difficultyMediumDescription => '足し算/引き算の計算式を生成する、中程度の難易度です。';

  @override
  String get difficultyHardDescription => '掛け算/割り算の計算式を作成する、高度な難易度です。';

  @override
  String get difficultyExtremeDescription =>
      '複雑な足し算/引き算、より高いレベルのランダムな数字、または掛け算/割り算の計算式からランダムに選択する、最もやりがいのある体験です。';

  @override
  String get pickRightDescription => '正しい数式を選択してください！5秒タイマーのクイック選択ゲーム。';

  @override
  String get difficultyEasyTitle => 'かんたんモード';

  @override
  String get difficultyMediumTitle => 'ふつうモード';

  @override
  String get difficultyHardTitle => 'むずかしいモード';

  @override
  String get difficultyExtremeTitle => '究極モード';

  @override
  String get pickRightTitle => '正しい方を選べ';

  @override
  String get confirmChangeDifficulty => 'ターンはリセットされます。本当に難易度を変更しますか？';

  @override
  String get no_turn_yet => 'まだターンがありません';

  @override
  String get daily => '1日以内';

  @override
  String get dailyDescription => '今日記録されたターンに基づくランキング。';

  @override
  String get weekly => '1週間以内';

  @override
  String get weeklyDescription => '過去7日間に記録されたターンに基づくランキング。';

  @override
  String get allTime => '全期間';

  @override
  String get allTimeDescription => '記録されたすべてのターンに基づくランキング。';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return '数字をタップするのに $totalSeconds 秒時間が与えられます。時間が経つにつれてバーの色が変わります：緑（$halfSeconds秒以上）、オレンジ（$quarterSeconds-$halfSeconds秒）、赤（$quarterSeconds秒未満）。';
  }

  @override
  String get selectPlayMode => 'プレイモード選択';

  @override
  String get soloMode => 'ソロモード';

  @override
  String get soloModeDescription => '一人でプレイしてハイスコア更新に挑戦';

  @override
  String get combatMode => '対戦モード';

  @override
  String get combatModeDescription => 'Bluetooth接続で他のプレイヤーと交代でプレイ';

  @override
  String get createRoom => 'ルーム作成';

  @override
  String get createRoomDescription => '新しいゲームをホストして他のプレイヤーを待つ';

  @override
  String get joinRoom => 'ルーム参加';

  @override
  String get joinRoomDescription => 'ルームコードを入力して既存のゲームに参加';

  @override
  String get hostRoom => 'ホストルーム';

  @override
  String get roomCode => 'ルームコード';

  @override
  String get shareCodeWithPlayer => 'このコードを他のプレイヤーと共有してください';

  @override
  String get enterRoomCode => 'ルームコード入力';

  @override
  String get connect => '接続';

  @override
  String get searchingForPlayers => 'プレイヤーを検索中...';

  @override
  String pairedWith(String playerName) {
    return '$playerNameとペアリングしました！';
  }

  @override
  String get bluetoothPermissionRequired => 'Bluetooth権限が必要です';

  @override
  String get bluetoothPermissionMessage =>
      '対戦モードでは他のプレイヤーと接続するためにBluetooth権限が必要です。デバイスの設定でBluetooth権限を許可してください。';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Bluetooth権限が永久に拒否されました。対戦モードを使用するには、デバイスの設定でBluetooth権限を有効にする必要があります。\n\n設定 > NuCatch > 権限 に移動してBluetoothを有効にしてください。';

  @override
  String get bluetoothDisabled => 'Bluetoothが無効です';

  @override
  String get bluetoothDisabledMessage =>
      '対戦モードではBluetoothを有効にする必要があります。デバイスの設定でBluetoothをオンにしてください。';

  @override
  String get grantPermission => '権限を許可';

  @override
  String get checkAgain => '再確認';

  @override
  String get openSettings => '設定を開く';

  @override
  String get yourTurn => 'あなたのターン';

  @override
  String get opponentTurn => '相手のターン';

  @override
  String get waitingForOpponent => '相手を待っています...';

  @override
  String get watchingOpponent => '相手を見てください';

  @override
  String get youWin => 'あなたの勝ち！';

  @override
  String get youLose => 'あなたの負け！';

  @override
  String get opponentDisconnected => '相手が切断しました';

  @override
  String get opponentRanOutOfLives => '相手のライフがなくなりました';

  @override
  String get opponentGaveUp => '相手が降参しました';

  @override
  String get confirmEndCombat => '本当にこのゲームを終了しますか？相手の勝利になります。';

  @override
  String get youRanOutOfLives => 'ライフがなくなりました';

  @override
  String get doYouReadyForRestart => '再開の準備はできましたか？';

  @override
  String get notReady => '準備不足';

  @override
  String get you => 'あなた';

  @override
  String get opponent => '相手';

  @override
  String get youWillTakeFirst => 'あなたが先攻です！';

  @override
  String get opponentWillTakeFirst => '相手が先攻です';

  @override
  String get advertisingRoomWaiting => 'ルームを公開中！相手を待っています...';

  @override
  String get opponentJoinedReady => '相手が参加しました！準備ができたら「準備完了」を押してください。';

  @override
  String get opponentReady => '相手の準備完了！';

  @override
  String get bothPlayersReady => '両プレイヤー準備完了！';

  @override
  String get searchingForHosts => 'ホストを検索中...';

  @override
  String connectingToHost(String hostName) {
    return '$hostNameに接続中...';
  }

  @override
  String get hostReady => 'ホスト準備完了！';

  @override
  String get theHostIsReady => '✅ ホストの準備が完了しました！';

  @override
  String get pressReadyWhenPrepared => '準備ができたら「準備完了」を押してください。';

  @override
  String get yourOpponentIsReady => '✅ 相手の準備が完了しました！';

  @override
  String get gameIsStarting => 'ゲームを開始します...';

  @override
  String get waitingForHostToSelectDifficulty => 'ホストが難易度を選択するのを待っています...';

  @override
  String get failedToInitializeNearby =>
      'Nearby Connectionsの初期化に失敗しました。位置情報の権限を許可してください。';

  @override
  String get nearbyNotInitialized => 'Nearby Connectionsが初期化されていません';

  @override
  String failedToStartAdvertising(String error) {
    return '公開の開始に失敗しました: $error';
  }

  @override
  String failedToSetReady(String error) {
    return '準備完了の設定に失敗しました: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'ゲームの開始に失敗しました: $error';
  }

  @override
  String get advertisingRoomStatus => 'ルームを公開中...\n相手が見つけて接続するのを待っています。';

  @override
  String get opponentConnectedStatus =>
      '相手が接続しました！\n両方のプレイヤーの準備ができたら「準備完了」を押してください。';

  @override
  String get bothPlayersReadyStatus => '両プレイヤー準備完了！ゲームを開始します...';

  @override
  String get settingUpDifficulty => 'ゲームの難易度を設定中...';

  @override
  String get advertisingAs => '公開名:';

  @override
  String get connectedViaNearby => 'Nearby経由で接続';

  @override
  String get advertising => '公開中...';

  @override
  String get selectHostToConnect => '接続するホストを選択';

  @override
  String availableHosts(int count) {
    return '利用可能なホスト ($count)';
  }

  @override
  String get tapToConnect => 'タップして接続';

  @override
  String get noHostsFoundNearby => '近くにホストが見つかりません';

  @override
  String get makeSureFriendHosting => '友達がホストしていることを確認し\n両方のデバイスを近づけてください';

  @override
  String get discovering => '検索中...';

  @override
  String get notDiscovering => '検索していません';

  @override
  String get distanceWarning => 'デバイスが10メートル以内にあることを確認してください';

  @override
  String get tourButtonLabel => 'ツアーを開始';

  @override
  String get tourWelcomeTitle => 'NuCatchへようこそ！';

  @override
  String get tourWelcomeDesc =>
      '歓迎します！この短いツアーで **NuCatch** の基本を学びましょう。 今すぐプレイを始められるよう、**主な機能**をすべてご案内します。';

  @override
  String get tourStartTitle => 'スタート - ゲームを開始';

  @override
  String get tourStartDesc =>
      '**スタートボタン**をタップしてください。その後、**ソロモード**か、**Bluetooth**を使った**対戦モード**を選択します。';

  @override
  String get tourInstantStartTitle => 'インスタントスタート';

  @override
  String get tourInstantStartDesc =>
      '**インスタントスタート**ボタンをタップすると、前回と同じ難易度ですぐにソロゲームを開始できます。 スコアを伸ばす最速の手段です！';

  @override
  String get tourSoloTitle => 'ソロモード';

  @override
  String get tourSoloDesc =>
      '**ソロモード**で自分自身に挑戦！ **4つの難易度**から選べます。**ライフは3つ** - 不正解や時間切れで1つ減ります。**難易度が高い**ほど高得点！';

  @override
  String get tourCombatTitle => '対戦モード - Bluetooth通信';

  @override
  String get tourCombatDesc =>
      '**Bluetooth**を使って友達と**対戦モード**！**2人のプレイヤー**が交互に数式を解きます。**WiFi不要**。10メートル以内でプレイ。';

  @override
  String get tourCreateRoomTitle => '対戦モード → ルーム作成';

  @override
  String get tourCreateRoomDesc =>
      '**ルーム作成**で**ホスト**になります。Bluetoothを許可してゲストを待ち、**難易度**を選択。あなたが先攻です。';

  @override
  String get tourJoinRoomTitle => '対戦モード → ルーム参加';

  @override
  String get tourJoinRoomDesc =>
      '**ルーム参加**で**ゲスト**になります。近くのルームから選び、**準備完了**をタップ。あなたは後攻です。';

  @override
  String get tourLeaderboardTitle => 'リーダーボード';

  @override
  String get tourLeaderboardDesc =>
      '進捗を確認！**グローバルランキング**や**自己ベスト**、**統計**を見られます。友達と競い合いましょう。';

  @override
  String get tourSettingsTitle => '設定 - カスタマイズ';

  @override
  String get tourSettingsDesc =>
      '**ユーザー名**、**テーマ**、**サウンド**、**言語**などを変更できます。このツアーは設定からいつでも再開できます。';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Discover the ancient legend behind the tower and learn the rules of the game.';

  @override
  String get tourNext => '次へ';

  @override
  String get tourPrevious => '前へ';

  @override
  String get tourSkip => 'スキップ';

  @override
  String get tourFinish => '完了';

  @override
  String get tourRestartFromSettings => 'ツアーを再確認';

  @override
  String get tourResetMessage => 'ツアーがリセットされました。メインメニューから始めましょう。';

  @override
  String get tourRuleRegularWelcomeTitle => 'Let\'s Play!';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Memorize the number, then type it back before time runs out. Ready to give it a try?';

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
      'Instead of typing, you\'ll pick the correct answer from a few choices.';

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
      'In Combat Mode, you and an opponent take turns racing to answer first.';

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
}
