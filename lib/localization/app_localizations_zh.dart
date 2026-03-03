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
  String get welcome => '欢迎!';

  @override
  String welcomeUser(String username) {
    return '欢迎 $username!';
  }

  @override
  String get mainMenu => '主菜单';

  @override
  String get start => '开始';

  @override
  String get instantStart => '即时开始';

  @override
  String get topScore => '最高分';

  @override
  String get setting => '设置';

  @override
  String get about => '关于';

  @override
  String get exit => '退出';

  @override
  String get version => '版本';

  @override
  String get anonymous => '匿名';

  @override
  String get level => '等级';

  @override
  String get score => '分数';

  @override
  String get ready => '准备';

  @override
  String get go => '开始!';

  @override
  String get gameOver => '游戏结束';

  @override
  String get difficultySetting => '难度设置';

  @override
  String get difficulty => '难度';

  @override
  String get easy => '简单';

  @override
  String get medium => '中等';

  @override
  String get hard => '困难';

  @override
  String get veryHard => '非常困难';

  @override
  String get extreme => '极限';

  @override
  String get selectDifficulty => '选择难度';

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
  String get name => '名字';

  @override
  String get fontSize => '字体大小';

  @override
  String get volume => '音量';

  @override
  String get vibrate => '震动';

  @override
  String get numberOfTopScores => '排行榜数量';

  @override
  String get onlyShowMyRecorded => '仅显示我的记录';

  @override
  String get global => '全球';

  @override
  String get personal => '个人';

  @override
  String get rank => '排名';

  @override
  String get share => '分享';

  @override
  String get language => '语言';

  @override
  String get thankYou => '感谢游玩';

  @override
  String get thankYouMessage => '感谢游玩我们的游戏。希望你喜欢。如果你有任何反馈或建议，请告诉我们。';

  @override
  String get authorName => '作者';

  @override
  String get connectWithUs => '联系我们';

  @override
  String get connectWithUsMessage => '如果你有任何问题或反馈，请随时通过我们的社交媒体渠道联系我们。';

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
  String get confirmExit => '你确定要退出吗？';

  @override
  String get restart => '重新开始';

  @override
  String get restartGame => '重新开始游戏';

  @override
  String get confirmRestart => '您确定要重新开始游戏吗？';

  @override
  String get no => '不';

  @override
  String get yes => '是';

  @override
  String get insertedSuccess => '成功记录你的回合';

  @override
  String get insertedFailed => '记录你的回合失败';

  @override
  String get scanQrToViewDetails => '扫描二维码查看详情';

  @override
  String get doYouWantToExit => '你想退出吗？';

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
  String get pickRightDescription => '选择正确的等式！快速选择游戏，5秒计时器。';

  @override
  String get difficultyEasyTitle => '简单模式';

  @override
  String get difficultyMediumTitle => '中等模式';

  @override
  String get difficultyHardTitle => '困难模式';

  @override
  String get difficultyExtremeTitle => '极限模式';

  @override
  String get pickRightTitle => 'Pick Right';

  @override
  String get confirmChangeDifficulty => '你的回合将被重置。你确定要更改难度吗？';

  @override
  String get areYouSure => '你确定吗？';

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
  String get updateRequired => '需要更新';

  @override
  String get updateAvailable => '可用更新';

  @override
  String get currentVersion => '当前版本';

  @override
  String get newVersion => '新版本';

  @override
  String get whatsNew => '新内容';

  @override
  String get forceUpdateMessage => '此更新是必需的，才能继续使用该应用程序。请立即更新。';

  @override
  String get later => '稍后';

  @override
  String get updateNow => '立即更新';

  @override
  String get update => '更新';

  @override
  String get checkForUpdates => '检查更新';

  @override
  String get appUpdates => '应用更新';

  @override
  String get tapToCheckUpdates => '点击下面的按钮检查应用更新。';

  @override
  String get checkingForUpdates => '正在检查更新...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return '新版本 $version 可用！ $forceMessage';
  }

  @override
  String get thisUpdateRequired => '此更新是必需的。';

  @override
  String get usingLatestVersion => '你正在使用最新版本！';

  @override
  String unableToCheckUpdates(String error) {
    return '无法检查更新。 $error';
  }

  @override
  String get tryAgainLater => '请稍后再试。';

  @override
  String get updatePostponed => '更新可用但已推迟。';

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
  String get cancel => '取消';

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
  String holidayNotification(String holidayName, String greeting) {
    return '今天是 $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => '新年';

  @override
  String get greetingNewYear => '新年快乐！';

  @override
  String get holidayLunarNewYear => '农历新年';

  @override
  String get greetingLunarNewYear => '新年快乐！ (Xīn Nián Kuài Lè!)';

  @override
  String get holidayValentine => '情人节';

  @override
  String get greetingValentine => '情人节快乐！';

  @override
  String get holidayHoli => '胡里节';

  @override
  String get greetingHoli => '胡里节快乐！';

  @override
  String get holidayEarthDay => '地球日';

  @override
  String get greetingEarthDay => '地球日快乐！保护我们的星球！';

  @override
  String get holidayEaster => '复活节';

  @override
  String get greetingEaster => '复活节快乐！';

  @override
  String get holidayPride => '骄傲月';

  @override
  String get greetingPride => '骄傲月快乐！爱就是爱！';

  @override
  String get holidayHalloween => '万圣节';

  @override
  String get greetingHalloween => '万圣节快乐！';

  @override
  String get holidayDiwali => '排灯节';

  @override
  String get greetingDiwali => '排灯节快乐！';

  @override
  String get holidayHanukkah => '光明节';

  @override
  String get greetingHanukkah => '光明节快乐！ (Chag Hanukkah Sameach!)';

  @override
  String get holidayChristmas => '圣诞节';

  @override
  String get greetingChristmas => '圣诞快乐！';

  @override
  String get holidayKwanzaa => '宽扎节';

  @override
  String get greetingKwanzaa => 'Habari Gani!';

  @override
  String get playAgain => '再玩一次';

  @override
  String get returnToMenu => '返回菜单';

  @override
  String get doYouReadyForRestart => '你准备好开始了吗？';

  @override
  String get notReady => '未准备好';

  @override
  String get you => '你';

  @override
  String get opponent => '对手';

  @override
  String get waiting => '等待中';

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
  String get ok => '确定';

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
  String get tourButtonLabel => '开始导览';

  @override
  String get tourWelcomeTitle => '欢迎来到 NuCatch!';

  @override
  String get tourWelcomeDesc =>
      '欢迎! 这个快速导览将帮助您顺利开始使用**NuCatch**。我们将向您展示所有**主要功能**，让您立即开始游戏。让我们开始吧!';

  @override
  String get tourStartTitle => '开始 - 开始您的游戏';

  @override
  String get tourStartDesc =>
      '点击开始按钮开始。然后您将在单人数学挑战的单人模式，或通过蓝牙进行实时多人对战的战斗模式之间进行选择。让我们探索这两个选项!';

  @override
  String get tourInstantStartTitle => '快速开始 - 快速游戏';

  @override
  String get tourInstantStartDesc =>
      '想立即开始吗？点击**快速开始按钮**，立即以上次玩的难度级别开始单人游戏。这是继续进度的最快方式！';

  @override
  String get tourSoloTitle => '单人模式 - 单独游戏';

  @override
  String get tourSoloDesc =>
      '在单人模式中，用数学方程式挑战自己! 从4个难度级别中选择（简单到极难）。您从3条生命开始 - 每个错误答案或超时花费1条生命。更高的难度意味着更多的分数! 现在让我们看看多人游戏选项。';

  @override
  String get tourCombatTitle => '战斗模式 - 蓝牙多人游戏';

  @override
  String get tourCombatDesc =>
      '战斗模式让您通过蓝牙与朋友对战! 两名玩家轮流解决方程式 - 不需要WiFi，只需保持在10米范围内。主机最初先玩，但在复赛中失败者先玩。您有两种方式开始比赛:';

  @override
  String get tourCreateRoomTitle => '战斗模式 → 创建房间';

  @override
  String get tourCreateRoomDesc =>
      '第一个选项: 创建房间使您成为主机! 授予蓝牙权限后，您将等待客人加入您的房间，然后选择难度级别。作为主机，您在初始比赛中先玩。或者您可以加入其他人的游戏:';

  @override
  String get tourJoinRoomTitle => '战斗模式 → 加入房间';

  @override
  String get tourJoinRoomDesc =>
      '第二个选项: 加入房间使您成为客人! 授予权限后，您将扫描附近的房间，选择一个并点击准备。主机选择难度，您将在初始比赛中第二个玩。现在让我们检查其他菜单功能。';

  @override
  String get tourLeaderboardTitle => '最高分 - 排行榜';

  @override
  String get tourLeaderboardDesc =>
      '在这里跟踪您的进度! 查看全球排名、您的个人记录和统计数据，包括玩过的游戏、胜率、准确性和按难度级别的分数。与朋友比较，看看您如何随时间改进。最后，让我们访问设置。';

  @override
  String get tourSettingsTitle => '设置 - 自定义';

  @override
  String get tourSettingsDesc =>
      '在这里自定义一切! 更改您的用户名，选择主题，调整声音/音乐，选择您的语言并管理隐私设置。您可以随时从这里重新启动此导览。就是这样 - 您准备好玩了!';

  @override
  String get tourNext => '下一步';

  @override
  String get tourPrevious => '上一步';

  @override
  String get tourSkip => '跳过导览';

  @override
  String get tourFinish => '完成';

  @override
  String get tourRestartFromSettings => '重新开始导览';

  @override
  String get tourResetMessage => '导览已重置。返回主菜单开始。';
}
