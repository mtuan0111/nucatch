abstract class UserEvent {}

class AttempGettingUser extends UserEvent {}

class UsernameChanged extends UserEvent {
  final String newUsername;

  UsernameChanged({required this.newUsername});
}
