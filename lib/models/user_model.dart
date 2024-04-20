class UserModel {
  final String? username;

  UserModel({
    this.username,
  });

  UserModel copyWith({
    String? username,
  }) {
    return UserModel(username: username ?? this.username);
  }
}
