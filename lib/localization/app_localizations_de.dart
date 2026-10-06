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
  String get lastPlayedLabel => 'Last played';

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
      'Eine kurze Tour: zuerst das **Menü**, dann ein kurzes **Übungsspiel**.\nDu kannst sie jederzeit überspringen.';

  @override
  String get tourStartTitle => 'Starten';

  @override
  String get tourStartDesc =>
      'Tippe auf **Starten**, um zu wählen, wie du spielen möchtest.';

  @override
  String get tourInstantStartTitle => 'Sofortstart';

  @override
  String get tourInstantStartDesc =>
      'Starte direkt ein **Solo**-Spiel mit dem Schwierigkeitsgrad, den du zuletzt gespielt hast.';

  @override
  String get tourSoloTitle => 'Zwei Arten zu spielen';

  @override
  String get tourSoloDesc =>
      '**Solo-Modus**: Spiele allein und knacke deinen Rekord.\n**Kampf-Modus**: Fordere einen Freund in der Nähe per **Bluetooth** heraus — einer erstellt einen Raum, der andere tritt bei.';

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
  String get tourLeaderboardTitle => 'Noch mehr entdecken';

  @override
  String get tourLeaderboardDesc =>
      '**Bestenliste** zeigt die Ranglisten.\nUnter **Einstellungen** änderst du Name, Design, Ton und Sprache.\n**Über** erklärt die Regeln.\nAls Nächstes: ein kurzes **Übungsspiel**!';

  @override
  String get tourSettingsTitle => 'Einstellungen';

  @override
  String get tourSettingsDesc =>
      'Passe alles hier an! Ändere deinen **Benutzernamen**, wähle ein **Theme**, passe **Ton** an, wähle deine **Sprache**. Du kannst diese Tour von hier aus jederzeit neu starten.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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

  @override
  String get tourRuleRegularWelcomeTitle => 'Klassisch';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Merke dir die Zahl und tippe sie dann ein, bevor die Zeit abläuft.\nDu hast **3 Leben** — verlierst du sie alle, endet das Spiel.';

  @override
  String get tourRuleRegularLivesTitle => 'Deine Leben';

  @override
  String get tourRuleRegularLivesDesc =>
      'Du startest mit **3 Leben**. Sie alle zu verlieren beendet das Spiel — also spiel sorgfältig!';

  @override
  String get tourRuleRegularMemorizeTitle => 'Merken';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Schau genau hin — die Zahl blinkt nur kurz auf dem Bildschirm auf, bevor sie verschwindet.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Tippe es ein';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Tippe nun die Ziffer, die du gerade gesehen hast, auf dem Tastenfeld ein.';

  @override
  String get tourRuleRegularScoringTitle => 'Super!';

  @override
  String get tourRuleRegularScoringDesc =>
      'Beantworte weiter richtig, um Punkte zu sammeln.';

  @override
  String get tourRuleRegularScoringResult =>
      'Du hast einen Punkt gewonnen! Jede richtige Antwort erhöht deine Punktzahl.';

  @override
  String get tourRuleRegularTimerTitle => 'Schlage die Zeit';

  @override
  String get tourRuleRegularTimerDesc =>
      'Achte auf den Zeitbalken — wenn er abläuft, bevor du fertig bist, verlierst du ein Leben.';

  @override
  String get tourRuleRegularTimerResult =>
      'Zeit abgelaufen! Keine Zeit mehr zu haben kostet dich ein Leben, genau wie ein falsches Tippen.';

  @override
  String get tourRuleRegularResetTitle => 'Brauchst du eine neue?';

  @override
  String get tourRuleRegularResetDesc =>
      'Tippe auf **Neu starten**, um eine knifflige Aufgabe durch eine neue zu ersetzen — das kostet aber immer ein Leben.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Levelaufstieg';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Beantworte genug Runden richtig und du steigst im Level auf.';

  @override
  String get tourRuleRegularLevelUpResult =>
      'Levelaufstieg! Die Zahlen werden von hier an etwas schwieriger.\nBeende ein Level, ohne ein Leben zu verlieren, um ein **Bonus-Leben** zu erhalten.';

  @override
  String get tourRuleRegularGameOverTitle => 'Spiel vorbei';

  @override
  String get tourRuleRegularGameOverDesc =>
      'Mit nur 1 verbleibenden Leben beendet ein weiterer Fehler das Spiel wirklich. Schau, was passiert.';

  @override
  String get tourRuleRegularWrapUpTitle => 'Das ist Klassisch!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Probieren wir nun den Modus Richtig Wählen aus — eine andere Art zu spielen.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Richtig Wählen';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Hier tippst du nichts ein — tippe auf die **richtige Antwort**.\nDie anderen Optionen sind Lockvögel.';

  @override
  String get tourRulePickRightOptionsTitle => 'Wähle klug';

  @override
  String get tourRulePickRightOptionsDesc =>
      'Einer davon ist richtig — die anderen sind Lockvögel.';

  @override
  String get tourRulePickRightCorrectTitle => 'Tippe auf die richtige';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Tippe auf den Button, den du für richtig hältst.';

  @override
  String get tourRulePickRightCorrectResult =>
      'Richtig! Du hast einen Punkt verdient.';

  @override
  String get tourRulePickRightWrongTitle => 'Hoppla!';

  @override
  String get tourRulePickRightWrongDesc =>
      'Versuche diesmal, auf einen anderen Button zu tippen.';

  @override
  String get tourRulePickRightWrongResult =>
      'Falsche Wahl — die richtige Antwort wird hervorgehoben und du verlierst ein Leben.';

  @override
  String get tourRulePickRightTimerTitle => 'Timer ist schneller';

  @override
  String get tourRulePickRightTimerDesc =>
      'Der Timer im Modus Richtig Wählen läuft schnell ab. Schau, was passiert, wenn du zu langsam bist.';

  @override
  String get tourRulePickRightTimerResult =>
      'Wieder Zeit abgelaufen — ohne verbleibende Leben heißt das Spiel vorbei.';

  @override
  String get tourRulePickRightWrapUpTitle => 'Das ist Richtig Wählen!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Probieren wir nun den Kampf-Modus aus — hier spielst du gegen einen echten Gegner.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Willkommen zum Kampf';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'Du und ein Gegner seid abwechselnd an der Reihe.\nDieses Abzeichen zeigt, **wer dran ist** — als Host beginnst du.';

  @override
  String get tourRuleCombatTurnOrderTitle => 'Wer ist dran?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'Dieses Abzeichen zeigt, wer dran ist. Als Host beginnst du.';

  @override
  String get tourRuleCombatYourTurnTitle => 'Du bist dran';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Tippe auf die angezeigte Ziffer, um deinen Zug zu beenden.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Gegner ist dran';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Schau nun zu — dein Gegner ist an der Reihe.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'Dein Gegner hat richtig geantwortet! Du bist direkt wieder an der Reihe.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'Ein Leben weniger';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Schau, was passiert, wenn dein Gegner einen Tipp verfehlt.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Dein Gegner hat ein Leben verloren — du siehst, wie seine Lebensanzeige sinkt, genau wie deine es würde.';

  @override
  String get tourRuleCombatTimerTitle => 'Jeder hat einen Timer';

  @override
  String get tourRuleCombatTimerDesc =>
      'Dein Timer funktioniert hier genauso — verpasse ihn und du verlierst auch ein Leben.';

  @override
  String get tourRuleCombatTimerResult =>
      'Zeit abgelaufen! Ein Leben im Kampf zu verlieren funktioniert genau wie im Solo-Modus.';

  @override
  String get tourRuleCombatWinTitle => 'Sieg!';

  @override
  String get tourRuleCombatWinDesc =>
      'Schau, was passiert, wenn dein Gegner keine Leben mehr hat.';

  @override
  String get tourRuleCombatWinResult =>
      'Du gewinnst! Wenn dein Gegner keine Leben mehr hat, endet das Match zu deinen Gunsten.';

  @override
  String get tourRuleCombatWrapUpTitle => 'Tutorial beendet!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'Das ist alles — Solo-Modus, Richtig Wählen und Kampf-Modus. Viel Glück da draußen!';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';

  @override
  String get accountSectionTitle => 'Konto';

  @override
  String get signInTitle => 'Anmelden';

  @override
  String get signInSubtitle =>
      'Sichere deine Punkte und deinen Rang – melde dich an, um sie auf ein neues Gerät mitzunehmen.';

  @override
  String get signInWithGoogle => 'Mit Google fortfahren';

  @override
  String get signInWithApple => 'Mit Apple fortfahren';

  @override
  String get signOut => 'Abmelden';

  @override
  String signedInAs(String account) {
    return 'Angemeldet als $account';
  }

  @override
  String get playingAsGuest => 'Als Gast spielen';

  @override
  String get signInAction => 'Anmelden';

  @override
  String get linkSuccessMessage =>
      'Angemeldet. Deine Punkte werden jetzt in deinem Konto gespeichert.';

  @override
  String get linkConflictTitle => 'Konto wird bereits verwendet';

  @override
  String get linkConflictMessage =>
      'Dieses Konto existiert bereits. Beim Wechsel gehen deine aktuellen Gast-Punkte verloren.';

  @override
  String get linkConflictSwitch => 'Konto wechseln';

  @override
  String get authError => 'Anmeldung fehlgeschlagen. Bitte versuche es erneut.';

  @override
  String get authErrorCancelled => 'Anmeldung abgebrochen.';

  @override
  String get authErrorNetwork =>
      'Keine Verbindung. Prüfe dein Netzwerk und versuche es erneut.';

  @override
  String get authErrorCredentialRejected =>
      'Die Anmeldung wurde abgelehnt. Bitte versuche es erneut.';

  @override
  String get authErrorProviderDisabled =>
      'Diese Anmeldemethode ist derzeit nicht verfügbar.';

  @override
  String get authErrorAppleUnavailable =>
      'Mit Apple anmelden ist auf diesem Gerät nicht verfügbar.';

  @override
  String get authErrorTooManyRequests =>
      'Zu viele Versuche. Bitte warte kurz und versuche es erneut.';

  @override
  String get authErrorAlreadyLinked => 'Dieses Konto ist bereits verknüpft.';

  @override
  String get authErrorAccountDisabled => 'Dieses Konto wurde deaktiviert.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'Diese E-Mail wird bereits mit einer anderen Anmeldemethode verwendet.';

  @override
  String get authErrorLinkConflict =>
      'Dieses Konto gehört bereits jemand anderem.';

  @override
  String get opponentPausedTitle => 'Gegner pausiert';

  @override
  String get opponentPausedBody =>
      'Das Handy des Gegners wurde zugeklappt oder geschlossen. Die Runde geht weiter, sobald er zurück ist.';

  @override
  String get opponentAwayTooLongBody =>
      'Der Gegner ist seit über einer Minute weg. Sieg beanspruchen oder weiter warten.';

  @override
  String get claimWin => 'Sieg beanspruchen';

  @override
  String get opponentWasAway => 'Gegner war zu lange weg';

  @override
  String get youWereAway => 'Du warst zu lange weg';

  @override
  String get tourChapterRegular => 'Klassisch';

  @override
  String get tourRuleRegularTypeBackResult =>
      'Richtig — das gibt einen **Punkt**!';
}
