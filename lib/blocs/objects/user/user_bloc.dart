import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch/blocs/objects/user/user_event.dart';
import 'package:nucatch/blocs/objects/user/user_state.dart';
import 'package:nucatch/services/user_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserServices _userServices = UserServices();
  UserBloc(super.initialState) {
    on<AttempGettingUser>(_onAttempGettingUser);

    on<UsernameChanged>(_onUsernameChanged);

    add(AttempGettingUser());
  }

  Future<void> _onAttempGettingUser(
    AttempGettingUser event,
    Emitter<UserState> emitter,
  ) async {
    emitter(
      UnAuthenticatedUser(),
    );

    // Initialize Firebase Anonymous Auth and get user session
    emitter(await _userServices.initializeAuth());
  }

  Future<void> _onUsernameChanged(
    UsernameChanged event,
    Emitter<UserState> emitter,
  ) async {
    if (await _userServices.saveUsername(event.newUsername)) {
      emitter(await _userServices.getUserSession());
    }
  }
}
