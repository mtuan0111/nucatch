class UserModel {
  final String name;
  final Map<String, dynamic>? settings;

  UserModel({
    required this.name,
    this.settings,
  });
}
