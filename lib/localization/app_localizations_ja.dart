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
  String get restartGame => 'ゲームを再起動';

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
  String get pickRightDescription => '正しい方程式を選べ！5秒タイマーのスピード選択ゲーム。';

  @override
  String get difficultyEasyTitle => 'かんたんモード';

  @override
  String get difficultyMediumTitle => 'ふつうモード';

  @override
  String get difficultyHardTitle => 'むずかしいモード';

  @override
  String get difficultyExtremeTitle => '究極モード';

  @override
  String get pickRightTitle => 'Pick Right';

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
  String get tourWelcomeTitle => 'NuCatchへようこそ!';

  @override
  String get tourWelcomeDesc =>
      'ようこそ! この簡単なツアーは、**NuCatch**をスムーズに始めるのに役立ちます。**主要な機能**をすべてお見せしますので、すぐにプレイを始められます。始めましょう!';

  @override
  String get tourStartTitle => 'スタート - ゲームを始める';

  @override
  String get tourStartDesc =>
      'スタートボタンをタップして始めましょう。次に、シングルプレイヤーの数学チャレンジ用のソロモード、またはBluetoothを介したリアルタイムマルチプレイヤーバトル用のコンバットモードを選択します。両方のオプションを見てみましょう!';

  @override
  String get tourInstantStartTitle => 'クイックスタート - 素早くプレイ';

  @override
  String get tourInstantStartDesc =>
      'すぐに始めたいですか？**クイックスタートボタン**をタップすると、前回プレイした難易度でソロゲームをすぐに開始できます。進行状況を続ける最速の方法です！';

  @override
  String get tourSoloTitle => 'ソロモード - 一人でプレイ';

  @override
  String get tourSoloDesc =>
      'ソロモードでは、数学の方程式で自分に挑戦してください! 4つの難易度レベル(簡単から非常に難しいまで)から選択します。3つのライフで始まり、間違った答えやタイムアウトごとに1ライフを失います。難易度が高いほど、より多くのポイントを獲得できます! 次はマルチプレイヤーオプションを見てみましょう。';

  @override
  String get tourCombatTitle => 'コンバットモード - Bluetoothマルチプレイヤー';

  @override
  String get tourCombatDesc =>
      'コンバットモードでは、Bluetoothを介して友達とバトルできます! 2人のプレイヤーが交互に方程式を解きます - WiFiは不要で、10メートル以内にいるだけです。ホストが最初に最初にプレイしますが、再戦では敗者が最初にプレイします。マッチを開始する2つの方法があります:';

  @override
  String get tourCreateRoomTitle => 'コンバットモード → ルームを作成';

  @override
  String get tourCreateRoomDesc =>
      '最初のオプション: ルームを作成すると、あなたがホストになります! Bluetoothの許可を与えた後、ゲストがあなたのルームに参加するのを待ち、その後難易度レベルを選択します。ホストとして、最初のマッチで最初にプレイします。または、他の人のゲームに参加できます:';

  @override
  String get tourJoinRoomTitle => 'コンバットモード → ルームに参加';

  @override
  String get tourJoinRoomDesc =>
      '2番目のオプション: ルームに参加すると、あなたがゲストになります! 許可を与えた後、近くのルームをスキャンし、1つを選択して準備完了をタップします。ホストが難易度を選択し、最初のマッチで2番目にプレイします。それでは、他のメニュー機能を確認しましょう。';

  @override
  String get tourLeaderboardTitle => 'トップスコア - リーダーボード';

  @override
  String get tourLeaderboardDesc =>
      'ここで進捗を追跡しましょう! グローバルランキング、個人記録、プレイしたゲーム、勝率、精度、難易度レベル別のスコアなどの統計を表示します。友達と比較し、時間の経過とともにどのように向上するかを確認してください。最後に、設定にアクセスしましょう。';

  @override
  String get tourSettingsTitle => '設定 - カスタマイズ';

  @override
  String get tourSettingsDesc =>
      'ここですべてをカスタマイズしましょう! ユーザー名を変更し、テーマを選択し、サウンド/音楽を調整し、言語を選択し、プライバシー設定を管理します。ここからいつでもこのツアーを再開できます。以上です - プレイする準備ができました!';

  @override
  String get tourNext => '次へ';

  @override
  String get tourPrevious => '前へ';

  @override
  String get tourSkip => 'ツアーをスキップ';

  @override
  String get tourFinish => '完了';

  @override
  String get tourRestartFromSettings => 'ツアーを再開';

  @override
  String get tourResetMessage => 'ツアーがリセットされました。開始するにはメインメニューに戻ってください。';
}
