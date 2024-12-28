import 'package:nucatch_with_bloc/helpers/const.dart';
import 'package:nucatch_with_bloc/models/user_model.dart';

class UserState {
  final UserModel model;

  UserState({
    required this.model,
  });

  String get username => model.username ?? defaultUsername;

  UserState copyWith({
    String? username,
    UserModel? model,
  }) {
    return UserState(
      model: this.model.copyWith(
            username: username,
          ),
    );
  }
}

class UnAuthenticatedUser extends UserState {
  UnAuthenticatedUser() : super(model: UserModel(username: defaultUsername));
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model});
}
