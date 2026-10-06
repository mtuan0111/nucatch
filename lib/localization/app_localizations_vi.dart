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
      'Một chuyến tham quan nhanh: trước hết là **menu**, sau đó là một **ván chơi thử** ngắn.\nBạn có thể bỏ qua bất cứ lúc nào.';

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
      '**Chơi đơn**: chơi một mình và phá kỷ lục của bạn.\n**Chế độ đối kháng**: thách đấu bạn bè ở gần qua **Bluetooth** — một người tạo phòng, người kia tham gia.';

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
      '**Điểm cao nhất** hiển thị bảng xếp hạng.\n**Cài đặt** để đổi tên, giao diện, âm thanh và ngôn ngữ.\n**Giới thiệu** giải thích luật chơi.\nTiếp theo: một **ván chơi thử** ngắn!';

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
  String get tourRuleRegularWelcomeTitle => 'Chế độ Cổ điển';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Ghi nhớ số, sau đó nhập lại trước khi hết giờ.\nBạn có **3 mạng** — mất hết là trò chơi kết thúc.';

  @override
  String get tourRuleRegularLivesTitle => 'Mạng của bạn';

  @override
  String get tourRuleRegularLivesDesc =>
      'Bạn bắt đầu với **3 mạng**. Mất hết thì trò chơi kết thúc — hãy chơi cẩn thận!';

  @override
  String get tourRuleRegularMemorizeTitle => 'Hãy ghi nhớ';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Nhìn kỹ nhé — con số nhấp nháy trên màn hình một lúc rồi ẩn đi.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Nhập lại số';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Bây giờ hãy chạm vào chữ số bạn vừa thấy trên bàn phím.';

  @override
  String get tourRuleRegularScoringTitle => 'Tuyệt!';

  @override
  String get tourRuleRegularScoringDesc =>
      'Tiếp tục trả lời đúng để kiếm điểm.';

  @override
  String get tourRuleRegularScoringResult =>
      'Bạn vừa được một điểm! Mỗi câu trả lời đúng cộng vào điểm số của bạn.';

  @override
  String get tourRuleRegularTimerTitle => 'Nhanh tay lên';

  @override
  String get tourRuleRegularTimerDesc =>
      'Chú ý thanh thời gian — nếu hết giờ trước khi bạn nhập xong, bạn sẽ mất một mạng.';

  @override
  String get tourRuleRegularTimerResult =>
      'Hết giờ! Hết thời gian sẽ làm bạn mất mạng, giống như khi nhập sai.';

  @override
  String get tourRuleRegularResetTitle => 'Muốn thử lại?';

  @override
  String get tourRuleRegularResetDesc =>
      'Chạm **Làm mới** để bỏ qua thử thách khó và nhận số mới — nhưng luôn tốn một mạng.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Tăng cấp độ';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Trả lời đúng đủ số lượt và bạn sẽ thăng cấp.';

  @override
  String get tourRuleRegularLevelUpResult =>
      'Tăng cấp! Các con số sẽ khó hơn một chút từ đây.\nHoàn thành cấp độ mà không mất mạng nào để nhận **mạng thưởng**.';

  @override
  String get tourRuleRegularGameOverTitle => 'Kết thúc trò chơi';

  @override
  String get tourRuleRegularGameOverDesc =>
      'Khi chỉ còn 1 mạng, sai một lần nữa trò chơi sẽ thực sự kết thúc. Hãy xem chuyện gì xảy ra.';

  @override
  String get tourRuleRegularWrapUpTitle => 'Đó là Cổ điển!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Bây giờ hãy thử chế độ Chọn Đúng — một cách chơi khác.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Chế độ Chọn Đúng';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Ở đây bạn không cần nhập — hãy chạm vào **đáp án đúng**.\nCác lựa chọn khác là mồi nhử.';

  @override
  String get tourRulePickRightOptionsTitle => 'Chọn thận trọng';

  @override
  String get tourRulePickRightOptionsDesc =>
      'Một trong số này là đúng — những cái còn lại là mồi nhử.';

  @override
  String get tourRulePickRightCorrectTitle => 'Chạm đáp án đúng';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Chạm vào nút mà bạn nghĩ là đúng.';

  @override
  String get tourRulePickRightCorrectResult =>
      'Chính xác! Bạn đã ghi được một điểm.';

  @override
  String get tourRulePickRightWrongTitle => 'Ôi không!';

  @override
  String get tourRulePickRightWrongDesc =>
      'Lần này, hãy thử chạm vào một nút khác.';

  @override
  String get tourRulePickRightWrongResult =>
      'Chọn sai — đáp án đúng được tô sáng, và bạn mất một mạng.';

  @override
  String get tourRulePickRightTimerTitle => 'Thời gian trôi nhanh';

  @override
  String get tourRulePickRightTimerDesc =>
      'Thời gian của chế độ Chọn Đúng hết rất nhanh. Hãy xem điều gì xảy ra nếu bạn quá chậm.';

  @override
  String get tourRulePickRightTimerResult =>
      'Lại hết giờ — khi không còn mạng nào, đó là Kết thúc trò chơi.';

  @override
  String get tourRulePickRightWrapUpTitle => 'Đó là Chọn Đúng!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Bây giờ hãy thử Chế độ đối kháng — nơi bạn chơi với Đối thủ thật.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Chào mừng Đối kháng';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'Bạn và đối thủ sẽ thay phiên nhau.\nHuy hiệu này cho biết **đến lượt ai** — với tư cách là chủ phòng, bạn đi trước.';

  @override
  String get tourRuleCombatTurnOrderTitle => 'Đến lượt ai?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'Huy hiệu này cho biết đến lượt ai. Là chủ phòng, bạn đi trước.';

  @override
  String get tourRuleCombatYourTurnTitle => 'Lượt của bạn';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Chạm vào chữ số hiển thị để hoàn thành lượt của bạn.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Lượt đối thủ';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Bây giờ hãy xem — đối thủ của bạn thực hiện lượt của họ.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'Đối thủ của bạn trả lời đúng! Lượt được chuyển lại cho bạn.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'Mất một mạng';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Xem điều gì xảy ra khi đối thủ bỏ lỡ một lần chạm.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Đối thủ của bạn đã mất một mạng — bạn sẽ thấy số mạng của họ giảm, giống như của bạn vậy.';

  @override
  String get tourRuleCombatTimerTitle => 'Ai cũng có bộ đếm giờ';

  @override
  String get tourRuleCombatTimerDesc =>
      'Bộ đếm giờ của bạn hoạt động tương tự ở đây — hết giờ là mất mạng.';

  @override
  String get tourRuleCombatTimerResult =>
      'Hết giờ! Mất mạng trong Đối kháng giống như trong Chơi đơn.';

  @override
  String get tourRuleCombatWinTitle => 'Chiến thắng!';

  @override
  String get tourRuleCombatWinDesc =>
      'Hãy xem điều gì xảy ra khi đối thủ của bạn hết mạng.';

  @override
  String get tourRuleCombatWinResult =>
      'Bạn thắng! Làm đối thủ hết mạng sẽ kết thúc trận đấu với phần thắng thuộc về bạn.';

  @override
  String get tourRuleCombatWrapUpTitle => 'Hoàn thành Hướng dẫn!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'Đó là tất cả — Chơi đơn, Chọn Đúng, và Chế độ đối kháng. Chúc bạn may mắn!';

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
  String get tourRuleRegularTypeBackResult => 'Chính xác — bạn được **điểm**!';
}
