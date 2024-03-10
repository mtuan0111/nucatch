import 'package:nucatch_with_bloc/models/user_model.dart';

class UserState {
  final UserModel? model;

  UserState({
    this.model,
  });

  UserState copyWith({
    UserModel? model,
    bool? isLoading,
  }) {
    return UserState(
      model: model ?? this.model,
    );
  }
}

class LoadingUser extends UserState {
  LoadingUser();
}

class UnAuthenticatedUser extends UserState {
  UnAuthenticatedUser() : super(model: UserModel(name: "Anonymous"));
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({required super.model});
}
