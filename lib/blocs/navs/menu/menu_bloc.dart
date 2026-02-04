import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(super.initialState) {
    on<SelectOption>(_onSelectOption);
    on<ShowMenu>(_onShowMenu);
  }

  Future<void> _onSelectOption(
    SelectOption event,
    Emitter<MenuState> emitter,
  ) async {
    switch (event.option) {
      case MenuOption.start:
        emitter(Play());
        break;

      case MenuOption.instantStart:
        emitter(InstantStart());
        break;

      case MenuOption.topScore:
        emitter(TopScore());
        break;

      case MenuOption.setting:
        emitter(Setting());
        break;

      case MenuOption.about:
        emitter(About());
        break;

      case MenuOption.exit:
        emitter(Exit());
        SystemNavigator.pop();
        exit(0);
    }
  }

  Future<void> _onShowMenu(
    ShowMenu event,
    Emitter<MenuState> emitter,
  ) async {
    emitter(Menu());
  }
}
