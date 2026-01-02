// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => 'Selamat Datang!';

  @override
  String welcomeUser(String username) {
    return 'Selamat Datang $username!';
  }

  @override
  String get mainMenu => 'Menu Utama';

  @override
  String get start => 'Mulai';

  @override
  String get topScore => 'Skor Tertinggi';

  @override
  String get setting => 'Pengaturan';

  @override
  String get about => 'Tentang';

  @override
  String get exit => 'Keluar';

  @override
  String get version => 'Versi';

  @override
  String get anonymous => 'Anonim';

  @override
  String get level => 'Level';

  @override
  String get score => 'Skor';

  @override
  String get ready => 'Siap';

  @override
  String get go => 'Mulai!';

  @override
  String get gameOver => 'Permainan Berakhir';

  @override
  String get difficultySetting => 'Pengaturan Kesulitan';

  @override
  String get difficulty => 'Kesulitan';

  @override
  String get easy => 'Mudah';

  @override
  String get medium => 'Sedang';

  @override
  String get hard => 'Sulit';

  @override
  String get veryHard => 'Sangat Sulit';

  @override
  String get extreme => 'Ekstrem';

  @override
  String get selectDifficulty => 'Pilih Kesulitan';

  @override
  String get selectLevel => 'Pilih Level';

  @override
  String get selectLevelMessage =>
      'Pilih level yang ingin Anda mainkan. Semakin tinggi level, semakin sulit.';

  @override
  String get yourScoreIs => 'Skor Anda saat ini adalah';

  @override
  String get theCorrectIs => 'Jawaban yang benar adalah';

  @override
  String get name => 'Nama';

  @override
  String get fontSize => 'Ukuran Font';

  @override
  String get volume => 'Volume';

  @override
  String get vibrate => 'Getar';

  @override
  String get numberOfTopScores => 'Jumlah Skor Tertinggi';

  @override
  String get language => 'Bahasa';

  @override
  String get thankYou => 'Terima kasih telah bermain';

  @override
  String get thankYouMessage =>
      'Terima kasih telah memainkan permainan kami. Kami harap Anda menyukainya. Jika Anda memiliki umpan balik atau saran, beri tahu kami.';

  @override
  String get authorName => 'Penulis';

  @override
  String get connectWithUs => 'Terhubung dengan Kami';

  @override
  String get connectWithUsMessage =>
      'Jika Anda memiliki pertanyaan atau komentar, jangan ragu untuk menghubungi kami melalui saluran media sosial kami.';

  @override
  String get introductionContent =>
      'NuCatch adalah permainan otak yang menyenangkan dan menarik yang dirancang untuk mempertajam ingatan dan meningkatkan fokus Anda. Tantang diri Anda untuk menangkap angka dengan cepat dalam waktu singkat, membantu Anda mengingat hal-hal seperti OTP, nomor telepon, ulang tahun, dan lainnya. Nikmati pengalamannya dan tingkatkan keterampilan ingatan Anda!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'Bergabunglah dengan #NuCatch bersama $username! Jelajahi sekarang di $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Jelajahi #NuCatch sekarang di $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Pengalaman dengan #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Pengalaman dengan $username di #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username mendapatkan skor $point pada $timeCreated. Bergabunglah dengan #NuCatch bersama $username!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'Seorang pemain mendapatkan skor $point pada $timeCreated. Bergabunglah dengan #NuCatch sekarang!!';
  }

  @override
  String get confirmExit => 'Apakah Anda yakin ingin keluar?';

  @override
  String get no => 'Tidak';

  @override
  String get yes => 'Ya';

  @override
  String get insertedSuccess => 'Berhasil mencatat giliran Anda';

  @override
  String get insertedFailed => 'Gagal mencatat giliran Anda';

  @override
  String get scanQrToViewDetails => 'Pindai Kode QR untuk melihat detail';

  @override
  String get doYouWantToExit => 'Apakah Anda ingin keluar?';

  @override
  String get difficultyEasyDescription =>
      'Menghasilkan angka acak dengan level yang sedikit ditingkatkan untuk tantangan sederhana.';

  @override
  String get difficultyMediumDescription =>
      'Menghasilkan perhitungan penjumlahan/pengurangan untuk kesulitan sedang.';

  @override
  String get difficultyHardDescription =>
      'Membuat perhitungan perkalian/pembagian untuk kesulitan lanjutan.';

  @override
  String get difficultyExtremeDescription =>
      'Memilih secara acak antara menghasilkan perhitungan penjumlahan/pengurangan yang kompleks, angka acak level yang lebih tinggi, atau perhitungan perkalian/pembagian untuk pengalaman yang paling menantang.';

  @override
  String get difficultyEasyTitle => 'Mode Mudah';

  @override
  String get difficultyMediumTitle => 'Mode Sedang';

  @override
  String get difficultyHardTitle => 'Mode Sulit';

  @override
  String get difficultyExtremeTitle => 'Mode Ekstrem';

  @override
  String get confirmChangeDifficulty =>
      'Giliran Anda akan direset. Apakah Anda yakin ingin mengubah kesulitan?';

  @override
  String get areYouSure => 'Apakah Anda yakin?';

  @override
  String get no_turn_yet => 'Belum ada giliran';

  @override
  String get daily => 'Dalam Sehari';

  @override
  String get dailyDescription =>
      'Peringkat berdasarkan giliran yang dicatat hari ini.';

  @override
  String get weekly => 'Dalam Seminggu';

  @override
  String get weeklyDescription =>
      'Peringkat berdasarkan giliran yang dicatat dalam 7 hari terakhir.';

  @override
  String get allTime => 'Sepanjang Waktu';

  @override
  String get allTimeDescription =>
      'Peringkat berdasarkan semua giliran yang dicatat.';

  @override
  String get updateRequired => 'Pembaruan Diperlukan';

  @override
  String get updateAvailable => 'Pembaruan Tersedia';

  @override
  String get currentVersion => 'Versi Saat Ini';

  @override
  String get newVersion => 'Versi Baru';

  @override
  String get whatsNew => 'Apa yang Baru';

  @override
  String get forceUpdateMessage =>
      'Pembaruan ini diperlukan untuk terus menggunakan aplikasi. Harap perbarui sekarang.';

  @override
  String get later => 'Nanti';

  @override
  String get updateNow => 'Perbarui Sekarang';

  @override
  String get update => 'Perbarui';

  @override
  String get checkForUpdates => 'Periksa Pembaruan';

  @override
  String get appUpdates => 'Pembaruan Aplikasi';

  @override
  String get tapToCheckUpdates =>
      'Ketuk tombol di bawah untuk memeriksa pembaruan aplikasi.';

  @override
  String get checkingForUpdates => 'Memeriksa pembaruan...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Versi baru $version tersedia! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Pembaruan ini diperlukan.';

  @override
  String get usingLatestVersion => 'Anda menggunakan versi terbaru!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Tidak dapat memeriksa pembaruan. $error';
  }

  @override
  String get tryAgainLater => 'Silakan coba lagi nanti.';

  @override
  String get updatePostponed => 'Pembaruan tersedia tetapi ditunda.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'Anda memiliki $totalSeconds detik untuk mengetuk angka. Bilah berubah warna seiring berjalannya waktu: Hijau (di atas $halfSeconds detik), Oranye ($quarterSeconds-$halfSeconds detik), Merah (di bawah $quarterSeconds detik).';
  }

  @override
  String get selectPlayMode => 'Pilih Mode Bermain';

  @override
  String get soloMode => 'Mode Solo';

  @override
  String get soloModeDescription =>
      'Mainkan sendiri dan tantang diri Anda untuk mengalahkan skor tertinggi Anda';

  @override
  String get combatMode => 'Mode Pertarungan';

  @override
  String get combatModeDescription =>
      'Bermain dengan pemain lain melalui koneksi Bluetooth dan ambil giliran';

  @override
  String get createRoom => 'Buat Ruangan';

  @override
  String get createRoomDescription =>
      'Tuan rumah permainan baru dan tunggu pemain lain bergabung';

  @override
  String get joinRoom => 'Gabung Ruangan';

  @override
  String get joinRoomDescription =>
      'Masukkan kode ruangan untuk bergabung dengan permainan yang ada';

  @override
  String get hostRoom => 'Ruangan Tuan Rumah';

  @override
  String get roomCode => 'Kode Ruangan';

  @override
  String get shareCodeWithPlayer => 'Bagikan kode ini dengan pemain lain';

  @override
  String get enterRoomCode => 'Masukkan Kode Ruangan';

  @override
  String get connect => 'Hubungkan';

  @override
  String get searchingForPlayers => 'Mencari pemain...';

  @override
  String pairedWith(String playerName) {
    return 'Dipasangkan dengan $playerName!';
  }

  @override
  String get bluetoothPermissionRequired => 'Izin Bluetooth Diperlukan';

  @override
  String get bluetoothPermissionMessage =>
      'Mode Pertarungan memerlukan izin Bluetooth untuk terhubung dengan pemain lain. Harap berikan izin Bluetooth di pengaturan perangkat Anda.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Izin Bluetooth telah ditolak secara permanen. Untuk menggunakan Mode Pertarungan, Anda perlu mengaktifkan izin Bluetooth di pengaturan perangkat Anda.\n\nSilakan buka Pengaturan > NuCatch > Izin dan aktifkan Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth Dinonaktifkan';

  @override
  String get bluetoothDisabledMessage =>
      'Mode Pertarungan mengharuskan Bluetooth diaktifkan. Harap aktifkan Bluetooth di pengaturan perangkat Anda.';

  @override
  String get cancel => 'Batal';

  @override
  String get grantPermission => 'Berikan Izin';

  @override
  String get checkAgain => 'Periksa Lagi';

  @override
  String get openSettings => 'Buka Pengaturan';

  @override
  String get yourTurn => 'Giliran Anda';

  @override
  String get opponentTurn => 'Giliran Lawan';

  @override
  String get waitingForOpponent => 'Menunggu lawan...';

  @override
  String get watchingOpponent => 'Perhatikan lawan Anda';

  @override
  String get youWin => 'Anda Menang!';

  @override
  String get youLose => 'Anda Kalah!';

  @override
  String get opponentDisconnected => 'Lawan terputus';

  @override
  String get opponentRanOutOfLives => 'Lawan kehabisan nyawa';

  @override
  String get opponentGaveUp => 'Lawan Anda menyerah';

  @override
  String get confirmEndCombat =>
      'Apakah Anda yakin ingin mengakhiri permainan ini? Lawan Anda akan menang.';

  @override
  String get youRanOutOfLives => 'Anda kehabisan nyawa';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Hari ini adalah $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Tahun Baru';

  @override
  String get greetingNewYear => 'Selamat Tahun Baru!';

  @override
  String get holidayLunarNewYear => 'Tahun Baru Imlek';

  @override
  String get greetingLunarNewYear => 'Selamat Tahun Baru Imlek!';

  @override
  String get holidayValentine => 'Hari Valentine';

  @override
  String get greetingValentine => 'Selamat Hari Valentine!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => 'Selamat Holi!';

  @override
  String get holidayEarthDay => 'Hari Bumi';

  @override
  String get greetingEarthDay => 'Selamat Hari Bumi! Lindungi planet kita!';

  @override
  String get holidayEaster => 'Paskah';

  @override
  String get greetingEaster => 'Selamat Paskah!';

  @override
  String get holidayPride => 'Bulan Kebanggaan';

  @override
  String get greetingPride => 'Selamat Bulan Kebanggaan! Cinta adalah Cinta!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => 'Selamat Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => 'Selamat Diwali!';

  @override
  String get holidayHanukkah => 'Hanukkah';

  @override
  String get greetingHanukkah => 'Selamat Hanukkah!';

  @override
  String get holidayChristmas => 'Natal';

  @override
  String get greetingChristmas => 'Selamat Natal!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => 'Selamat Kwanzaa!';

  @override
  String get playAgain => 'Main Lagi';

  @override
  String get returnToMenu => 'Kembali ke Menu';

  @override
  String get doYouReadyForRestart => 'Apakah Anda siap untuk memulai ulang?';

  @override
  String get notReady => 'Belum Siap';

  @override
  String get you => 'Anda';

  @override
  String get opponent => 'Lawan';

  @override
  String get waiting => 'Menunggu';

  @override
  String get youWillTakeFirst => 'Anda akan mulai duluan!';

  @override
  String get opponentWillTakeFirst => 'Lawan akan mulai duluan';

  @override
  String get advertisingRoomWaiting => 'Menyiarkan ruangan! Menunggu lawan...';

  @override
  String get opponentJoinedReady =>
      'Lawan bergabung! Tekan Siap saat sudah siap.';

  @override
  String get opponentReady => 'Lawan Siap!';

  @override
  String get ok => 'OKE';

  @override
  String get bothPlayersReady => 'Kedua Pemain Siap!';

  @override
  String get searchingForHosts => 'Mencari tuan rumah...';

  @override
  String connectingToHost(String hostName) {
    return 'Menghubungkan ke $hostName...';
  }

  @override
  String get hostReady => 'Tuan Rumah Siap!';

  @override
  String get theHostIsReady => '✅ Tuan rumah sudah siap!';

  @override
  String get pressReadyWhenPrepared =>
      'Tekan Siap saat Anda siap untuk memulai.';

  @override
  String get yourOpponentIsReady => '✅ Lawan Anda sudah siap!';

  @override
  String get gameIsStarting => 'Permainan dimulai...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'Menunggu tuan rumah memilih kesulitan...';

  @override
  String get failedToInitializeNearby =>
      'Gagal menginisialisasi Nearby Connections. Harap berikan izin lokasi.';

  @override
  String get nearbyNotInitialized => 'Nearby Connections tidak diinisialisasi';

  @override
  String failedToStartAdvertising(String error) {
    return 'Gagal memulai siaran: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Gagal mengatur status siap: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Gagal memulai permainan: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Menyiarkan ruangan...\nMenunggu lawan menemukan dan terhubung.';

  @override
  String get opponentConnectedStatus =>
      'Lawan terhubung!\nTekan Siap saat kedua pemain siap.';

  @override
  String get bothPlayersReadyStatus =>
      'Kedua pemain siap! Memulai permainan...';

  @override
  String get settingUpDifficulty => 'Menyiapkan kesulitan permainan...';

  @override
  String get advertisingAs => 'Menyiarkan sebagai:';

  @override
  String get connectedViaNearby => 'Terhubung melalui Nearby';

  @override
  String get advertising => 'Menyiarkan...';

  @override
  String get selectHostToConnect => 'Pilih tuan rumah untuk terhubung';

  @override
  String availableHosts(int count) {
    return 'Tuan Rumah Tersedia ($count)';
  }

  @override
  String get tapToConnect => 'Ketuk untuk terhubung';

  @override
  String get noHostsFoundNearby => 'Tidak ada tuan rumah ditemukan di dekatnya';

  @override
  String get makeSureFriendHosting =>
      'Pastikan teman sedang menjadi tuan rumah\ndan kedua perangkat berdekatan';

  @override
  String get discovering => 'Menemukan...';

  @override
  String get notDiscovering => 'Tidak menemukan';

  @override
  String get distanceWarning =>
      'Pastikan perangkat berjarak kurang dari 10 meter';
}
