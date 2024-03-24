import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_event.dart';
import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/services/user_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserServices _userServices = UserServices();
  UserBloc(super.initialState) {
    on<AttempGettingUser>(_onAttempGettingUser);

    add(AttempGettingUser());
  }

  Future<void> _onAttempGettingUser(
    AttempGettingUser event,
    Emitter<UserState> emitter,
  ) async {
    emitter(
      UnAuthenticatedUser(),
    );

    emitter(await _userServices.getUserSession());
  }
}
