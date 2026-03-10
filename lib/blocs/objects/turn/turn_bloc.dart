import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/services/turn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:nucatch/helpers/preferences_key.dart';

class TurnBloc extends Bloc<TurnEvent, TurnState> {
  final TurnRecordedServices _turnedServices = TurnRecordedServices();
  final AudioBloc _audioBloc;
  final VibrationBloc _vibrationBloc;
  Timer? _tapTimer;

  TurnBloc(
    TurnState initialState, {
    required AudioBloc audioBloc,
    required VibrationBloc vibrationBloc,
  })  : _audioBloc = audioBloc,
        _vibrationBloc = vibrationBloc,
        super(initialState) {
    on<Tap>(_onTap);
    on<AddPoint>(_onAddPoint);
    on<LifeLost>(_onLostLife);
    on<GainLife>(_onGainLife);
    on<ShowExpect>(_onShowExpect);
    on<SetLevel>(_onSetLevel);
    on<SetDifficulty>(_onSetDifficulty);
    on<GeneratedRequiredString>(_onGeneratedRequiredString);
    on<ResetNewNumber>(_onResetNewNumber);
    on<SaveRecorded>(_onSaveRecorded);
    on<Start>(_onStart);
    on<End>(_onEnd);
    on<CountDownIntro>(_onCountDownIntro);
    on<ApplySetting>(_onApplySetting);
    on<TapTimerTick>(_onTapTimerTick);
    on<TapTimerTimeout>(_onTapTimerTimeout);
    on<TapTimerPause>(_onTapTimerPause);
    on<TapTimerResume>(_onTapTimerResume);
    on<TapTimerReset>(_onTapTimerReset);
    on<Renew>(_onRenew);
    on<PickRightButtonTap>(_onPickRightButtonTap);
  }

  @override
  Future<void> close() {
    _tapTimer?.cancel();
    return super.close();
  }

  void _startTapTimer() {
    _tapTimer?.cancel();
    const tickDuration = Duration(milliseconds: kAnimationDurationFast);
    // Use difficulty model's timer for Pick Right mode, otherwise use global constant
    double remainingTime = state.difficultyModel?.isPickRightMode == true
        ? (state.difficultyModel?.timeLimitPerTurn.toDouble() ??
            tapTimerDuration)
        : tapTimerDuration;

    _tapTimer = Timer.periodic(tickDuration, (timer) {
      if (isClosed) {
        timer.cancel();
        return;
      }

      if (state.isTimerPaused) {
        return; // Don't tick when paused
      }

      remainingTime -= tickDuration.inMilliseconds / 1000.0;

      if (remainingTime <= 0) {
        timer.cancel();
        add(TapTimerTick(0));
        add(TapTimerTimeout());
      } else {
        // add(TapTimerTick(remainingTime));
      }
    });
  }

  void _stopTapTimer() {
    _tapTimer?.cancel();
  }

  Future<void> _onTap(
    Tap event,
    Emitter<TurnState> emitter,
  ) async {
    if (!state.isAbleToTap) {
      return;
    }

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _audioBloc.add(PlayTapAudio());

    // Reset timer on each tap
    _startTapTimer();

    if (event.keyValue == KeyboardOption.reset) {
      return;
    }

    if (event.keyValue == KeyboardOption.mainMenu) {
      return;
    }

    if (state.lifeRemaining < 0) {
      return;
    }

    if (state.expect == null || state.expect!.isEmpty) {
      return;
    }

    if (!state.isAbleToTap) {
      if (state.isExpectNotEmpty) {
        emitter(
          state.copyWith(
            status: TurnStatus.playing,
          ),
        );
      } else {
        return;
      }
    }

    // Checking is correct tap or not.
    String keyValue = keyboardArray[event.keyValue].toString();
    if (state.expect == null || state.expect!.isEmpty) {
      return;
    }

    if (keyValue == state.expect![state.currentTypingIndex]) {
      await _onMarkCorrectTap(
        event.keyValue,
        emitter,
      );
    } else {
      await _onMarkWrongTap(
        emitter,
      );
      if (!state.isAbleToContinue) {
        return;
      }
    }

    // When correct Checking is finish the turn or not
    if (state.isFinishTarget) {
      _stopTapTimer();
      _vibrationBloc.add(VibrateShort());

      await _onAddPoint(AddPoint(), emitter);
      emitter(
        state.copyWith(
          timesCorrect: state.timesCorrect + 1,
          lifeRemaining:
              state.timesCorrect > state.difficultyModel!.numberTurnEachLevel
                  ? state.lifeRemaining + 1
                  : state.lifeRemaining,
        ),
      );

      // Play sound immediately
      if (state.isAbleToLevelUp) {
        _audioBloc.add(PlayCorrectUpAudio());
      } else {
        _audioBloc.add(PlayCorrectAudio());
      }

      await Future.delayed(const Duration(milliseconds: 1000));
      if (isClosed) {
        return;
      }

      // Checking is up level or not
      if (state.isAbleToLevelUp) {
        add(SetLevel(
          level: state.level + 1,
        ));
      } else {
        add(SetLevel(
          level: state.level,
        ));
      }
    }
  }

