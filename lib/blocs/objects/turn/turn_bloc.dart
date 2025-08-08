import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/turn/turn_event.dart';
import 'package:nucatch/blocs/objects/turn/turn_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/preferences_key.dart';
import 'package:nucatch/models/setting_model.dart';
import 'package:nucatch/models/turn_record_model.dart';
import 'package:nucatch/services/audio_services.dart';
import 'package:nucatch/services/turn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class TurnBloc extends Bloc<TurnEvent, TurnState> {
  late TurnRecordedServices _turnedServices;
  late AudioServices _audioServices;
  late VibrationServices _vibrateServices;

  TurnBloc(super.initialState, {SettingModel? settingModel}) {
    on<Tap>(_onTap);
    on<SetLevel>(_onSetLevel);
    on<LostLife>(_onLostLife);
    on<AddPoint>(_onAddPoint); // Handle AddPoint as a SetLevel event
    on<GainLife>(_onGainLife);
    on<GeneratedRequiredString>(_onGeneratedRequiredString);
    on<ShowExpect>(_onShowExpect);
    on<SetDifficulty>(_onSetDifficulty);

    // on<HideExpect>(_onHideExpect);
    // on<MarkCorrectTap>(_onMarkCorrectTap);
    // on<MarkWrongTap>(_onMarkWrongTap);
    on<ResetNewNumber>(_onResetNewNumber);
    on<SaveRecorded>(_onSaveRecorded);

    on<Start>(_onStart);
    on<End>(_onEnd);

    on<CountDownIntro>(_onCountDownIntro);
    on<ApplySetting>(_onApplySetting);

    _turnedServices = TurnRecordedServices();
    _audioServices = AudioServices();
    _vibrateServices = VibrationServices();
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

    _audioServices.playTap();

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
        event.context,
        // MarkWrongTap(),
        emitter,
      );
      if (!state.isAbleToContinue) {
        return;
      }
    }

    // When correct Checking is finish the turn or not
    if (state.isFinishTarget) {
      _vibrateServices.vibrate(duration: 100);

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
        _audioServices.playCorrectUp();
      } else {
        _audioServices.playCorrect();
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
      add(End(event.context, isCauseGameOver: true));
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

    _vibrateServices.vibrate(duration: 100);
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
        difficultyModel: event.difficultyModel,
      ),
    );

    // add(Start(
    //   seconds: state.countDown,
    // ));

    event.onChanged?.call(event.difficultyModel);
  }

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

    _vibrateServices.vibrate(duration: 50);

    emitter(
      state.copyWith(
          typing: "${state.typing}${keyboardArray[keyValue].toString()}"),
    );
  }

  Future<void> _onMarkWrongTap(
    BuildContext context,
    // MarkWrongTap event,

    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    _vibrateServices.vibrate(duration: 500);

    add(LostLife(context));

    if (!state.isAbleToContinue) {
      add(End(context));

      return;
    } else {
      _audioServices.playWrong();
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

    add(LostLife(event.context));
    _vibrateServices.multipleVibrate();

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
      return;
    }

    if (state.recordedItem == null) {
      return;
    }

    if (state.recordedItem!.point == 0) {
      return;
    }

    if (state.isLoading) {
      return;
    }

    emitter(
      state.copyWith(
        isLoading: true,
      ),
    );

    bool insertSuccess = await _turnedServices.addItem(state.recordedItem!);

    Fluttertoast.showToast(
      msg: insertSuccess
          // ignore: use_build_context_synchronously
          ? lang(event.context).insertedSuccess
          // ignore: use_build_context_synchronously
          : lang(event.context).insertedFailed,
    );

    _audioServices.playSaveSuccess();

    emitter(
      state.copyWith(
        isLoading: false,
      ),
    );

    // emitter(
    //   state.copyWith(
    //     listModel: await _turnedServices.getTurnedList(),
    //   ),
    // );

    // return itemModel;
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
      TurnState(state.context).copyWith(
        countDown: event.seconds,
        status: TurnStatus.intro,
        difficultyModel:
            state.difficultyModel ?? DifficultyModel.getModel(Difficulty.easy),
      ),
    );

    _audioServices.playIntro();

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

    _vibrateServices.vibrate(duration: 100);

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
      _audioServices.playEnd();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(PreferencesKey.USERNAME);

    TurnRecordedModel itemModel = TurnRecordedModel(
      turnId: const Uuid().v4(),
      playedUsername: username,
      point: state.point,
      recordedTime: DateTime.now(),
    );

    emitter(
      state.copyWith(
        status: TurnStatus.gameOver,
        recordedItem: itemModel,
      ),
    );

    add(SaveRecorded(
      event.context,
    ));
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
    // _audioServices.setVolume(event.settingModel.vol / 10) = AudioServices(volume: event.settingModel.vol / 10);
    _audioServices.setVolume = event.settingModel.vol / 10;
    _vibrateServices.setIsVibrate = event.settingModel.isVibrate;
  }
}
