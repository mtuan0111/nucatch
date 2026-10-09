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
  String get lastPlayedLabel => 'Last played';

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
      'Tur singkat: pertama **menu**, lalu **permainan latihan** singkat.\nKamu bisa melewatinya kapan saja.';

  @override
  String get tourStartTitle => 'Mulai';

  @override
  String get tourStartDesc => 'Ketuk **Mulai** untuk memilih cara bermain.';

  @override
  String get tourInstantStartTitle => 'Mulai Instan';

  @override
  String get tourInstantStartDesc =>
      'Langsung main **Solo** dengan tingkat kesulitan terakhir yang kamu mainkan.';

  @override
  String get tourSoloTitle => 'Dua Cara Bermain';

  @override
  String get tourSoloDesc =>
      '**Mode Solo**: bermain sendiri dan kalahkan skor terbaikmu.\n**Mode Pertarungan**: tantang teman di dekatmu lewat **Bluetooth** — satu membuat ruangan, yang lain bergabung.';

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
  String get tourLeaderboardTitle => 'Jelajahi Lebih Banyak';

  @override
  String get tourLeaderboardDesc =>
      '**Skor Tertinggi** menampilkan peringkat.\n**Pengaturan** untuk mengubah nama, tema, suara, dan bahasa.\n**Tentang** menjelaskan aturannya.\nBerikutnya: **permainan latihan** singkat!';

  @override
  String get tourSettingsTitle => 'Pengaturan';

  @override
  String get tourSettingsDesc =>
      'Sesuaikan semuanya! Ubah **nama pengguna**, **tema**, **suara**, **bahasa**. Anda bisa ulangi tur ini kapan saja di sini.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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
  String get tourRuleRegularWelcomeTitle => 'Mode Klasik';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Hafalkan angkanya, lalu ketik kembali sebelum waktu habis.\nKamu punya **3 nyawa** — jika semuanya habis, permainan berakhir.';

  @override
  String get tourRuleRegularLivesTitle => 'Nyawamu';

  @override
  String get tourRuleRegularLivesDesc =>
      'Kamu mulai dengan **3 nyawa**. Kehilangan semuanya mengakhiri permainan — jadi bermainlah dengan hati-hati!';

  @override
  String get tourRuleRegularMemorizeTitle => 'Hafalkan';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Perhatikan baik-baik — angkanya berkedip di layar sesaat sebelum bersembunyi.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Ketik Kembali';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Sekarang ketuk angka yang baru saja kamu lihat di papan tombol.';

  @override
  String get tourRuleRegularScoringTitle => 'Bagus!';

  @override
  String get tourRuleRegularScoringDesc =>
      'Terus jawab dengan benar untuk mendapatkan poin.';

  @override
  String get tourRuleRegularScoringResult =>
      'Kamu baru saja mendapatkan satu poin! Setiap jawaban benar menambah skormu.';

  @override
  String get tourRuleRegularTimerTitle => 'Kalahkan Waktu';

  @override
  String get tourRuleRegularTimerDesc =>
      'Perhatikan bilah waktu — jika habis sebelum kamu selesai mengetik, kamu akan kehilangan satu nyawa.';

  @override
  String get tourRuleRegularTimerResult =>
      'Waktu habis! Kehabisan waktu akan mengorbankan satu nyawa, sama seperti salah ketuk.';

  @override
  String get tourRuleRegularResetTitle => 'Butuh yang Baru?';

  @override
  String get tourRuleRegularResetDesc =>
      'Ketuk **Reset** untuk melewati tantangan sulit dan mendapatkan yang baru — tapi selalu butuh satu nyawa.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Naik Level';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Jawab beberapa giliran dengan benar dan kamu akan naik level.';

  @override
  String get tourRuleRegularLevelUpResult =>
      'Naik level! Angka-angka menjadi sedikit lebih sulit dari sini.\nSelesaikan level tanpa kehilangan nyawa untuk mendapatkan **nyawa bonus**.';

  @override
  String get tourRuleRegularGameOverTitle => 'Permainan Berakhir';

  @override
  String get tourRuleRegularGameOverDesc =>
      'Dengan hanya sisa 1 nyawa, satu kesalahan lagi akan benar-benar mengakhiri permainan. Lihat apa yang terjadi.';

  @override
  String get tourRuleRegularWrapUpTitle => 'Itu Mode Klasik!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Sekarang mari kita coba mode Pilih Benar — cara bermain yang berbeda.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Mode Pilih Benar';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Di sini kamu tidak mengetik — ketuk **jawaban yang benar**.\nPilihan lainnya hanyalah jebakan.';

  @override
  String get tourRulePickRightOptionsTitle => 'Pilih dengan cermat';

  @override
  String get tourRulePickRightOptionsDesc =>
      'Salah satunya benar — yang lain hanyalah jebakan.';

  @override
  String get tourRulePickRightCorrectTitle => 'Ketuk yang Benar';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Ketuk tombol yang menurutmu benar.';

  @override
  String get tourRulePickRightCorrectResult =>
      'Benar! Kamu mendapatkan satu poin.';

  @override
  String get tourRulePickRightWrongTitle => 'Ups!';

  @override
  String get tourRulePickRightWrongDesc =>
      'Kali ini, coba ketuk tombol yang berbeda.';

  @override
  String get tourRulePickRightWrongResult =>
      'Pilihan salah — jawaban yang benar disorot, dan kamu kehilangan satu nyawa.';

  @override
  String get tourRulePickRightTimerTitle => 'Waktu Lebih Cepat';

  @override
  String get tourRulePickRightTimerDesc =>
      'Waktu di mode Pilih Benar cepat habis. Lihat apa yang terjadi jika kamu terlalu lambat.';

  @override
  String get tourRulePickRightTimerResult =>
      'Waktu habis lagi — tanpa nyawa yang tersisa, Permainan Berakhir.';

  @override
  String get tourRulePickRightWrapUpTitle => 'Itu Pilih Benar!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Sekarang mari kita coba Mode Pertarungan — di mana kamu bermain melawan lawan sungguhan.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Selamat Datang di Pertarungan';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'Kamu dan lawan bergiliran.\nLencana ini menunjukkan **giliran siapa** — sebagai host, kamu mulai duluan.';

  @override
  String get tourRuleCombatTurnOrderTitle => 'Giliran Siapa?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'Lencana ini menunjukkan giliran siapa. Sebagai host, kamu mulai duluan.';

  @override
  String get tourRuleCombatYourTurnTitle => 'Giliran Anda';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Ketuk angka yang ditampilkan untuk menyelesaikan giliranmu.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Giliran Lawan';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Sekarang perhatikan — lawanmu mengambil giliran mereka.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'Lawanmu menjawab dengan benar! Giliran langsung kembali padamu.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'Satu Nyawa Hilang';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Lihat apa yang terjadi saat lawanmu salah ketuk.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Lawanmu kehilangan satu nyawa — kamu akan melihat jumlah nyawanya berkurang, sama seperti nyawamu.';

  @override
  String get tourRuleCombatTimerTitle => 'Semua Punya Timer';

  @override
  String get tourRuleCombatTimerDesc =>
      'Timermu bekerja sama di sini — lewatkan dan kamu juga kehilangan satu nyawa.';

  @override
  String get tourRuleCombatTimerResult =>
      'Waktu habis! Kehilangan nyawa di Pertarungan sama seperti di Mode Solo.';

  @override
  String get tourRuleCombatWinTitle => 'Kemenangan!';

  @override
  String get tourRuleCombatWinDesc =>
      'Lihat apa yang terjadi saat lawanmu kehabisan nyawa.';

  @override
  String get tourRuleCombatWinResult =>
      'Anda Menang! Menghabiskan nyawa lawanmu akan mengakhiri pertandingan untuk kemenanganmu.';

  @override
  String get tourRuleCombatWrapUpTitle => 'Tutorial Selesai!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'Itu saja semuanya — Mode Solo, Pilih Benar, dan Pertarungan. Semoga berhasil!';

  @override
  String get menuGreeting => 'Uji ingatan dan kemampuan matematikamu hari ini!';

  @override
  String get accountSectionTitle => 'Akun';

  @override
  String get signInTitle => 'Masuk';

  @override
  String get signInSubtitle =>
      'Amankan skor dan peringkatmu — masuk untuk membawanya ke perangkat baru.';

  @override
  String get signInWithGoogle => 'Lanjutkan dengan Google';

  @override
  String get signInWithApple => 'Lanjutkan dengan Apple';

  @override
  String get signOut => 'Keluar';

  @override
  String signedInAs(String account) {
    return 'Masuk sebagai $account';
  }

  @override
  String get playingAsGuest => 'Bermain sebagai tamu';

  @override
  String get signInAction => 'Masuk';

  @override
  String get linkSuccessMessage =>
      'Berhasil masuk. Skormu kini tersimpan di akunmu.';

  @override
  String get linkConflictTitle => 'Akun sudah digunakan';

  @override
  String get linkConflictMessage =>
      'Akun ini sudah ada. Beralih ke akun tersebut akan meninggalkan skor tamu saat ini.';

  @override
  String get linkConflictSwitch => 'Ganti akun';

  @override
  String get authError => 'Gagal masuk. Silakan coba lagi.';

  @override
  String get authErrorCancelled => 'Proses masuk dibatalkan.';

  @override
  String get authErrorNetwork =>
      'Tidak ada koneksi. Periksa jaringanmu lalu coba lagi.';

  @override
  String get authErrorCredentialRejected =>
      'Proses masuk ditolak. Silakan coba lagi.';

  @override
  String get authErrorProviderDisabled =>
      'Metode masuk ini belum tersedia saat ini.';

  @override
  String get authErrorAppleUnavailable =>
      'Masuk dengan Apple tidak tersedia di perangkat ini.';

  @override
  String get authErrorTooManyRequests =>
      'Terlalu banyak percobaan. Tunggu sebentar lalu coba lagi.';

  @override
  String get authErrorAlreadyLinked => 'Akun ini sudah tertaut.';

  @override
  String get authErrorAccountDisabled => 'Akun ini telah dinonaktifkan.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'Email itu sudah dipakai dengan metode masuk lain.';

  @override
  String get authErrorLinkConflict => 'Akun ini sudah milik orang lain.';

  @override
  String get opponentPausedTitle => 'Lawan dijeda';

  @override
  String get opponentPausedBody =>
      'Lawan melipat atau menutup ponselnya. Ronde berlanjut saat mereka kembali.';

  @override
  String get opponentAwayTooLongBody =>
      'Lawan sudah pergi lebih dari satu menit. Klaim kemenangan, atau terus menunggu.';

  @override
  String get claimWin => 'Klaim kemenangan';

  @override
  String get opponentWasAway => 'Lawan pergi terlalu lama';

  @override
  String get youWereAway => 'Kamu pergi terlalu lama';

  @override
  String get tourChapterRegular => 'Klasik';

  @override
  String get tourRuleRegularTypeBackResult =>
      'Benar — itu adalah **satu poin**!';
}
