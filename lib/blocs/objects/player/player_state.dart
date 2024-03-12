import 'package:nucatch_with_bloc/models/user_model.dart';

class PlayerState {
  final UserModel user;
  final int point;
  final int level;

  PlayerState({
    required this.user,
    this.point = 0,
    this.level = 1,
  });

  PlayerState copyWith({
    UserModel? user,
    int? point,
    int? level,
  }) {
    return PlayerState(
      user: user ?? this.user,
      point: point ?? this.point,
      level: level ?? this.level,
    );
  }
}
