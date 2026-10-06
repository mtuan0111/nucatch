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
  String get lastPlayedLabel => 'Last played';

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
      'Une visite rapide : d\'abord le **menu**, puis une courte **partie d\'entraînement**.\nVous pouvez la passer à tout moment.';

  @override
  String get tourStartTitle => 'Commencer';

  @override
  String get tourStartDesc =>
      'Appuyez sur **Commencer** pour choisir comment jouer.';

  @override
  String get tourInstantStartTitle => 'Démarrage instantané';

  @override
  String get tourInstantStartDesc =>
      'Lancez directement une partie **Solo** avec la difficulté jouée la dernière fois.';

  @override
  String get tourSoloTitle => 'Deux façons de jouer';

  @override
  String get tourSoloDesc =>
      '**Mode Solo** : jouez seul et battez votre meilleur score.\n**Mode Combat** : défiez un ami à proximité via **Bluetooth** — l\'un crée une salle, l\'autre la rejoint.';

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
  String get tourLeaderboardTitle => 'Encore plus à découvrir';

  @override
  String get tourLeaderboardDesc =>
      '**Meilleur Score** affiche les classements.\n**Paramètres** permet de changer votre nom, thème, son et langue.\n**À propos** explique les règles.\nEnsuite : une courte **partie d\'entraînement** !';

  @override
  String get tourSettingsTitle => 'Paramètres - Personnaliser';

  @override
  String get tourSettingsDesc =>
      'Personnalisez tout ici ! Changez votre **nom d\'utilisateur**, sélectionnez un **thème**, ajustez le **son**, choisissez votre **langue** et gérez la confidentialité. Vous pouvez redémarrer cette visite à tout moment à partir d\'ici.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

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
  String get tourRuleRegularWelcomeTitle => 'Mode Classique';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Mémorisez le nombre, puis tapez-le avant la fin du temps imparti.\nVous avez **3 vies** — si vous les perdez toutes, le jeu se termine.';

  @override
  String get tourRuleRegularLivesTitle => 'Vos vies';

  @override
  String get tourRuleRegularLivesDesc =>
      'Vous commencez avec **3 vies**. Les perdre toutes termine le jeu — jouez donc prudemment !';

  @override
  String get tourRuleRegularMemorizeTitle => 'Mémorisez-le';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Regardez bien — le nombre clignote brièvement à l\'écran avant de disparaître.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Tapez-le';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Appuyez maintenant sur le chiffre que vous venez de voir sur le clavier.';

  @override
  String get tourRuleRegularScoringTitle => 'Bien joué !';

  @override
  String get tourRuleRegularScoringDesc =>
      'Continuez à répondre correctement pour gagner des points.';

  @override
  String get tourRuleRegularScoringResult =>
      'Vous venez de gagner un point ! Chaque bonne réponse ajoute à votre score.';

  @override
  String get tourRuleRegularTimerTitle => 'Battez le chrono';

  @override
  String get tourRuleRegularTimerDesc =>
      'Surveillez la barre de temps — si elle se vide avant que vous ayez fini de taper, vous perdrez une vie.';

  @override
  String get tourRuleRegularTimerResult =>
      'Temps écoulé ! Manquer de temps vous coûte une vie, tout comme une mauvaise touche.';

  @override
  String get tourRuleRegularResetTitle => 'Besoin d\'un autre ?';

  @override
  String get tourRuleRegularResetDesc =>
      'Appuyez sur **Réinitialiser** pour passer un défi difficile et en obtenir un nouveau — mais cela coûte toujours une vie.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Niveau Supérieur';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Répondez correctement à suffisamment de tours et vous passerez au niveau supérieur.';

  @override
  String get tourRuleRegularLevelUpResult =>
      'Niveau supérieur ! Les nombres deviennent un peu plus difficiles à partir d\'ici.\nTerminez un niveau sans perdre de vie pour gagner une **vie bonus**.';

  @override
  String get tourRuleRegularGameOverTitle => 'Jeu Terminé';

  @override
  String get tourRuleRegularGameOverDesc =>
      'Avec 1 seule vie restante, une erreur de plus termine vraiment le jeu. Regardez ce qui se passe.';

  @override
  String get tourRuleRegularWrapUpTitle => 'C\'est le Classique !';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Essayons maintenant le mode Choisissez Bien — une façon différente de jouer.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Mode Choisissez Bien';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Ici, vous ne tapez pas — appuyez sur la **bonne réponse**.\nLes autres choix sont des leurres.';

  @override
  String get tourRulePickRightOptionsTitle => 'Choisissez bien';

  @override
  String get tourRulePickRightOptionsDesc =>
      'L\'une d\'elles est correcte — les autres sont des leurres.';

  @override
  String get tourRulePickRightCorrectTitle => 'Appuyez sur le bon';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Appuyez sur le bouton que vous pensez être correct.';

  @override
  String get tourRulePickRightCorrectResult =>
      'Correct ! Vous avez gagné un point.';

  @override
  String get tourRulePickRightWrongTitle => 'Oups !';

  @override
  String get tourRulePickRightWrongDesc =>
      'Cette fois, essayez d\'appuyer sur un bouton différent.';

  @override
  String get tourRulePickRightWrongResult =>
      'Mauvais choix — la bonne réponse est mise en évidence, et vous perdez une vie.';

  @override
  String get tourRulePickRightTimerTitle => 'Chrono plus rapide';

  @override
  String get tourRulePickRightTimerDesc =>
      'Le temps du mode Choisissez Bien s\'écoule rapidement. Regardez ce qui se passe si vous êtes trop lent.';

  @override
  String get tourRulePickRightTimerResult =>
      'Temps écoulé encore — sans aucune vie restante, c\'est Jeu Terminé.';

  @override
  String get tourRulePickRightWrapUpTitle => 'C\'est Choisissez Bien !';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Essayons maintenant le Mode Combat — où vous jouez contre un vrai adversaire.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Bienvenue au Combat';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'Vous et un adversaire jouez à tour de rôle.\nCe badge indique **à qui c\'est le tour** — en tant qu\'hôte, vous commencez.';

  @override
  String get tourRuleCombatTurnOrderTitle => 'À qui le tour ?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'Ce badge indique à qui c\'est le tour. En tant qu\'hôte, vous commencez.';

  @override
  String get tourRuleCombatYourTurnTitle => 'À votre tour';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Appuyez sur le chiffre affiché pour terminer votre tour.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Tour de l\'adversaire';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Maintenant regardez — votre adversaire joue son tour.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'Votre adversaire a répondu correctement ! Le tour vous revient directement.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'Une vie perdue';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Regardez ce qui se passe quand votre adversaire rate une touche.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Votre adversaire a perdu une vie — vous verrez son compteur baisser, comme le vôtre le ferait.';

  @override
  String get tourRuleCombatTimerTitle => 'Chacun a un chrono';

  @override
  String get tourRuleCombatTimerDesc =>
      'Votre minuterie fonctionne de la même façon ici — ratez-la et vous perdez aussi une vie.';

  @override
  String get tourRuleCombatTimerResult =>
      'Temps écoulé ! Perdre une vie en Combat fonctionne comme en Mode Solo.';

  @override
  String get tourRuleCombatWinTitle => 'Victoire !';

  @override
  String get tourRuleCombatWinDesc =>
      'Regardez ce qui se passe lorsque votre adversaire n\'a plus de vies.';

  @override
  String get tourRuleCombatWinResult =>
      'Vous avez gagné ! Priver votre adversaire de vies termine le match en votre faveur.';

  @override
  String get tourRuleCombatWrapUpTitle => 'Tutoriel Terminé !';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'C\'est tout — Mode Solo, Choisissez Bien et Mode Combat. Bonne chance à vous !';

  @override
  String get menuGreeting => 'Test your memory and math skills today!';

  @override
  String get accountSectionTitle => 'Compte';

  @override
  String get signInTitle => 'Se connecter';

  @override
  String get signInSubtitle =>
      'Protégez vos scores et votre classement : connectez-vous pour les retrouver sur un autre appareil.';

  @override
  String get signInWithGoogle => 'Continuer avec Google';

  @override
  String get signInWithApple => 'Continuer avec Apple';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String signedInAs(String account) {
    return 'Connecté en tant que $account';
  }

  @override
  String get playingAsGuest => 'Vous jouez en invité';

  @override
  String get signInAction => 'Se connecter';

  @override
  String get linkSuccessMessage =>
      'Connecté. Vos scores sont désormais enregistrés sur votre compte.';

  @override
  String get linkConflictTitle => 'Compte déjà utilisé';

  @override
  String get linkConflictMessage =>
      'Ce compte existe déjà. Y basculer abandonnera vos scores d’invité actuels.';

  @override
  String get linkConflictSwitch => 'Changer de compte';

  @override
  String get authError => 'Échec de la connexion. Veuillez réessayer.';

  @override
  String get authErrorCancelled => 'Connexion annulée.';

  @override
  String get authErrorNetwork =>
      'Aucune connexion. Vérifiez votre réseau et réessayez.';

  @override
  String get authErrorCredentialRejected =>
      'Connexion refusée. Veuillez réessayer.';

  @override
  String get authErrorProviderDisabled =>
      'Cette méthode de connexion n’est pas disponible pour le moment.';

  @override
  String get authErrorAppleUnavailable =>
      'Se connecter avec Apple n’est pas disponible sur cet appareil.';

  @override
  String get authErrorTooManyRequests =>
      'Trop de tentatives. Patientez un instant et réessayez.';

  @override
  String get authErrorAlreadyLinked => 'Ce compte est déjà lié.';

  @override
  String get authErrorAccountDisabled => 'Ce compte a été désactivé.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'Cet e-mail est déjà utilisé avec une autre méthode de connexion.';

  @override
  String get authErrorLinkConflict =>
      'Ce compte appartient déjà à quelqu’un d’autre.';

  @override
  String get opponentPausedTitle => 'Adversaire en pause';

  @override
  String get opponentPausedBody =>
      'Votre adversaire a plié ou fermé son téléphone. La manche reprend à son retour.';

  @override
  String get opponentAwayTooLongBody =>
      'Votre adversaire est absent depuis plus d\'une minute. Réclamez la victoire ou continuez d\'attendre.';

  @override
  String get claimWin => 'Réclamer la victoire';

  @override
  String get opponentWasAway => 'L\'adversaire s\'est absenté trop longtemps';

  @override
  String get youWereAway => 'Vous vous êtes absenté trop longtemps';

  @override
  String get tourChapterRegular => 'Classique';

  @override
  String get tourRuleRegularTypeBackResult =>
      'Correct — cela fait un **point** !';
}
