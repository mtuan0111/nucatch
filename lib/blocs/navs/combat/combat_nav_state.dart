abstract class CombatNavState {}

class CombatNavInitial extends CombatNavState {}

/// Setup screen - choose to create or join room
class CombatSetupState extends CombatNavState {}

/// Host is creating/advertising a room
class HostRoomState extends CombatNavState {}

/// Guest is discovering/joining a room
class JoinRoomState extends CombatNavState {}

/// Setting difficulty (host only)
class CombatSetDifficultyState extends CombatNavState {}

/// Playing the combat game
class CombatPlayingState extends CombatNavState {}

/// Game ended
class CombatEndGameState extends CombatNavState {}

/// Restart confirmation screen
class CombatRestartConfirmationState extends CombatNavState {}
