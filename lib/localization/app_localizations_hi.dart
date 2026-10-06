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
      'एक छोटा टूर: पहले **मेन्यू**, फिर एक छोटा **अभ्यास गेम**।\nआप इसे कभी भी छोड़ सकते हैं।';

  @override
  String get tourStartTitle => 'शुरू करें';

  @override
  String get tourStartDesc =>
      'खेलने का तरीका चुनने के लिए **शुरू करें** पर टैप करें।';

  @override
  String get tourInstantStartTitle => 'तत्काल शुरुआत';

  @override
  String get tourInstantStartDesc =>
      'पिछली बार वाली कठिनाई पर सीधे एक **सोलो** गेम शुरू करें।';

  @override
  String get tourSoloTitle => 'खेलने के दो तरीके';

  @override
  String get tourSoloDesc =>
      '**सोलो मोड**: अकेले खेलें और अपना सर्वश्रेष्ठ स्कोर तोड़ें।\n**कॉम्बैट मोड**: पास के दोस्त को **Bluetooth** से चुनौती दें — एक रूम बनाता है, दूसरा जुड़ता है।';

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
  String get tourLeaderboardTitle => 'और भी बहुत कुछ';

  @override
  String get tourLeaderboardDesc =>
      '**शीर्ष स्कोर** में रैंकिंग देखें।\n**सेटिंग्स** में नाम, थीम, आवाज़ और भाषा बदलें।\n**के बारे में** में नियम पढ़ें।\nआगे: एक छोटा **अभ्यास गेम**!';

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
  String get tourRuleRegularWelcomeTitle => 'क्लासिक मोड';

  @override
  String get tourRuleRegularWelcomeDesc =>
      'नंबर याद रखें, फिर समय खत्म होने से पहले उसे टाइप करें।\nआपके पास **3 लाइफ** हैं — अगर सभी खत्म हो जाएं तो खेल खत्म हो जाएगा।';

  @override
  String get tourRuleRegularLivesTitle => 'आपकी लाइफ';

  @override
  String get tourRuleRegularLivesDesc =>
      'आप **3 लाइफ** के साथ शुरू करते हैं। सभी खोने से खेल खत्म हो जाता है — इसलिए सावधानी से खेलें!';

  @override
  String get tourRuleRegularMemorizeTitle => 'इसे याद रखें';

  @override
  String get tourRuleRegularMemorizeDesc =>
      'ध्यान से देखें — नंबर स्क्रीन पर छिपने से पहले बस कुछ पल के लिए चमकता है।';

  @override
  String get tourRuleRegularTypeBackTitle => 'इसे टाइप करें';

  @override
  String get tourRuleRegularTypeBackDesc =>
      'अब कीपैड पर वह अंक टैप करें जो आपने अभी देखा है।';

  @override
  String get tourRuleRegularScoringTitle => 'शानदार!';

  @override
  String get tourRuleRegularScoringDesc =>
      'पॉइंट कमाने के लिए सही उत्तर देते रहें।';

  @override
  String get tourRuleRegularScoringResult =>
      'आपने अभी एक पॉइंट कमाया! हर सही उत्तर आपके स्कोर में जुड़ता है।';

  @override
  String get tourRuleRegularTimerTitle => 'समय को हराएं';

  @override
  String get tourRuleRegularTimerDesc =>
      'टाइमर बार पर नज़र रखें — यदि आपके टाइप करने से पहले यह खत्म हो गया, तो आप एक लाइफ खो देंगे।';

  @override
  String get tourRuleRegularTimerResult =>
      'समय समाप्त! समय खत्म होने से आपको एक लाइफ गंवानी पड़ती है, बिल्कुल गलत टैप की तरह।';

  @override
  String get tourRuleRegularResetTitle => 'नया चाहिए?';

  @override
  String get tourRuleRegularResetDesc =>
      'एक मुश्किल चुनौती छोड़कर नई पाने के लिए **रीसेट** टैप करें — लेकिन इसमें हमेशा एक लाइफ जाती है।';

  @override
  String get tourRuleRegularLevelUpTitle => 'लेवल पार करना';

  @override
  String get tourRuleRegularLevelUpDesc =>
      'पर्याप्त बारी का सही उत्तर दें और आप लेवल ऊपर कर लेंगे।';

  @override
  String get tourRuleRegularLevelUpResult =>
      'लेवल अप! नंबर यहाँ से थोड़े कठिन हो जाते हैं।\nएक भी लाइफ खोए बिना एक लेवल पूरा करें और एक **बोनस लाइफ** अर्जित करें।';

  @override
  String get tourRuleRegularGameOverTitle => 'खेल खत्म';

  @override
  String get tourRuleRegularGameOverDesc =>
      'केवल 1 लाइफ बची होने पर, एक और चूक खेल को सच में खत्म कर देती है। देखें क्या होता है।';

  @override
  String get tourRuleRegularWrapUpTitle => 'यह क्लासिक है!';

  @override
  String get tourRuleRegularWrapUpDesc =>
      'अब आइए सही चुनें मोड आज़माएं — खेलने का एक अलग तरीका।';

  @override
  String get tourRulePickRightWelcomeTitle => 'सही चुनें मोड';

  @override
  String get tourRulePickRightWelcomeDesc =>
      'यहाँ आपको टाइप नहीं करना है — **सही उत्तर** पर टैप करें।\nअन्य विकल्प चकमा देने के लिए हैं।';

  @override
  String get tourRulePickRightOptionsTitle => 'सोच-समझकर चुनें';

  @override
  String get tourRulePickRightOptionsDesc =>
      'इनमें से एक सही है — बाकी चकमा देने के लिए हैं।';

  @override
  String get tourRulePickRightCorrectTitle => 'सही पर टैप करें';

  @override
  String get tourRulePickRightCorrectDesc =>
      'उस बटन पर टैप करें जो आपको सही लगता है।';

  @override
  String get tourRulePickRightCorrectResult =>
      'सही! आपने एक पॉइंट अर्जित किया।';

  @override
  String get tourRulePickRightWrongTitle => 'उफ़!';

  @override
  String get tourRulePickRightWrongDesc =>
      'इस बार, किसी अलग बटन पर टैप करने का प्रयास करें।';

  @override
  String get tourRulePickRightWrongResult =>
      'गलत चुनाव — सही उत्तर हाईलाइट हो जाता है, और आप एक लाइफ खो देते हैं।';

  @override
  String get tourRulePickRightTimerTitle => 'यह टाइमर तेज़ है';

  @override
  String get tourRulePickRightTimerDesc =>
      'सही चुनें मोड का टाइमर जल्दी खत्म हो जाता है। देखें अगर आप धीमे हैं तो क्या होता है।';

  @override
  String get tourRulePickRightTimerResult =>
      'फिर से समय समाप्त — बिना किसी लाइफ के, यह खेल खत्म है।';

  @override
  String get tourRulePickRightWrapUpTitle => 'यह सही चुनें है!';

  @override
  String get tourRulePickRightWrapUpDesc =>
      'अब आइए कॉम्बैट मोड आज़माएं — जहाँ आप एक असली प्रतिद्वंद्वी के खिलाफ खेलते हैं।';

  @override
  String get tourRuleCombatWelcomeTitle => 'कॉम्बैट में स्वागत है';

  @override
  String get tourRuleCombatWelcomeDesc =>
      'आप और प्रतिद्वंद्वी बारी-बारी से खेलते हैं।\nयह बैज दिखाता है कि **किसकी बारी** है — होस्ट के रूप में, आप पहले जाएंगे।';

  @override
  String get tourRuleCombatTurnOrderTitle => 'किसकी बारी है?';

  @override
  String get tourRuleCombatTurnOrderDesc =>
      'यह बैज दिखाता है कि किसकी बारी है। होस्ट के रूप में, आप पहले जाएंगे।';

  @override
  String get tourRuleCombatYourTurnTitle => 'आपकी बारी';

  @override
  String get tourRuleCombatYourTurnDesc =>
      'अपनी बारी पूरी करने के लिए दिखाए गए अंक पर टैप करें।';

  @override
  String get tourRuleCombatOpponentTurnTitle => 'प्रतिद्वंद्वी की बारी';

  @override
  String get tourRuleCombatOpponentTurnDesc =>
      'अब देखें — आपका प्रतिद्वंद्वी अपनी बारी चलता है।';

  @override
  String get tourRuleCombatOpponentTurnResult =>
      'आपके प्रतिद्वंद्वी ने सही उत्तर दिया! बारी वापस आपके पास आ जाती है।';

  @override
  String get tourRuleCombatOpponentLifeLostTitle => 'एक लाइफ गई';

  @override
  String get tourRuleCombatOpponentLifeLostDesc =>
      'देखें क्या होता है जब आपका प्रतिद्वंद्वी एक टैप चूक जाता है।';

  @override
  String get tourRuleCombatOpponentLifeLostResult =>
      'आपके प्रतिद्वंद्वी ने एक लाइफ खो दी — आप देखेंगे कि उनकी लाइफ कम हो जाती है, बिल्कुल वैसे जैसे आपकी होती।';

  @override
  String get tourRuleCombatTimerTitle => 'सबके पास टाइमर है';

  @override
  String get tourRuleCombatTimerDesc =>
      'आपका टाइमर यहाँ भी उसी तरह काम करता है — चूकने पर आप भी एक लाइफ खो देंगे।';

  @override
  String get tourRuleCombatTimerResult =>
      'समय समाप्त! कॉम्बैट में लाइफ खोना सोलो मोड की तरह ही काम करता है।';

  @override
  String get tourRuleCombatWinTitle => 'जीत!';

  @override
  String get tourRuleCombatWinDesc =>
      'देखें क्या होता है जब आपके प्रतिद्वंद्वी की लाइफ खत्म हो जाती है।';

  @override
  String get tourRuleCombatWinResult =>
      'आप जीत गए! प्रतिद्वंद्वी की लाइफ खत्म करने से मैच आपके पक्ष में खत्म हो जाता है।';

  @override
  String get tourRuleCombatWrapUpTitle => 'ट्यूटोरियल पूर्ण!';

  @override
  String get tourRuleCombatWrapUpDesc =>
      'यह सब कुछ है — सोलो मोड, सही चुनें, और कॉम्बैट। आपको शुभकामनाएं!';

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

  @override
  String get opponentPausedTitle => 'प्रतिद्वंद्वी ने रोका';

  @override
  String get opponentPausedBody =>
      'प्रतिद्वंद्वी ने अपना फ़ोन मोड़ा या बंद किया। उनके लौटने पर राउंड फिर शुरू होगा।';

  @override
  String get opponentAwayTooLongBody =>
      'प्रतिद्वंद्वी एक मिनट से ज़्यादा समय से दूर हैं। जीत का दावा करें या इंतज़ार करें।';

  @override
  String get claimWin => 'जीत का दावा करें';

  @override
  String get opponentWasAway => 'प्रतिद्वंद्वी बहुत देर तक दूर रहे';

  @override
  String get youWereAway => 'आप बहुत देर तक दूर रहे';

  @override
  String get tourChapterRegular => 'क्लासिक';

  @override
  String get tourRuleRegularTypeBackResult => 'सही — यह एक **पॉइंट** है!';
}
