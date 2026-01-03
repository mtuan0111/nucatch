// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => 'Bienvenue !';

  @override
  String welcomeUser(String username) {
    return 'Bienvenue $username !';
  }

  @override
  String get mainMenu => 'Menu Principal';

  @override
  String get start => 'Commencer';

  @override
  String get topScore => 'Meilleur Score';

  @override
  String get setting => 'Paramètres';

  @override
  String get about => 'À propos';

  @override
  String get exit => 'Quitter';

  @override
  String get version => 'Version';

  @override
  String get anonymous => 'Anonyme';

  @override
  String get level => 'Niveau';

  @override
  String get score => 'Score';

  @override
  String get ready => 'Prêt';

  @override
  String get go => 'Partez !';

  @override
  String get gameOver => 'Jeu Terminé';

  @override
  String get difficultySetting => 'Réglage de la difficulté';

  @override
  String get difficulty => 'Difficulté';

  @override
  String get easy => 'Facile';

  @override
  String get medium => 'Moyen';

  @override
  String get hard => 'Difficile';

  @override
  String get veryHard => 'Très Difficile';

  @override
  String get extreme => 'Extrême';

  @override
  String get selectDifficulty => 'Sélectionner la difficulté';

  @override
  String get selectLevel => 'Sélectionner le niveau';

  @override
  String get selectLevelMessage =>
      'Choisissez le niveau auquel vous voulez jouer. Plus le niveau est élevé, plus c\'est difficile.';

  @override
  String get yourScoreIs => 'Votre score actuel est';

  @override
  String get theCorrectIs => 'La bonne réponse est';

  @override
  String get name => 'Nom';

  @override
  String get fontSize => 'Taille de la police';

  @override
  String get volume => 'Volume';

  @override
  String get vibrate => 'Vibrer';

  @override
  String get numberOfTopScores => 'Nombre de meilleurs scores';

  @override
  String get language => 'Langue';

  @override
  String get thankYou => 'Merci d\'avoir joué';

  @override
  String get thankYouMessage =>
      'Merci de jouer à notre jeu. Nous espérons que vous l\'avez apprécié. Si vous avez des commentaires ou des suggestions, n\'hésitez pas à nous le faire savoir.';

  @override
  String get authorName => 'Auteur';

  @override
  String get connectWithUs => 'Connectez-vous avec nous';

  @override
  String get connectWithUsMessage =>
      'Si vous avez des questions ou des commentaires, n\'hésitez pas à nous contacter sur nos réseaux sociaux.';

  @override
  String get introductionContent =>
      'NuCatch est un jeu d\'esprit amusant et engageant conçu pour aiguiser votre mémoire et améliorer votre concentration. Mettez-vous au défi d\'attraper rapidement des chiffres en peu de temps, vous aidant à mémoriser des choses comme des OTP, des numéros de téléphone, des anniversaires et plus encore. Profitez de l\'expérience et boostez vos compétences de mémoire !';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return 'Rejoignez #NuCatch avec $username ! Explorez-le maintenant sur $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Explorez #NuCatch maintenant sur $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Expérience avec #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Expérience avec $username sur #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username a obtenu $point points à $timeCreated. Rejoignez #NuCatch avec $username !!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'Un joueur a obtenu $point points à $timeCreated. Rejoignez #NuCatch maintenant !!';
  }

  @override
  String get confirmExit => 'Êtes-vous sûr de vouloir quitter ?';

  @override
  String get restart => 'Restart';

  @override
  String get restartGame => 'Restart Game';

  @override
  String get confirmRestart => 'Are you sure you want to restart the game?';

  @override
  String get no => 'Non';

  @override
  String get yes => 'Oui';

  @override
  String get insertedSuccess => 'Tour enregistré avec succès';

  @override
  String get insertedFailed => 'Échec de l\'enregistrement de votre tour';

  @override
  String get scanQrToViewDetails => 'Scannez le code QR pour voir les détails';

  @override
  String get doYouWantToExit => 'Voulez-vous quitter ?';

  @override
  String get difficultyEasyDescription =>
      'Génère un nombre aléatoire avec un niveau légèrement augmenté pour des défis simples.';

  @override
  String get difficultyMediumDescription =>
      'Produit une expression de calcul d\'addition/soustraction pour une difficulté modérée.';

  @override
  String get difficultyHardDescription =>
      'Crée une expression de calcul de multiplication/division pour une difficulté avancée.';

  @override
  String get difficultyExtremeDescription =>
      'Choisit aléatoirement entre générer un calcul complexe d\'addition/soustraction, un nombre aléatoire de plus haut niveau ou un calcul de multiplication/division pour l\'expérience la plus difficile.';

  @override
  String get difficultyEasyTitle => 'Mode Facile';

  @override
  String get difficultyMediumTitle => 'Mode Moyen';

  @override
  String get difficultyHardTitle => 'Mode Difficile';

  @override
  String get difficultyExtremeTitle => 'Mode Extrême';

  @override
  String get confirmChangeDifficulty =>
      'Votre tour sera réinitialisé. Êtes-vous sûr de vouloir changer la difficulté ?';

  @override
  String get areYouSure => 'Êtes-vous sûr ?';

  @override
  String get no_turn_yet => 'Pas encore de tours';

  @override
  String get daily => 'En un jour';

  @override
  String get dailyDescription =>
      'Classements basés sur les tours enregistrés aujourd\'hui.';

  @override
  String get weekly => 'En une semaine';

  @override
  String get weeklyDescription =>
      'Classements basés sur les tours enregistrés au cours des 7 derniers jours.';

  @override
  String get allTime => 'Tout le temps';

  @override
  String get allTimeDescription =>
      'Classements basés sur tous les tours enregistrés.';

  @override
  String get updateRequired => 'Mise à jour requise';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get currentVersion => 'Version actuelle';

  @override
  String get newVersion => 'Nouvelle version';

  @override
  String get whatsNew => 'Nouveautés';

  @override
  String get forceUpdateMessage =>
      'Cette mise à jour est nécessaire pour continuer à utiliser l\'application. Veuillez mettre à jour maintenant.';

  @override
  String get later => 'Plus tard';

  @override
  String get updateNow => 'Mettre à jour maintenant';

  @override
  String get update => 'Mettre à jour';

  @override
  String get checkForUpdates => 'Vérifier les mises à jour';

  @override
  String get appUpdates => 'Mises à jour de l\'application';

  @override
  String get tapToCheckUpdates =>
      'Appuyez sur le bouton ci-dessous pour vérifier les mises à jour de l\'application.';

  @override
  String get checkingForUpdates => 'Recherche de mises à jour...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'Nouvelle version $version disponible ! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Cette mise à jour est obligatoire.';

  @override
  String get usingLatestVersion => 'Vous utilisez la dernière version !';

  @override
  String unableToCheckUpdates(String error) {
    return 'Impossible de vérifier les mises à jour. $error';
  }

  @override
  String get tryAgainLater => 'Veuillez réessayer plus tard.';

  @override
  String get updatePostponed => 'Mise à jour disponible mais reportée.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'Vous avez $totalSeconds secondes pour toucher un nombre. La barre change de couleur au fur et à mesure que le temps s\'écoule : vert (plus de ${halfSeconds}s), orange ($quarterSeconds-${halfSeconds}s), rouge (moins de ${quarterSeconds}s).';
  }

  @override
  String get selectPlayMode => 'Sélectionner le mode de jeu';

  @override
  String get soloMode => 'Mode Solo';

  @override
  String get soloModeDescription =>
      'Jouez seul et mettez-vous au défi de battre votre meilleur score';

  @override
  String get combatMode => 'Mode Combat';

  @override
  String get combatModeDescription =>
      'Jouez avec un autre joueur via une connexion Bluetooth et jouez tour à tour';

  @override
  String get createRoom => 'Créer une salle';

  @override
  String get createRoomDescription =>
      'Hébergez un nouveau jeu et attendez qu\'un autre joueur rejoigne';

  @override
  String get joinRoom => 'Rejoindre une salle';

  @override
  String get joinRoomDescription =>
      'Entrez un code de salle pour rejoindre un jeu existant';

  @override
  String get hostRoom => 'Salle d\'hôte';

  @override
  String get roomCode => 'Code de la salle';

  @override
  String get shareCodeWithPlayer => 'Partagez ce code avec un autre joueur';

  @override
  String get enterRoomCode => 'Entrer le code de la salle';

  @override
  String get connect => 'Se connecter';

  @override
  String get searchingForPlayers => 'Recherche de joueurs...';

  @override
  String pairedWith(String playerName) {
    return 'Apparié avec $playerName !';
  }

  @override
  String get bluetoothPermissionRequired => 'Permission Bluetooth requise';

  @override
  String get bluetoothPermissionMessage =>
      'Le mode Combat nécessite l\'autorisation Bluetooth pour se connecter avec d\'autres joueurs. Veuillez accorder l\'autorisation Bluetooth dans les paramètres de votre appareil.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Les autorisations Bluetooth ont été refusées de manière permanente. Pour utiliser le mode Combat, vous devez activer les autorisations Bluetooth dans les paramètres de votre appareil.\n\nVeuillez aller dans Paramètres > NuCatch > Autorisations et activer le Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth désactivé';

  @override
  String get bluetoothDisabledMessage =>
      'Le mode Combat nécessite que le Bluetooth soit activé. Veuillez activer le Bluetooth dans les paramètres de votre appareil.';

  @override
  String get cancel => 'Annuler';

  @override
  String get grantPermission => 'Accorder la permission';

  @override
  String get checkAgain => 'Vérifier à nouveau';

  @override
  String get openSettings => 'Ouvrir les paramètres';

  @override
  String get yourTurn => 'À votre tour';

  @override
  String get opponentTurn => 'Tour de l\'adversaire';

  @override
  String get waitingForOpponent => 'En attente de l\'adversaire...';

  @override
  String get watchingOpponent => 'Regardez votre adversaire';

  @override
  String get youWin => 'Vous avez gagné !';

  @override
  String get youLose => 'Vous avez perdu !';

  @override
  String get opponentDisconnected => 'Adversaire déconnecté';

  @override
  String get opponentRanOutOfLives => 'L\'adversaire n\'a plus de vies';

  @override
  String get opponentGaveUp => 'Votre adversaire a abandonné';

  @override
  String get confirmEndCombat =>
      'Êtes-vous sûr de vouloir terminer ce jeu ? Votre adversaire gagnera.';

  @override
  String get youRanOutOfLives => 'Vous n\'avez plus de vies';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Aujourd\'hui, c\'est $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Nouvel An';

  @override
  String get greetingNewYear => 'Bonne Année !';

  @override
  String get holidayLunarNewYear => 'Nouvel An Lunaire';

  @override
  String get greetingLunarNewYear => 'Bonne Année Lunaire !';

  @override
  String get holidayValentine => 'Saint-Valentin';

  @override
  String get greetingValentine => 'Joyeuse Saint-Valentin !';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => 'Joyeux Holi !';

  @override
  String get holidayEarthDay => 'Jour de la Terre';

  @override
  String get greetingEarthDay =>
      'Joyeux Jour de la Terre ! Protégez notre planète !';

  @override
  String get holidayEaster => 'Pâques';

  @override
  String get greetingEaster => 'Joyeuses Pâques !';

  @override
  String get holidayPride => 'Mois des Fiertés';

  @override
  String get greetingPride =>
      'Joyeux Mois des Fiertés ! L\'amour est l\'amour !';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => 'Joyeux Halloween !';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => 'Joyeux Diwali !';

  @override
  String get holidayHanukkah => 'Hanoucca';

  @override
  String get greetingHanukkah => 'Joyeux Hanoucca !';

  @override
  String get holidayChristmas => 'Noël';

  @override
  String get greetingChristmas => 'Joyeux Noël !';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => 'Joyeux Kwanzaa !';

  @override
  String get playAgain => 'Rejouer';

  @override
  String get returnToMenu => 'Retour au menu';

  @override
  String get doYouReadyForRestart => 'Êtes-vous prêt pour redémarrer ?';

  @override
  String get notReady => 'Pas Prêt';

  @override
  String get you => 'Vous';

  @override
  String get opponent => 'Adversaire';

  @override
  String get waiting => 'En attente';

  @override
  String get youWillTakeFirst => 'Vous prendrez le premier tour !';

  @override
  String get opponentWillTakeFirst => 'L\'adversaire prendra le premier tour';

  @override
  String get advertisingRoomWaiting =>
      'Salle diffusée ! En attente de l\'adversaire...';

  @override
  String get opponentJoinedReady =>
      'Adversaire rejoint ! Appuyez sur Prêt lorsque vous êtes préparé.';

  @override
  String get opponentReady => 'Adversaire Prêt !';

  @override
  String get ok => 'OK';

  @override
  String get bothPlayersReady => 'Les deux joueurs sont prêts !';

  @override
  String get searchingForHosts => 'Recherche d\'hôtes...';

  @override
  String connectingToHost(String hostName) {
    return 'Connexion à $hostName...';
  }

  @override
  String get hostReady => 'Hôte Prêt !';

  @override
  String get theHostIsReady => '✅ L\'hôte est prêt !';

  @override
  String get pressReadyWhenPrepared =>
      'Appuyez sur Prêt lorsque vous êtes prêt à commencer.';

  @override
  String get yourOpponentIsReady => '✅ Votre adversaire est prêt !';

  @override
  String get gameIsStarting => 'Le jeu commence...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'En attente que l\'hôte sélectionne la difficulté...';

  @override
  String get failedToInitializeNearby =>
      'Échec de l\'initialisation de Nearby Connections. Veuillez accorder les autorisations de localisation.';

  @override
  String get nearbyNotInitialized => 'Nearby Connections n\'est pas initialisé';

  @override
  String failedToStartAdvertising(String error) {
    return 'Échec du démarrage de la diffusion : $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Échec de la définition de l\'état Prêt : $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Échec du démarrage du jeu : $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Diffusion de la salle...\nEn attente de la découverte et de la connexion de l\'adversaire.';

  @override
  String get opponentConnectedStatus =>
      'Adversaire connecté !\nAppuyez sur Prêt lorsque les deux joueurs sont prêts.';

  @override
  String get bothPlayersReadyStatus =>
      'Les deux joueurs sont prêts ! Démarrage du jeu...';

  @override
  String get settingUpDifficulty => 'Configuration de la difficulté du jeu...';

  @override
  String get advertisingAs => 'Diffusion en tant que :';

  @override
  String get connectedViaNearby => 'Connecté via Nearby';

  @override
  String get advertising => 'Diffusion...';

  @override
  String get selectHostToConnect => 'Sélectionnez un hôte pour vous connecter';

  @override
  String availableHosts(int count) {
    return 'Hôtes Disponibles ($count)';
  }

  @override
  String get tapToConnect => 'Appuyez pour vous connecter';

  @override
  String get noHostsFoundNearby => 'Aucun hôte trouvé à proximité';

  @override
  String get makeSureFriendHosting =>
      'Assurez-vous qu\'un ami héberge\net que les deux appareils sont proches l\'un de l\'autre';

  @override
  String get discovering => 'Découverte...';

  @override
  String get notDiscovering => 'Pas de découverte';

  @override
  String get distanceWarning =>
      'Assurez-vous que les appareils sont à moins de 10 mètres de distance';

  @override
  String get tourButtonLabel => 'Démarrer la visite';

  @override
  String get tourWelcomeTitle => 'Bienvenue sur NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Bienvenue! Cette visite rapide vous aidera à démarrer en douceur avec **NuCatch**. Nous vous montrerons toutes les **fonctionnalités principales** pour que vous puissiez vous lancer et commencer à jouer immédiatement. Commençons!';

  @override
  String get tourStartTitle => 'Démarrer - Commencez votre jeu';

  @override
  String get tourStartDesc =>
      'Appuyez sur le bouton Démarrer pour commencer. Vous choisirez ensuite entre le Mode Solo pour des défis mathématiques en solo, ou le Mode Combat pour des batailles multijoueurs en temps réel via Bluetooth. Explorons les deux options!';

  @override
  String get tourSoloTitle => 'Mode Solo - Jouez seul';

  @override
  String get tourSoloDesc =>
      'En Mode Solo, défiez-vous avec des équations mathématiques! Choisissez parmi 4 niveaux de difficulté (Facile à Extrêmement Difficile). Vous commencez avec 3 vies - chaque mauvaise réponse ou expiration coûte 1 vie. Plus la difficulté est élevée, plus vous gagnez de points! Voyons maintenant l\'option multijoueur.';

  @override
  String get tourCombatTitle => 'Mode Combat - Multijoueur Bluetooth';

  @override
  String get tourCombatDesc =>
      'Le Mode Combat vous permet de vous battre contre un ami via Bluetooth! Deux joueurs résolvent à tour de rôle des équations - pas besoin de WiFi, restez juste à moins de 10 mètres. L\'hôte joue en premier initialement, mais lors des revanches, le perdant commence. Vous avez deux façons de commencer un match:';

  @override
  String get tourCreateRoomTitle => 'Mode Combat → Créer une salle';

  @override
  String get tourCreateRoomDesc =>
      'Première option: Créer une salle fait de vous l\'hôte! Après avoir accordé les autorisations Bluetooth, vous attendrez qu\'un invité rejoigne votre salle, puis vous choisirez le niveau de difficulté. En tant qu\'hôte, vous jouez en premier dans le match initial. Ou vous pouvez rejoindre la partie de quelqu\'un d\'autre:';

  @override
  String get tourJoinRoomTitle => 'Mode Combat → Rejoindre une salle';

  @override
  String get tourJoinRoomDesc =>
      'Deuxième option: Rejoindre une salle fait de vous l\'invité! Après avoir accordé les autorisations, vous rechercherez les salles à proximité, en sélectionnerez une et appuierez sur prêt. L\'hôte choisit la difficulté, et vous jouerez en deuxième dans le match initial. Vérifions maintenant les autres fonctionnalités du menu.';

  @override
  String get tourLeaderboardTitle => 'Meilleur score - Classements';

  @override
  String get tourLeaderboardDesc =>
      'Suivez vos progrès ici! Consultez les classements mondiaux, vos records personnels et les statistiques, y compris les parties jouées, le taux de victoire, la précision et les scores par niveau de difficulté. Comparez avec des amis et observez comment vous vous améliorez au fil du temps. Enfin, visitons les Paramètres.';

  @override
  String get tourSettingsTitle => 'Paramètres - Personnaliser';

  @override
  String get tourSettingsDesc =>
      'Personnalisez tout ici! Changez votre nom d\'utilisateur, sélectionnez un thème, ajustez le son/la musique, choisissez votre langue et gérez les paramètres de confidentialité. Vous pouvez redémarrer cette visite à tout moment depuis ici. C\'est tout - vous êtes prêt à jouer!';

  @override
  String get tourNext => 'Suivant';

  @override
  String get tourPrevious => 'Précédent';

  @override
  String get tourSkip => 'Passer la visite';

  @override
  String get tourFinish => 'Terminer';

  @override
  String get tourRestartFromSettings => 'Redémarrer la visite';

  @override
  String get tourResetMessage =>
      'La visite a été réinitialisée. Retournez au menu principal pour commencer.';
}
