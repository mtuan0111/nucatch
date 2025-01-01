import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/helpers/helper.dart';
import 'package:nucatch_with_bloc/helpers/preferences_key.dart';
import 'package:nucatch_with_bloc/models/turn_record_model.dart';
import 'package:nucatch_with_bloc/services/turn_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TurnBloc extends Bloc<TurnEvent, TurnState> {
  late TurnRecordedServices _turnedServices;

  TurnBloc(super.initialState) {
    on<Tap>(_onTap);
    on<SetLevel>(_onSetLevel);
    on<ShowExpect>(_onShowExpect);
    on<HideExpect>(_onHideExpect);
    // on<MarkCorrectTap>(_onMarkCorrectTap);
    // on<MarkWrongTap>(_onMarkWrongTap);
    on<ResetNewNumber>(_onResetNewNumber);
    on<SaveRecorded>(_onSaveRecorded);

    on<Start>(_onStart);
    on<CountDownIntro>(_onCountDownIntro);

    _turnedServices = TurnRecordedServices();
  }

  Future<void> _onTap(
    Tap event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

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
        // MarkWrongTap(),
        emitter,
      );
      if (!state.isAbleToContinue) {
        return;
      }
    }

    // When correct Checking is finish the turn or not
    if (state.isFinishTarget) {
      HapticFeedback.vibrate();
      emitter(
        state.copyWith(
          point: state.point + 1,
          timesCorrect: state.timesCorrect + 1,
          // status: TurnStatus.rest,
          // expect: "",
        ),
      );

      await Future.delayed(const Duration(milliseconds: 1000));

      // Checking is up level or not
      if (state.timesCorrect > 3) {
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

    emitter(
      state.copyWith(
        status: TurnStatus.playing,
        expect: "",
      ),
    );

    emitter(
      state.copyWith(
        level: event.level,
        timesCorrect: state.level != event.level
            ? 0
            : state.timesCorrect + (event.addPoint > 0 ? 1 : 0),
        lifeRemaining: state.level != event.level
            ? state.lifeRemaining
            : state.lifeRemaining + event.addPoint,
        expect: Helper().generateRandomNumber(event.level + 2),
        typing: "",
      ),
    );

    add(ShowExpect());

    await Future.delayed(Duration(milliseconds: state.getTimeShowTarget));

    add(HideExpect());
  }

  void _onShowExpect(
    ShowExpect event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) {
      return;
    }

    emitter(
      state.copyWith(
        status: TurnStatus.initial,
      ),
    );
  }

  void _onHideExpect(
    HideExpect event,
    Emitter<TurnState> emitter,
  ) {
    if (isClosed) {
      return;
    }

    emitter(
      state.copyWith(
        status: TurnStatus.playing,
      ),
    );
  }

  Future<void> _onMarkCorrectTap(
    KeyboardOption keyValue,
    // MarkCorrectTap event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    HapticFeedback.heavyImpact();

    emitter(
      state.copyWith(
          typing: "${state.typing}${keyboardArray[keyValue].toString()}"),
    );
  }

  Future<void> _onMarkWrongTap(
    // MarkWrongTap event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    emitter(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - 1,
      ),
    );

    if (!state.isAbleToContinue) {
      // TurnRecordedModel itemSaved =
      //     await _onSaveRecorded(SaveRecorded(), emitter);

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String username =
          prefs.getString(PreferencesKey.USERNAME) ?? defaultUsername;

      TurnRecordedModel itemModel = TurnRecordedModel(
        playedUsername: username,
        point: state.point,
        recordedTime: DateTime.now(),
      );

      add(SaveRecorded(savingRecord: itemModel));

      emitter(
        state.copyWith(
          status: TurnStatus.gameOver,
          recordedItem: itemModel,
        ),
      );
      return;
    }
  }

  Future<void> _onResetNewNumber(
    ResetNewNumber event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }

    if (!state.isAbleToReset) {
      return;
    }

    emitter(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - 1,
      ),
    );

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

    await _turnedServices.addItem(event.savingRecord);

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

    emitter(
      TurnState().copyWith(
        countDown: event.seconds,
        status: TurnStatus.intro,
      ),
    );

    await Future.delayed(
      Duration(
        seconds: state.countDown,
      ),
    );

    if (isClosed) {
      return;
    }

    HapticFeedback.vibrate();

    add(
      SetLevel(
        level: 1,
      ),
    );
  }

  Future<void> _onCountDownIntro(
    CountDownIntro event,
    Emitter<TurnState> emitter,
  ) async {
    if (isClosed) {
      return;
    }
  }
}
