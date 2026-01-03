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
  String get welcome => 'स्वागत है!';

  @override
  String welcomeUser(String username) {
    return 'स्वागत है $username!';
  }

  @override
  String get mainMenu => 'मुख्य मेनू';

  @override
  String get start => 'शुरू करें';

  @override
  String get topScore => 'शीर्ष स्कोर';

  @override
  String get setting => 'सेटिंग्स';

  @override
  String get about => 'के बारे में';

  @override
  String get exit => 'बाहर निकलें';

  @override
  String get version => 'वर्जन';

  @override
  String get anonymous => 'बेनामी';

  @override
  String get level => 'स्तर';

  @override
  String get score => 'स्कोर';

  @override
  String get ready => 'तैयार';

  @override
  String get go => 'जाओ!';

  @override
  String get gameOver => 'खेल खत्म';

  @override
  String get difficultySetting => 'कठिनाई सेटिंग';

  @override
  String get difficulty => 'कठिनाई';

  @override
  String get easy => 'आसान';

  @override
  String get medium => 'मध्यम';

  @override
  String get hard => 'कठिन';

  @override
  String get veryHard => 'बहुत कठिन';

  @override
  String get extreme => 'अत्यधिक';

  @override
  String get selectDifficulty => 'कठिनाई चुनें';

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
  String get name => 'नाम';

  @override
  String get fontSize => 'फ़ॉन्ट आकार';

  @override
  String get volume => 'वॉल्यूम';

  @override
  String get vibrate => 'कंपन';

  @override
  String get numberOfTopScores => 'शीर्ष स्कोर की संख्या';

  @override
  String get language => 'भाषा';

  @override
  String get thankYou => 'खेलने के लिए धन्यवाद';

  @override
  String get thankYouMessage =>
      'हमारा खेल खेलने के लिए धन्यवाद। हमें उम्मीद है कि आपने इसका आनंद लिया। यदि आपके पास कोई प्रतिक्रिया या सुझाव है, तो कृपया हमें बताएं।';

  @override
  String get authorName => 'लेखक';

  @override
  String get connectWithUs => 'हमसे जुड़ें';

  @override
  String get connectWithUsMessage =>
      'यदि आपके पास कोई प्रश्न या टिप्पणी है, तो बेझिझक हमारे सोशल मीडिया चैनलों के माध्यम से हमसे संपर्क करें।';

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
  String get confirmExit => 'क्या आप वाकई छोड़ना चाहते हैं?';

  @override
  String get no => 'नहीं';

  @override
  String get yes => 'हाँ';

  @override
  String get insertedSuccess => 'आपकी बारी सफलतापूर्वक रिकॉर्ड की गई';

  @override
  String get insertedFailed => 'आपकी बारी रिकॉर्ड करने में विफल';

  @override
  String get scanQrToViewDetails => 'विवरण देखने के लिए क्यूआर कोड स्कैन करें';

  @override
  String get doYouWantToExit => 'क्या आप बाहर निकलना चाहते हैं?';

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
  String get difficultyEasyTitle => 'आसान मोड';

  @override
  String get difficultyMediumTitle => 'मध्यम मोड';

  @override
  String get difficultyHardTitle => 'कठिन मोड';

  @override
  String get difficultyExtremeTitle => 'अत्यधिक मोड';

  @override
  String get confirmChangeDifficulty =>
      'आपकी बारी रीसेट कर दी जाएगी। क्या आप वाकई कठिनाई बदलना चाहते हैं?';

  @override
  String get areYouSure => 'क्या आपको यकीन है?';

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
  String get updateRequired => 'अपडेट आवश्यक';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध';

  @override
  String get currentVersion => 'वर्तमान संस्करण';

  @override
  String get newVersion => 'नया संस्करण';

  @override
  String get whatsNew => 'नया क्या है';

  @override
  String get forceUpdateMessage =>
      'ऐप का उपयोग जारी रखने के लिए यह अपडेट आवश्यक है। कृपया अभी अपडेट करें।';

  @override
  String get later => 'बाद में';

  @override
  String get updateNow => 'अभी अपडेट करें';

  @override
  String get update => 'अपडेट करें';

  @override
  String get checkForUpdates => 'अपडेट देखें';

  @override
  String get appUpdates => 'ऐप अपडेट';

  @override
  String get tapToCheckUpdates =>
      'ऐप अपडेट देखने के लिए नीचे दिए गए बटन पर टैप करें।';

  @override
  String get checkingForUpdates => 'अपडेट की जांच हो रही है...';

  @override
  String newVersionAvailable(String version, String forceMessage) {
    return 'नया संस्करण $version उपलब्ध है! $forceMessage';
  }

  @override
  String get thisUpdateRequired => 'यह अपडेट आवश्यक है।';

  @override
  String get usingLatestVersion => 'आप नवीनतम संस्करण का उपयोग कर रहे हैं!';

  @override
  String unableToCheckUpdates(String error) {
    return 'अपडेट की जांच करने में असमर्थ। $error';
  }

  @override
  String get tryAgainLater => 'कृपया बाद में पुनः प्रयास करें।';

  @override
  String get updatePostponed => 'अपडेट उपलब्ध है लेकिन स्थगित कर दिया गया है।';

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
  String get cancel => 'रद्द करें';

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
  String holidayNotification(String holidayName, String greeting) {
    return 'आज $holidayName है, $greeting';
  }

  @override
  String get holidayNewYear => 'नया साल';

  @override
  String get greetingNewYear => 'नया साल मुबारक हो!';

  @override
  String get holidayLunarNewYear => 'चंद्र नव वर्ष';

  @override
  String get greetingLunarNewYear => 'चंद्र नव वर्ष मुबारक हो!';

  @override
  String get holidayValentine => 'वेलेंटाइन डे';

  @override
  String get greetingValentine => 'हैप्पी वेलेंटाइन डे!';

  @override
  String get holidayHoli => 'होली';

  @override
  String get greetingHoli => 'होली मुबारक!';

  @override
  String get holidayEarthDay => 'पृथ्वी दिवस';

  @override
  String get greetingEarthDay =>
      'हैप्पी पृथ्वी दिवस! हमारे ग्रह की रक्षा करें!';

  @override
  String get holidayEaster => 'ईस्टर';

  @override
  String get greetingEaster => 'हैप्पी ईस्टर!';

  @override
  String get holidayPride => 'प्राइड मंथ';

  @override
  String get greetingPride => 'हैप्पी प्राइड मंथ! प्यार प्यार है!';

  @override
  String get holidayHalloween => 'हैलोवीन';

  @override
  String get greetingHalloween => 'हैप्पी हैलोवीन!';

  @override
  String get holidayDiwali => 'दीपावली';

  @override
  String get greetingDiwali => 'दीपावली मुबारक!';

  @override
  String get holidayHanukkah => 'हनुक्काह';

  @override
  String get greetingHanukkah => 'हैप्पी हनुक्काह!';

  @override
  String get holidayChristmas => 'क्रिसमस';

  @override
  String get greetingChristmas => 'मेरी क्रिसमस!';

  @override
  String get holidayKwanzaa => 'क्वांज़ा';

  @override
  String get greetingKwanzaa => 'हैप्पी क्वांज़ा!';

  @override
  String get playAgain => 'फिर से खेलें';

  @override
  String get returnToMenu => 'मेनू पर लौटें';

  @override
  String get doYouReadyForRestart => 'क्या आप पुनरारंभ करने के लिए तैयार हैं?';

  @override
  String get notReady => 'तैयार नहीं';

  @override
  String get you => 'आप';

  @override
  String get opponent => 'प्रतिद्वंद्वी';

  @override
  String get waiting => 'प्रतीक्षा कर रहा है';

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
  String get ok => 'ठीक';

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
      'स्वागत है! यह त्वरित दौरा NuCatch के साथ सुगमता से शुरूआत करने में आपकी मदद करेगा। हम आपको सभी मुख्य सुविधाएं दिखाएंगे ताकि आप सीधे शुरू कर सकें। शुरू करते हैं!';

  @override
  String get tourStartTitle => 'शुरू करें - अपना गेम शुरू करें';

  @override
  String get tourStartDesc =>
      'शुरू करने के लिए स्टार्ट बटन टैप करें। फिर आप सिंगल-प्लेयर गणितीय चुनौतियों के लिए सोलो मोड, या ब्लूटूथ के माध्यम से रीयल-टाइम मल्टीप्लेयर युद्धों के लिए कॉम्बैट मोड के बीच चुनेंगे। आइए दोनों विकल्पों का अन्वेषण करें!';

  @override
  String get tourSoloTitle => 'सोलो मोड - अकेले खेलें';

  @override
  String get tourSoloDesc =>
      'सोलो मोड में, गणितीय समीकरणों के साथ खुद को चुनौती दें! 4 कठिनाई स्तरों में से चुनें (आसान से अत्यंत कठिन तक)। आप 3 जीवन के साथ शुरू करते हैं - प्रत्येक गलत उत्तर या टाइमआउट 1 जीवन खर्च करता है। उच्च कठिनाई का मतलब अधिक अंक हैं! अब मल्टीप्लेयर विकल्प देखें।';

  @override
  String get tourCombatTitle => 'कॉम्बैट मोड - ब्लूटूथ मल्टीप्लेयर';

  @override
  String get tourCombatDesc =>
      'कॉम्बैट मोड आपको ब्लूटूथ के माध्यम से एक दोस्त के साथ लड़ने की अनुमति देता है! दो खिलाड़ी बारी-बारी से समीकरणों को हल करते हैं - कोई वाईफाई की आवश्यकता नहीं, बस 10 मीटर के भीतर रहें। मेजबान शुरू में पहले खेलता है, लेकिन री-मैचों में हारने वाला पहले जाता है। आपके पास मैच शुरू करने के दो तरीके हैं:';

  @override
  String get tourCreateRoomTitle => 'कॉम्बैट मोड → रूम बनाएं';

  @override
  String get tourCreateRoomDesc =>
      'पहला विकल्प: रूम बनाएं आपको मेजबान बनाता है! ब्लूटूथ अनुमतियाँ देने के बाद, आप एक अतिथि के अपने कमरे में शामिल होने का इंतजार करेंगे, फिर कठिनाई स्तर चुनेंगे। मेजबान के रूप में, आप प्रारंभिक मैच में पहले खेलते हैं। या आप किसी और के गेम में शामिल हो सकते हैं:';

  @override
  String get tourJoinRoomTitle => 'कॉम्बैट मोड → रूम में शामिल हों';

  @override
  String get tourJoinRoomDesc =>
      'दूसरा विकल्प: रूम में शामिल होना आपको अतिथि बनाता है! अनुमतियाँ देने के बाद, आप आस-पास के कमरों को स्कैन करेंगे, एक का चयन करेंगे और तैयार टैप करेंगे। मेजबान कठिनाई चुनता है, और आप प्रारंभिक मैच में दूसरे खेलेंगे। अब अन्य मेनू सुविधाओं की जाँच करें।';

  @override
  String get tourLeaderboardTitle => 'शीर्ष स्कोर - लीडरबोर्ड';

  @override
  String get tourLeaderboardDesc =>
      'यहाँ अपनी प्रगति ट्रैक करें! वैश्विक रैंकिंग, अपने व्यक्तिगत रिकॉर्ड और सांख्यिकी देखें जिसमें खेले गए गेम, जीत दर, सटीकता और कठिनाई स्तर के अनुसार स्कोर शामिल हैं। दोस्तों के साथ तुलना करें और देखें कि आप समय के साथ कैसे सुधरते हैं। अंत में, सेटिंग्स पर जाएँ।';

  @override
  String get tourSettingsTitle => 'सेटिंग्स - अनुकूलित करें';

  @override
  String get tourSettingsDesc =>
      'यहाँ सब कुछ अनुकूलित करें! अपना उपयोगकर्ता नाम बदलें, एक थीम चुनें, साउंड/म्यूज़िक समायोजित करें, अपनी भाषा चुनें और गोपनीयता सेटिंग्स प्रबंधित करें। आप यहाँ से किसी भी समय इस टूर को पुनः प्रारंभ कर सकते हैं। बस इतना ही - आप खेलने के लिए तैयार हैं!';

  @override
  String get tourNext => 'अगला';

  @override
  String get tourPrevious => 'पिछला';

  @override
  String get tourSkip => 'टूर छोड़ें';

  @override
  String get tourFinish => 'समाप्त करें';

  @override
  String get tourRestartFromSettings => 'टूर पुनः प्रारंभ करें';
}
