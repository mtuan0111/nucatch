import 'package:nucatch_with_bloc/models/user_model.dart';

class UserState {
  final UserModel model;

  UserState({
    required this.model,
  });

  UserState copyWith({
    UserModel? model,
  }) {
    return UserState(
      model: model ?? this.model,
    );
  }
}

class UnAuthenticatedUser extends UserState {
  UnAuthenticatedUser() : super(model: UserModel(name: "Anonymous"));
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model});
}
