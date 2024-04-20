import 'package:nucatch_with_bloc/models/user_model.dart';

class UserState {
  final UserModel model;

  UserState({
    required this.model,
  });

  String get username => model.username ?? "Anonymous";

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
  UnAuthenticatedUser() : super(model: UserModel(username: "Anonymous"));
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model});
}
