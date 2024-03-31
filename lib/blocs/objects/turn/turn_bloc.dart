import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/navs/menu/menu_state.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/turn/turn_state.dart';
import 'package:nucatch_with_bloc/helpers/helper.dart';

class TurnBloc extends Bloc<TurnEvent, TurnState> {
  TurnBloc(super.initialState) {
    on<Tap>(_onTap);
    on<SetLevel>(_onSetLevel);
    on<ShowExpect>(_onShowExpect);
    on<HideExpect>(_onHideExpect);
    on<MarkCorrectTap>(_onMarkCorrectTap);
    on<MarkWrongTap>(_onMarkWrongTap);
    on<ResetNewNumber>(_onResetNewNumber);

    on<Start>(_onStart);
    on<CountDownIntro>(_onCountDownIntro);
  }

  Future<bool> _onTap(
    Tap event,
    Emitter<TurnState> emitter,
  ) async {
    if (event.keyValue == KeyboardOption.reset) {
      return false;
    }

    if (event.keyValue == KeyboardOption.mainMenu) {
      return false;
    }

    if (state.lifeRemaining < 0) {
      return false;
    }

    if (state.expect == null || state.expect!.isEmpty) {
      return false;
    }

    if (!state.isAbleToTap) {
      if (state.isExpectNotEmpty) {
        emitter(
          state.copyWith(
            status: TurnStatus.playing,
          ),
        );
      } else {
        return false;
      }
    }

    // Checking is correct tap or not.
    String keyValue = keyboardArray[event.keyValue].toString();
    if (keyValue == state.expect![state.currentTypingIndex]) {
      await _onMarkCorrectTap(
        MarkCorrectTap(keyValue: event.keyValue),
        emitter,
      );
    } else {
      bool isAllowToContinue = await _onMarkWrongTap(
        MarkWrongTap(),
        emitter,
      );
      if (!isAllowToContinue) {
        return false;
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
    return true;
  }

  Future<void> _onSetLevel(
    SetLevel event,
    Emitter<TurnState> emitter,
  ) async {
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
    emitter(
      state.copyWith(
        status: TurnStatus.playing,
      ),
    );
  }

  Future<void> _onMarkCorrectTap(
    MarkCorrectTap event,
    Emitter<TurnState> emitter,
  ) async {
    HapticFeedback.heavyImpact();

    emitter(
      state.copyWith(
          typing: "${state.typing}${keyboardArray[event.keyValue].toString()}"),
    );
  }

  Future<bool> _onMarkWrongTap(
    MarkWrongTap event,
    Emitter<TurnState> emitter,
  ) async {
    emitter(
      state.copyWith(
        lifeRemaining: state.lifeRemaining - 1,
      ),
    );

    if (state.lifeRemaining == 0) {
      emitter(
        state.copyWith(
          status: TurnStatus.gameOver,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> _onResetNewNumber(
    ResetNewNumber event,
    Emitter<TurnState> emitter,
  ) async {
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

  Future<void> _onStart(
    Start event,
    Emitter<TurnState> emitter,
  ) async {
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
  ) async {}
}
