// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => 'ยินดีต้อนรับ!';

  @override
  String welcomeUser(String username) {
    return 'ยินดีต้อนรับ $username!';
  }

  @override
  String get mainMenu => 'เมนูหลัก';

  @override
  String get start => 'เริ่ม';

  @override
  String get topScore => 'คะแนนสูงสุด';

  @override
  String get setting => 'การตั้งค่า';

  @override
  String get about => 'เกี่ยวกับ';

  @override
  String get exit => 'ออก';

  @override
  String get version => 'เวอร์ชัน';

  @override
  String get anonymous => 'ไม่ระบุชื่อ';

  @override
  String get level => 'ระดับ';

  @override
  String get score => 'คะแนน';

  @override
  String get ready => 'พร้อม';

  @override
  String get go => 'ไป!';

  @override
  String get gameOver => 'จบเกม';

  @override
  String get difficultySetting => 'การตั้งค่าความยาก';

  @override
  String get difficulty => 'ความยาก';

  @override
  String get easy => 'ง่าย';

  @override
  String get medium => 'ปานกลาง';

  @override
  String get hard => 'ยาก';

  @override
  String get veryHard => 'ยากมาก';

  @override
  String get extreme => 'สุดโหด';

  @override
  String get selectDifficulty => 'เลือกระดับความยาก';

  @override
  String get selectLevel => 'เลือกระดับ';

  @override
  String get selectLevelMessage =>
      'เลือกระดับที่คุณต้องการเล่น ยิ่งระดับสูง ยิ่งยากขึ้น';

  @override
  String get yourScoreIs => 'คะแนนปัจจุบันของคุณคือ';

  @override
  String get theCorrectIs => 'คำตอบที่ถูกต้องคือ';

  @override
  String get name => 'ชื่อ';

  @override
  String get fontSize => 'ขนาดตัวอักษร';

  @override
  String get volume => 'ระดับเสียง';

  @override
  String get vibrate => 'สั่น';

  @override
  String get numberOfTopScores => 'จำนวนคะแนนสูงสุดที่แสดง';

  @override
  String get language => 'ภาษา';

  @override
  String get thankYou => 'ขอบคุณที่เล่น';

  @override
  String get thankYouMessage =>
      'ขอบคุณที่เล่นเกมของเรา เราหวังว่าคุณจะชอบ หากคุณมีข้อเสนอแนะ โปรดแจ้งให้เราทราบ';

  @override
  String get authorName => 'ผู้สร้าง';

  @override
  String get connectWithUs => 'เชื่อมต่อกับเรา';

  @override
  String get connectWithUsMessage =>
      'หากคุณมีคำถามหรือความคิดเห็น โปรดติดต่อเราผ่านโซเชียลมีเดียวของเรา';

  @override
  String get introductionContent =>
      'NuCatch เป็นเกมฝึกสมองที่สนุกและน่าสนใจ ออกแบบมาเพื่อเพิ่มความจำและสมาธิของคุณ ท้าทายตัวเองให้จับตัวเลขอย่างรวดเร็วในเวลาอันสั้น ช่วยให้คุณจำสิ่งต่างๆ เช่น OTP, เบอร์โทรศัพท์, วันเกิด และอื่นๆ ได้ดียิ่งขึ้น สนุกกับประสบการณ์และเพิ่มทักษะความจำของคุณ!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'เข้าร่วม #NuCatch กับ $username! สำรวจเลยที่ $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'สำรวจ #NuCatch เลยที่ $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'ประสบการณ์กับ #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'ประสบการณ์กับ $username บน #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username ได้คะแนน $point ที่ $timeCreated เข้าร่วม #NuCatch กับ $username เลย!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'ผู้เล่นคนหนึ่งได้คะแนน $point ที่ $timeCreated เข้าร่วม #NuCatch เลย!!';
  }

  @override
  String get confirmExit => 'คุณแน่ใจหรือไม่ว่าต้องการออก?';

  @override
  String get no => 'ไม่';

  @override
  String get yes => 'ใช่';

  @override
  String get insertedSuccess => 'บันทึกรอบของคุณสำเร็จ';

  @override
  String get insertedFailed => 'บันทึกรอบของคุณล้มเหลว';

  @override
  String get scanQrToViewDetails => 'สแกน QR Code เพื่อดูรายละเอียด';

  @override
  String get doYouWantToExit => 'คุณต้องการออกหรือไม่?';

  @override
  String get difficultyEasyDescription =>
      'สร้างตัวเลขสุ่มที่มีระดับเพิ่มขึ้นเล็กน้อยเพื่อความท้าทายง่ายๆ';

  @override
  String get difficultyMediumDescription =>
      'สร้างโจทย์การคำนวณบวก/ลบ สำหรับความยากปานกลาง';

  @override
  String get difficultyHardDescription =>
      'สร้างโจทย์การคำนวณคูณ/หาร สำหรับความยากระดับสูง';

  @override
  String get difficultyExtremeDescription =>
      'สุ่มเลือกระหว่างโจทย์บวก/ลบที่ซับซ้อน ตัวเลขสุ่มระดับสูง หรือโจทย์คูณ/หาร เพื่อประสบการณ์ที่ท้าทายที่สุด';

  @override
  String get difficultyEasyTitle => 'โหมดง่าย';

  @override
  String get difficultyMediumTitle => 'โหมดปานกลาง';

  @override
  String get difficultyHardTitle => 'โหมดยาก';

  @override
  String get difficultyExtremeTitle => 'โหมดสุดโหด';

  @override
  String get confirmChangeDifficulty =>
      'รอบของคุณจะถูกรีเซ็ต คุณแน่ใจหรือไม่ว่าต้องการเปลี่ยนระดับความยาก?';

  @override
  String get areYouSure => 'คุณแน่ใจหรือไม่?';

  @override
  String get no_turn_yet => 'ยังไม่มีรอบที่เล่น';

  @override
  String get daily => 'ในหนึ่งวัน';

  @override
  String get dailyDescription => 'อันดับตามรอบที่บันทึกในวันนี้';

  @override
  String get weekly => 'ในหนึ่งสัปดาห์';

  @override
  String get weeklyDescription => 'อันดับตามรอบที่บันทึกใน 7 วันที่ผ่านมา';

  @override
  String get allTime => 'ตลอดกาล';

  @override
  String get allTimeDescription => 'อันดับตามรอบที่บันทึกทั้งหมด';

  @override
  String get updateRequired => 'จำเป็นต้องอัปเดต';

  @override
  String get updateAvailable => 'มีอัปเดตใหม่';

  @override
  String get currentVersion => 'เวอร์ชันปัจจุบัน';

  @override
  String get newVersion => 'เวอร์ชันใหม่';

  @override
  String get whatsNew => 'มีอะไรใหม่';

  @override
  String get forceUpdateMessage =>
      'จำเป็นต้องอัปเดตนี้เพื่อใช้งานแอปต่อ โปรดอัปเดตทันที';

  @override
  String get later => 'ภายหลัง';

  @override
  String get updateNow => 'อัปเดตทันที';

  @override
  String get update => 'อัปเดต';

  @override
  String get checkForUpdates => 'ตรวจสอบการอัปเดต';

  @override
  String get appUpdates => 'อัปเดตแอป';

  @override
  String get tapToCheckUpdates => 'แตะปุ่มด้านล่างเพื่อตรวจสอบการอัปเดตแอป';

  @override
  String get checkingForUpdates => 'กำลังตรวจสอบการอัปเดต...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'มีเวอร์ชันใหม่ $version ให้ใช้งาน! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'การอัปเดตนี้จำเป็น';

  @override
  String get usingLatestVersion => 'คุณกำลังใช้เวอร์ชันล่าสุด!';

  @override
  String unableToCheckUpdates(String error) {
    return 'ไม่สามารถตรวจสอบการอัปเดตได้ $error';
  }

  @override
  String get tryAgainLater => 'โปรดลองใหม่ในภายหลัง';

  @override
  String get updatePostponed => 'มีการอัปเดตแต่ถูกเลื่อนออกไป';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'คุณมีเวลา $totalSeconds วินาทีในการแตะตัวเลข แถบจะเปลี่ยนสีเมื่อเวลาผ่านไป: สีเขียว (มากกว่า $halfSeconds วินาที), สีส้ม ($quarterSeconds-$halfSeconds วินาที), สีแดง (น้อยกว่า $quarterSeconds วินาที)';
  }

  @override
  String get selectPlayMode => 'เลือกโหมดการเล่น';

  @override
  String get soloMode => 'โหมดเล่นคนเดียว';

  @override
  String get soloModeDescription =>
      'เล่นคนเดียวและท้าทายตัวเองเพื่อทำลายสถิติคะแนนสูงสุด';

  @override
  String get combatMode => 'โหมดต่อสู้';

  @override
  String get combatModeDescription =>
      'เล่นกับผู้เล่นอื่นผ่านบลูทูธและผลัดกันเล่น';

  @override
  String get createRoom => 'สร้างห้อง';

  @override
  String get createRoomDescription =>
      'เป็นโฮสต์เกมใหม่และรอให้ผู้เล่นอื่นเข้าร่วม';

  @override
  String get joinRoom => 'เข้าร่วมห้อง';

  @override
  String get joinRoomDescription => 'ป้อนรหัสห้องเพื่อเข้าร่วมเกมที่มีอยู่';

  @override
  String get hostRoom => 'ห้องโฮสต์';

  @override
  String get roomCode => 'รหัสห้อง';

  @override
  String get shareCodeWithPlayer => 'แชร์รหัสนี้กับผู้เล่นอื่น';

  @override
  String get enterRoomCode => 'ป้อนรหัสห้อง';

  @override
  String get connect => 'เชื่อมต่อ';

  @override
  String get searchingForPlayers => 'กำลังค้นหาผู้เล่น...';

  @override
  String pairedWith(String playerName) {
    return 'จับคู่กับ $playerName แล้ว!';
  }

  @override
  String get bluetoothPermissionRequired => 'ต้องการสิทธิ์บลูทูธ';

  @override
  String get bluetoothPermissionMessage =>
      'โหมดต่อสู้ต้องการสิทธิ์บลูทูธเพื่อเชื่อมต่อกับผู้เล่นอื่น โปรดอนุญาตสิทธิ์บลูทูธในการตั้งค่าอุปกรณ์ของคุณ';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'สิทธิ์บลูทูธถูกปฏิเสธอย่างถาวร หากต้องการใช้โหมดต่อสู้ คุณต้องเปิดใช้งานสิทธิ์บลูทูธในการตั้งค่าอุปกรณ์ของคุณ\n\nโปรดไปที่ การตั้งค่า > NuCatch > สิทธิ์ และเปิดใช้งานบลูทูธ';

  @override
  String get bluetoothDisabled => 'บลูทูธถูกปิดใช้งาน';

  @override
  String get bluetoothDisabledMessage =>
      'โหมดต่อสู้ต้องการให้เปิดบลูทูธ โปรดเปิดบลูทูธในการตั้งค่าอุปกรณ์ของคุณ';

  @override
  String get cancel => 'ยกเลิก';

  @override
  String get grantPermission => 'อนุญาตสิทธิ์';

  @override
  String get checkAgain => 'ตรวจสอบอีกครั้ง';

  @override
  String get openSettings => 'เปิดการตั้งค่า';

  @override
  String get yourTurn => 'ตาคุณ';

  @override
  String get opponentTurn => 'ตาคู่ต่อสู้';

  @override
  String get waitingForOpponent => 'รอคู่ต่อสู้...';

  @override
  String get watchingOpponent => 'ดูคู่ต่อสู้ของคุณ';

  @override
  String get youWin => 'คุณชนะ!';

  @override
  String get youLose => 'คุณแพ้!';

  @override
  String get opponentDisconnected => 'คู่ต่อสู้ตัดการเชื่อมต่อ';

  @override
  String get opponentRanOutOfLives => 'คู่ต่อสู้หมดชีวิต';

  @override
  String get opponentGaveUp => 'คู่ต่อสู้ของคุณยอมแพ้';

  @override
  String get confirmEndCombat =>
      'คุณแน่ใจหรือไม่ว่าต้องการจบเกมนี้? คู่ต่อสู้ของคุณจะชนะ';

  @override
  String get youRanOutOfLives => 'คุณหมดชีวิต';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'วันนี้เป็นวัน $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'วันปีใหม่';

  @override
  String get greetingNewYear => 'สวัสดีปีใหม่!';

  @override
  String get holidayLunarNewYear => 'วันตรุษจีน';

  @override
  String get greetingLunarNewYear => 'ซินเจียยู่อี่ ซินนี้ฮวดไช้!';

  @override
  String get holidayValentine => 'วันวาเลนไทน์';

  @override
  String get greetingValentine => 'สุขสันต์วันวาเลนไทน์!';

  @override
  String get holidayHoli => 'เทศกาลโฮลี';

  @override
  String get greetingHoli => 'สุขสันต์วันโฮลี!';

  @override
  String get holidayEarthDay => 'วันคุ้มครองโลก';

  @override
  String get greetingEarthDay =>
      'สุขสันต์วันคุ้มครองโลก! ช่วยกันรักษาโลกของเรา!';

  @override
  String get holidayEaster => 'วันอีสเตอร์';

  @override
  String get greetingEaster => 'สุขสันต์วันอีสเตอร์!';

  @override
  String get holidayPride => 'เดือนแห่งความภาคภูมิใจ';

  @override
  String get greetingPride => 'สุขสันต์เดือนแห่งความภาคภูมิใจ! รักคือรัก!';

  @override
  String get holidayHalloween => 'วันฮาโลวีน';

  @override
  String get greetingHalloween => 'สุขสันต์วันฮาโลวีน!';

  @override
  String get holidayDiwali => 'เทศกาลดิวาลี';

  @override
  String get greetingDiwali => 'สุขสันต์วันดิวาลี!';

  @override
  String get holidayHanukkah => 'เทศกาลฮานุคคา';

  @override
  String get greetingHanukkah => 'สุขสันต์วันฮานุคคา!';

  @override
  String get holidayChristmas => 'วันคริสต์มาส';

  @override
  String get greetingChristmas => 'สุขสันต์วันคริสต์มาส!';

  @override
  String get holidayKwanzaa => 'เทศกาลควอนซา';

  @override
  String get greetingKwanzaa => 'สุขสันต์วันควอนซา!';

  @override
  String get playAgain => 'เล่นอีกครั้ง';

  @override
  String get returnToMenu => 'กลับสู่เมนู';

  @override
  String get doYouReadyForRestart => 'คุณพร้อมที่จะเริ่มใหม่หรือไม่?';

  @override
  String get notReady => 'ไม่พร้อม';

  @override
  String get you => 'คุณ';

  @override
  String get opponent => 'คู่ต่อสู้';

  @override
  String get waiting => 'กำลังรอ';

  @override
  String get youWillTakeFirst => 'คุณจะได้เริ่มก่อน!';

  @override
  String get opponentWillTakeFirst => 'คู่ต่อสู้จะเริ่มก่อน';

  @override
  String get advertisingRoomWaiting => 'กำลังประกาศห้อง! รอคู่ต่อสู้...';

  @override
  String get opponentJoinedReady =>
      'คู่ต่อสู้เข้าร่วมแล้ว! กดพร้อมเมื่อคุณเตรียมตัวเสร็จ';

  @override
  String get opponentReady => 'คู่ต่อสู้พร้อม!';

  @override
  String get ok => 'ตกลง';

  @override
  String get bothPlayersReady => 'ผู้เล่นทั้งสองพร้อม!';

  @override
  String get searchingForHosts => 'กำลังค้นหาโฮสต์...';

  @override
  String connectingToHost(String hostName) {
    return 'กำลังเชื่อมต่อไปยัง $hostName...';
  }

  @override
  String get hostReady => 'โฮสต์พร้อม!';

  @override
  String get theHostIsReady => '✅ โฮสต์พร้อมแล้ว!';

  @override
  String get pressReadyWhenPrepared => 'กดพร้อมเมื่อคุณเตรียมตัวเสร็จ';

  @override
  String get yourOpponentIsReady => '✅ คู่ต่อสู้ของคุณพร้อมแล้ว!';

  @override
  String get gameIsStarting => 'เกมกำลังจะเริ่ม...';

  @override
  String get waitingForHostToSelectDifficulty => 'รอโฮสต์เลือกระดับความยาก...';

  @override
  String get failedToInitializeNearby =>
      'ไม่สามารถเริ่มต้น Nearby Connections ได้ โปรดอนุญาตสิทธิ์ตำแหน่งที่ตั้ง';

  @override
  String get nearbyNotInitialized => 'Nearby Connections ไม่ได้เริ่มต้น';

  @override
  String failedToStartAdvertising(String error) {
    return 'ไม่สามารถเริ่มการประกาศได้: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'ไม่สามารถตั้งค่าความพร้อมได้: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'ไม่สามารถเริ่มเกมได้: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'กำลังประกาศห้อง...\nรอให้คู่ต่อสู้ค้นพบและเชื่อมต่อ';

  @override
  String get opponentConnectedStatus =>
      'คู่ต่อสู้เชื่อมต่อแล้ว!\nกดพร้อมเมื่อผู้เล่นทั้งสองพร้อม';

  @override
  String get bothPlayersReadyStatus => 'ผู้เล่นทั้งสองพร้อม! เริ่มเกม...';

  @override
  String get settingUpDifficulty => 'กำลังตั้งค่าความยากของเกม...';

  @override
  String get advertisingAs => 'ประกาศในชื่อ:';

  @override
  String get connectedViaNearby => 'เชื่อมต่อผ่าน Nearby';

  @override
  String get advertising => 'กำลังประกาศ...';

  @override
  String get selectHostToConnect => 'เลือกโฮสต์เพื่อเชื่อมต่อ';

  @override
  String availableHosts(int count) {
    return 'โฮสต์ที่พร้อมใช้งาน ($count)';
  }

  @override
  String get tapToConnect => 'แตะเพื่อเชื่อมต่อ';

  @override
  String get noHostsFoundNearby => 'ไม่พบโฮสต์ในบริเวณใกล้เคียง';

  @override
  String get makeSureFriendHosting =>
      'ตรวจสอบให้แน่ใจว่าเพื่อนกำลังโฮสต์อยู่\nและอุปกรณ์ทั้งสองอยู่ใกล้กัน';

  @override
  String get discovering => 'กำลังค้นพบ...';

  @override
  String get notDiscovering => 'ไม่ได้ค้นพบ';

  @override
  String get distanceWarning =>
      'ตรวจสอบให้แน่ใจว่าอุปกรณ์อยู่ห่างกันไม่เกิน 10 เมตร';

  @override
  String get tourButtonLabel => 'เริ่มทัวร์';

  @override
  String get tourWelcomeTitle => 'ยินดีต้อนรับสู่ NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'ยินดีต้อนรับ! ทัวร์สั้นๆ นี้จะช่วยให้คุณเริ่มต้นกับ NuCatch ได้อย่างราบรื่น เราจะแสดงคุณสมบัติหลักทั้งหมด เพื่อให้คุณสามารถเข้าไปเล่นได้ทันที มาเริ่มกันเลย!';

  @override
  String get tourStartTitle => 'เริ่ม - เริ่มเกมของคุณ';

  @override
  String get tourStartDesc =>
      'แตะปุ่มเริ่มเพื่อเริ่มต้น จากนั้นคุณจะเลือกระหว่างโหมดเดี่ยวสำหรับความท้าทายทางคณิตศาสตร์ผู้เล่นเดียว หรือโหมดต่อสู้สำหรับการต่อสู้แบบผู้เล่นหลายคนแบบเรียลไทม์ผ่านบลูทูธ มาสำรวจทั้งสองตัวเลือกกัน!';

  @override
  String get tourSoloTitle => 'โหมดเดี่ยว - เล่นคนเดียว';

  @override
  String get tourSoloDesc =>
      'ในโหมดเดี่ยว ท้าทายตัวเองด้วยสมการคณิตศาสตร์! เลือกจาก 4 ระดับความยาก (ง่ายถึงยากมาก) คุณเริ่มด้วย 3 ชีวิต - คำตอบผิดหรือหมดเวลาแต่ละครั้งเสีย 1 ชีวิต ความยากที่สูงขึ้นหมายถึงแต้มมากขึ้น! ตอนนี้มาดูตัวเลือกผู้เล่นหลายคนกัน';

  @override
  String get tourCombatTitle => 'โหมดต่อสู้ - ผู้เล่นหลายคนผ่านบลูทูธ';

  @override
  String get tourCombatDesc =>
      'โหมดต่อสู้ให้คุณต่อสู้กับเพื่อนผ่านบลูทูธ! ผู้เล่นสองคนผลัดกันแก้สมการ - ไม่ต้องใช้ WiFi เพียงอยู่ในระยะ 10 เมตร ผู้สร้างห้องเล่นก่อนในตอนแรก แต่ในการแข่งขันซ้ำผู้แพ้จะเล่นก่อน คุณมีสองวิธีในการเริ่มการแข่งขัน:';

  @override
  String get tourCreateRoomTitle => 'โหมดต่อสู้ → สร้างห้อง';

  @override
  String get tourCreateRoomDesc =>
      'ตัวเลือกแรก: สร้างห้องทำให้คุณเป็นเจ้าบ้าน! หลังจากอนุญาตบลูทูธ คุณจะรอแขกเข้าร่วมห้องของคุณ จากนั้นเลือกระดับความยาก ในฐานะเจ้าบ้าน คุณเล่นก่อนในการแข่งขันแรก หรือคุณสามารถเข้าร่วมเกมของคนอื่น:';

  @override
  String get tourJoinRoomTitle => 'โหมดต่อสู้ → เข้าร่วมห้อง';

  @override
  String get tourJoinRoomDesc =>
      'ตัวเลือกที่สอง: เข้าร่วมห้องทำให้คุณเป็นแขก! หลังจากอนุญาต คุณจะสแกนหาห้องใกล้เคียง เลือกหนึ่งห้อง และแตะพร้อม เจ้าบ้านเลือกความยาก และคุณจะเล่นเป็นคนที่สองในการแข่งขันแรก ตอนนี้มาตรวจสอบคุณสมบัติเมนูอื่นๆ กัน';

  @override
  String get tourLeaderboardTitle => 'คะแนนสูงสุด - กระดานผู้นำ';

  @override
  String get tourLeaderboardDesc =>
      'ติดตามความคืบหน้าของคุณที่นี่! ดูอันดับทั่วโลก สถิติส่วนตัวของคุณ และสถิติรวมถึงเกมที่เล่น อัตราชนะ ความแม่นยำ และคะแนนตามระดับความยาก เปรียบเทียบกับเพื่อนและดูว่าคุณพัฒนาขึ้นอย่างไร สุดท้าย มาไปที่การตั้งค่ากัน';

  @override
  String get tourSettingsTitle => 'การตั้งค่า - ปรับแต่ง';

  @override
  String get tourSettingsDesc =>
      'ปรับแต่งทุกอย่างที่นี่! เปลี่ยนชื่อผู้ใช้ เลือกธีม ปรับเสียง/เพลง เลือกภาษา และจัดการการตั้งค่าความเป็นส่วนตัว คุณสามารถเริ่มทัวร์นี้ใหม่ได้ทุกเมื่อจากที่นี่ เท่านี้แหละ - คุณพร้อมเล่นแล้ว!';

  @override
  String get tourNext => 'ถัดไป';

  @override
  String get tourPrevious => 'ก่อนหน้า';

  @override
  String get tourSkip => 'ข้ามทัวร์';

  @override
  String get tourFinish => 'เสร็จสิ้น';

  @override
  String get tourRestartFromSettings => 'เริ่มทัวร์ใหม่';
}
