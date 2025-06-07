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
  String get theCorrectIs => 'Đáp án đúng là';

  @override
  String get name => 'Tên người chơi';

  @override
  String get fontSize => 'Kích thước phông chữ';

  @override
  String get volume => 'Âm lượng';

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
    return 'Experience with $username at #NuCatch';
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
}