  Future<void> _onSetLevel(
    SetLevel event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        status: TurnStatus.playing,
        expect: "",
      ),
    );

    emitter(
      state.copyWith(
        level: event.level,
        timesCorrect: state.level != event.level ? 0 : null,
        typing: "",
        tapTimerRemaining: state.effectiveTimerDuration,
        pickRightJustCorrect:
            false, // Reset animation flag after new equations ready
        selectedOption: null, // Clear selection highlight
      ),
    );

    // add(ShowExpect(
    //   Duration(milliseconds: state.getTimeShowTarget),
    // ));

    await _onShowExpect(
        ShowExpect(Duration(milliseconds: state.getTimeShowTarget)), emitter);

    // Start the tap timer when showing expect
    _startTapTimer();

    // await Future.delayed(Duration(milliseconds: state.getTimeShowTarget));

    // add(HideExpect());
  }

  Future<void> _onLostLife(
    LifeLost event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - event.lifeRemaining,
      ),
    );

    if (!state.isAbleToContinue) {
      add(End(isCauseGameOver: true));
    }
  }

  Future<void> _onAddPoint(
    AddPoint event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        point: state.point + state.difficultyModel!.pointEachTurn,
      ),
    );
  }

  Future<void> _onGainLife(
    GainLife event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        lifeRemaining: state.lifeRemaining + event.lifeGained,
      ),
    );

    _vibrationBloc.add(VibrateShort());
  }

  Future<String> _onGeneratedRequiredString(
    GeneratedRequiredString event,
    Emitter<TurnState> emitter,
  ) async {
    String requiredString;
    late String expectString;

    switch (state.difficultyModel?.difficulty ?? Difficulty.easy) {
      /// Handles the generation of calculation expressions or random numbers based on the selected [Difficulty] mode:
      ///
      /// - [Difficulty.easy]: Generates a random number with a slightly increased level for simple challenges.
      /// - [Difficulty.medium]: Produces a plus/minus calculation expression for moderate difficulty.
      /// - [Difficulty.hard]: Creates a multiplication/division calculation expression for advanced difficulty.
      /// - [Difficulty.extreme]: Randomly selects between generating a complex plus/minus calculation, a higher-level random number, or a multiplication/division calculation for the most challenging experience.
      case Difficulty.medium:
        // Generate a plus/minus calculation expression for medium difficulty
        Map<String, String> result =
            Helper().randomCalculatorWithPlusMinus(state.level);
        expectString = result['expect']!;
        requiredString = result['expression']!;
        break;
      case Difficulty.hard:
        // Generate a multiplication/division calculation expression for hard difficulty
        Map<String, String> result =
            Helper().randomCalculatorWithMulDiv(state.level);
        expectString = result['expect']!;
        requiredString = result['expression']!;
        break;
      case Difficulty.extreme:
        // For extreme difficulty, randomly choose between different generators for added challenge
        final rand = Random();
        final choice = rand.nextInt(3);
        if (choice == 0) {
          // Plus/minus calculation with higher level
          var result = Helper().randomCalculatorWithPlusMinus(state.level + 2);
          expectString = result['expect']!;
          requiredString = result['expression']!;
        } else if (choice == 1) {
          // Generate a random number with higher level
          expectString = Helper().generateRandomNumber(state.level + 5);
          requiredString = expectString;
        } else {
          // Multiplication/division calculation with higher level
          var result = Helper().randomCalculatorWithMulDiv(state.level + 2);
          expectString = result['expect']!;
          requiredString = result['expression']!;
        }
        break;
      case Difficulty.pickRight:
        // Pick Right mode - generate three equations (one true, two false)
        Map<String, dynamic> equationsData =
            Helper().generatePickRightEquations(state.level);

        // Store equations in state
        emitter(
          state.copyWith(
            trueEquation: equationsData['trueEquation'],
            falseEquation: equationsData['falseEquation'],
            isLeftCorrect: equationsData['isLeftCorrect'],
            correctIndex: equationsData['correctIndex'],
            equations: List<String>.from(equationsData['equations']),
            selectedOption: null, // Reset selection
          ),
        );

        // For Pick Right mode, the "expect" is which button is correct (0, 1, or 2)
        // The "requirementString" shows all equations
        expectString = equationsData['correctIndex'].toString();
        final eqs = equationsData['equations'] as List<String>;
        requiredString = eqs.join(' | ');
        break;
      case Difficulty.easy:
        // Generate a random number for easy difficulty
        expectString = Helper().generateRandomNumber(state.level + 2);
        requiredString = expectString;
        break;
    }

    // String requiredString = Helper().generateRandomNumber(event.difficulty);

    emitter(
      state.copyWith(
        requirementString: requiredString,
        expect: expectString,
      ),
    );
    return requiredString;
  }

  /// Handles Pick Right mode button tap
  Future<void> _onPickRightButtonTap(
    PickRightButtonTap event,
    Emitter<TurnState> emitter,
  ) async {
    if (!state.isAbleToTap) {
      return;
    }

    if (state.expect == null || state.expect!.isEmpty) {
      return;
    }

    // Stop timer on selection
    _stopTapTimer();

    // Update state with selected option
    emitter(
      state.copyWith(
        selectedOption: event.buttonIndex,
      ),
    );

    // Check if selection is correct
    final expectedButton = int.tryParse(state.expect!) ?? -1;
    final isCorrect = event.buttonIndex == expectedButton;

    if (isCorrect) {
      // Correct selection
      _audioBloc.add(PlayCorrectAudio());
      _vibrationBloc.add(VibrateShort());

      // Trigger scale+fade-out animation
      emitter(
        state.copyWith(
          typing: state.expect, // Mark as complete
          pickRightJustCorrect: true,
        ),
      );

      // Wait for fade-out animation to complete
      await Future.delayed(const Duration(milliseconds: 400));
      if (isClosed) return;

      // Add point and proceed
      add(AddPoint());

      // Increment timesCorrect for progression tracking
      emitter(
        state.copyWith(
          timesCorrect: state.timesCorrect + 1,
          lifeRemaining:
              state.timesCorrect > state.difficultyModel!.numberTurnEachLevel
                  ? state.lifeRemaining + 1
                  : state.lifeRemaining,
        ),
      );

      if (isClosed) return;

      // Rest 0.5s between rounds
      await Future.delayed(const Duration(milliseconds: 500));
      if (isClosed) return;

      // Progress to next turn (SetLevel will generate new equations then reset flag)
      if (state.isAbleToLevelUp) {
        add(SetLevel(level: state.level + 1));
      } else {
        add(SetLevel(level: state.level));
      }
    } else {
      // Wrong selection
      _audioBloc.add(PlayWrongAudio());
      add(LifeLost(lifeRemaining: 1));

      if (state.lifeRemaining > 1) {
        await Future.delayed(const Duration(milliseconds: 1000));
        if (isClosed) return;

        // Reset and show new challenge
        add(SetLevel(level: state.level));
      } else {
        // Game over - last life lost
        await Future.delayed(const Duration(milliseconds: 1000));
        if (isClosed) return;

        add(End(isCauseGameOver: true));
      }
    }
  }

  Future<void> _onShowExpect(
    ShowExpect event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _stopTapTimer();
    await _onGeneratedRequiredString(GeneratedRequiredString(), emitter);

    emitter(
      state.copyWith(
        status: TurnStatus.initial,
        // expect: await _onGeneratedRequiredString(
        //     GeneratedRequiredString(), emitter),
      ),
    );

    await Future.delayed(
      event.duration,
      () {},
    );

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        status: TurnStatus.playing,
      ),
    );
  }

  Future<void> _onSetDifficulty(
    SetDifficulty event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        difficultyModel: DifficultyModel.getModel(event.difficulty),
      ),
    );

    // Save the last used difficulty for instant start feature
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      NucatchPreferencesKey.LAST_USED_DIFFICULTY,
      event.difficulty.name,
    );

    // add(Start(
    //   seconds: state.countDown,
    // ));

    event.onChanged?.call();
  }

  // Future<void> _onResetDifficulty(
  //   ResetDifficulty event,
  //   Emitter<TurnState> emitter,
  // ) async {
  //   if (isClosed) {
  //     return;
  //   }

  //   if (state.isLoading) {
  //     return;
  //   }

  //   emitter(
  //     state.copyWith(
  //       difficultyModel: DifficultyModel.getModel(Difficulty.easy),
  //     ),
  //   );

  //   add(SetLevel(
  //     level: 0,
  //     addPoint: 1,
  //   ));
  // }

  // void _onHideExpect(
  //   HideExpect event,
  //   Emitter<TurnState> emitter,
  // ) {
  //   if (isClosed) {
  //     return;
  //   }

  //   emitter(
  //     state.copyWith(
  //       status: TurnStatus.playing,
  //     ),
  //   );
  // }

  Future<void> _onMarkCorrectTap(
    KeyboardOption keyValue,
    // MarkCorrectTap event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _vibrationBloc.add(VibrateShort());

    emitter(
      state.copyWith(
          typing: "${state.typing}${keyboardArray[keyValue].toString()}"),
    );
  }

  Future<void> _onMarkWrongTap(
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _stopTapTimer();
    _vibrationBloc.add(VibrateLong());

    add(LifeLost());

    if (!state.isAbleToContinue) {
      add(End());

      return;
    } else {
      _audioBloc.add(PlayWrongAudio());
    }
  }

  Future<void> _onResetNewNumber(
    ResetNewNumber event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    if (!state.isAbleToReset) {
      return;
    }

    _stopTapTimer();
    add(LifeLost());
    _vibrationBloc.add(VibrateMultiple());

    await Future.delayed(
        Duration(milliseconds: event.duration.inMilliseconds + 500));
    await _onSetLevel(
      SetLevel(
        level: state.level,
      ),
      emitter,
    );
  }

  Future<void> _onSaveRecorded(
    SaveRecorded event,
    Emitter<TurnState> emitter,
  ) async {
    debugPrint('🎮 SaveRecorded event triggered');

    if (isClosed) {
      debugPrint('⚠️ Save skipped: BLoC is closed');
      event.callback?.call();
      return;
    }

    if (state.recordedItem == null) {
      debugPrint('⚠️ Save skipped: recordedItem is null');
      event.callback?.call();
      return;
    }

    if (state.recordedItem!.point == 0) {
      debugPrint('⚠️ Save skipped: score is 0 (intentional)');
      event.callback?.call();
      return;
    }

    if (state.isLoading) {
      debugPrint('⚠️ Save skipped: already loading');
      event.callback?.call();
      return;
    }

    debugPrint('✅ Starting save for score: ${state.recordedItem!.point}');

    emitter(
      state.copyWith(
        isLoading: true,
      ),
    );

    // Save to Firestore - offline persistence will queue if offline and auto-sync when online
    final insertSuccess =
        await _turnedServices.addItemToFirebase(state.recordedItem!);
    final saveSuccess = insertSuccess;

    _audioBloc.add(PlaySaveSuccessAudio());

    emitter(
      state.copyWith(
        isLoading: false,
        saveSuccess: saveSuccess,
        message: saveSuccess ? 'save_success' : 'save_failed',
      ),
    );

    // emitter(
    //   state.copyWith(
    //     listModel: await _turnedServices.getTurnedList(),
    //   ),
    // );

    // return itemModel;

    event.callback?.call();
  }

  Future<void> _onStart(
    Start event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      const TurnState().copyWith(
        countDown: event.seconds,
        status: TurnStatus.intro,
        point: 0,
        difficultyModel:
            state.difficultyModel ?? DifficultyModel.getModel(Difficulty.easy),
      ),
    );

    _audioBloc.add(PlayIntroAudio());

    // await Future.delayed(
    //   Duration(
    //     seconds: state.countDown,
    //   ),
    // );

    // Play countdown audio for each second
    for (int i = state.countDown; i > 0; i--) {
      if (i > 0 && i <= state.countDown - 1) {
        _audioBloc.add(PlaySecondTicking());
      }

      if (i == 1) {
        Future.delayed(const Duration(milliseconds: kAnimationDurationSlow))
            .then((_) {
          _audioBloc.add(PlayNewTings());
        });
      }

      if (i > 0 && i < state.countDown) {
        _vibrationBloc.add(VibrateShort());
      }
      await Future.delayed(const Duration(seconds: 1));
      if (isClosed) {
        return;
      }
    }

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _vibrationBloc.add(VibrateLong());

    add(
      SetLevel(
        level: 1,
      ),
    );
  }

  Future<void> _onEnd(
    End event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    // Guard: skip if we are already in gameOver state to prevent duplicate saves
    if (state.status == TurnStatus.gameOver) {
      debugPrint('⚠️ End skipped: already in gameOver state');
      return;
    }

    if (state.isLoading) {
      return;
    }

    _stopTapTimer();

    if (event.isCauseGameOver) {
      _audioBloc.add(PlayEndAudio());
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PreferencesKey.USERNAME);

    // Get Firebase UID from UserServices
    final userServices = UserServices();
    final userState = await userServices.getUserSession();
    String? firebaseUserId = userState.model.firebaseUserId;

    // Retry auth if Firebase user ID is null (race condition fix)
    if (firebaseUserId == null) {
      debugPrint('⚠️ Firebase user not ready, retrying auth...');
      final retryState = await userServices.initializeAuth();
      firebaseUserId = retryState.model.firebaseUserId;
      debugPrint('✅ Firebase user after retry: $firebaseUserId');
    }

    TurnRecordedModel itemModel = TurnRecordedModel(
      turnId: const Uuid().v4(),
      playedUsername: username,
      point: state.point,
      recordedTime: DateTime.now(),
      difficulty: state.difficultyModel?.difficulty ?? Difficulty.easy,
      firebaseUserId: firebaseUserId,
    );

    emitter(
      state.copyWith(
        status: TurnStatus.gameOver,
        recordedItem: itemModel,
      ),
    );

    add(SaveRecorded());
  }

  Future<void> _onCountDownIntro(
    CountDownIntro event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }
  }

  Future<void> _onApplySetting(
    ApplySetting event,
    Emitter<TurnState> emitter,
  ) async {
    _audioBloc.add(SetAudioVolume(volume: event.settingModel.vol / 10));
    _vibrationBloc
        .add(SetVibrationEnabled(enabled: event.settingModel.isVibrate));
  }

  void _onTapTimerTick(
    TapTimerTick event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) return;
    if (state.isLoading) return;

    // Clamp to 0 if very close to prevent floating-point errors
    final clampedTime = event.remainingTime < 0.01 ? 0.0 : event.remainingTime;

    emitter(
      state.copyWith(
        tapTimerRemaining: clampedTime,
      ),
    );
  }

  Future<void> _onTapTimerTimeout(
    TapTimerTimeout event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) return;
    if (state.isLoading) return;
    if (!state.isAbleToTap) return;

    _stopTapTimer();

    await _onLostLife(LifeLost(), emitter);

    // NOTE: Do NOT also call add(End()) here.
    // _onLostLife already dispatches add(End(isCauseGameOver: true)) internally
    // when !isAbleToContinue. Adding it here caused a double-End -> double SaveRecorded.
    if (state.isAbleToContinue) {
      _audioBloc.add(PlayWrongAudio());
      await Future.delayed(
          const Duration(milliseconds: kAnimationDurationSlow));
      add(SetLevel(level: state.level));
    }
  }

  void _onTapTimerPause(
    TapTimerPause event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) return;

    emitter(
      state.copyWith(
        isTimerPaused: true,
      ),
    );
  }

  void _onTapTimerResume(
    TapTimerResume event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) return;

    emitter(
      state.copyWith(
        isTimerPaused: false,
      ),
    );
  }

  void _onTapTimerReset(
    TapTimerReset event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) return;

    _startTapTimer();
    emitter(
      state.copyWith(
        tapTimerRemaining: state.effectiveTimerDuration,
        isTimerPaused: false,
      ),
    );
  }

  void _onRenew(
    Renew event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) return;

    emitter(
      const TurnState(),
    );
  }
}
