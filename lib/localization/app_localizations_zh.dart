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
  String get lastPlayedLabel => 'Last played';

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
  String get tourWelcomeDesc => '快速导览：先看**菜单**，再来一局简短的**练习游戏**。\n你可以随时跳过。';

  @override
  String get tourStartTitle => '开始';

  @override
  String get tourStartDesc => '点击**开始**，选择你想要的玩法。';

  @override
  String get tourInstantStartTitle => '即时开始';

  @override
  String get tourInstantStartDesc => '以上次的难度直接开始一局**单人**游戏。';

  @override
  String get tourSoloTitle => '两种玩法';

  @override
  String get tourSoloDesc =>
      '**单人模式**：独自挑战，刷新你的最高分。\n**对战模式**：通过**蓝牙**挑战身边的朋友——一人创建房间，另一人加入。';

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
  String get tourLeaderboardTitle => '更多精彩';

  @override
  String get tourLeaderboardDesc =>
      '**最高分**查看排行榜。\n**设置**可更改名字、主题、声音和语言。\n**关于**介绍游戏规则。\n接下来：一局简短的**练习游戏**！';

  @override
  String get tourSettingsTitle => '设置';

  @override
  String get tourSettingsDesc =>
      '这里可以自定义所有内容！更改您的**用户名**、选择**主题**、调节**声音**和**语言**。您随时能重启此导览。';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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
  String get tourRuleRegularWelcomeTitle => '经典模式';

  @override
  String get tourRuleRegularWelcomeDesc =>
      '记住数字，然后在时间耗尽前将其输入。\n你有 **3 条命** — 全部失去则游戏结束。';

  @override
  String get tourRuleRegularLivesTitle => '你的命';

  @override
  String get tourRuleRegularLivesDesc => '你从 **3 条命** 开始。失去所有命则游戏结束 — 小心游玩！';

  @override
  String get tourRuleRegularMemorizeTitle => '记住它';

  @override
  String get tourRuleRegularMemorizeDesc => '仔细看 — 数字会在屏幕上闪烁片刻然后隐藏。';

  @override
  String get tourRuleRegularTypeBackTitle => '把它输回去';

  @override
  String get tourRuleRegularTypeBackDesc => '现在在键盘上点击你刚刚看到的数字。';

  @override
  String get tourRuleRegularScoringTitle => '很好！';

  @override
  String get tourRuleRegularScoringDesc => '继续正确回答来赚取分数。';

  @override
  String get tourRuleRegularScoringResult => '你刚刚得了一分！每个正确答案都会增加你的分数。';

  @override
  String get tourRuleRegularTimerTitle => '与时间赛跑';

  @override
  String get tourRuleRegularTimerDesc => '注意时间条 — 如果在你完成输入前耗尽，你将失去一条命。';

  @override
  String get tourRuleRegularTimerResult => '时间到！时间耗尽会让你失去一条命，就像点错一样。';

  @override
  String get tourRuleRegularResetTitle => '需要换一个？';

  @override
  String get tourRuleRegularResetDesc =>
      '点击**重置**可以跳过棘手的挑战换一个新的 — 但这总是需要消耗一条命。';

  @override
  String get tourRuleRegularLevelUpTitle => '正在升级';

  @override
  String get tourRuleRegularLevelUpDesc => '正确回答足够多的回合，你就会升级。';

  @override
  String get tourRuleRegularLevelUpResult =>
      '升级！从这里开始数字会变得有点难。\n在不失命的情况下完成一个等级，可以获得一条**奖励命**。';

  @override
  String get tourRuleRegularGameOverTitle => '游戏结束';

  @override
  String get tourRuleRegularGameOverDesc => '当只剩 1 条命时，再失误一次游戏就真的结束了。看看会发生什么。';

  @override
  String get tourRuleRegularWrapUpTitle => '这就是经典模式！';

  @override
  String get tourRuleRegularWrapUpDesc => '现在让我们尝试选出正确答案模式 — 一种不同的玩法。';

  @override
  String get tourRulePickRightWelcomeTitle => '选出正确答案';

  @override
  String get tourRulePickRightWelcomeDesc =>
      '这里不需要你输入 — 点击**正确答案**。\n其他选项都是干扰项。';

  @override
  String get tourRulePickRightOptionsTitle => '谨慎选择';

  @override
  String get tourRulePickRightOptionsDesc => '其中一个是正确的 — 其他都是干扰项。';

  @override
  String get tourRulePickRightCorrectTitle => '点击正确的那个';

  @override
  String get tourRulePickRightCorrectDesc => '点击你认为正确的按钮。';

  @override
  String get tourRulePickRightCorrectResult => '正确！你获得了一分。';

  @override
  String get tourRulePickRightWrongTitle => '哎呀！';

  @override
  String get tourRulePickRightWrongDesc => '这一次，试着点击一个不同的按钮。';

  @override
  String get tourRulePickRightWrongResult => '选错了 — 正确答案会高亮显示，你失去一条命。';

  @override
  String get tourRulePickRightTimerTitle => '倒计时更快';

  @override
  String get tourRulePickRightTimerDesc => '选出正确答案模式的倒计时很快。看看如果你太慢会发生什么。';

  @override
  String get tourRulePickRightTimerResult => '时间又到了 — 没有命了，游戏结束。';

  @override
  String get tourRulePickRightWrapUpTitle => '这就是选出正确答案！';

  @override
  String get tourRulePickRightWrapUpDesc => '现在让我们尝试对战模式 — 在这里你要与真实的对手较量。';

  @override
  String get tourRuleCombatWelcomeTitle => '欢迎来到对战';

  @override
  String get tourRuleCombatWelcomeDesc =>
      '你和对手轮流进行。\n这个徽章显示了**轮到谁** — 作为房主，你先开始。';

  @override
  String get tourRuleCombatTurnOrderTitle => '轮到谁了？';

  @override
  String get tourRuleCombatTurnOrderDesc => '这个徽章显示轮到谁了。作为房主，你先开始。';

  @override
  String get tourRuleCombatYourTurnTitle => '你的回合';

  @override
  String get tourRuleCombatYourTurnDesc => '点击显示的数字来完成你的回合。';

  @override
  String get tourRuleCombatOpponentTurnTitle => '对手的回合';

  @override
  String get tourRuleCombatOpponentTurnDesc => '现在看好 — 轮到你的对手行动了。';

  @override
  String get tourRuleCombatOpponentTurnResult => '你的对手回答正确！回合立刻回到了你这里。';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => '失去一条命';

  @override
  String get tourRuleCombatOpponentLifeLostDesc => '看看当你的对手点错时会发生什么。';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      '你的对手失去了一条命 — 你会看到他们的命数减少，就像你的一样。';

  @override
  String get tourRuleCombatTimerTitle => '每人都有倒计时';

  @override
  String get tourRuleCombatTimerDesc => '你的倒计时在这里以同样的方式运作 — 错过了你也会失去一条命。';

  @override
  String get tourRuleCombatTimerResult => '时间到！在对战中失去一条命和单人模式一样。';

  @override
  String get tourRuleCombatWinTitle => '胜利！';

  @override
  String get tourRuleCombatWinDesc => '看看当你的对手失去所有命时会发生什么。';

  @override
  String get tourRuleCombatWinResult => '你赢了！让你的对手耗尽所有的命，你就能赢得比赛。';

  @override
  String get tourRuleCombatWrapUpTitle => '教程完成！';

  @override
  String get tourRuleCombatWrapUpDesc => '这就是全部内容 — 单人模式、选出正确答案和对战。祝你好运！';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';

  @override
  String get accountSectionTitle => '账户';

  @override
  String get signInTitle => '登录';

  @override
  String get signInSubtitle => '保护你的分数和排名——登录后可在新设备上继续。';

  @override
  String get signInWithGoogle => '使用 Google 继续';

  @override
  String get signInWithApple => '使用 Apple 继续';

  @override
  String get signOut => '退出登录';

  @override
  String signedInAs(String account) {
    return '已登录：$account';
  }

  @override
  String get playingAsGuest => '以访客身份游玩';

  @override
  String get signInAction => '登录';

  @override
  String get linkSuccessMessage => '已登录。你的分数现在保存在账户中。';

  @override
  String get linkConflictTitle => '该账户已被使用';

  @override
  String get linkConflictMessage => '该账户已存在。切换过去会放弃当前访客的分数。';

  @override
  String get linkConflictSwitch => '切换账户';

  @override
  String get authError => '登录失败，请重试。';

  @override
  String get authErrorCancelled => '已取消登录。';

  @override
  String get authErrorNetwork => '没有网络连接，请检查后重试。';

  @override
  String get authErrorCredentialRejected => '登录被拒绝，请重试。';

  @override
  String get authErrorProviderDisabled => '此登录方式当前不可用。';

  @override
  String get authErrorAppleUnavailable => '此设备不支持使用 Apple 登录。';

  @override
  String get authErrorTooManyRequests => '尝试次数过多，请稍后再试。';

  @override
  String get authErrorAlreadyLinked => '该账户已关联。';

  @override
  String get authErrorAccountDisabled => '该账户已被停用。';

  @override
  String get authErrorAccountExistsDifferentCredential => '该邮箱已用于其他登录方式。';

  @override
  String get authErrorLinkConflict => '该账户已属于其他用户。';

  @override
  String get opponentPausedTitle => '对手已暂停';

  @override
  String get opponentPausedBody => '对手折叠或合上了手机。对手回来后本局继续。';

  @override
  String get opponentAwayTooLongBody => '对手已离开超过一分钟。可以宣告胜利，或继续等待。';

  @override
  String get claimWin => '宣告胜利';

  @override
  String get opponentWasAway => '对手离开太久';

  @override
  String get youWereAway => '你离开太久';

  @override
  String get tourChapterRegular => '经典';

  @override
  String get tourRuleRegularTypeBackResult => '正确 — 你得了一**分**！';
}
