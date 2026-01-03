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
  String get welcome => 'ようこそ！';

  @override
  String welcomeUser(String username) {
    return 'ようこそ、$usernameさん！';
  }

  @override
  String get mainMenu => 'メインメニュー';

  @override
  String get start => 'スタート';

  @override
  String get topScore => '最高スコア';

  @override
  String get setting => '設定';

  @override
  String get about => 'アプリについて';

  @override
  String get exit => '終了';

  @override
  String get version => 'バージョン';

  @override
  String get anonymous => '匿名';

  @override
  String get level => 'レベル';

  @override
  String get score => 'スコア';

  @override
  String get ready => '準備完了';

  @override
  String get go => 'ゴー！';

  @override
  String get gameOver => 'ゲームオーバー';

  @override
  String get difficultySetting => '難易度設定';

  @override
  String get difficulty => '難易度';

  @override
  String get easy => 'かんたん';

  @override
  String get medium => 'ふつう';

  @override
  String get hard => 'むずかしい';

  @override
  String get veryHard => '激ムズ';

  @override
  String get extreme => '究極';

  @override
  String get selectDifficulty => '難易度を選択';

  @override
  String get selectLevel => 'レベルを選択';

  @override
  String get selectLevelMessage => 'プレイしたいレベルを選んでください。レベルが高いほど難しくなります。';

  @override
  String get yourScoreIs => '現在のスコアは';

  @override
  String get theCorrectIs => '正解は';

  @override
  String get name => '名前';

  @override
  String get fontSize => 'フォントサイズ';

  @override
  String get volume => '音量';

  @override
  String get vibrate => '振動';

  @override
  String get numberOfTopScores => 'ハイスコア表示数';

  @override
  String get language => '言語';

  @override
  String get thankYou => 'プレイありがとうございます';

  @override
  String get thankYouMessage =>
      '当ゲームをプレイいただきありがとうございます。楽しんでいただけたでしょうか。ご意見やご感想がございましたら、お気軽にお寄せください。';

  @override
  String get authorName => '作者';

  @override
  String get connectWithUs => 'お問い合わせ';

  @override
  String get connectWithUsMessage =>
      'ご質問やご意見がございましたら、ソーシャルメディアチャネルからお気軽にお問い合わせください。';

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
  String get confirmExit => '本当に終了しますか？';

  @override
  String get no => 'いいえ';

  @override
  String get yes => 'はい';

  @override
  String get insertedSuccess => 'ターンの記録に成功しました';

  @override
  String get insertedFailed => 'ターンの記録に失敗しました';

  @override
  String get scanQrToViewDetails => 'QRコードをスキャンして詳細を表示';

  @override
  String get doYouWantToExit => '終了しますか？';

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
  String get difficultyEasyTitle => 'かんたんモード';

  @override
  String get difficultyMediumTitle => 'ふつうモード';

  @override
  String get difficultyHardTitle => 'むずかしいモード';

  @override
  String get difficultyExtremeTitle => '究極モード';

  @override
  String get confirmChangeDifficulty => 'ターンはリセットされます。本当に難易度を変更しますか？';

  @override
  String get areYouSure => 'よろしいですか？';

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
  String get updateRequired => 'アップデートが必要です';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String get currentVersion => '現在のバージョン';

  @override
  String get newVersion => '新しいバージョン';

  @override
  String get whatsNew => '新機能';

  @override
  String get forceUpdateMessage => 'アプリを引き続き使用するには、この更新が必要です。今すぐ更新してください。';

  @override
  String get later => '後で';

  @override
  String get updateNow => '今すぐ更新';

  @override
  String get update => '更新';

  @override
  String get checkForUpdates => '更新を確認';

  @override
  String get appUpdates => 'アプリアップデート';

  @override
  String get tapToCheckUpdates => '下のボタンをタップして、アプリの更新を確認してください。';

  @override
  String get checkingForUpdates => '更新を確認中...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return '新しいバージョン $version が利用可能です！ $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'この更新は必須です。';

  @override
  String get usingLatestVersion => '最新バージョンを使用しています！';

  @override
  String unableToCheckUpdates(String error) {
    return '更新を確認できませんでした。$error';
  }

  @override
  String get tryAgainLater => '後でもう一度お試しください。';

  @override
  String get updatePostponed => '更新は利用可能ですが延期されました。';

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
  String get cancel => 'キャンセル';

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
  String holidayNotification(String holidayName, String greeting) {
    return '今日は$holidayName、$greeting';
  }

  @override
  String get holidayNewYear => 'お正月';

  @override
  String get greetingNewYear => 'あけましておめでとうございます！';

  @override
  String get holidayLunarNewYear => '旧正月';

  @override
  String get greetingLunarNewYear => '旧正月おめでとうございます！';

  @override
  String get holidayValentine => 'バレンタインデー';

  @override
  String get greetingValentine => 'ハッピーバレンタイン！';

  @override
  String get holidayHoli => 'ホーリー';

  @override
  String get greetingHoli => 'ハッピーホーリー！';

  @override
  String get holidayEarthDay => 'アースデイ';

  @override
  String get greetingEarthDay => 'ハッピーアースデイ！地球を守ろう！';

  @override
  String get holidayEaster => 'イースター';

  @override
  String get greetingEaster => 'ハッピーイースター！';

  @override
  String get holidayPride => 'プライド月間';

  @override
  String get greetingPride => 'ハッピープライド！愛は愛！';

  @override
  String get holidayHalloween => 'ハロウィン';

  @override
  String get greetingHalloween => 'ハッピーハロウィン！';

  @override
  String get holidayDiwali => 'ディワリ';

  @override
  String get greetingDiwali => 'ハッピーディワリ！';

  @override
  String get holidayHanukkah => 'ハヌカ';

  @override
  String get greetingHanukkah => 'ハッピーハヌカ！';

  @override
  String get holidayChristmas => 'クリスマス';

  @override
  String get greetingChristmas => 'メリークリスマス！';

  @override
  String get holidayKwanzaa => 'クワンザ';

  @override
  String get greetingKwanzaa => 'ハッピークワンザ！';

  @override
  String get playAgain => 'もう一度プレイ';

  @override
  String get returnToMenu => 'メニューに戻る';

  @override
  String get doYouReadyForRestart => '再開の準備はできましたか？';

  @override
  String get notReady => '準備不足';

  @override
  String get you => 'あなた';

  @override
  String get opponent => '相手';

  @override
  String get waiting => '待機中';

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
  String get ok => 'OK';

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
