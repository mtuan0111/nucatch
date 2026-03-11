// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get instantStart => '即时开始';

  @override
  String get selectLevel => '选择等级';

  @override
  String get selectLevelMessage => '选择你想玩的等级。等级越高，难度越大。';

  @override
  String get yourScoreIs => '你当前的分数是';

  @override
  String get theCorrectIs => '正确答案是';

  @override
  String get whichOneIsCorrect => '哪个是正确的？';

  @override
  String get numberOfTopScores => '排行榜数量';

  @override
  String get onlyShowMyRecorded => '仅显示我的记录';

  @override
  String get introductionContent =>
      'NuCatch 是一款有趣且引人入胜的益智游戏，旨在提高你的记忆力和注意力。挑战自己在短时间内快速捕捉数字，帮助你记住 OTP、电话号码、生日等内容。享受体验并提升你的记忆力！';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return '与 $username 一起加入 #NuCatch！现在在 $profileUrl 探索它';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return '现在在 $profileUrl 探索 #NuCatch';
  }

  @override
  String get messageSharePlayedLeaderSubject => '#NuCatch 体验';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return '与 $username 在 #NuCatch 的体验';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username 在 $timeCreated 获得了 $point 分。快来和 $username 一起加入 #NuCatch 吧！！';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return '一位玩家在 $timeCreated 获得了 $point 分。现在加入 #NuCatch！！';
  }

  @override
  String get restartGame => '重新开始游戏';

  @override
  String get confirmRestart => '您确定要重新启动游戏吗？';

  @override
  String get insertedSuccess => '成功记录你的回合';

  @override
  String get insertedFailed => '记录你的回合失败';

  @override
  String get scanQrToViewDetails => '扫描二维码查看详情';

  @override
  String get difficultyEasyDescription => '生成一个随机数，难度略有增加，适合简单的挑战。';

  @override
  String get difficultyMediumDescription => '生成一个加减法计算表达式，难度适中。';

  @override
  String get difficultyHardDescription => '创建一个乘除法计算表达式，难度较高。';

  @override
  String get difficultyExtremeDescription =>
      '随机会生成复杂的加减法计算、更高等级的随机数或乘除法计算，带来最具挑战性的体验。';

  @override
  String get pickRightDescription => '选择正确的等式！ 极速反应的5秒限时游戏。';

  @override
  String get difficultyEasyTitle => '简单模式';

  @override
  String get difficultyMediumTitle => '中等模式';

  @override
  String get difficultyHardTitle => '困难模式';

  @override
  String get difficultyExtremeTitle => '极限模式';

  @override
  String get pickRightTitle => '选出正确答案';

  @override
  String get confirmChangeDifficulty => '你的回合将被重置。你确定要更改难度吗？';

  @override
  String get no_turn_yet => '暂无记录';

  @override
  String get daily => '一天内';

  @override
  String get dailyDescription => '基于今天记录的回合排名。';

  @override
  String get weekly => '一周内';

  @override
  String get weeklyDescription => '基于过去 7 天记录的回合排名。';

  @override
  String get allTime => '所有时间';

  @override
  String get allTimeDescription => '基于所有记录的回合排名。';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return '你有 $totalSeconds 秒的时间点击一个数字。进度条会随着时间流逝改变颜色：绿色（超过 $halfSeconds秒），橙色（$quarterSeconds-$halfSeconds秒），红色（少于 $quarterSeconds秒）。';
  }

  @override
  String get selectPlayMode => '选择游戏模式';

  @override
  String get soloMode => '单人模式';

  @override
  String get soloModeDescription => '独自游玩并挑战自己打破最高分';

  @override
  String get combatMode => '对战模式';

  @override
  String get combatModeDescription => '通过蓝牙连接与另一位玩家一起游玩并轮流操作';

  @override
  String get createRoom => '创建房间';

  @override
  String get createRoomDescription => '主持一个新游戏并等待另一位玩家加入';

  @override
  String get joinRoom => '加入房间';

  @override
  String get joinRoomDescription => '输入房间代码以加入现有游戏';

  @override
  String get hostRoom => '房主房间';

  @override
  String get roomCode => '房间代码';

  @override
  String get shareCodeWithPlayer => '与另一位玩家分享此代码';

  @override
  String get enterRoomCode => '输入房间代码';

  @override
  String get connect => '连接';

  @override
  String get searchingForPlayers => '正在搜索玩家...';

  @override
  String pairedWith(String playerName) {
    return '已与 $playerName 配对！';
  }

  @override
  String get bluetoothPermissionRequired => '需要蓝牙权限';

  @override
  String get bluetoothPermissionMessage => '对战模式需要蓝牙权限才能与其他玩家连接。请在设备设置中授予蓝牙权限。';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      '蓝牙权限已被永久拒绝。要使用对战模式，你需要在设备设置中启用蓝牙权限。\n\n请前往设置 > NuCatch > 权限并启用蓝牙。';

  @override
  String get bluetoothDisabled => '蓝牙已禁用';

  @override
  String get bluetoothDisabledMessage => '对战模式需要启用蓝牙。请在设备设置中启用蓝牙。';

  @override
  String get grantPermission => '授予权限';

  @override
  String get checkAgain => '再次检查';

  @override
  String get openSettings => '打开设置';

  @override
  String get yourTurn => '你的回合';

  @override
  String get opponentTurn => '对手的回合';

  @override
  String get waitingForOpponent => '等待对手...';

  @override
  String get watchingOpponent => '观看你的对手';

  @override
  String get youWin => '你赢了！';

  @override
  String get youLose => '你输了！';

  @override
  String get opponentDisconnected => '对手已断开连接';

  @override
  String get opponentRanOutOfLives => '对手耗尽了生命';

  @override
  String get opponentGaveUp => '你的对手放弃了';

  @override
  String get confirmEndCombat => '你确定要结束这场游戏吗？你的对手将获胜。';

  @override
  String get youRanOutOfLives => '你耗尽了生命';

  @override
  String get doYouReadyForRestart => '你准备好开始了吗？';

  @override
  String get notReady => '未准备好';

  @override
  String get you => '你';

  @override
  String get opponent => '对手';

  @override
  String get youWillTakeFirst => '你将先行！';

  @override
  String get opponentWillTakeFirst => '对手将先行';

  @override
  String get advertisingRoomWaiting => '房间广播中！等待对手...';

  @override
  String get opponentJoinedReady => '对手已加入！准备好后请按“准备”。';

  @override
  String get opponentReady => '对手已准备！';

  @override
  String get bothPlayersReady => '双方已准备！';

  @override
  String get searchingForHosts => '正在搜索房主...';

  @override
  String connectingToHost(String hostName) {
    return '正在连接到 $hostName...';
  }

  @override
  String get hostReady => '房主已准备！';

  @override
  String get theHostIsReady => '✅ 房主已准备！';

  @override
  String get pressReadyWhenPrepared => '准备好开始后请按“准备”。';

  @override
  String get yourOpponentIsReady => '✅ 你的对手已准备！';

  @override
  String get gameIsStarting => '游戏即将开始...';

  @override
  String get waitingForHostToSelectDifficulty => '等待房主选择难度...';

  @override
  String get failedToInitializeNearby => '无法初始化 Nearby Connections。请授予位置权限。';

  @override
  String get nearbyNotInitialized => 'Nearby Connections 未初始化';

  @override
  String failedToStartAdvertising(String error) {
    return '开始广播失败：$error';
  }

  @override
  String failedToSetReady(String error) {
    return '设置准备状态失败：$error';
  }

  @override
  String failedToStartGame(String error) {
    return '开始游戏失败：$error';
  }

  @override
  String get advertisingRoomStatus => '房间广播中...\n等待对手发现并连接。';

  @override
  String get opponentConnectedStatus => '对手已连接！\n双方准备好后请按“准备”。';

  @override
  String get bothPlayersReadyStatus => '双方已准备！开始游戏...';

  @override
  String get settingUpDifficulty => '正在设置游戏难度...';

  @override
  String get advertisingAs => '广播名称：';

  @override
  String get connectedViaNearby => '通过 Nearby 连接';

  @override
  String get advertising => '广播中...';

  @override
  String get selectHostToConnect => '选择房主连接';

  @override
  String availableHosts(int count) {
    return '可用房主 ($count)';
  }

  @override
  String get tapToConnect => '点击连接';

  @override
  String get noHostsFoundNearby => '附近未找到房主';

  @override
  String get makeSureFriendHosting => '确保朋友正在主持\n且两台设备距离较近';

  @override
  String get discovering => '正在发现...';

  @override
  String get notDiscovering => '未在发现';

  @override
  String get distanceWarning => '请确保设备距离在 10 米以内';

  @override
  String get tourButtonLabel => '开始教程';

  @override
  String get tourWelcomeTitle => '欢迎来到 NuCatch！';

  @override
  String get tourWelcomeDesc =>
      '欢迎！这个简短的导览将帮助您顺利上手 **NuCatch**。我们将向您展示所有**主要功能**，让您可以立即投入游戏。';

  @override
  String get tourStartTitle => '开始 - 启动游戏';

  @override
  String get tourStartDesc =>
      '点击**开始按钮**启动应用。然后选择**单人模式**进行单独算术挑战，或者选择**战斗模式**通过**蓝牙**进行实时对战。';

  @override
  String get tourInstantStartTitle => '快速开始';

  @override
  String get tourInstantStartDesc =>
      '点击**即时开始**按钮，即可立即以与上次游玩相同的难度开始单人游戏。这是您继续游戏进程的最快方式！';

  @override
  String get tourSoloTitle => '单人模式';

  @override
  String get tourSoloDesc =>
      '在**单人模式**中挑战自己。在 **4个体能等级** 中选择。您拥有**3条生命**-每次答错或超时扣1生命。**难度越高**积分越多！';

  @override
  String get tourCombatTitle => '战斗模式 - 蓝牙对战';

  @override
  String get tourCombatDesc =>
      '**战斗模式**允许您通过**蓝牙**与朋友对决！**两名玩家**轮流解算术题 - **无需WiFi**，只需保持在**10米**范围内。';

  @override
  String get tourCreateRoomTitle => '战斗模式 → 创建房间';

  @override
  String get tourCreateRoomDesc =>
      '**创建房间**让您成为**主机**。授予**蓝牙权限**后，您将等待客人加入，然后选择**难度级别**。作为主机，您先玩。';

  @override
  String get tourJoinRoomTitle => '战斗模式 → 加入房间';

  @override
  String get tourJoinRoomDesc =>
      '**加入房间**让您成为**客人**。您将扫描附近房间，选择一个并点击**准备**。主机选择难度，您后手游戏。';

  @override
  String get tourLeaderboardTitle => '排行榜';

  @override
  String get tourLeaderboardDesc =>
      '在这里追踪您的进度！查看**全球排行榜**，您的**个人记录**和**统计数据**。与朋友比较分数！';

  @override
  String get tourSettingsTitle => '设置';

  @override
  String get tourSettingsDesc =>
      '这里可以自定义所有内容！更改您的**用户名**、选择**主题**、调节**声音**和**语言**。您随时能重启此导览。';

  @override
  String get tourNext => '下一步';

  @override
  String get tourPrevious => '上一步';

  @override
  String get tourSkip => '跳过导览';

  @override
  String get tourFinish => '完成';

  @override
  String get tourRestartFromSettings => '重置导览';

  @override
  String get tourResetMessage => '导览已重置。返回主菜单查看。';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';
}
