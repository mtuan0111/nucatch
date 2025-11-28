abstract class AppVersionEvent {}

class CheckForUpdateEvent extends AppVersionEvent {}

class DismissUpdateEvent extends AppVersionEvent {}

class UpdateLaterEvent extends AppVersionEvent {}
