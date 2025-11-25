class UserModel {
  final String? username;
  final String? firebaseUserId;
  final bool isAnonymous;

  UserModel({
    this.username,
    this.firebaseUserId,
    this.isAnonymous = true,
  });

  UserModel copyWith({
    String? username,
    String? firebaseUserId,
    bool? isAnonymous,
  }) {
    return UserModel(
      username: username ?? this.username,
      firebaseUserId: firebaseUserId ?? this.firebaseUserId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
    );
  }
}
