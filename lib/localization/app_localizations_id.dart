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
  String get tourRuleRegularWelcomeTitle => 'Regular Mode';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Memorize the number, then type it back before time runs out.\nYou have **3 lives** — lose them all and the game ends.';

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
      'Level up! Numbers get a little harder from here.\nFinish a level without losing a life to earn a **bonus life**.';

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
      'Here you don\'t type — tap the **right answer**.\nThe other choices are decoys.';

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
      'You and an opponent take turns.\nThis badge shows **whose turn** it is — as host, you go first.';

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
  String get menuGreeting => 'Test your memory and math skills today!';

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
  String get tourRuleRegularTypeBackResult => 'Correct — that\'s a **point**!';
}
