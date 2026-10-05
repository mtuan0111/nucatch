// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'mẫu_flutter_mới';

  @override
  String get instantStart => 'Bắt đầu nhanh';

  @override
  String get lastPlayedLabel => 'Chơi gần nhất';

  @override
  String get selectLevel => 'Chọn cấp độ';

  @override
  String get selectLevelMessage =>
      'Chọn cấp độ bạn muốn chơi. Cấp độ càng cao, độ khó càng tăng.';

  @override
  String get yourScoreIs => 'Điểm của bạn hiện là';

  @override
  String get theCorrectIs => 'Đáp án đúng là';

  @override
  String get whichOneIsCorrect => 'Đáp án nào đúng?';

  @override
  String get numberOfTopScores => 'Số điểm cao nhất';

  @override
  String get onlyShowMyRecorded => 'Chỉ hiển thị bản ghi của tôi';

  @override
  String get introductionContent =>
      'NuCatch là một trò chơi đơn giản và thú vị, được thiết kế để giúp bạn rèn luyện trí nhớ và cải thiện sự tập trung. Hãy thử thách bản thân và tận hưởng trò chơi!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'Tham gia #NuCatch với $username! Khám phá ngay tại $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Khám phá #NuCatch ngay tại $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Trải nghiệm cùng #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Trải nghiệm cùng $username tại #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username đã đạt được $point điểm vào lúc $timeCreated. Hãy tham gia #NuCatch cùng $username!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'Một người chơi đã đạt được $point điểm vào lúc $timeCreated. Hãy tham gia #NuCatch ngay!!';
  }

  @override
  String get restartGame => 'Chơi Lại';

  @override
  String get confirmRestart => 'Bạn có muốn khởi động lại trò chơi?';

  @override
  String get insertedSuccess => 'Ghi lượt chơi của bạn thành công';

  @override
  String get insertedFailed => 'Ghi lượt chơi của bạn thất bại';

  @override
  String get scanQrToViewDetails => 'Quét mã QR để xem chi tiết';

  @override
  String get difficultyEasyDescription =>
      'Bạn sẽ gặp các câu hỏi đơn giản, chủ yếu là số nhỏ, rất phù hợp để làm quen và bắt đầu chơi.';

  @override
  String get difficultyMediumDescription =>
      'Các phép cộng và trừ với số lớn hơn, giúp bạn nâng cao kỹ năng một cách nhẹ nhàng.';

  @override
  String get difficultyHardDescription =>
      'Xuất hiện phép nhân và chia, yêu cầu bạn phải tập trung và phản xạ nhanh hơn.';

  @override
  String get difficultyExtremeDescription =>
      'Câu hỏi đa dạng, số lớn, phép tính phức tạp, mang đến thử thách thực sự cho bạn.';

  @override
  String get pickRightDescription =>
      'Chọn câu trả lời đúng! Mini-game lựa chọn nhanh 5 giây.';

  @override
  String get difficultyEasyTitle => 'Dễ';

  @override
  String get difficultyMediumTitle => 'Trung bình';

  @override
  String get difficultyHardTitle => 'Khó';

  @override
  String get difficultyExtremeTitle => 'Cực kỳ khó';

  @override
  String get pickRightTitle => 'Chọn Đúng';

  @override
  String get confirmChangeDifficulty =>
      'Lượt chơi sẽ bị reset. Bạn có chắc chắn muốn thay đổi không?';

  @override
  String get no_turn_yet => 'Chưa có lượt chơi nào';

  @override
  String get daily => 'Trong ngày';

  @override
  String get dailyDescription =>
      'Xếp hạng dựa trên các lượt chơi được ghi trong ngày hôm nay.';

  @override
  String get weekly => 'Trong tuần';

  @override
  String get weeklyDescription =>
      'Xếp hạng dựa trên các lượt chơi được ghi trong 7 ngày qua.';

  @override
  String get allTime => 'Tất cả';

  @override
  String get allTimeDescription =>
      'Xếp hạng dựa trên các lượt chơi được ghi trong tất cả thời gian.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'Bạn có $totalSeconds giây để chạm vào một số. Thanh đổi màu khi thời gian trôi qua: xanh lá (hơn $halfSeconds giây), cam ($quarterSeconds-$halfSeconds giây), đỏ (dưới $quarterSeconds giây).';
  }

  @override
  String get selectPlayMode => 'Chọn chế độ chơi';

  @override
  String get soloMode => 'Chơi đơn';

  @override
  String get soloModeDescription =>
      'Chơi một mình và thử thách bản thân để đạt điểm cao nhất';

  @override
  String get combatMode => 'Chế độ đối kháng';

  @override
  String get combatModeDescription =>
      'Chơi với người chơi khác qua kết nối Bluetooth và luân phiên';

  @override
  String get createRoom => 'Tạo phòng';

  @override
  String get createRoomDescription =>
      'Tạo phòng mới và chờ người chơi khác tham gia';

  @override
  String get joinRoom => 'Tham gia phòng';

  @override
  String get joinRoomDescription => 'Nhập mã phòng để tham gia trận đấu';

  @override
  String get hostRoom => 'Phòng Chủ';

  @override
  String get roomCode => 'Mã phòng';

  @override
  String get shareCodeWithPlayer => 'Chia sẻ mã này với người chơi khác';

  @override
  String get enterRoomCode => 'Nhập mã phòng';

  @override
  String get connect => 'Kết nối';

  @override
  String get searchingForPlayers => 'Đang tìm người chơi...';

  @override
  String pairedWith(String playerName) {
    return 'Đã ghép đôi với $playerName!';
  }

  @override
  String get bluetoothPermissionRequired => 'Yêu cầu quyền Bluetooth';

  @override
  String get bluetoothPermissionMessage =>
      'Chế độ đối kháng cần quyền Bluetooth để kết nối với người chơi khác. Vui lòng cấp quyền Bluetooth trong cài đặt thiết bị.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Quyền Bluetooth đã bị từ chối trước đó. Để sử dụng Chế độ đối kháng, bạn cần bật quyền Bluetooth trong cài đặt thiết bị.\n\nVui lòng vào Cài đặt > NuCatch > Quyền và bật Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth đã tắt';

  @override
  String get bluetoothDisabledMessage =>
      'Chế độ đối kháng yêu cầu Bluetooth phải được bật. Vui lòng bật Bluetooth trong cài đặt thiết bị.';

  @override
  String get grantPermission => 'Cấp quyền';

  @override
  String get checkAgain => 'Kiểm tra lại';

  @override
  String get openSettings => 'Mở cài đặt';

  @override
  String get yourTurn => 'Lượt của bạn';

  @override
  String get opponentTurn => 'Lượt đối thủ';

  @override
  String get waitingForOpponent => 'Đang chờ đối thủ...';

  @override
  String get watchingOpponent => 'Theo dõi đối thủ';

  @override
  String get youWin => 'Bạn thắng!';

  @override
  String get youLose => 'Bạn thua!';

  @override
  String get opponentDisconnected => 'Đối thủ đã ngắt kết nối';

  @override
  String get opponentRanOutOfLives => 'Đối thủ đã hết mạng';

  @override
  String get opponentGaveUp => 'Đối thủ của bạn đã bỏ cuộc';

  @override
  String get confirmEndCombat =>
      'Bạn có chắc chắn muốn kết thúc trò chơi này? Đối thủ của bạn sẽ thắng.';

  @override
  String get youRanOutOfLives => 'Bạn đã hết mạng';

  @override
  String get doYouReadyForRestart => 'Bạn sẵn sàng chơi lại chưa?';

  @override
  String get notReady => 'Chưa sẵn sàng';

  @override
  String get you => 'Bạn';

  @override
  String get opponent => 'Đối thủ';

  @override
  String get youWillTakeFirst => 'Bạn sẽ đi lượt đầu tiên!';

  @override
  String get opponentWillTakeFirst => 'Đối thủ sẽ đi lượt đầu tiên';

  @override
  String get advertisingRoomWaiting => 'Đang tạo kết nối phòng! Chờ đối thủ...';

  @override
  String get opponentJoinedReady =>
      'Đối thủ đã tham gia! Nhấn Sẵn sàng khi bạn đã chuẩn bị.';

  @override
  String get opponentReady => 'Đối thủ sẵn sàng!';

  @override
  String get bothPlayersReady => 'Cả hai người chơi đã sẵn sàng!';

  @override
  String get searchingForHosts => 'Đang tìm kiếm chủ phòng...';

  @override
  String connectingToHost(String hostName) {
    return 'Đang kết nối với $hostName...';
  }

  @override
  String get hostReady => 'Chủ phòng sẵn sàng!';

  @override
  String get theHostIsReady => 'Chủ phòng đã sẵn sàng!';

  @override
  String get pressReadyWhenPrepared =>
      'Nhấn Sẵn sàng khi bạn đã chuẩn bị xong.';

  @override
  String get yourOpponentIsReady => 'Đối thủ của bạn đã sẵn sàng!';

  @override
  String get gameIsStarting => 'Trò chơi đang bắt đầu...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'Đang chờ chủ phòng chọn độ khó...';

  @override
  String get failedToInitializeNearby =>
      'Không thể khởi tạo Kết nối Gần. Vui lòng cấp quyền truy cập vị trí.';

  @override
  String get nearbyNotInitialized => 'Kết nối Gần chưa được khởi tạo';

  @override
  String failedToStartAdvertising(String error) {
    return 'Không thể bắt đầu tạo kết nối: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Không thể đặt trạng thái sẵn sàng: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Không thể bắt đầu trò chơi: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Đang tạo kết nối phòng...\nChờ đối thủ tìm và kết nối.';

  @override
  String get opponentConnectedStatus =>
      'Đối thủ đã kết nối!\nNhấn Sẵn sàng khi cả hai người chơi đã chuẩn bị.';

  @override
  String get bothPlayersReadyStatus =>
      'Cả hai người chơi đã sẵn sàng! Đang bắt đầu trò chơi...';

  @override
  String get settingUpDifficulty => 'Đang thiết lập độ khó...';

  @override
  String get advertisingAs => 'Đang tạo kết nối dưới tên:';

  @override
  String get connectedViaNearby => 'Đã kết nối qua Nearby';

  @override
  String get advertising => 'Đang tạo kết nối...';

  @override
  String get selectHostToConnect => 'Chọn chủ phòng để kết nối';

  @override
  String availableHosts(int count) {
    return 'Chủ phòng khả dụng ($count)';
  }

  @override
  String get tapToConnect => 'Nhấn để kết nối';

  @override
  String get noHostsFoundNearby => 'Không tìm thấy chủ phòng gần đây';

  @override
  String get makeSureFriendHosting =>
      'Đảm bảo bạn bè đang tạo phòng\nvà cả hai thiết bị gần nhau';

  @override
  String get discovering => 'Đang tìm kiếm...';

  @override
  String get notDiscovering => 'Không tìm kiếm';

  @override
  String get distanceWarning =>
      'Đảm bảo các thiết bị cách nhau trong vòng 10 mét';

  @override
  String get tourButtonLabel => 'Bắt đầu Hướng dẫn';

  @override
  String get tourWelcomeTitle => 'Chào mừng đến với NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Một chuyến tham quan nhanh: trước hết là **menu**, sau đó là một **ván chơi thử** ngắn. Bạn có thể bỏ qua bất cứ lúc nào.';

  @override
  String get tourStartTitle => 'Bắt đầu';

  @override
  String get tourStartDesc => 'Nhấn **Bắt đầu** để chọn cách chơi.';

  @override
  String get tourInstantStartTitle => 'Bắt đầu nhanh';

  @override
  String get tourInstantStartDesc =>
      'Vào ngay một ván **Chơi đơn** với độ khó bạn chơi lần trước.';

  @override
  String get tourSoloTitle => 'Hai cách chơi';

  @override
  String get tourSoloDesc =>
      '**Chơi đơn**: chơi một mình và phá kỷ lục của bạn. **Chế độ đối kháng**: thách đấu bạn bè ở gần qua **Bluetooth** — một người tạo phòng, người kia tham gia.';

  @override
  String get tourCombatTitle => 'Chế độ Đối Kháng - Qua Bluetooth';

  @override
  String get tourCombatDesc =>
      '**Chế độ Đối Kháng** cho phép bạn kết nối với bạn bè thông qua **Bluetooth**! Hai người sẽ lần lượt giải các phương trình - **không cần thiết có Mạng**, chỉ cần thiết bị trong phạm vi 10 mét.';

  @override
  String get tourCreateRoomTitle => 'Chế độ Đối Kháng → Tạo Phòng';

  @override
  String get tourCreateRoomDesc =>
      '**Tạo Phòng** biến bạn thành **Chủ Phòng**. Sau khi chia sẻ Bluetooth, hãy chờ khách kết nối với bạn và chọn **mức độ khó**. Bạn chơi trước.';

  @override
  String get tourJoinRoomTitle => 'Chế độ Đối Kháng → Vào Phòng';

  @override
  String get tourJoinRoomDesc =>
      '**Vào Phòng** khiến bạn là **Khách**. Hãy quét xung quanh phòng hiển thị, chọn và ấn **Sẵn Sàng**. Bạn chơi sau người tạo phòng.';

  @override
  String get tourLeaderboardTitle => 'Còn nhiều điều để khám phá';

  @override
  String get tourLeaderboardDesc =>
      '**Điểm cao nhất** hiển thị bảng xếp hạng, **Cài đặt** để đổi tên, giao diện, âm thanh và ngôn ngữ, còn **Giới thiệu** giải thích luật chơi. Tiếp theo: một **ván chơi thử** ngắn!';

  @override
  String get tourSettingsTitle => 'Cài Đặt';

  @override
  String get tourSettingsDesc =>
      'Mọi thay đổi hiển thị ở đây! Từ **tên**, **giao diện**, **âm thanh**, **ngôn ngữ**.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

  @override
  String get tourNext => 'Tiếp theo';

  @override
  String get tourPrevious => 'Trở lại';

  @override
  String get tourSkip => 'Bỏ qua';

  @override
  String get tourFinish => 'Hoàn thành';

  @override
  String get tourRestartFromSettings => 'Khởi động lại hướng dẫn';

  @override
  String get tourResetMessage =>
      'Đã tạo lại hướng dẫn. Xin quay về Màn hình Chính để xem.';

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
  String get menuGreeting =>
      'Thử thách trí nhớ và kỹ năng tính toán của bạn ngay lúc này!';

  @override
  String get accountSectionTitle => 'Tài khoản';

  @override
  String get signInTitle => 'Đăng nhập';

  @override
  String get signInSubtitle =>
      'Giữ an toàn điểm số và thứ hạng — đăng nhập để mang chúng sang thiết bị mới.';

  @override
  String get signInWithGoogle => 'Tiếp tục với Google';

  @override
  String get signInWithApple => 'Tiếp tục với Apple';

  @override
  String get signOut => 'Đăng xuất';

  @override
  String signedInAs(String account) {
    return 'Đã đăng nhập bằng $account';
  }

  @override
  String get playingAsGuest => 'Đang chơi với tư cách khách';

  @override
  String get signInAction => 'Đăng nhập';

  @override
  String get linkSuccessMessage =>
      'Đã đăng nhập. Điểm số của bạn giờ được lưu vào tài khoản.';

  @override
  String get linkConflictTitle => 'Tài khoản đã được sử dụng';

  @override
  String get linkConflictMessage =>
      'Tài khoản này đã tồn tại. Chuyển sang tài khoản đó sẽ bỏ lại điểm số khách hiện tại.';

  @override
  String get linkConflictSwitch => 'Chuyển tài khoản';

  @override
  String get authError => 'Đăng nhập thất bại. Vui lòng thử lại.';

  @override
  String get authErrorCancelled => 'Đã hủy đăng nhập.';

  @override
  String get authErrorNetwork =>
      'Không có kết nối. Hãy kiểm tra mạng và thử lại.';

  @override
  String get authErrorCredentialRejected =>
      'Đăng nhập bị từ chối. Vui lòng thử lại.';

  @override
  String get authErrorProviderDisabled =>
      'Phương thức đăng nhập này hiện không khả dụng.';

  @override
  String get authErrorAppleUnavailable =>
      'Đăng nhập bằng Apple không khả dụng trên thiết bị này.';

  @override
  String get authErrorTooManyRequests =>
      'Quá nhiều lần thử. Vui lòng đợi một lát rồi thử lại.';

  @override
  String get authErrorAlreadyLinked => 'Tài khoản này đã được liên kết.';

  @override
  String get authErrorAccountDisabled => 'Tài khoản này đã bị vô hiệu hóa.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'Email đó đã được dùng với phương thức đăng nhập khác.';

  @override
  String get authErrorLinkConflict => 'Tài khoản này đã thuộc về người khác.';

  @override
  String get opponentPausedTitle => 'Đối thủ tạm dừng';

  @override
  String get opponentPausedBody =>
      'Đối thủ đã gập hoặc đóng điện thoại. Ván đấu tiếp tục khi họ quay lại.';

  @override
  String get opponentAwayTooLongBody =>
      'Đối thủ đã rời đi hơn một phút. Nhận chiến thắng hoặc tiếp tục chờ.';

  @override
  String get claimWin => 'Nhận chiến thắng';

  @override
  String get opponentWasAway => 'Đối thủ rời đi quá lâu';

  @override
  String get youWereAway => 'Bạn đã rời đi quá lâu';

  @override
  String get tourChapterRegular => 'Cổ điển';

  @override
  String get tourRuleRegularTypeBackResult => 'Correct — that\'s a **point**!';
}
