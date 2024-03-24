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
    on<TakeARest>(_onTakeARest);
    on<MarkCorrectTap>(_onMarkCorrectTap);
    on<MarkWrongTap>(_onMarkWrongTap);
    on<ResetNewNumber>(_onResetNewNumber);
  }

  Future<void> _onTap(
    Tap event,
    Emitter<TurnState> emitter,
  ) async {
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
      return;
    }

    // Checking is correct tap or not.
    String keyValue = keyboardArray[event.keyValue].toString();
    if (keyValue == state.expect![state.currentTypingIndex]) {
      await _onMarkCorrectTap(
          MarkCorrectTap(keyValue: event.keyValue), emitter);
    } else {
      bool isAllowToContinue = await _onMarkWrongTap(MarkWrongTap(), emitter);
      if (!isAllowToContinue) {
        return;
      }
    }

    // When correct Checking is finish the turn or not
    if (state.isFinishTarget) {
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
    emitter(
      state.copyWith(
        status: TurnStatus.initial,
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
        status: TurnStatus.initial,
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

  Future<void> _onTakeARest(
    TakeARest event,
    Emitter<TurnState> emitter,
  ) async {
    TurnStatus previousStatus = state.status;
    await Future.delayed(const Duration(milliseconds: 50));
    emitter(
      state.copyWith(
        status: TurnStatus.rest,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    emitter(
      state.copyWith(
        status: previousStatus,
      ),
    );
  }

  Future<void> _onMarkCorrectTap(
    MarkCorrectTap event,
    Emitter<TurnState> emitter,
  ) async {
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

    await _onSetLevel(SetLevel(level: state.level, addPoint: 0), emitter);
  }
}
