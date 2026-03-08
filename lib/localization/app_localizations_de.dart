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
  String get instantStart => 'Sofortstart';

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
  String get whichOneIsCorrect => 'Welche ist richtig?';

  @override
  String get numberOfTopScores => 'Anzahl der Bestenlisten';

  @override
  String get onlyShowMyRecorded => 'Nur meine Aufzeichnungen anzeigen';

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
  String get restartGame => 'Neustart';

  @override
  String get confirmRestart => 'Möchten Sie das Spiel wirklich neu starten?';

  @override
  String get insertedSuccess => 'Runde erfolgreich aufgezeichnet';

  @override
  String get insertedFailed => 'Fehler beim Aufzeichnen deiner Runde';

  @override
  String get scanQrToViewDetails => 'QR-Code scannen, um Details anzuzeigen';

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
  String get pickRightDescription =>
      'Wähle die richtige Gleichung! Schnelles Auswahlspiel mit 5-Sekunden-Timer.';

  @override
  String get difficultyEasyTitle => 'Leicht';

  @override
  String get difficultyMediumTitle => 'Mittel';

  @override
  String get difficultyHardTitle => 'Schwer';

  @override
  String get difficultyExtremeTitle => 'Extrem';

  @override
  String get pickRightTitle => 'Richtig Wählen';

  @override
  String get confirmChangeDifficulty =>
      'Deine Runde wird zurückgesetzt. Bist du sicher, dass du die Schwierigkeit ändern möchtest?';

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
  String get doYouReadyForRestart => 'Bist du bereit für einen Neustart?';

  @override
  String get notReady => 'Nicht bereit';

  @override
  String get you => 'Du';

  @override
  String get opponent => 'Gegner';

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
  String get tourButtonLabel => 'Tour Starten';

  @override
  String get tourWelcomeTitle => 'Willkommen bei NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Willkommen! Diese kurze Tour hilft dir, reibungslos mit **NuCatch** zu beginnen. Wir zeigen dir alle **Hauptfunktionen**, damit du sofort einsteigen und losspielen kannst.';

  @override
  String get tourStartTitle => 'Start - Beginne dein Spiel';

  @override
  String get tourStartDesc =>
      'Tippe auf den **Start-Button**, um zu beginnen. Du wählst dann zwischen dem **Solo-Modus** für einzelne Mathe-Herausforderungen oder dem **Kampf-Modus** für Echtzeit-Multiplayer über **Bluetooth**.';

  @override
  String get tourInstantStartTitle => 'Sofortstart';

  @override
  String get tourInstantStartDesc =>
      'Tippe auf den Button **Sofortstart**, um sofort ein Solo-Spiel mit dem gleichen Schwierigkeitsgrad wie beim letzten Mal zu beginnen. Es ist der schnellste Weg, um deinen Fortschritt fortzusetzen!';

  @override
  String get tourSoloTitle => 'Solo-Modus';

  @override
  String get tourSoloDesc =>
      'Fordere dich im **Solo-Modus** heraus. Wähle aus **4 Schwierigkeitsgraden**. Du startest mit **3 Leben** - jede falsche Antwort oder Zeitüberschreitung kostet 1 Leben. **Höhere Schwierigkeit** bedeutet mehr Punkte!';

  @override
  String get tourCombatTitle => 'Kampf-Modus - Bluetooth Multiplayer';

  @override
  String get tourCombatDesc =>
      'Mit dem **Kampf-Modus** kannst du über **Bluetooth** gegen einen Freund antreten! **Zwei Spieler** lösen abwechselnd Gleichungen - **kein WLAN erforderlich**, bleib einfach innerhalb von **10 Metern**.';

  @override
  String get tourCreateRoomTitle => 'Kampf-Modus → Raum Erstellen';

  @override
  String get tourCreateRoomDesc =>
      '**Raum Erstellen** macht dich zum **Gastgeber**. Nachdem du **Bluetooth-Berechtigungen** erteilt hast, wartest du darauf, dass ein Gast beigetreten ist, und wählst dann den **Schwierigkeitsgrad**. Du spielst als Erster.';

  @override
  String get tourJoinRoomTitle => 'Kampf-Modus → Raum Beitreten';

  @override
  String get tourJoinRoomDesc =>
      '**Raum Beitreten** macht dich zum **Gast**. Du scannst nach Räumen in der Nähe, wählst einen aus und tippst auf **Bereit**. Der Gastgeber wählt die Schwierigkeit, und du spielst als Zweiter.';

  @override
  String get tourLeaderboardTitle => 'Bestenliste';

  @override
  String get tourLeaderboardDesc =>
      'Verfolge hier deinen Fortschritt! Sieh dir **globale Ranglisten**, deine **persönlichen Rekorde** und **Statistiken** an. Vergleiche dich mit Freunden und beobachte, wie du dich verbesserst.';

  @override
  String get tourSettingsTitle => 'Einstellungen';

  @override
  String get tourSettingsDesc =>
      'Passe alles hier an! Ändere deinen **Benutzernamen**, wähle ein **Theme**, passe **Ton** an, wähle deine **Sprache**. Du kannst diese Tour von hier aus jederzeit neu starten.';

  @override
  String get tourNext => 'Weiter';

  @override
  String get tourPrevious => 'Zurück';

  @override
  String get tourSkip => 'Überspringen';

  @override
  String get tourFinish => 'Fertig';

  @override
  String get tourRestartFromSettings => 'Tour Neustarten';

  @override
  String get tourResetMessage =>
      'Die Tour wurde zurückgesetzt. Kehre zum Hauptmenü zurück, um zu beginnen.';
}
