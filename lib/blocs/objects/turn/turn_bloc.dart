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

    add(SetLevel(level: 1));
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

    String keyValue = keyboardArray[event.keyValue].toString();
    if (keyValue == state.expect![state.currentTypingIndex]) {
      emitter(
        state.copyWith(
            typing:
                "${state.typing}${keyboardArray[event.keyValue].toString()}"),
      );
    }

    if (state.isFinishTarget) {
      emitter(
        state.copyWith(
          point: state.point + 1,
          timesCorrect: state.timesCorrect + 1,
        ),
      );

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
        level: event.level,
        timesCorrect: state.level != event.level ? 0 : state.timesCorrect + 1,
        expect: Helper().generateRandomNumber(event.level + 2),
        typing: "",
      ),
    );

    add(ShowExpect(isShow: true));
    await Future.delayed(Duration(milliseconds: state.getTimeShowTarget));
    add(ShowExpect(isShow: false));
  }

  void _onShowExpect(
    ShowExpect event,
    Emitter<TurnState> emitter,
  ) {
    emitter(
      state.copyWith(
        isShowExpect: event.isShow,
      ),
    );
  }
}
