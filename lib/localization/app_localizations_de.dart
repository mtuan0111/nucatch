// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => 'Willkommen!';

  @override
  String welcomeUser(String username) {
    return 'Willkommen $username!';
  }

  @override
  String get mainMenu => 'Hauptmenü';

  @override
  String get start => 'Starten';

  @override
  String get topScore => 'Bestenliste';

  @override
  String get setting => 'Einstellungen';

  @override
  String get about => 'Über';

  @override
  String get exit => 'Verlassen';

  @override
  String get version => 'Version';

  @override
  String get anonymous => 'Anonym';

  @override
  String get level => 'Level';

  @override
  String get score => 'Punktzahl';

  @override
  String get ready => 'Bereit';

  @override
  String get go => 'Los!';

  @override
  String get gameOver => 'Spiel vorbei';

  @override
  String get difficultySetting => 'Schwierigkeitseinstellung';

  @override
  String get difficulty => 'Schwierigkeit';

  @override
  String get easy => 'Leicht';

  @override
  String get medium => 'Mittel';

  @override
  String get hard => 'Schwer';

  @override
  String get veryHard => 'Sehr schwer';

  @override
  String get extreme => 'Extrem';

  @override
  String get selectDifficulty => 'Schwierigkeit wählen';

  @override
  String get selectLevel => 'Level wählen';

  @override
  String get selectLevelMessage =>
      'Wähle das Level, das du spielen möchtest. Je höher das Level, desto schwieriger.';

  @override
  String get yourScoreIs => 'Deine aktuelle Punktzahl ist';

  @override
  String get theCorrectIs => 'Das Richtige ist';

  @override
  String get name => 'Name';

  @override
  String get fontSize => 'Schriftgröße';

  @override
  String get volume => 'Lautstärke';

  @override
  String get vibrate => 'Vibrieren';

  @override
  String get numberOfTopScores => 'Anzahl der Bestenlisten';

  @override
  String get language => 'Sprache';

  @override
  String get thankYou => 'Danke fürs Spielen';

  @override
  String get thankYouMessage =>
      'Danke, dass du unser Spiel gespielt hast. Wir hoffen, es hat dir gefallen. Wenn du Feedback oder Vorschläge hast, lass es uns bitte wissen.';

  @override
  String get authorName => 'Autor';

  @override
  String get connectWithUs => 'Verbinde dich mit uns';

  @override
  String get connectWithUsMessage =>
      'Wenn du Fragen oder Kommentare hast, kannst du uns gerne über unsere Social-Media-Kanäle kontaktieren.';

  @override
  String get introductionContent =>
      'NuCatch ist ein lustiges und fesselndes Denkspiel, das entwickelt wurde, um dein Gedächtnis zu schärfen und den Fokus zu verbessern. Fordere dich selbst heraus, indem du in kurzer Zeit schnell Zahlen fängst, was dir hilft, dich an Dinge wie OTPs, Telefonnummern, Geburtstage und mehr zu erinnern. Genieße das Erlebnis und verbessere deine Gedächtnisfähigkeiten!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'Tritt #NuCatch bei mit $username! Entdecke es jetzt auf $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Entdecke #NuCatch jetzt auf $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Erfahrung mit #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Erfahrung mit $username in #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username hat $point Punkte um $timeCreated erzielt. Tritt #NuCatch bei mit $username!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'Ein Spieler hat $point Punkte um $timeCreated erzielt. Tritt #NuCatch jetzt bei!!';
  }

  @override
  String get confirmExit => 'Bist du sicher, dass du aufhören möchtest?';

  @override
  String get restart => 'Neustart';

  @override
  String get restartGame => 'Spiel neu starten';

  @override
  String get confirmRestart => 'Möchten Sie das Spiel wirklich neu starten?';

  @override
  String get no => 'Nein';

  @override
  String get yes => 'Ja';

  @override
  String get insertedSuccess => 'Runde erfolgreich aufgezeichnet';

  @override
  String get insertedFailed => 'Fehler beim Aufzeichnen deiner Runde';

  @override
  String get scanQrToViewDetails => 'QR-Code scannen, um Details anzuzeigen';

  @override
  String get doYouWantToExit => 'Möchtest du beenden?';

  @override
  String get difficultyEasyDescription =>
      'Erzeugt eine Zufallszahl mit leicht erhöhtem Level für einfache Herausforderungen.';

  @override
  String get difficultyMediumDescription =>
      'Erstellt eine Additions-/Subtraktionsberechnung für moderate Schwierigkeit.';

  @override
  String get difficultyHardDescription =>
      'Erstellt eine Multiplikations-/Divisionsberechnung für fortgeschrittene Schwierigkeit.';

  @override
  String get difficultyExtremeDescription =>
      'Wählt zufällig zwischen einer komplexen Additions-/Subtraktionsberechnung, einer Zufallszahl mit höherem Level oder einer Multiplikations-/Divisionsberechnung für die anspruchsvollste Erfahrung.';

  @override
  String get difficultyEasyTitle => 'Leicht';

  @override
  String get difficultyMediumTitle => 'Mittel';

  @override
  String get difficultyHardTitle => 'Schwer';

  @override
  String get difficultyExtremeTitle => 'Extrem';

  @override
  String get confirmChangeDifficulty =>
      'Deine Runde wird zurückgesetzt. Bist du sicher, dass du die Schwierigkeit ändern möchtest?';

  @override
  String get areYouSure => 'Bist du sicher?';

  @override
  String get no_turn_yet => 'Noch keine Runden';

  @override
  String get daily => 'An einem Tag';

  @override
  String get dailyDescription =>
      'Ranglisten basierend auf heute aufgezeichneten Runden.';

  @override
  String get weekly => 'In einer Woche';

  @override
  String get weeklyDescription =>
      'Ranglisten basierend auf in den letzten 7 Tagen aufgezeichneten Runden.';

  @override
  String get allTime => 'Gesamte Zeit';

  @override
  String get allTimeDescription =>
      'Ranglisten basierend auf allen aufgezeichneten Runden.';

  @override
  String get updateRequired => 'Update erforderlich';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get currentVersion => 'Aktuelle Version';

  @override
  String get newVersion => 'Neue Version';

  @override
  String get whatsNew => 'Was ist neu';

  @override
  String get forceUpdateMessage =>
      'Dieses Update ist erforderlich, um die App weiter nutzen zu können. Bitte jetzt aktualisieren.';

  @override
  String get later => 'Später';

  @override
  String get updateNow => 'Jetzt aktualisieren';

  @override
  String get update => 'Aktualisieren';

  @override
  String get checkForUpdates => 'Nach Updates suchen';

  @override
  String get appUpdates => 'App-Updates';

  @override
  String get tapToCheckUpdates =>
      'Tippe auf die Schaltfläche unten, um nach App-Updates zu suchen.';

  @override
  String get checkingForUpdates => 'Suche nach Updates...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Neue Version $version verfügbar! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Dieses Update ist erforderlich.';

  @override
  String get usingLatestVersion => 'Du verwendest die neueste Version!';

  @override
  String unableToCheckUpdates(String error) {
    return 'Fehler beim Suchen nach Updates. $error';
  }

  @override
  String get tryAgainLater => 'Bitte versuche es später noch einmal.';

  @override
  String get updatePostponed => 'Update verfügbar, aber verschoben.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'Du hast $totalSeconds Sekunden Zeit, um auf eine Zahl zu tippen. Der Balken ändert seine Farbe, wenn die Zeit abläuft: Grün (über ${halfSeconds}s), Orange ($quarterSeconds-${halfSeconds}s), Rot (unter ${quarterSeconds}s).';
  }

  @override
  String get selectPlayMode => 'Spielmodus wählen';

  @override
  String get soloMode => 'Solo-Modus';

  @override
  String get soloModeDescription =>
      'Spiele alleine und fordere dich heraus, deinen Highscore zu schlagen';

  @override
  String get combatMode => 'Kampf-Modus';

  @override
  String get combatModeDescription =>
      'Spiele mit einem anderen Spieler über Bluetooth und wechsle dich ab';

  @override
  String get createRoom => 'Raum erstellen';

  @override
  String get createRoomDescription =>
      'Hoste ein neues Spiel und warte darauf, dass ein anderer Spieler beitritt';

  @override
  String get joinRoom => 'Raum beitreten';

  @override
  String get joinRoomDescription =>
      'Gib einen Raumcode ein, um einem bestehenden Spiel beizutreten';

  @override
  String get hostRoom => 'Host-Raum';

  @override
  String get roomCode => 'Raumcode';

  @override
  String get shareCodeWithPlayer =>
      'Teile diesen Code mit einem anderen Spieler';

  @override
  String get enterRoomCode => 'Raumcode eingeben';

  @override
  String get connect => 'Verbinden';

  @override
  String get searchingForPlayers => 'Suche nach Spielern...';

  @override
  String pairedWith(String playerName) {
    return 'Gepaart mit $playerName!';
  }

  @override
  String get bluetoothPermissionRequired =>
      'Bluetooth-Berechtigung erforderlich';

  @override
  String get bluetoothPermissionMessage =>
      'Der Kampf-Modus erfordert Bluetooth-Berechtigungen, um sich mit anderen Spielern zu verbinden. Bitte gewähre Bluetooth-Berechtigungen in den Einstellungen deines Geräts.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Bluetooth-Berechtigungen wurden dauerhaft verweigert. Um den Kampf-Modus zu nutzen, musst du Bluetooth-Berechtigungen in den Einstellungen deines Geräts aktivieren.\n\nBitte gehe zu Einstellungen > NuCatch > Berechtigungen und aktiviere Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth deaktiviert';

  @override
  String get bluetoothDisabledMessage =>
      'Der Kampf-Modus erfordert, dass Bluetooth aktiviert ist. Bitte aktiviere Bluetooth in den Einstellungen deines Geräts.';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get grantPermission => 'Berechtigung gewähren';

  @override
  String get checkAgain => 'Erneut prüfen';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get yourTurn => 'Du bist dran';

  @override
  String get opponentTurn => 'Gegner ist dran';

  @override
  String get waitingForOpponent => 'Warte auf Gegner...';

  @override
  String get watchingOpponent => 'Beobachte deinen Gegner';

  @override
  String get youWin => 'Du gewinnst!';

  @override
  String get youLose => 'Du verlierst!';

  @override
  String get opponentDisconnected => 'Gegner getrennt';

  @override
  String get opponentRanOutOfLives => 'Gegner hat keine Leben mehr';

  @override
  String get opponentGaveUp => 'Dein Gegner hat aufgegeben';

  @override
  String get confirmEndCombat =>
      'Bist du sicher, dass du dieses Spiel beenden möchtest? Dein Gegner wird gewinnen.';

  @override
  String get youRanOutOfLives => 'Du hast keine Leben mehr';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Heute ist $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Neujahr';

  @override
  String get greetingNewYear => 'Frohes Neues Jahr!';

  @override
  String get holidayLunarNewYear => 'Mondneujahr';

  @override
  String get greetingLunarNewYear => 'Frohes Mondneujahr!';

  @override
  String get holidayValentine => 'Valentinstag';

  @override
  String get greetingValentine => 'Fröhlichen Valentinstag!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => 'Fröhliches Holi!';

  @override
  String get holidayEarthDay => 'Tag der Erde';

  @override
  String get greetingEarthDay =>
      'Fröhlichen Tag der Erde! Schütze unseren Planeten!';

  @override
  String get holidayEaster => 'Ostern';

  @override
  String get greetingEaster => 'Frohe Ostern!';

  @override
  String get holidayPride => 'Pride-Monat';

  @override
  String get greetingPride => 'Fröhlichen Pride-Monat! Liebe ist Liebe!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => 'Fröhliches Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => 'Fröhliches Diwali!';

  @override
  String get holidayHanukkah => 'Chanukka';

  @override
  String get greetingHanukkah => 'Fröhliches Chanukka!';

  @override
  String get holidayChristmas => 'Weihnachten';

  @override
  String get greetingChristmas => 'Frohe Weihnachten!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => 'Fröhliches Kwanzaa!';

  @override
  String get playAgain => 'Nochmal spielen';

  @override
  String get returnToMenu => 'Zum Menü zurückkehren';

  @override
  String get doYouReadyForRestart => 'Bist du bereit für einen Neustart?';

  @override
  String get notReady => 'Nicht bereit';

  @override
  String get you => 'Du';

  @override
  String get opponent => 'Gegner';

  @override
  String get waiting => 'Warten';

  @override
  String get youWillTakeFirst => 'Du bist zuerst dran!';

  @override
  String get opponentWillTakeFirst => 'Der Gegner ist zuerst dran';

  @override
  String get advertisingRoomWaiting =>
      'Raum wird beworben! Warte auf Gegner...';

  @override
  String get opponentJoinedReady =>
      'Gegner beigetreten! Drücke Bereit, wenn du vorbereitet bist.';

  @override
  String get opponentReady => 'Gegner bereit!';

  @override
  String get ok => 'OK';

  @override
  String get bothPlayersReady => 'Beide Spieler bereit!';

  @override
  String get searchingForHosts => 'Suche nach Hosts...';

  @override
  String connectingToHost(String hostName) {
    return 'Verbinde mit $hostName...';
  }

  @override
  String get hostReady => 'Host bereit!';

  @override
  String get theHostIsReady => '✅ Der Host ist bereit!';

  @override
  String get pressReadyWhenPrepared =>
      'Drücke Bereit, wenn du bereit bist zu starten.';

  @override
  String get yourOpponentIsReady => '✅ Dein Gegner ist bereit!';

  @override
  String get gameIsStarting => 'Spiel startet...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'Warte darauf, dass der Host die Schwierigkeit wählt...';

  @override
  String get failedToInitializeNearby =>
      'Fehler beim Initialisieren von Nearby Connections. Bitte Standortberechtigungen gewähren.';

  @override
  String get nearbyNotInitialized =>
      'Nearby Connections ist nicht initialisiert';

  @override
  String failedToStartAdvertising(String error) {
    return 'Fehler beim Starten der Werbung: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Fehler beim Setzen von Bereit: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Fehler beim Starten des Spiels: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Werbe Raum...\nWarte darauf, dass der Gegner entdeckt und verbindet.';

  @override
  String get opponentConnectedStatus =>
      'Gegner verbunden!\nDrücke Bereit, wenn beide Spieler bereit sind.';

  @override
  String get bothPlayersReadyStatus => 'Beide Spieler bereit! Spiel startet...';

  @override
  String get settingUpDifficulty => 'Richte Spielschwierigkeit ein...';

  @override
  String get advertisingAs => 'Werbe als:';

  @override
  String get connectedViaNearby => 'Verbunden über Nearby';

  @override
  String get advertising => 'Werbe...';

  @override
  String get selectHostToConnect => 'Wähle einen Host zum Verbinden';

  @override
  String availableHosts(int count) {
    return 'Verfügbare Hosts ($count)';
  }

  @override
  String get tapToConnect => 'Tipp zum Verbinden';

  @override
  String get noHostsFoundNearby => 'Keine Hosts in der Nähe gefunden';

  @override
  String get makeSureFriendHosting =>
      'Stelle sicher, dass ein Freund hostet\nund beide Geräte nah beieinander sind';

  @override
  String get discovering => 'Entdecke...';

  @override
  String get notDiscovering => 'Entdecke nicht';

  @override
  String get distanceWarning =>
      'Stelle sicher, dass die Geräte weniger als 10 Meter entfernt sind';

  @override
  String get tourButtonLabel => 'Tour starten';

  @override
  String get tourWelcomeTitle => 'Willkommen bei NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Willkommen! Diese kurze Tour hilft Ihnen, problemlos mit **NuCatch** zu beginnen. Wir zeigen Ihnen alle **Hauptfunktionen**, damit Sie sofort loslegen und spielen können. Los geht\'s!';

  @override
  String get tourStartTitle => 'Start - Beginne dein Spiel';

  @override
  String get tourStartDesc =>
      'Tippe auf die **Start-Schaltfläche**, um zu beginnen. Dann wählst du zwischen **Einzelmodus** für mathematische Herausforderungen oder **Kampfmodus** für Echtzeit-Multiplayer-Kämpfe über **Bluetooth**. Lass uns beide Optionen erkunden!';

  @override
  String get tourSoloTitle => 'Einzelmodus - Alleine spielen';

  @override
  String get tourSoloDesc =>
      'Im Einzelmodus fordere dich selbst mit mathematischen Gleichungen heraus! Wähle aus 4 Schwierigkeitsgraden (Leicht bis Extrem Schwer). Du startest mit 3 Leben - jede falsche Antwort oder Zeitüberschreitung kostet 1 Leben. Höhere Schwierigkeit bedeutet mehr Punkte! Schauen wir uns jetzt die Multiplayer-Option an.';

  @override
  String get tourCombatTitle => 'Kampfmodus - Bluetooth-Multiplayer';

  @override
  String get tourCombatDesc =>
      'Der Kampfmodus ermöglicht dir, gegen einen Freund über Bluetooth zu kämpfen! Zwei Spieler lösen abwechselnd Gleichungen - kein WLAN erforderlich, bleibe nur innerhalb von 10 Metern. Der Gastgeber spielt zunächst zuerst, aber bei Rückspielen beginnt der Verlierer. Du hast zwei Möglichkeiten, ein Match zu starten:';

  @override
  String get tourCreateRoomTitle => 'Kampfmodus → Raum erstellen';

  @override
  String get tourCreateRoomDesc =>
      'Erste Option: Raum erstellen macht dich zum Gastgeber! Nach Erteilung der Bluetooth-Berechtigungen wartest du auf einen Gast, der deinem Raum beitritt, dann wählst du den Schwierigkeitsgrad. Als Gastgeber spielst du im ersten Match zuerst. Oder du kannst dem Spiel eines anderen beitreten:';

  @override
  String get tourJoinRoomTitle => 'Kampfmodus → Raum beitreten';

  @override
  String get tourJoinRoomDesc =>
      'Zweite Option: Raum beitreten macht dich zum Gast! Nach Erteilung der Berechtigungen scannst du nach nahegelegenen Räumen, wählst einen aus und tippst auf Bereit. Der Gastgeber wählt die Schwierigkeit, und du spielst im ersten Match als Zweiter. Schauen wir uns jetzt die anderen Menüfunktionen an.';

  @override
  String get tourLeaderboardTitle => 'Top-Score - Bestenlisten';

  @override
  String get tourLeaderboardDesc =>
      'Verfolge hier deinen Fortschritt! Sieh dir globale Rankings, deine persönlichen Rekorde und Statistiken an, einschließlich gespielter Spiele, Gewinnrate, Genauigkeit und Punktzahlen nach Schwierigkeitsgrad. Vergleiche dich mit Freunden und beobachte, wie du dich im Laufe der Zeit verbesserst. Abschließend besuchen wir die Einstellungen.';

  @override
  String get tourSettingsTitle => 'Einstellungen - Anpassen';

  @override
  String get tourSettingsDesc =>
      'Passe hier alles an! Ändere deinen Benutzernamen, wähle ein Design, passe Sound/Musik an, wähle deine Sprache und verwalte Datenschutzeinstellungen. Du kannst diese Tour jederzeit von hier aus neu starten. Das war\'s - du bist bereit zum Spielen!';

  @override
  String get tourNext => 'Weiter';

  @override
  String get tourPrevious => 'Zurück';

  @override
  String get tourSkip => 'Tour überspringen';

  @override
  String get tourFinish => 'Fertig';

  @override
  String get tourRestartFromSettings => 'Tour neu starten';

  @override
  String get tourResetMessage =>
      'Die Tour wurde zurückgesetzt. Kehren Sie zum Hauptmenü zurück, um zu beginnen.';
}
