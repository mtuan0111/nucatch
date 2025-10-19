import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/audio/audio_bloc.dart';
import 'package:nucatch/blocs/objects/audio/audio_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_bloc.dart';
import 'package:nucatch/blocs/objects/vibration/vibration_event.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/services/turn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TurnBloc extends Bloc<TurnEvent, TurnState> {
  final TurnRecordedServices _turnedServices = TurnRecordedServices();
  final AudioBloc _audioBloc;
  final VibrationBloc _vibrationBloc;

  TurnBloc(
    TurnState initialState, {
    required AudioBloc audioBloc,
    required VibrationBloc vibrationBloc,
  })  : _audioBloc = audioBloc,
        _vibrationBloc = vibrationBloc,
        super(initialState) {
    on<Tap>(_onTap);
    on<AddPoint>(_onAddPoint);
    on<LostLife>(_onLostLife);
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
      _vibrationBloc.add(VibrateShort());

      await _onAddPoint(AddPoint(), emitter);
      emitter(
        state.copyWith(
          timesCorrect: state.timesCorrect + 1,
          lifeRemaining: state.timesCorrect >= 2
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
        // lifeRemaining: state.level != event.level
        //     ? state.lifeRemaining
        //     : state.lifeRemaining + event.addPoint,
        // expect: Helper().generateRandomNumber(event.level + 2),
        typing: "",
      ),
    );

    add(ShowExpect(
      Duration(milliseconds: state.getTimeShowTarget),
    ));

    // await Future.delayed(Duration(milliseconds: state.getTimeShowTarget));

    // add(HideExpect());
  }

  Future<void> _onLostLife(
    LostLife event,
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

    _vibrationBloc.add(VibrateLong());

    add(LostLife());

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

    add(LostLife());
    _vibrationBloc.add(VibrateMultiple());

    await Future.delayed(
        Duration(milliseconds: event.duration.inMilliseconds + 500));
    await _onSetLevel(
      SetLevel(
        level: state.level,
        addPoint: 0,
      ),
      emitter,
    );
  }

  Future<void> _onSaveRecorded(
    SaveRecorded event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      event.callback?.call();
      return;
    }

    if (state.recordedItem == null) {
      event.callback?.call();
      return;
    }

    if (state.recordedItem!.point == 0) {
      event.callback?.call();
      return;
    }

    if (state.isLoading) {
      event.callback?.call();
      return;
    }

    emitter(
      state.copyWith(
        isLoading: true,
      ),
    );

    bool insertSuccess =
        await _turnedServices.addItemToFirebase(state.recordedItem!);

    await _turnedServices.addItem(state.recordedItem!); //For backup locally

    _audioBloc.add(PlaySaveSuccessAudio());

    emitter(
      state.copyWith(
        isLoading: false,
        saveSuccess: insertSuccess,
        message: insertSuccess ? 'save_success' : 'save_failed',
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
        difficultyModel:
            state.difficultyModel ?? DifficultyModel.getModel(Difficulty.easy),
      ),
    );

    _audioBloc.add(PlayIntroAudio());

    await Future.delayed(
      Duration(
        seconds: state.countDown,
      ),
    );

    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _vibrationBloc.add(VibrateShort());

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

    if (state.isLoading) {
      return;
    }
    if (event.isCauseGameOver) {
      _audioBloc.add(PlayEndAudio());
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PreferencesKey.USERNAME);

    TurnRecordedModel itemModel = TurnRecordedModel(
      turnId: const Uuid().v4(),
      playedUsername: username,
      point: state.point,
      recordedTime: DateTime.now(),
      difficulty: state.difficultyModel?.difficulty ?? Difficulty.easy,
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
}
