import 'package:nucatch_with_bloc/blocs/objects/user/user_state.dart';
import 'package:nucatch_with_bloc/models/user_model.dart';

class UserServices {
  Future<UserState> getUserSession() async {
    await Future.delayed(const Duration(seconds: 1));

    UserModel? attempUser = UserModel(name: "BOM", settings: null);

    return AuthenticatedUser(model: attempUser);
    return UnAuthenticatedUser();
  }
}
