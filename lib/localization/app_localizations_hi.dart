// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'new_flutter_template';

  @override
  String get instantStart => 'तत्काल शुरुआत';

  @override
  String get lastPlayedLabel => 'Last played';

  @override
  String get selectLevel => 'स्तर चुनें';

  @override
  String get selectLevelMessage =>
      'उस स्तर का चयन करें जिसे आप खेलना चाहते हैं। उच्च स्तर का मतलब अधिक कठिनाई है।';

  @override
  String get yourScoreIs => 'आपका वर्तमान स्कोर है';

  @override
  String get theCorrectIs => 'सही जवाब है';

  @override
  String get whichOneIsCorrect => 'कौन सा सही है?';

  @override
  String get numberOfTopScores => 'शीर्ष स्कोर की संख्या';

  @override
  String get onlyShowMyRecorded => 'केवल मेरे रिकॉर्ड दिखाएं';

  @override
  String get introductionContent =>
      'NuCatch एक मजेदार और आकर्षक मस्तिष्क खेल है जो आपकी याददाश्त को तेज करने और आपका ध्यान बेहतर बनाने के लिए डिज़ाइन किया गया है। कम समय में संख्याओं को जल्दी से पकड़ने के लिए खुद को चुनौती दें, जिससे आपको ओटीपी, फोन नंबर, जन्मदिन और बहुत कुछ याद रखने में मदद मिलती है। अनुभव का आनंद लें और अपनी याददाश्त कौशल को बढ़ाएं!';

  @override
  String messageShareIntroWIthUsername(String username, String profileUrl) {
    return '$username के साथ #NuCatch में शामिल हों! इसे अब $profileUrl पर एक्सप्लोर करें';
  }

  @override
  String messageShareIntro(String profileUrl) {
    return '$profileUrl पर अब #NuCatch एक्सप्लोर करें';
  }

  @override
  String get messageSharePlayedLeaderSubject => '#NuCatch के साथ अनुभव';

  @override
  String messageSharePlayedLeaderSubjectWithUsername(String username) {
    return '#NuCatch पर $username के साथ अनुभव';
  }

  @override
  String messageSharePlayedLeaderBody(
      String username, num point, String timeCreated) {
    return '$username ने $timeCreated पर $point अंक प्राप्त किए। $username के साथ #NuCatch में शामिल हों!!';
  }

  @override
  String messageSharePlayedLeaderBodyAnonymousBody(
      num point, String timeCreated) {
    return 'एक खिलाड़ी ने $timeCreated पर $point अंक प्राप्त किए। अभी #NuCatch में शामिल हों!!';
  }

  @override
  String get restartGame => 'खेल फिर से शुरू करें';

  @override
  String get confirmRestart =>
      'क्या आप वाकई खेल को फिर से शुरू करना चाहते हैं?';

  @override
  String get insertedSuccess => 'आपकी बारी सफलतापूर्वक रिकॉर्ड की गई';

  @override
  String get insertedFailed => 'आपकी बारी रिकॉर्ड करने में विफल';

  @override
  String get scanQrToViewDetails => 'विवरण देखने के लिए क्यूआर कोड स्कैन करें';

  @override
  String get difficultyEasyDescription =>
      'साधारण चुनौतियों के लिए थोड़े बढ़े हुए स्तर के साथ एक यादृच्छिक संख्या उत्पन्न करता है।';

  @override
  String get difficultyMediumDescription =>
      'मध्यम कठिनाई के लिए एक जोड़/घटाव गणना अभिव्यक्ति तैयार करता है।';

  @override
  String get difficultyHardDescription =>
      'उन्नत कठिनाई के लिए एक गुणा/भाग गणना अभिव्यक्ति बनाता है।';

  @override
  String get difficultyExtremeDescription =>
      'सबसे चुनौतीपूर्ण अनुभव के लिए एक जटिल जोड़/घटाव गणना, एक उच्च स्तर की यादृच्छिक संख्या, या एक गुणा/भाग गणना उत्पन्न करने के बीच यादृच्छिक रूप से चयन करता है।';

  @override
  String get pickRightDescription =>
      'सही समीकरण चुनें! 5-सेकंड टाइमर के साथ त्वरित चयन गेम।';

  @override
  String get difficultyEasyTitle => 'आसान मोड';

  @override
  String get difficultyMediumTitle => 'मध्यम मोड';

  @override
  String get difficultyHardTitle => 'कठिन मोड';

  @override
  String get difficultyExtremeTitle => 'अत्यधिक मोड';

  @override
  String get pickRightTitle => 'सही चुनें';

  @override
  String get confirmChangeDifficulty =>
      'आपकी बारी रीसेट कर दी जाएगी। क्या आप वाकई कठिनाई बदलना चाहते हैं?';

  @override
  String get no_turn_yet => 'अभी तक कोई बारी नहीं';

  @override
  String get daily => 'एक दिन में';

  @override
  String get dailyDescription => 'आज रिकॉर्ड की गई बारियों के आधार पर रैंकिंग।';

  @override
  String get weekly => 'एक सप्ताह में';

  @override
  String get weeklyDescription =>
      'पिछले 7 दिनों में रिकॉर्ड की गई बारियों के आधार पर रैंकिंग।';

  @override
  String get allTime => 'पूरे समय';

  @override
  String get allTimeDescription =>
      'रिकॉर्ड की गई सभी बारियों के आधार पर रैंकिंग।';

  @override
  String tapTimerTooltip(
      int totalSeconds, int halfSeconds, int quarterSeconds) {
    return 'संख्या पर टैप करने के लिए आपके पास $totalSeconds सेकंड हैं। बार समय के साथ रंग बदलता है: हरा ($halfSeconds से अधिक), नारंगी ($quarterSeconds-${halfSeconds}s), लाल ($quarterSeconds से कम)।';
  }

  @override
  String get selectPlayMode => 'खेल मोड चुनें';

  @override
  String get soloMode => 'सोलो मोड';

  @override
  String get soloModeDescription =>
      'अकेले खेलें और अपने शीर्ष स्कोर को मात देने के लिए खुद को चुनौती दें';

  @override
  String get combatMode => 'कॉम्बैट मोड';

  @override
  String get combatModeDescription =>
      'ब्लूटूथ कनेक्शन के माध्यम से दूसरे खिलाड़ी के साथ खेलें और बारी-बारी से खेलें';

  @override
  String get createRoom => 'रूम बनाएं';

  @override
  String get createRoomDescription =>
      'एक नया गेम होस्ट करें और दूसरे खिलाड़ी के शामिल होने की प्रतीक्षा करें';

  @override
  String get joinRoom => 'रूम ज्वाइन करें';

  @override
  String get joinRoomDescription =>
      'मौजूदा गेम में शामिल होने के लिए रूम कोड दर्ज करें';

  @override
  String get hostRoom => 'होस्ट रूम';

  @override
  String get roomCode => 'रूम कोड';

  @override
  String get shareCodeWithPlayer => 'इस कोड को दूसरे खिलाड़ी के साथ शेयर करें';

  @override
  String get enterRoomCode => 'रूम कोड दर्ज करें';

  @override
  String get connect => 'कनेक्ट करें';

  @override
  String get searchingForPlayers => 'खिलाड़ियों की खोज की जा रही है...';

  @override
  String pairedWith(String playerName) {
    return '$playerName के साथ पेयर किया गया!';
  }

  @override
  String get bluetoothPermissionRequired => 'ब्लूटूथ अनुमति आवश्यक';

  @override
  String get bluetoothPermissionMessage =>
      'कॉम्बैट मोड को अन्य खिलाड़ियों से जुड़ने के लिए ब्लूटूथ अनुमति की आवश्यकता होती है। कृपया अपने डिवाइस सेटिंग में ब्लूटूथ अनुमति दें।';

  @override
  String get bluetoothPermissionPermanentlyDeniedMessage =>
      'ब्लूटूथ अनुमतियाँ स्थायी रूप से अस्वीकार कर दी गई हैं। कॉम्बैट मोड का उपयोग करने के लिए, आपको अपने डिवाइस सेटिंग में ब्लूटूथ अनुमतियाँ सक्षम करनी होंगी।\n\nकृपया सेटिंग > NuCatch > अनुमतियाँ पर जाएँ और ब्लूटूथ सक्षम करें।';

  @override
  String get bluetoothDisabled => 'ब्लूटूथ अक्षम';

  @override
  String get bluetoothDisabledMessage =>
      'कॉम्बैट मोड के लिए ब्लूटूथ सक्षम होना आवश्यक है। कृपया अपने डिवाइस सेटिंग में ब्लूटूथ चालू करें।';

  @override
  String get grantPermission => 'अनुमति दें';

  @override
  String get checkAgain => 'फिर से जांचें';

  @override
  String get openSettings => 'सेटिंग्स खोलें';

  @override
  String get yourTurn => 'आपकी बारी';

  @override
  String get opponentTurn => 'प्रतिद्वंद्वी की बारी';

  @override
  String get waitingForOpponent => 'प्रतिद्वंद्वी की प्रतीक्षा कर रहा है...';

  @override
  String get watchingOpponent => 'अपने प्रतिद्वंद्वी को देखें';

  @override
  String get youWin => 'आप जीत गए!';

  @override
  String get youLose => 'आप हार गए!';

  @override
  String get opponentDisconnected => 'प्रतिद्वंद्वी डिस्कनेक्ट हो गया';

  @override
  String get opponentRanOutOfLives => 'प्रतिद्वंद्वी का जीवन समाप्त हो गया';

  @override
  String get opponentGaveUp => 'आपके प्रतिद्वंद्वी ने हार मान ली';

  @override
  String get confirmEndCombat =>
      'क्या आप वाकई इस गेम को समाप्त करना चाहते हैं? आपका प्रतिद्वंद्वी जीत जाएगा।';

  @override
  String get youRanOutOfLives => 'आपका जीवन समाप्त हो गया';

  @override
  String get doYouReadyForRestart => 'क्या आप पुनरारंभ करने के लिए तैयार हैं?';

  @override
  String get notReady => 'तैयार नहीं';

  @override
  String get you => 'आप';

  @override
  String get opponent => 'प्रतिद्वंद्वी';

  @override
  String get youWillTakeFirst => 'आप पहले लेंगे!';

  @override
  String get opponentWillTakeFirst => 'प्रतिद्वंद्वी पहले लेगा';

  @override
  String get advertisingRoomWaiting =>
      'रूम ब्रॉडकास्टिंग! प्रतिद्वंद्वी की प्रतीक्षा कर रहा है...';

  @override
  String get opponentJoinedReady =>
      'प्रतिद्वंद्वी शामिल हो गया! तैयार होने पर तैयार दबाएं।';

  @override
  String get opponentReady => 'प्रतिद्वंद्वी तैयार!';

  @override
  String get bothPlayersReady => 'दोनों खिलाड़ी तैयार!';

  @override
  String get searchingForHosts => 'होस्ट की तलाश की जा रही है...';

  @override
  String connectingToHost(String hostName) {
    return '$hostName से जुड़ रहा है...';
  }

  @override
  String get hostReady => 'होस्ट तैयार!';

  @override
  String get theHostIsReady => '✅ होस्ट तैयार है!';

  @override
  String get pressReadyWhenPrepared =>
      'शुरू करने के लिए तैयार होने पर तैयार दबाएं।';

  @override
  String get yourOpponentIsReady => '✅ आपका प्रतिद्वंद्वी तैयार है!';

  @override
  String get gameIsStarting => 'खेल शुरू हो रहा है...';

  @override
  String get waitingForHostToSelectDifficulty =>
      'होस्ट द्वारा कठिनाई चुनने की प्रतीक्षा कर रहा है...';

  @override
  String get failedToInitializeNearby =>
      'Nearby Connections प्रारंभ करने में विफल। कृपया स्थान अनुमति प्रदान करें।';

  @override
  String get nearbyNotInitialized => 'Nearby Connections प्रारंभ नहीं किया गया';

  @override
  String failedToStartAdvertising(String error) {
    return 'विज्ञापन शुरू करने में विफल: $error';
  }

  @override
  String failedToSetReady(String error) {
    return 'तैयार स्थिति सेट करने में विफल: $error';
  }

  @override
  String failedToStartGame(String error) {
    return 'खेल शुरू करने में विफल: $error';
  }

  @override
  String get advertisingRoomStatus =>
      'रूम ब्रॉडकास्टिंग...\nप्रतिद्वंद्वी के खोजने और कनेक्ट करने की प्रतीक्षा कर रहा है।';

  @override
  String get opponentConnectedStatus =>
      'प्रतिद्वंद्वी जुड़ा हुआ है!\nजब दोनों खिलाड़ी तैयार हों तो तैयार दबाएं।';

  @override
  String get bothPlayersReadyStatus => 'दोनों खिलाड़ी तैयार! खेल शुरू...';

  @override
  String get settingUpDifficulty => 'खेल कठिनाई सेट कर रहा है...';

  @override
  String get advertisingAs => 'के रूप में विज्ञापन:';

  @override
  String get connectedViaNearby => 'Nearby के माध्यम से जुड़ा हुआ है';

  @override
  String get advertising => 'विज्ञापन...';

  @override
  String get selectHostToConnect => 'कनेक्ट करने के लिए होस्ट चुनें';

  @override
  String availableHosts(int count) {
    return 'उपलब्ध होस्ट ($count)';
  }

  @override
  String get tapToConnect => 'कनेक्ट करने के लिए टैप करें';

  @override
  String get noHostsFoundNearby => 'आस-पास कोई होस्ट नहीं मिला';

  @override
  String get makeSureFriendHosting =>
      'सुनिश्चित करें कि कोई मित्र होस्ट कर रहा है\nऔर दोनों डिवाइस एक दूसरे के करीब हैं';

  @override
  String get discovering => 'खोज रहा है...';

  @override
  String get notDiscovering => 'खोज नहीं रहा है';

  @override
  String get distanceWarning =>
      'सुनिश्चित करें कि डिवाइस 10 मीटर से कम दूरी पर हैं';

  @override
  String get tourButtonLabel => 'टूर शुरू करें';

  @override
  String get tourWelcomeTitle => 'NuCatch में आपका स्वागत है!';

  @override
  String get tourWelcomeDesc =>
      'स्वागत है! यह संक्षिप्त टूर आपको **NuCatch** के साथ सहज शुरुआत करने में मदद करेगा। हम आपको सभी **मुख्य विशेषताएं** दिखाएंगे ताकि आप सीधे खेलना शुरू कर सकें।';

  @override
  String get tourStartTitle => 'प्रारंभ - अपना खेल शुरू करें';

  @override
  String get tourStartDesc =>
      'शुरू करने के लिए **स्टार्ट बटन** पर टैप करें। फिर आप व्यक्तिगत गणितीय चुनौतियों के लिए **सोलो मोड**, या **ब्लूटूथ** के माध्यम से रियल-टाइम मल्टीप्लेयर लड़ाइयों के लिए **कॉम्बैट मोड** के बीच चयन करेंगे।';

  @override
  String get tourInstantStartTitle => 'इंस्टेंट स्टार्ट - त्वरित खेल';

  @override
  String get tourInstantStartDesc =>
      'क्या आप तुरंत शुरुआत करना चाहते हैं? जिस कठिनाई स्तर पर आपने पिछली बार खेला था, उसी स्तर पर तुरंत एकल गेम शुरू करने के लिए **इंस्टेंट स्टार्ट** बटन पर टैप करें!';

  @override
  String get tourSoloTitle => 'सोलो मोड - अकेले खेलें';

  @override
  String get tourSoloDesc =>
      '**सोलो मोड** में, खुद को चुनौती दें। **4 कठिनाई स्तरों** में से चुनें। आप **3 जीवन** से शुरू करते हैं - प्रत्येक गलत उत्तर या समय समाप्त होने पर 1 जीवन कम हो जाता है। **अधिक कठिनाई** का अर्थ है अधिक अंक!';

  @override
  String get tourCombatTitle => 'कॉम्बैट मोड - ब्लूटूथ मल्टीप्लेयर';

  @override
  String get tourCombatDesc =>
      '**कॉम्बैट मोड** आपको **ब्लूटूथ** के माध्यम से किसी मित्र के साथ लड़ने की अनुमति देता है! **दो खिलाड़ी** बारी-बारी से समीकरणों को हल करते हैं - **कोई वाईफाई की आवश्यकता नहीं है**, बस **10 मीटर** के भीतर रहें।';

  @override
  String get tourCreateRoomTitle => 'कॉम्बैट मोड → रूम बनाएं';

  @override
  String get tourCreateRoomDesc =>
      '**रूम बनाएं** आपको **होस्ट** बनाता है। **ब्लूटूथ अनुमतियां** देने के बाद, आप एक अतिथि के शामिल होने की प्रतीक्षा करेंगे, फिर **कठिनाई स्तर** चुनें। मेजबान के रूप में, आप पहले खेलते हैं।';

  @override
  String get tourJoinRoomTitle => 'कॉम्बैट मोड → रूम से जुड़ें';

  @override
  String get tourJoinRoomDesc =>
      '**रूम से जुड़ें** आपको **अतिथि** बनाता है। आप आस-पास के कमरों को स्कैन करेंगे, एक का चयन करेंगे और **तैयार** पर टैप करेंगे। मेजबान कठिनाई चुनता है, और आप शुरू में दूसरे खेलते हैं।';

  @override
  String get tourLeaderboardTitle => 'लीडरबोर्ड - रैंकिंग';

  @override
  String get tourLeaderboardDesc =>
      'यहां अपनी प्रगति को ट्रैक करें! **वैश्विक रैंकिंग**, अपने **व्यक्तिगत रिकॉर्ड** और **आंकड़े** देखें। दोस्तों के साथ तुलना करें और देखें कि आप समय के साथ कैसे सुधार कर रहे हैं।';

  @override
  String get tourSettingsTitle => 'सेटिंग्स - वैयक्तिकृत करें';

  @override
  String get tourSettingsDesc =>
      'यहां सब कुछ वैयक्तिकृत करें! अपना **उपयोगकर्ता नाम** बदलें, **थीम** चुनें, **ध्वनि/संगीत** निकालें और **भाषा** चुनें। आप यहां से कभी भी इस टूर को पुनः आरंभ कर सकते हैं।';

  @override
  String get tourAboutTitle => 'History & Rules';

  @override
  String get tourAboutDesc =>
      'Read the legend behind the tower and the full rules of the game any time from here. That covers the menu! Tap **Next** to start a short **hands-on practice** — you\'ll try **Regular**, **Pick Right** and **Combat** modes with a guide on screen.';

  @override
  String get tourNext => 'अगला';

  @override
  String get tourPrevious => 'पिछला';

  @override
  String get tourSkip => 'टूर छोड़ें';

  @override
  String get tourFinish => 'समाप्त करें';

  @override
  String get tourRestartFromSettings => 'टूर रीसेट करें';

  @override
  String get tourResetMessage =>
      'टूर को रीसेट कर दिया गया है। शुरू करने के लिए मुख्य मेनू पर लौटें।';

  @override
  String get tourRuleRegularWelcomeTitle => 'Let\'s Play!';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'Memorize the number, then type it back before time runs out. Ready to give it a try?';

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
      'Level up! Numbers get a little harder from here — and completing a level without losing a life earns you a bonus life.';

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
      'Instead of typing, you\'ll pick the correct answer from a few choices.';

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
      'In Combat Mode, you and an opponent take turns racing to answer first.';

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
  String get accountSectionTitle => 'खाता';

  @override
  String get signInTitle => 'साइन इन करें';

  @override
  String get signInSubtitle =>
      'अपने स्कोर और रैंक सुरक्षित रखें — साइन इन करके उन्हें नए डिवाइस पर ले जाएँ।';

  @override
  String get signInWithGoogle => 'Google के साथ जारी रखें';

  @override
  String get signInWithApple => 'Apple के साथ जारी रखें';

  @override
  String get signOut => 'साइन आउट';

  @override
  String signedInAs(String account) {
    return '$account के रूप में साइन इन';
  }

  @override
  String get playingAsGuest => 'अतिथि के रूप में खेल रहे हैं';

  @override
  String get signInAction => 'साइन इन करें';

  @override
  String get linkSuccessMessage =>
      'साइन इन हो गया। आपके स्कोर अब आपके खाते में सहेजे जाते हैं।';

  @override
  String get linkConflictTitle => 'खाता पहले से उपयोग में है';

  @override
  String get linkConflictMessage =>
      'यह खाता पहले से मौजूद है। इस पर स्विच करने से आपके मौजूदा अतिथि स्कोर छूट जाएँगे।';

  @override
  String get linkConflictSwitch => 'खाता बदलें';

  @override
  String get authError => 'साइन इन विफल रहा। कृपया पुनः प्रयास करें।';

  @override
  String get authErrorCancelled => 'साइन इन रद्द किया गया।';

  @override
  String get authErrorNetwork =>
      'कोई कनेक्शन नहीं। अपना नेटवर्क जाँचें और पुनः प्रयास करें।';

  @override
  String get authErrorCredentialRejected =>
      'साइन इन अस्वीकृत हुआ। कृपया पुनः प्रयास करें।';

  @override
  String get authErrorProviderDisabled => 'यह साइन-इन विधि अभी उपलब्ध नहीं है।';

  @override
  String get authErrorAppleUnavailable =>
      'इस डिवाइस पर Apple से साइन इन उपलब्ध नहीं है।';

  @override
  String get authErrorTooManyRequests =>
      'बहुत अधिक प्रयास। कृपया थोड़ी देर बाद पुनः प्रयास करें।';

  @override
  String get authErrorAlreadyLinked => 'यह खाता पहले से लिंक है।';

  @override
  String get authErrorAccountDisabled => 'यह खाता अक्षम कर दिया गया है।';

  @override
  String get authErrorAccountExistsDifferentCredential =>
      'वह ईमेल पहले से किसी अन्य साइन-इन विधि में उपयोग हो रहा है।';

  @override
  String get authErrorLinkConflict => 'यह खाता पहले से किसी और का है।';
}
