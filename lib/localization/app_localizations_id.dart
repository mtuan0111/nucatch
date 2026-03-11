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
  String get instantStart => 'Mulai Instan';

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
  String get whichOneIsCorrect => 'Mana yang benar?';

  @override
  String get numberOfTopScores => 'Jumlah Skor Tertinggi';

  @override
  String get onlyShowMyRecorded => 'Hanya tampilkan rekaman saya';

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
  String get restartGame => 'Ulangi Game';

  @override
  String get confirmRestart => 'Apakah Anda yakin ingin mengulang permainan?';

  @override
  String get insertedSuccess => 'Berhasil mencatat giliran Anda';

  @override
  String get insertedFailed => 'Gagal mencatat giliran Anda';

  @override
  String get scanQrToViewDetails => 'Pindai Kode QR untuk melihat detail';

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
  String get pickRightDescription =>
      'Pilih persamaan yang benar! Permainan ketangkasan waktu 5 detik.';

  @override
  String get difficultyEasyTitle => 'Mode Mudah';

  @override
  String get difficultyMediumTitle => 'Mode Sedang';

  @override
  String get difficultyHardTitle => 'Mode Sulit';

  @override
  String get difficultyExtremeTitle => 'Mode Ekstrem';

  @override
  String get pickRightTitle => 'Pilih Benar';

  @override
  String get confirmChangeDifficulty =>
      'Giliran Anda akan direset. Apakah Anda yakin ingin mengubah kesulitan?';

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
  String get doYouReadyForRestart => 'Apakah Anda siap untuk memulai ulang?';

  @override
  String get notReady => 'Belum Siap';

  @override
  String get you => 'Anda';

  @override
  String get opponent => 'Lawan';

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

  @override
  String get tourButtonLabel => 'Mulai Tur';

  @override
  String get tourWelcomeTitle => 'Selamat datang di NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Selamat datang! Tur singkat ini akan membantu Anda memulai **NuCatch** dengan lancar. Kami akan menunjukkan semua **fitur utama** agar Anda bisa langsung bermain.';

  @override
  String get tourStartTitle => 'Mulai - Mulai Permainan';

  @override
  String get tourStartDesc =>
      'Ketuk **tombol Mulai**. Anda akan memilih antara **Mode Solo** untuk tantangan matematika individu, atau **Mode Tempur** untuk pertarungan multipemain via **Bluetooth**.';

  @override
  String get tourInstantStartTitle => 'Mulai Instan';

  @override
  String get tourInstantStartDesc =>
      'Ketuk tombol **Mulai Instan** untuk memulai game solo langsung menggunakan tingkat kesulitan yang sama dengan saat terakhir bermain. Cara tercepat melanjutkan progres permainan Anda!';

  @override
  String get tourSoloTitle => 'Mode Solo';

  @override
  String get tourSoloDesc =>
      'Tantang diri Anda di **Mode Solo**. Pilih dari **4 tingkat kesulitan**. Anda mulai dengan **3 nyawa** - setiap salah jawab/habis waktu mengurangi 1 nyawa. **Kesulitan tinggi** = poin lebih besar!';

  @override
  String get tourCombatTitle => 'Mode Tempur - Multiplayer Bluetooth';

  @override
  String get tourCombatDesc =>
      '**Mode Tempur** via **Bluetooth** melawan teman! **Dua pemain** bergantian menjawab - **tanpa WiFi**, hanya harus berada dalam jarak **10 meter**.';

  @override
  String get tourCreateRoomTitle => 'Mode Tempur → Buat Ruang';

  @override
  String get tourCreateRoomDesc =>
      '**Buat Ruang** menjadikan Anda **Host**. Setelah izinkan Bluetooth, tunggu teman bergabung lalu pilih **kesulitan**. Anda main pertama.';

  @override
  String get tourJoinRoomTitle => 'Mode Tempur → Gabung Ruang';

  @override
  String get tourJoinRoomDesc =>
      '**Gabung Ruang** menjadikan Anda **Tamu**. Pindai ruang sekitar, pilih lalu ketuk **Siap**. Anda main kedua.';

  @override
  String get tourLeaderboardTitle => 'Papan Peringkat';

  @override
  String get tourLeaderboardDesc =>
      'Lacak kemajuan Anda! Lihat **peringkat global**, **rekor pribadi**, dan **statistik**. Bandingkan dengan teman.';

  @override
  String get tourSettingsTitle => 'Pengaturan';

  @override
  String get tourSettingsDesc =>
      'Sesuaikan semuanya! Ubah **nama pengguna**, **tema**, **suara**, **bahasa**. Anda bisa ulangi tur ini kapan saja di sini.';

  @override
  String get tourNext => 'Lanjut';

  @override
  String get tourPrevious => 'Kembali';

  @override
  String get tourSkip => 'Lewati';

  @override
  String get tourFinish => 'Selesai';

  @override
  String get tourRestartFromSettings => 'Ulangi Tur';

  @override
  String get tourResetMessage =>
      'Tur diatur ulang. Kembali ke menu utama untuk mulai.';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';
}
