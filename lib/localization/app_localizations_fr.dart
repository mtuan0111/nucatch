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
  String get instantStart => 'Démarrage instantané';

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
  String get whichOneIsCorrect => 'Laquelle est correcte ?';

  @override
  String get numberOfTopScores => 'Nombre de meilleurs scores';

  @override
  String get onlyShowMyRecorded => 'Afficher uniquement mes enregistrements';

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
  String get restartGame => 'Recommencer';

  @override
  String get confirmRestart => 'Voulez-vous vraiment recommencer le jeu ?';

  @override
  String get insertedSuccess => 'Tour enregistré avec succès';

  @override
  String get insertedFailed => 'Échec de l\'enregistrement de votre tour';

  @override
  String get scanQrToViewDetails => 'Scannez le code QR pour voir les détails';

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
  String get pickRightDescription =>
      'Choisissez la bonne équation ! Jeu de sélection rapide avec minuteur de 5 secondes.';

  @override
  String get difficultyEasyTitle => 'Mode Facile';

  @override
  String get difficultyMediumTitle => 'Mode Moyen';

  @override
  String get difficultyHardTitle => 'Mode Difficile';

  @override
  String get difficultyExtremeTitle => 'Mode Extrême';

  @override
  String get pickRightTitle => 'Choisissez Bien';

  @override
  String get confirmChangeDifficulty =>
      'Votre tour sera réinitialisé. Êtes-vous sûr de vouloir changer la difficulté ?';

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
  String get doYouReadyForRestart => 'Êtes-vous prêt pour redémarrer ?';

  @override
  String get notReady => 'Pas Prêt';

  @override
  String get you => 'Vous';

  @override
  String get opponent => 'Adversaire';

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
  String get tourButtonLabel => 'Démarrer la Visite';

  @override
  String get tourWelcomeTitle => 'Bienvenue sur NuCatch !';

  @override
  String get tourWelcomeDesc =>
      'Bienvenue ! Cette courte visite vous aidera à bien démarrer avec **NuCatch**. Nous allons vous montrer toutes les **fonctionnalités principales** pour que vous puissiez plonger et commencer à jouer  immédiatement.';

  @override
  String get tourStartTitle => 'Démarrer - Lancez votre Partie';

  @override
  String get tourStartDesc =>
      'Appuyez sur le **bouton Démarrer** pour lancer. Vous choisirez ensuite entre le **Mode Solo** pour des défis mathématiques individuels, ou le **Mode Combat** pour des batailles multijoueurs via **Bluetooth**.';

  @override
  String get tourInstantStartTitle => 'Démarrage Rapide';

  @override
  String get tourInstantStartDesc =>
      'Appuyez sur le bouton **Démarrage Rapide** pour lancer immédiatement une partie en solo avec le même niveau de difficulté que vous avez joué la dernière fois. C\'est le moyen le plus rapide de continuer votre progression !';

  @override
  String get tourSoloTitle => 'Mode Solo - Jouez Seul';

  @override
  String get tourSoloDesc =>
      'En **Mode Solo**, mettez-vous au défi. Choisissez parmi **4 niveaux de difficulté**. Vous commencez avec **3 vies** - chaque mauvaise réponse ou dépassement de temps coûte 1 vie. Une **difficulté plus élevée** signifie plus de points !';

  @override
  String get tourCombatTitle => 'Mode Combat - Multijoueur Bluetooth';

  @override
  String get tourCombatDesc =>
      'Le **Mode Combat** vous permet de combattre un ami via **Bluetooth** ! **Deux joueurs** résolvent des équations tour à tour - **pas de WiFi nécessaire**, restez juste dans un rayon de **10 mètres**.';

  @override
  String get tourCreateRoomTitle => 'Mode Combat → Créer un Salon';

  @override
  String get tourCreateRoomDesc =>
      'Première option : **Créer un Salon** fait de vous l\'**hôte**. Après avoir accordé les **autorisations Bluetooth**, vous attendrez qu\'un invité vous rejoigne, puis choisirez la **difficulté**. En tant qu\'hôte, vous **jouez en premier**.';

  @override
  String get tourJoinRoomTitle => 'Mode Combat → Rejoindre un Salon';

  @override
  String get tourJoinRoomDesc =>
      'Deuxième option : **Rejoindre un Salon** fait de vous l\'**invité**. Vous **scannerez** les salons à proximité, en sélectionnerez un et appuierez sur **prêt**. L\'hôte choisit la difficulté, et vous **jouerez en second**.';

  @override
  String get tourLeaderboardTitle => 'Meilleurs Scores';

  @override
  String get tourLeaderboardDesc =>
      'Suivez vos progrès ici ! Voir les **classements mondiaux**, vos **records personnels** et les **statistiques**. Comparez avec vos amis et voyez comment vous vous améliorez au fil du temps.';

  @override
  String get tourSettingsTitle => 'Paramètres - Personnaliser';

  @override
  String get tourSettingsDesc =>
      'Personnalisez tout ici ! Changez votre **nom d\'utilisateur**, sélectionnez un **thème**, ajustez le **son**, choisissez votre **langue** et gérez la confidentialité. Vous pouvez redémarrer cette visite à tout moment à partir d\'ici.';

  @override
  String get tourNext => 'Suivant';

  @override
  String get tourPrevious => 'Précédent';

  @override
  String get tourSkip => 'Passer';

  @override
  String get tourFinish => 'Terminer';

  @override
  String get tourRestartFromSettings => 'Redémarrer la Visite';

  @override
  String get tourResetMessage =>
      'La visite a été réinitialisée. Retournez au menu principal pour commencer.';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';
}
