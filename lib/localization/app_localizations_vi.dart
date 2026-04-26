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
      'Chào bạn! Đây là hướng dẫn ngắn để bạn bắt đầu chơi **NuCatch**. Chúng tôi sẽ chỉ cho bạn tất cả các **tính năng chính** để bạn có thể sẵn sàng ngay lập tức.';

  @override
  String get tourStartTitle => 'Bắt đầu - Vào Game';

  @override
  String get tourStartDesc =>
      'Nhấn **Nút Bắt Đầu** để chơi. Bạn có thể chọn giữa **Chế độ Solo** để chơi một mình, hoặc **Chế độ Đối Kháng** cho Bluetooth nhiều người chơi.';

  @override
  String get tourInstantStartTitle => 'Bắt Đầu Nhanh';

  @override
  String get tourInstantStartDesc =>
      'Nhấn nút **Bắt Đầu Nhanh** để vào ngay trò chơi solo với cùng mức độ khó như lần trước. Đây là cách nhanh nhất để tiếp tục!';

  @override
  String get tourSoloTitle => 'Chế độ Solo';

  @override
  String get tourSoloDesc =>
      'Ở **Chế độ Solo**, hãy thử thách chính mình. Chọn giữa **4 mức độ khó**. Trò chơi cung cấp **3 mạng** - mỗi câu hỏi sai bạn sẽ mất 1 mạng. **Khó hơn** tức là sẽ nhiều điểm hơn!';

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
  String get tourLeaderboardTitle => 'Bảng Xếp Hạng';

  @override
  String get tourLeaderboardDesc =>
      'Theo dõi kỷ lục của bạn trong trang này! Cả điểm số **toàn cầu** cũng như **kỷ lục cá nhân** của bạn, và **thống kê**. Hãy khoe bạn bè !';

  @override
  String get tourSettingsTitle => 'Cài Đặt';

  @override
  String get tourSettingsDesc =>
      'Mọi thay đổi hiển thị ở đây! Từ **tên**, **giao diện**, **âm thanh**, **ngôn ngữ**.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Discover the ancient legend behind the tower and learn the rules of the game.';

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
  String get menuGreeting =>
      'Thử thách trí nhớ và kỹ năng tính toán của bạn ngay lúc này!';
}
