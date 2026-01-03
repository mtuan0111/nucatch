// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get welcome => '¡Bienvenido/a!';

  @override
  String welcomeUser(String username) {
    return '¡Bienvenido/a $username!';
  }

  @override
  String get mainMenu => 'Menú principal';

  @override
  String get start => 'Comenzar';

  @override
  String get topScore => 'Mejor puntuación';

  @override
  String get setting => 'Configuración';

  @override
  String get about => 'Acerca de';

  @override
  String get exit => 'Salir';

  @override
  String get version => 'Versión';

  @override
  String get anonymous => 'Anónimo';

  @override
  String get level => 'Nivel';

  @override
  String get score => 'Puntuación';

  @override
  String get ready => 'Listo';

  @override
  String get go => '¡Ya!';

  @override
  String get gameOver => 'Juego terminado';

  @override
  String get difficultySetting => 'Ajuste de dificultad';

  @override
  String get difficulty => 'Dificultad';

  @override
  String get easy => 'Fácil';

  @override
  String get medium => 'Medio';

  @override
  String get hard => 'Difícil';

  @override
  String get veryHard => 'Muy difícil';

  @override
  String get extreme => 'Extremo';

  @override
  String get selectDifficulty => 'Seleccionar dificultad';

  @override
  String get selectLevel => 'Seleccionar nivel';

  @override
  String get selectLevelMessage =>
      'Elige el nivel que quieres jugar. Cuanto más alto sea el nivel, más difícil será.';

  @override
  String get yourScoreIs => 'Tu puntuación actual es';

  @override
  String get theCorrectIs => 'Lo correcto es';

  @override
  String get name => 'Nombre';

  @override
  String get fontSize => 'Tamaño de fuente';

  @override
  String get volume => 'Volumen';

  @override
  String get vibrate => 'Vibrar';

  @override
  String get numberOfTopScores => 'Número de mejores puntuaciones';

  @override
  String get language => 'Idioma';

  @override
  String get thankYou => 'Gracias por jugar';

  @override
  String get thankYouMessage =>
      'Gracias por jugar nuestro juego. Esperamos que lo hayas disfrutado. Si tienes algún comentario o sugerencia, no dudes en hacérnoslo saber.';

  @override
  String get authorName => 'Autor';

  @override
  String get connectWithUs => 'Conéctate con nosotros';

  @override
  String get connectWithUsMessage =>
      'Si tienes alguna pregunta o comentario, no dudes en contactarnos en nuestras redes sociales.';

  @override
  String get introductionContent =>
      'NuCatch es un juego mental divertido y atractivo diseñado para agudizar tu memoria y mejorar el enfoque. Desafíate a atrapar números rápidamente en poco tiempo, ayudándote a recordar cosas como OTPs, números de teléfono, cumpleaños y más. ¡Disfruta de la experiencia y mejora tus habilidades de memoria!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return '¡Únete a #NuCatch con $username! Explóralo ahora en $profileUrl';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return 'Explora #NuCatch ahora en $profileUrl';
  }

  @override
  String get messageSharePlayedLeaderSubject => 'Experiencia con #NuCatch';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return 'Experiencia con $username en #NuCatch';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username obtuvo $point puntos a las $timeCreated. ¡¡Únete a #NuCatch con $username!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'Un jugador obtuvo $point puntos a las $timeCreated. ¡¡Únete a #NuCatch ahora!!';
  }

  @override
  String get confirmExit => '¿Estás seguro de que quieres salir?';

  @override
  String get no => 'No';

  @override
  String get yes => 'Sí';

  @override
  String get insertedSuccess => 'Turno registrado con éxito';

  @override
  String get insertedFailed => 'Error al registrar tu turno';

  @override
  String get scanQrToViewDetails => 'Escanea el código QR para ver detalles';

  @override
  String get doYouWantToExit => '¿Quieres salir?';

  @override
  String get difficultyEasyDescription =>
      'Genera un número aleatorio con un nivel ligeramente aumentado para desafíos simples.';

  @override
  String get difficultyMediumDescription =>
      'Produce una expresión de cálculo de suma/resta para una dificultad moderada.';

  @override
  String get difficultyHardDescription =>
      'Crea una expresión de cálculo de multiplicación/división para una dificultad avanzada.';

  @override
  String get difficultyExtremeDescription =>
      'Selecciona aleatoriamente entre generar un cálculo complejo de suma/resta, un número aleatorio de mayor nivel o un cálculo de multiplicación/división para la experiencia más desafiante.';

  @override
  String get difficultyEasyTitle => 'Modo Fácil';

  @override
  String get difficultyMediumTitle => 'Modo Medio';

  @override
  String get difficultyHardTitle => 'Modo Difícil';

  @override
  String get difficultyExtremeTitle => 'Modo Extremo';

  @override
  String get confirmChangeDifficulty =>
      'Tu turno se reiniciará. ¿Estás seguro de que quieres cambiar la dificultad?';

  @override
  String get areYouSure => '¿Estás seguro?';

  @override
  String get no_turn_yet => 'Aún no hay turnos';

  @override
  String get daily => 'En un día';

  @override
  String get dailyDescription =>
      'Clasificaciones basadas en turnos registrados hoy.';

  @override
  String get weekly => 'En una semana';

  @override
  String get weeklyDescription =>
      'Clasificaciones basadas en turnos registrados en los últimos 7 días.';

  @override
  String get allTime => 'Todo el tiempo';

  @override
  String get allTimeDescription =>
      'Clasificaciones basadas en todos los turnos registrados.';

  @override
  String get updateRequired => 'Actualización requerida';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get currentVersion => 'Versión actual';

  @override
  String get newVersion => 'Nueva versión';

  @override
  String get whatsNew => 'Novedades';

  @override
  String get forceUpdateMessage =>
      'Esta actualización es necesaria para continuar usando la aplicación. Por favor actualiza ahora.';

  @override
  String get later => 'Más tarde';

  @override
  String get updateNow => 'Actualizar ahora';

  @override
  String get update => 'Actualizar';

  @override
  String get checkForUpdates => 'Buscar actualizaciones';

  @override
  String get appUpdates => 'Actualizaciones de la aplicación';

  @override
  String get tapToCheckUpdates =>
      'Toque el botón de abajo para buscar actualizaciones de la aplicación.';

  @override
  String get checkingForUpdates => 'Buscando actualizaciones...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return '¡Nueva versión $version disponible! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'Esta actualización es obligatoria.';

  @override
  String get usingLatestVersion => '¡Estás usando la última versión!';

  @override
  String unableToCheckUpdates(String error) {
    return 'No se pudo buscar actualizaciones. $error';
  }

  @override
  String get tryAgainLater => 'Por favor inténtelo de nuevo más tarde.';

  @override
  String get updatePostponed => 'Actualización disponible pero pospuesta.';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'Tienes $totalSeconds segundos para tocar un número. La barra cambia de color a medida que se agota el tiempo: verde (más de ${halfSeconds}s), naranja ($quarterSeconds-${halfSeconds}s), rojo (menos de ${quarterSeconds}s).';
  }

  @override
  String get selectPlayMode => 'Seleccionar modo de juego';

  @override
  String get soloMode => 'Modo Solo';

  @override
  String get soloModeDescription =>
      'Juega solo y desafíate a superar tu puntuación más alta';

  @override
  String get combatMode => 'Modo Combate';

  @override
  String get combatModeDescription =>
      'Juega con otro jugador a través de conexión Bluetooth y tómense turnos';

  @override
  String get createRoom => 'Crear Sala';

  @override
  String get createRoomDescription =>
      'Organiza un nuevo juego y espera a que otro jugador se una';

  @override
  String get joinRoom => 'Unirse a Sala';

  @override
  String get joinRoomDescription =>
      'Ingresa un código de sala para unirte a un juego existente';

  @override
  String get hostRoom => 'Sala de Anfitrión';

  @override
  String get roomCode => 'Código de Sala';

  @override
  String get shareCodeWithPlayer => 'Comparte este código con otro jugador';

  @override
  String get enterRoomCode => 'Ingresar Código de Sala';

  @override
  String get connect => 'Conectar';

  @override
  String get searchingForPlayers => 'Buscando jugadores...';

  @override
  String pairedWith(String playerName) {
    return '¡Emparejado con $playerName!';
  }

  @override
  String get bluetoothPermissionRequired => 'Permiso de Bluetooth Requerido';

  @override
  String get bluetoothPermissionMessage =>
      'El Modo Combate requiere permisos de Bluetooth para conectarse con otros jugadores. Por favor otorga permisos de Bluetooth en la configuración de tu dispositivo.';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'Los permisos de Bluetooth fueron denegados permanentemente. Para usar el Modo Combate, necesitas habilitar los permisos de Bluetooth en la configuración de tu dispositivo.\n\nPor favor ve a Configuración > NuCatch > Permisos y habilita Bluetooth.';

  @override
  String get bluetoothDisabled => 'Bluetooth Desactivado';

  @override
  String get bluetoothDisabledMessage =>
      'El Modo Combate requiere que el Bluetooth esté activado. Por favor activa el Bluetooth en la configuración de tu dispositivo.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get grantPermission => 'Otorgar Permiso';

  @override
  String get checkAgain => 'Verificar de Nuevo';

  @override
  String get openSettings => 'Abrir Configuración';

  @override
  String get yourTurn => 'Tu Turno';

  @override
  String get opponentTurn => 'Turno del Oponente';

  @override
  String get waitingForOpponent => 'Esperando al oponente...';

  @override
  String get watchingOpponent => 'Mira a tu oponente';

  @override
  String get youWin => '¡Ganaste!';

  @override
  String get youLose => '¡Perdiste!';

  @override
  String get opponentDisconnected => 'Oponente desconectado';

  @override
  String get opponentRanOutOfLives => 'El oponente se quedó sin vidas';

  @override
  String get opponentGaveUp => 'Tu oponente se rindió';

  @override
  String get confirmEndCombat =>
      '¿Estás seguro de que quieres terminar este juego? Tu oponente ganará.';

  @override
  String get youRanOutOfLives => 'Te quedaste sin vidas';

  @override
  String holidayNotification(String holidayName, String greeting) {
    return 'Hoy es $holidayName, $greeting';
  }

  @override
  String get holidayNewYear => 'Año Nuevo';

  @override
  String get greetingNewYear => '¡Feliz Año Nuevo!';

  @override
  String get holidayLunarNewYear => 'Año Nuevo Lunar';

  @override
  String get greetingLunarNewYear => '¡Feliz Año Nuevo Lunar!';

  @override
  String get holidayValentine => 'Día de San Valentín';

  @override
  String get greetingValentine => '¡Feliz Día de San Valentín!';

  @override
  String get holidayHoli => 'Holi';

  @override
  String get greetingHoli => '¡Feliz Holi!';

  @override
  String get holidayEarthDay => 'Día de la Tierra';

  @override
  String get greetingEarthDay =>
      '¡Feliz Día de la Tierra! ¡Protege nuestro planeta!';

  @override
  String get holidayEaster => 'Pascua';

  @override
  String get greetingEaster => '¡Felices Pascuas!';

  @override
  String get holidayPride => 'Mes del Orgullo';

  @override
  String get greetingPride => '¡Feliz Orgullo! ¡Amor es Amor!';

  @override
  String get holidayHalloween => 'Halloween';

  @override
  String get greetingHalloween => '¡Feliz Halloween!';

  @override
  String get holidayDiwali => 'Diwali';

  @override
  String get greetingDiwali => '¡Feliz Diwali!';

  @override
  String get holidayHanukkah => 'Jánuca';

  @override
  String get greetingHanukkah => '¡Feliz Jánuca!';

  @override
  String get holidayChristmas => 'Navidad';

  @override
  String get greetingChristmas => '¡Feliz Navidad!';

  @override
  String get holidayKwanzaa => 'Kwanzaa';

  @override
  String get greetingKwanzaa => '¡Feliz Kwanzaa!';

  @override
  String get playAgain => 'Jugar de Nuevo';

  @override
  String get returnToMenu => 'Volver al Menú';

  @override
  String get doYouReadyForRestart => '¿Estás listo para reiniciar?';

  @override
  String get notReady => 'No Listo';

  @override
  String get you => 'Tú';

  @override
  String get opponent => 'Oponente';

  @override
  String get waiting => 'Esperando';

  @override
  String get youWillTakeFirst => '¡Tomarás el primer turno!';

  @override
  String get opponentWillTakeFirst => 'El oponente tomará el primer turno';

  @override
  String get advertisingRoomWaiting =>
      '¡Anunciando sala! Esperando oponente...';

  @override
  String get opponentJoinedReady =>
      '¡Oponente unido! Presiona Listo cuando estés preparado.';

  @override
  String get opponentReady => '¡Oponente Listo!';

  @override
  String get ok => 'OK';

  @override
  String get bothPlayersReady => '¡Ambos Jugadores Listos!';

  @override
  String get searchingForHosts => 'Buscando anfitriones...';

  @override
  String connectingToHost(String hostName) {
    return 'Conectando con $hostName...';
  }

  @override
  String get hostReady => '¡Anfitrión Listo!';

  @override
  String get theHostIsReady => '✅ ¡El anfitrión está listo!';

  @override
  String get pressReadyWhenPrepared =>
      'Presiona Listo cuando estés preparado para comenzar.';

  @override
  String get yourOpponentIsReady => '✅ ¡Tu oponente está listo!';

  @override
  String get gameIsStarting => 'El juego está comenzando...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'Esperando a que el anfitrión seleccione la dificultad...';

  @override
  String get failedToInitializeNearby =>
      'No se pudo inicializar Nearby Connections. Por favor otorga permisos de ubicación.';

  @override
  String get nearbyNotInitialized => 'Nearby Connections no está inicializado';

  @override
  String failedToStartAdvertising(String error) {
    return 'Error al comenzar a anunciar: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'Error al establecer listo: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'Error al iniciar el juego: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'Anunciando sala...\nEsperando que el oponente descubra y conecte.';

  @override
  String get opponentConnectedStatus =>
      '¡Oponente conectado!\nPresiona Listo cuando ambos jugadores estén listos.';

  @override
  String get bothPlayersReadyStatus =>
      '¡Ambos jugadores listos! Iniciando juego...';

  @override
  String get settingUpDifficulty => 'Configurando dificultad del juego...';

  @override
  String get advertisingAs => 'Anunciando como:';

  @override
  String get connectedViaNearby => 'Conectado vía Nearby';

  @override
  String get advertising => 'Anunciando...';

  @override
  String get selectHostToConnect => 'Selecciona un anfitrión para conectar';

  @override
  String availableHosts(int count) {
    return 'Anfitriones Disponibles ($count)';
  }

  @override
  String get tapToConnect => 'Toca para conectar';

  @override
  String get noHostsFoundNearby => 'No se encontraron anfitriones cerca';

  @override
  String get makeSureFriendHosting =>
      'Asegúrate de que un amigo esté siendo anfitrión\ny ambos dispositivos estén cerca';

  @override
  String get discovering => 'Descubriendo...';

  @override
  String get notDiscovering => 'No descubriendo';

  @override
  String get distanceWarning =>
      'Asegúrate de que los dispositivos estén a menos de 10 metros de distancia';

  @override
  String get tourButtonLabel => 'Start Tour';

  @override
  String get tourStartTitle => 'Let\'s Get Started!';

  @override
  String get tourStartDesc =>
      'This button opens both Solo and Combat modes. Tap it and I\'ll explain more inside!';

  @override
  String get tourSoloTitle => 'Solo Mode';

  @override
  String get tourSoloDesc =>
      'Challenge yourself! Tap numbers to solve math problems or match sequences. The faster you are, the higher your score. Each correct answer levels you up with harder challenges!';

  @override
  String get tourCombatTitle => 'Combat Mode';

  @override
  String get tourCombatDesc =>
      'Battle against friends in real-time using Bluetooth! No internet required. Two players solve the same challenges simultaneously - the fastest wins!';

  @override
  String get tourCreateRoomTitle => 'Create Room';

  @override
  String get tourCreateRoomDesc =>
      'Host a game for your friend! Choose your difficulty level and share your room code. Your opponent can join using Nearby Connections or by scanning your QR code.';

  @override
  String get tourJoinRoomTitle => 'Join Room';

  @override
  String get tourJoinRoomDesc =>
      'Join a friend\'s game! Enter their room code or scan their QR code to connect. Make sure you\'re within Bluetooth range for the best experience.';

  @override
  String get tourLeaderboardTitle => 'Top Scores';

  @override
  String get tourLeaderboardDesc =>
      'Check out the best players! View high scores, track your progress, and compete to reach the top. Can you beat the current champions?';

  @override
  String get tourSettingsTitle => 'Settings';

  @override
  String get tourSettingsDesc =>
      'Customize your experience! Adjust sound, change language, modify difficulty, and personalize the app to your liking. You can also restart this tour anytime from here.';

  @override
  String get tourNext => 'Next';

  @override
  String get tourPrevious => 'Previous';

  @override
  String get tourSkip => 'Skip Tour';

  @override
  String get tourFinish => 'Finish';

  @override
  String get tourRestartFromSettings => 'Restart Tour';
}
