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
  String get lastPlayedLabel => '前回プレイ';

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
      'かんたんなツアーです。まず**メニュー**、次に短い**練習ゲーム**。\nいつでもスキップできます。';

  @override
  String get tourStartTitle => 'スタート';

  @override
  String get tourStartDesc => '**スタート**をタップして、遊び方を選びましょう。';

  @override
  String get tourInstantStartTitle => 'インスタントスタート';

  @override
  String get tourInstantStartDesc => '前回と同じ難易度で、すぐに**ソロ**ゲームを始めます。';

  @override
  String get tourSoloTitle => '2つの遊び方';

  @override
  String get tourSoloDesc =>
      '**ソロモード**：ひとりで遊んで自己ベストを更新。\n**対戦モード**：近くの友だちと**Bluetooth**で対戦 — ひとりがルームを作り、もうひとりが参加します。';

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
  String get tourLeaderboardTitle => 'ほかにもいろいろ';

  @override
  String get tourLeaderboardDesc =>
      '**最高スコア**でランキングを確認できます。\n**設定**で名前・テーマ・サウンド・言語を変更できます。\n**アプリについて**でルールを確認できます。\n次は短い**練習ゲーム**です！';

  @override
  String get tourSettingsTitle => '設定 - カスタマイズ';

  @override
  String get tourSettingsDesc =>
      '**ユーザー名**、**テーマ**、**サウンド**、**言語**などを変更できます。このツアーは設定からいつでも再開できます。';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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
  String get tourRuleRegularWelcomeTitle => 'クラシックモード';

  @override
  String get tourRuleRegularWelcomeDesc =>
      '数字を覚えて、時間切れになる前に入力してください。\n**ライフは3つ**あります — すべて失うとゲームオーバーです。';

  @override
  String get tourRuleRegularLivesTitle => 'ライフについて';

  @override
  String get tourRuleRegularLivesDesc =>
      '**ライフ3つ**でスタートします。すべて失うとゲーム終了 — 慎重にプレイしましょう！';

  @override
  String get tourRuleRegularMemorizeTitle => '覚えましょう';

  @override
  String get tourRuleRegularMemorizeDesc => 'よく見てください — 数字は画面に一瞬だけ表示されてから消えます。';

  @override
  String get tourRuleRegularTypeBackTitle => '入力しましょう';

  @override
  String get tourRuleRegularTypeBackDesc => '今見た数字をキーパッドでタップしてください。';

  @override
  String get tourRuleRegularScoringTitle => 'いいですね！';

  @override
  String get tourRuleRegularScoringDesc => '正解を続けてポイントを獲得しましょう。';

  @override
  String get tourRuleRegularScoringResult => 'ポイント獲得！正解するたびにスコアが増えます。';

  @override
  String get tourRuleRegularTimerTitle => '時間に注意';

  @override
  String get tourRuleRegularTimerDesc =>
      'タイムバーを見てください — 入力が終わる前に時間切れになると、ライフを1つ失います。';

  @override
  String get tourRuleRegularTimerResult =>
      '時間切れです！時間を使い果たすと、間違えた時と同じようにライフを1つ失います。';

  @override
  String get tourRuleRegularResetTitle => 'リセットしますか？';

  @override
  String get tourRuleRegularResetDesc =>
      '**リセット**をタップすると難しい問題をスキップして新しい問題にできますが、必ずライフを1つ消費します。';

  @override
  String get tourRuleRegularLevelUpTitle => 'レベルアップ';

  @override
  String get tourRuleRegularLevelUpDesc => '正しい答えを続けるとレベルアップします。';

  @override
  String get tourRuleRegularLevelUpResult =>
      'レベルアップ！ここからは少し難しくなります。\nライフを失わずにレベルをクリアすると、**ボーナスライフ**を獲得できます。';

  @override
  String get tourRuleRegularGameOverTitle => 'ゲームオーバー';

  @override
  String get tourRuleRegularGameOverDesc =>
      'ライフが残り1つの時、もう一度間違えると本当にゲームオーバーです。何が起こるか見てみましょう。';

  @override
  String get tourRuleRegularWrapUpTitle => 'クラシックの遊び方';

  @override
  String get tourRuleRegularWrapUpDesc => '次は正しい方を選べモードを試してみましょう — 違う遊び方です。';

  @override
  String get tourRulePickRightWelcomeTitle => '正しい方を選べ';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'ここでは入力はしません — **正しい答え**をタップしてください。\n他の選択肢はダミーです。';

  @override
  String get tourRulePickRightOptionsTitle => 'よく考えて選ぼう';

  @override
  String get tourRulePickRightOptionsDesc => '1つが正解で、残りはダミーです。';

  @override
  String get tourRulePickRightCorrectTitle => '正解をタップ';

  @override
  String get tourRulePickRightCorrectDesc => '正しいと思うボタンをタップしてください。';

  @override
  String get tourRulePickRightCorrectResult => '正解です！ポイントを獲得しました。';

  @override
  String get tourRulePickRightWrongTitle => 'おっと！';

  @override
  String get tourRulePickRightWrongDesc => '今度は違うボタンをタップしてみてください。';

  @override
  String get tourRulePickRightWrongResult => '間違いです — 正解がハイライトされ、ライフを1つ失います。';

  @override
  String get tourRulePickRightTimerTitle => 'タイマーが速い';

  @override
  String get tourRulePickRightTimerDesc =>
      '正しい方を選べモードの時間はすぐに無くなります。遅すぎるとどうなるか見てみましょう。';

  @override
  String get tourRulePickRightTimerResult =>
      'また時間切れです — ライフが残っていないので、ゲームオーバーです。';

  @override
  String get tourRulePickRightWrapUpTitle => 'これが正しい方を選べ！';

  @override
  String get tourRulePickRightWrapUpDesc => '次は対戦モードを試してみましょう — 実際の相手と対戦します。';

  @override
  String get tourRuleCombatWelcomeTitle => '対戦モードへ';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'あなたと相手が交互にプレイします。\nこのバッジは**誰のターン**かを示します — ホストとして、あなたが先攻です。';

  @override
  String get tourRuleCombatTurnOrderTitle => '誰のターン？';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'このバッジが誰のターンかを示します。ホストとして、あなたが先攻です。';

  @override
  String get tourRuleCombatYourTurnTitle => 'あなたのターン';

  @override
  String get tourRuleCombatYourTurnDesc => '表示された数字をタップして、ターンを完了してください。';

  @override
  String get tourRuleCombatOpponentTurnTitle => '相手のターン';

  @override
  String get tourRuleCombatOpponentTurnDesc => 'さあ見てみましょう — 相手のターンになります。';

  @override
  String get tourRuleCombatOpponentTurnResult => '相手が正解しました！すぐにあなたのターンが回ってきます。';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'ライフを失った';

  @override
  String get tourRuleCombatOpponentLifeLostDesc => '相手がタップを外したら何が起こるか見てみましょう。';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      '相手がライフを失いました — 自分のように相手のライフカウントが下がるのが見えます。';

  @override
  String get tourRuleCombatTimerTitle => '全員にタイマーあり';

  @override
  String get tourRuleCombatTimerDesc =>
      'あなたのタイマーもここで同じように動きます — 時間切れでライフを失います。';

  @override
  String get tourRuleCombatTimerResult => '時間切れ！対戦でライフを失うのもソロモードと同じです。';

  @override
  String get tourRuleCombatWinTitle => '勝利！';

  @override
  String get tourRuleCombatWinDesc => '相手のライフがなくなるとどうなるか見てみましょう。';

  @override
  String get tourRuleCombatWinResult => 'あなたの勝ち！相手のライフをゼロにすると、あなたの勝利で試合が終わります。';

  @override
  String get tourRuleCombatWrapUpTitle => 'チュートリアル完了';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'これで全てです — ソロモード、正しい方を選べ、そして対戦。頑張ってください！';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';

  @override
  String get accountSectionTitle => 'アカウント';

  @override
  String get signInTitle => 'サインイン';

  @override
  String get signInSubtitle => 'スコアとランクを安全に保存 — サインインすると新しい端末でも引き継げます。';

  @override
  String get signInWithGoogle => 'Google で続行';

  @override
  String get signInWithApple => 'Apple で続行';

  @override
  String get signOut => 'サインアウト';

  @override
  String signedInAs(String account) {
    return '$account でサインイン中';
  }

  @override
  String get playingAsGuest => 'ゲストとしてプレイ中';

  @override
  String get signInAction => 'サインイン';

  @override
  String get linkSuccessMessage => 'サインインしました。スコアはアカウントに保存されます。';

  @override
  String get linkConflictTitle => 'このアカウントは使用中です';

  @override
  String get linkConflictMessage => 'このアカウントは既に存在します。切り替えると現在のゲストスコアは引き継がれません。';

  @override
  String get linkConflictSwitch => 'アカウントを切り替える';

  @override
  String get authError => 'サインインに失敗しました。もう一度お試しください。';

  @override
  String get authErrorCancelled => 'サインインをキャンセルしました。';

  @override
  String get authErrorNetwork => '接続がありません。ネットワークを確認してください。';

  @override
  String get authErrorCredentialRejected => 'サインインが拒否されました。もう一度お試しください。';

  @override
  String get authErrorProviderDisabled => 'このサインイン方法は現在利用できません。';

  @override
  String get authErrorAppleUnavailable => 'この端末では Apple でサインインできません。';

  @override
  String get authErrorTooManyRequests => '試行回数が多すぎます。しばらくしてからお試しください。';

  @override
  String get authErrorAlreadyLinked => 'このアカウントは既にリンクされています。';

  @override
  String get authErrorAccountDisabled => 'このアカウントは無効になっています。';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'そのメールアドレスは別のサインイン方法で使用されています。';

  @override
  String get authErrorLinkConflict => 'このアカウントは既に他のユーザーのものです。';

  @override
  String get opponentPausedTitle => '相手が一時停止中';

  @override
  String get opponentPausedBody => '相手がスマホを折りたたむか閉じました。戻るとラウンドが再開します。';

  @override
  String get opponentAwayTooLongBody => '相手が1分以上離れています。勝利を申請するか、待ち続けてください。';

  @override
  String get claimWin => '勝利を申請';

  @override
  String get opponentWasAway => '相手の離席が長すぎました';

  @override
  String get youWereAway => '離席が長すぎました';

  @override
  String get tourChapterRegular => 'クラシック';

  @override
  String get tourRuleRegularTypeBackResult => '正解 — **1ポイント**獲得です！';
}
