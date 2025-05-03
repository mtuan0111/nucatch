import 'package:nucatch/models/user_model.dart';

class UserState {
  final UserModel model;

  UserState({
    required this.model,
  });

  String? get username =>
      model.username?.isNotEmpty == true ? model.username : null;

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
  UnAuthenticatedUser() : super(model: UserModel());
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model});
}
