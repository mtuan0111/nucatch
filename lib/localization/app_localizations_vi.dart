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
  String get welcome => 'Chào mừng!!';

  @override
  String welcomeUser(String username) {
    return 'Chào mừng $username!!';
  }

  @override
  String get mainMenu => 'Trang chính';

  @override
  String get start => 'Bắt đầu';

  @override
  String get topScore => 'Điểm cao nhất';

  @override
  String get setting => 'Cài đặt';

  @override
  String get about => 'Giới thiệu';

  @override
  String get exit => 'Thoát';

  @override
  String get version => 'Phiên bản';

  @override
  String get anonymous => 'Ẩn danh';

  @override
  String get level => 'Cấp độ';

  @override
  String get score => 'Điểm số';

  @override
  String get ready => 'Sẵn sàng';

  @override
  String get go => 'Bắt đầu';

  @override
  String get gameOver => 'Kết thúc trò chơi';

  @override
  String get difficultySetting => 'Cài đặt độ khó';

  @override
  String get difficulty => 'Độ khó';

  @override
  String get easy => 'Dễ';

  @override
  String get medium => 'Trung bình';

  @override
  String get hard => 'Khó';

  @override
  String get veryHard => 'Rất khó';

  @override
  String get extreme => 'Cực kỳ khó';

  @override
  String get selectDifficulty => 'Chọn độ khó';

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
  String get name => 'Tên người chơi';

  @override
  String get fontSize => 'Kích thước phông chữ';

  @override
  String get volume => 'Âm lượng';

  @override
  String get vibrate => 'Rung';

  @override
  String get numberOfTopScores => 'Số điểm cao nhất';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get thankYou => 'Cảm ơn bạn!';

  @override
  String get thankYouMessage =>
      'Cảm ơn bạn đã chơi trò chơi của chúng tôi. Chúng tôi hy vọng bạn đã thích nó. Nếu bạn có bất kỳ phản hồi hoặc đề xuất nào, xin vui lòng cho chúng tôi biết.';

  @override
  String get authorName => 'Tác giả';

  @override
  String get connectWithUs => 'Kết nối với chúng tôi';

  @override
  String get connectWithUsMessage =>
      'Nếu bạn có bất kỳ câu hỏi hoặc phản hồi nào, hãy liên hệ với chúng tôi qua các kênh truyền thông xã hội của chúng tôi.';

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
  String get confirmExit => 'Bạn có chắc chắn muốn thoát không?';

  @override
  String get no => 'Không';

  @override
  String get yes => 'Có';

  @override
  String get insertedSuccess => 'Ghi lượt chơi của bạn thành công';

  @override
  String get insertedFailed => 'Ghi lượt chơi của bạn thất bại';

  @override
  String get scanQrToViewDetails => 'Quét mã QR để xem chi tiết';

  @override
  String get doYouWantToExit => 'Bạn có muốn thoát không?';

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
  String get difficultyEasyTitle => 'Dễ';

  @override
  String get difficultyMediumTitle => 'Trung bình';

  @override
  String get difficultyHardTitle => 'Khó';

  @override
  String get difficultyExtremeTitle => 'Cực kỳ khó';

  @override
  String get confirmChangeDifficulty =>
      'Lượt chơi sẽ bị reset. Bạn có chắc chắn muốn thay đổi không?';

  @override
  String get areYouSure => 'Bạn có chắc chắn không?';

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
  String get updateRequired => 'Yêu cầu cập nhật';

  @override
  String get updateAvailable => 'Có bản cập nhật';

  @override
  String get currentVersion => 'Phiên bản hiện tại';

  @override
  String get newVersion => 'Phiên bản mới';

  @override
  String get whatsNew => 'Có gì mới';

  @override
  String get forceUpdateMessage =>
      'Bản cập nhật này là bắt buộc để tiếp tục sử dụng ứng dụng. Vui lòng cập nhật ngay.';

  @override
  String get later => 'Để sau';

  @override
  String get updateNow => 'Cập nhật ngay';

  @override
  String get update => 'Cập nhật';

  @override
  String get checkForUpdates => 'Kiểm tra cập nhật';

  @override
  String get appUpdates => 'Cập nhật ứng dụng';

  @override
  String get tapToCheckUpdates =>
      'Nhấn vào nút bên dưới để kiểm tra cập nhật ứng dụng.';

  @override
  String get checkingForUpdates => 'Đang kiểm tra cập nhật...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Phiên bản mới $version đã có! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Bản cập nhật này là bắt buộc.';

  @override
  String get usingLatestVersion => 'Bạn đang sử dụng phiên bản mới nhất!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Không thể kiểm tra cập nhật. $error';
  }

  @override
  String get tryAgainLater => 'Vui lòng thử lại sau.';

  @override
  String get updatePostponed => 'Có bản cập nhật nhưng đã hoãn lại.';

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
  String get hostRoom => 'Phòng chủ';

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
  String get cancel => 'Hủy';

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
  String holidayNotification(String holidayName, String greeting) {
    return 'Hôm nay là $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Tết Dương lịch';

  @override
  String get greetingNewYear => 'Chúc mừng năm mới!';

  @override
  String get holidayLunarNewYear => 'Tết Nguyên đán';

  @override
  String get greetingLunarNewYear => 'Chúc mừng năm mới! Vạn sự như ý!';

  @override
  String get holidayValentine => 'Ngày Lễ Tình Nhân';

  @override
  String get greetingValentine => 'Chúc mừng ngày lễ tình nhân!';

  @override
  String get holidayHoli => 'Lễ hội Holi';

  @override
  String get greetingHoli => 'होली की शुभकामनाएं! (Holi Ki Shubhkamnayein!)';

  @override
  String get holidayEarthDay => 'Ngày Trái Đất';

  @override
  String get greetingEarthDay =>
      'Chúc mừng Ngày Trái Đất! Bảo vệ hành tinh của chúng ta! 🌍';

  @override
  String get holidayEaster => 'Lễ Phục Sinh';

  @override
  String get greetingEaster => 'Chúc mừng Lễ Phục Sinh!';

  @override
  String get holidayPride => 'Tháng Tự Hào';

  @override
  String get greetingPride =>
      'Tháng Tự Hào Vui Vẻ! Tình Yêu Là Tình Yêu! 🏳️‍🌈';

  @override
  String get holidayHalloween => 'Lễ Halloween';

  @override
  String get greetingHalloween => 'Chúc mừng Halloween!';

  @override
  String get holidayDiwali => 'Lễ hội Diwali';

  @override
  String get greetingDiwali =>
      'दीपावली की शुभकामनाएं! (Deepavali Ki Shubhkamnayein!)';

  @override
  String get holidayHanukkah => 'Lễ Hanukkah';

  @override
  String get greetingHanukkah => 'חג חנוכה שמח! (Chag Hanukkah Sameach!)';

  @override
  String get holidayChristmas => 'Lễ Giáng Sinh';

  @override
  String get greetingChristmas => 'Chúc mừng Giáng Sinh!';

  @override
  String get holidayKwanzaa => 'Lễ Kwanzaa';

  @override
  String get greetingKwanzaa => 'Habari Gani!';

  @override
  String get playAgain => 'Chơi lại';

  @override
  String get returnToMenu => 'Về menu';

  @override
  String get doYouReadyForRestart => 'Bạn sẵn sàng chơi lại chưa?';

  @override
  String get notReady => 'Chưa sẵn sàng';

  @override
  String get you => 'Bạn';

  @override
  String get opponent => 'Đối thủ';

  @override
  String get waiting => 'Đang chờ';

  @override
  String get youWillTakeFirst => 'You will take first turn!';

  @override
  String get opponentWillTakeFirst => 'Opponent will take first turn';
}
