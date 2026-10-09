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
  String get instantStart => 'Inicio instantáneo';

  @override
  String get lastPlayedLabel => 'Last played';

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
  String get whichOneIsCorrect => '¿Cuál es correcta?';

  @override
  String get numberOfTopScores => 'Número de mejores puntuaciones';

  @override
  String get onlyShowMyRecorded => 'Solo mostrar mis registros';

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
  String get restartGame => 'Reiniciar Juego';

  @override
  String get confirmRestart =>
      '¿Estás seguro de que quieres reiniciar el juego?';

  @override
  String get insertedSuccess => 'Turno registrado con éxito';

  @override
  String get insertedFailed => 'Error al registrar tu turno';

  @override
  String get scanQrToViewDetails => 'Escanea el código QR para ver detalles';

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
  String get pickRightDescription =>
      '¡Elige la ecuación correcta! Juego de selección rápida con temporizador de 5 segundos.';

  @override
  String get difficultyEasyTitle => 'Modo Fácil';

  @override
  String get difficultyMediumTitle => 'Modo Medio';

  @override
  String get difficultyHardTitle => 'Modo Difícil';

  @override
  String get difficultyExtremeTitle => 'Modo Extremo';

  @override
  String get pickRightTitle => 'Elige Bien';

  @override
  String get confirmChangeDifficulty =>
      'Tu turno se reiniciará. ¿Estás seguro de que quieres cambiar la dificultad?';

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
  String get doYouReadyForRestart => '¿Estás listo para reiniciar?';

  @override
  String get notReady => 'No Listo';

  @override
  String get you => 'Tú';

  @override
  String get opponent => 'Oponente';

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
  String get tourButtonLabel => 'Iniciar Tour';

  @override
  String get tourWelcomeTitle => '¡Bienvenido a NuCatch!';

  @override
  String get tourWelcomeDesc =>
      'Un recorrido rápido: primero el **menú** y luego una breve **partida de práctica**.\nPuedes saltarlo cuando quieras.';

  @override
  String get tourStartTitle => 'Comenzar';

  @override
  String get tourStartDesc =>
      'Toca **Comenzar** para elegir cómo quieres jugar.';

  @override
  String get tourInstantStartTitle => 'Inicio instantáneo';

  @override
  String get tourInstantStartDesc =>
      'Empieza al instante una partida **Solo** con la dificultad que jugaste la última vez.';

  @override
  String get tourSoloTitle => 'Dos formas de jugar';

  @override
  String get tourSoloDesc =>
      '**Modo Solo**: juega solo y supera tu mejor puntuación.\n**Modo Combate**: reta a un amigo cercano por **Bluetooth** — uno crea una sala y el otro se une.';

  @override
  String get tourCombatTitle => 'Modo Combate - Multijugador Bluetooth';

  @override
  String get tourCombatDesc =>
      '¡El **Modo Combate** te permite batallar con un amigo vía **Bluetooth**! **Dos jugadores** se turnan resolviendo ecuaciones - **no se necesita WiFi**, solo mantente dentro de **10 metros**. Tienes dos formas de iniciar una partida:';

  @override
  String get tourCreateRoomTitle => 'Modo Combate → Crear Sala';

  @override
  String get tourCreateRoomDesc =>
      'Primera opción: **Crear Sala** te hace el **anfitrión**. Después de otorgar **permisos de Bluetooth**, esperarás a que un invitado se una, luego elegirás el **nivel de dificultad**. Como anfitrión, **juegas primero** en la partida inicial. O puedes unirte al juego de alguien más:';

  @override
  String get tourJoinRoomTitle => 'Modo Combate → Unirse a Sala';

  @override
  String get tourJoinRoomDesc =>
      'Segunda opción: **Unirse a Sala** te hace el **invitado**. Después de otorgar permisos, **escanearás** salas cercanas, seleccionarás una y tocarás **listo**. El anfitrión elige la dificultad, y **jugarás segundo** inicialmente. Ahora revisemos las otras características del menú.';

  @override
  String get tourLeaderboardTitle => 'Más por descubrir';

  @override
  String get tourLeaderboardDesc =>
      '**Mejor puntuación** muestra las clasificaciones.\nEn **Configuración** cambias tu nombre, tema, sonido e idioma.\n**Acerca de** explica las reglas.\nA continuación: ¡una breve **partida de práctica**!';

  @override
  String get tourSettingsTitle => 'Configuración - Personalizar';

  @override
  String get tourSettingsDesc =>
      '¡Personaliza todo aquí! Cambia tu **nombre de usuario**, selecciona un **tema**, ajusta **sonido/música**, elige tu **idioma** y administra la privacidad. Puedes reiniciar este tour en cualquier momento desde aquí.';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

  @override
  String get tourNext => 'Siguiente';

  @override
  String get tourPrevious => 'Anterior';

  @override
  String get tourSkip => 'Saltar Tour';

  @override
  String get tourFinish => 'Finalizar';

  @override
  String get tourRestartFromSettings => 'Reiniciar Tour';

  @override
  String get tourResetMessage =>
      'El tour ha sido reiniciado. Regresa al menú principal para comenzar.';

  @override
  String get tourRuleRegularWelcomeTitle => 'Modo Clásico';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Memoriza el número y escríbelo antes de que se acabe el tiempo.\nTienes **3 vidas** — si las pierdes todas, el juego termina.';

  @override
  String get tourRuleRegularLivesTitle => 'Tus Vidas';

  @override
  String get tourRuleRegularLivesDesc =>
      'Empiezas con **3 vidas**. Perderlas todas termina el juego — ¡así que juega con cuidado!';

  @override
  String get tourRuleRegularMemorizeTitle => 'Memorízalo';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'Mira bien — el número parpadea en la pantalla por un momento antes de ocultarse.';

  @override
  String get tourRuleRegularTypeBackTitle => 'Escríbelo de vuelta';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'Ahora toca el dígito que acabas de ver en el teclado.';

  @override
  String get tourRuleRegularScoringTitle => '¡Bien!';

  @override
  String get tourRuleRegularScoringDesc =>
      'Sigue respondiendo correctamente para ganar puntos.';

  @override
  String get tourRuleRegularScoringResult =>
      '¡Acabas de ganar un punto! Cada respuesta correcta suma a tu puntuación.';

  @override
  String get tourRuleRegularTimerTitle => 'Gánale al reloj';

  @override
  String get tourRuleRegularTimerDesc =>
      'Mira la barra de tiempo — si se acaba antes de que termines de escribir, perderás una vida.';

  @override
  String get tourRuleRegularTimerResult =>
      '¡Se acabó el tiempo! Quedarte sin tiempo te cuesta una vida, igual que un toque equivocado.';

  @override
  String get tourRuleRegularResetTitle => '¿Necesitas otro?';

  @override
  String get tourRuleRegularResetDesc =>
      'Toca **Reiniciar** para cambiar un desafío difícil por uno nuevo — pero siempre cuesta una vida.';

  @override
  String get tourRuleRegularLevelUpTitle => 'Subiendo de Nivel';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'Responde correctamente suficientes turnos y subirás de nivel.';

  @override
  String get tourRuleRegularLevelUpResult =>
      '¡Subiste de nivel! Los números se ponen un poco más difíciles desde aquí.\nTermina un nivel sin perder una vida para ganar una **vida extra**.';

  @override
  String get tourRuleRegularGameOverTitle => 'Juego terminado';

  @override
  String get tourRuleRegularGameOverDesc =>
      'Con solo 1 vida restante, un fallo más termina el juego de verdad. Mira lo que pasa.';

  @override
  String get tourRuleRegularWrapUpTitle => '¡Eso es Clásico!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'Ahora probemos el modo Elige Bien — una forma diferente de jugar.';

  @override
  String get tourRulePickRightWelcomeTitle => 'Modo Elige Bien';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'Aquí no escribes — toca la **respuesta correcta**.\nLas otras opciones son señuelos.';

  @override
  String get tourRulePickRightOptionsTitle => 'Elige bien';

  @override
  String get tourRulePickRightOptionsDesc =>
      'Una de estas es correcta — las demás son señuelos.';

  @override
  String get tourRulePickRightCorrectTitle => 'Toca la correcta';

  @override
  String get tourRulePickRightCorrectDesc =>
      'Toca el botón que creas que es correcto.';

  @override
  String get tourRulePickRightCorrectResult => '¡Correcto! Ganaste un punto.';

  @override
  String get tourRulePickRightWrongTitle => '¡Ups!';

  @override
  String get tourRulePickRightWrongDesc =>
      'Esta vez, intenta tocar un botón diferente.';

  @override
  String get tourRulePickRightWrongResult =>
      'Elección equivocada — la respuesta correcta se resalta y pierdes una vida.';

  @override
  String get tourRulePickRightTimerTitle => 'Temporizador rápido';

  @override
  String get tourRulePickRightTimerDesc =>
      'El tiempo del modo Elige Bien se acaba rápido. Mira qué pasa si eres muy lento.';

  @override
  String get tourRulePickRightTimerResult =>
      'Se acabó el tiempo de nuevo — sin vidas restantes, es Juego terminado.';

  @override
  String get tourRulePickRightWrapUpTitle => '¡Eso es Elige Bien!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'Ahora probemos el Modo Combate — donde juegas contra un oponente real.';

  @override
  String get tourRuleCombatWelcomeTitle => 'Bienvenido al Combate';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'Tú y un oponente se turnan.\nEsta insignia muestra de **quién es el turno** — como host, tú vas primero.';

  @override
  String get tourRuleCombatTurnOrderTitle => '¿De quién es el turno?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'Esta insignia muestra de quién es el turno. Como host, tú vas primero.';

  @override
  String get tourRuleCombatYourTurnTitle => 'Tu Turno';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'Toca el dígito mostrado para completar tu turno.';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'Turno del Oponente';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'Ahora mira — tu oponente toma su turno.';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      '¡Tu oponente respondió correctamente! El turno vuelve directamente a ti.';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'Una vida perdida';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'Mira lo que pasa cuando tu oponente falla un toque.';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'Tu oponente perdió una vida — verás cómo baja su contador, igual que el tuyo bajaría.';

  @override
  String get tourRuleCombatTimerTitle => 'Todos tienen temporizador';

  @override
  String get tourRuleCombatTimerDesc =>
      'Tu temporizador funciona igual aquí — si se acaba, también pierdes una vida.';

  @override
  String get tourRuleCombatTimerResult =>
      '¡Se acabó el tiempo! Perder una vida en Combate funciona igual que en Modo Solo.';

  @override
  String get tourRuleCombatWinTitle => '¡Victoria!';

  @override
  String get tourRuleCombatWinDesc =>
      'Mira lo que sucede cuando tu oponente se queda sin vidas.';

  @override
  String get tourRuleCombatWinResult =>
      '¡Ganaste! Dejar a tu oponente sin vidas termina la partida a tu favor.';

  @override
  String get tourRuleCombatWrapUpTitle => '¡Tutorial Completo!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'Eso es todo — Modo Solo, Elige Bien y Modo Combate. ¡Buena suerte ahí fuera!';

  @override
  String get menuGreeting =>
      '¡Pon a prueba hoy tu memoria y tus habilidades matemáticas!';

  @override
  String get accountSectionTitle => 'Cuenta';

  @override
  String get signInTitle => 'Iniciar sesión';

  @override
  String get signInSubtitle =>
      'Guarda tus puntuaciones y tu rango: inicia sesión para llevarlos a otro dispositivo.';

  @override
  String get signInWithGoogle => 'Continuar con Google';

  @override
  String get signInWithApple => 'Continuar con Apple';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String signedInAs(String account) {
    return 'Sesión iniciada como $account';
  }

  @override
  String get playingAsGuest => 'Jugando como invitado';

  @override
  String get signInAction => 'Iniciar sesión';

  @override
  String get linkSuccessMessage =>
      'Sesión iniciada. Tus puntuaciones ya se guardan en tu cuenta.';

  @override
  String get linkConflictTitle => 'La cuenta ya está en uso';

  @override
  String get linkConflictMessage =>
      'Esta cuenta ya existe. Cambiar a ella dejará atrás tus puntuaciones de invitado.';

  @override
  String get linkConflictSwitch => 'Cambiar de cuenta';

  @override
  String get authError => 'No se pudo iniciar sesión. Inténtalo de nuevo.';

  @override
  String get authErrorCancelled => 'Inicio de sesión cancelado.';

  @override
  String get authErrorNetwork =>
      'Sin conexión. Comprueba tu red e inténtalo de nuevo.';

  @override
  String get authErrorCredentialRejected =>
      'Se rechazó el inicio de sesión. Inténtalo de nuevo.';

  @override
  String get authErrorProviderDisabled =>
      'Este método de inicio de sesión no está disponible ahora.';

  @override
  String get authErrorAppleUnavailable =>
      'Iniciar sesión con Apple no está disponible en este dispositivo.';

  @override
  String get authErrorTooManyRequests =>
      'Demasiados intentos. Espera un momento e inténtalo de nuevo.';

  @override
  String get authErrorAlreadyLinked => 'Esta cuenta ya está vinculada.';

  @override
  String get authErrorAccountDisabled => 'Esta cuenta ha sido deshabilitada.';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'Ese correo ya se usa con otro método de inicio de sesión.';

  @override
  String get authErrorLinkConflict =>
      'Esta cuenta ya pertenece a otra persona.';

  @override
  String get opponentPausedTitle => 'Rival en pausa';

  @override
  String get opponentPausedBody =>
      'Tu rival plegó o cerró su teléfono. La ronda continúa cuando vuelva.';

  @override
  String get opponentAwayTooLongBody =>
      'Tu rival lleva más de un minuto fuera. Reclama la victoria o sigue esperando.';

  @override
  String get claimWin => 'Reclamar victoria';

  @override
  String get opponentWasAway => 'El rival estuvo fuera demasiado tiempo';

  @override
  String get youWereAway => 'Estuviste fuera demasiado tiempo';

  @override
  String get tourChapterRegular => 'Clásico';

  @override
  String get tourRuleRegularTypeBackResult =>
      'Correcto — ¡eso es un **punto**!';
}
