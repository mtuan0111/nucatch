# PlayMode Feature Implementation Summary

## Overview
This document outlines the implementation of the PlayMode feature system, which adds **Solo Mode** and **Combat Mode** gameplay options to NuCatch.

## PlayMode Enum
```dart
enum PlayMode {
  solo,    // Single player mode (current implementation)
  combat,  // Multiplayer mode via Bluetooth
}
```

## New Navigation Flow

### Updated Flow
```
Main Menu → Start
  ↓
Select Play Mode Screen
  ├─→ Solo Mode → Set Difficulty → Play
  └─→ Combat Mode → Create/Join Room → Pairing → Play (Turn-based)
```

## Files Created

### 1. SelectPlayModeScreen
**Path**: `/lib/screens/menu_screens/player/select_play_mode_screen.dart`
- Displays two cards for mode selection
- Solo Mode: Traditional single-player experience
- Combat Mode: Bluetooth multiplayer with turn-based gameplay

### 2. CombatModeSetupScreen
**Path**: `/lib/screens/menu_screens/player/combat_mode_setup_screen.dart`
- Two options:
  - **Create Room**: Host a game (generates 3-digit code)
  - **Join Room**: Enter room code to connect
- TODO: Bluetooth permission check before navigation

### 3. PairingRoomScreen
**Path**: `/lib/screens/menu_screens/player/pairing_room_screen.dart`

**Host View**:
- Displays generated 3-digit room code
- Waits for player connection
- Shows pairing status
- "Start" button appears when paired

**Guest View**:
- TextField for entering 3-digit code
- "Connect" button
- Shows connection/pairing status

**Features**:
- Real-time connection status
- Visual feedback (spinner, checkmark)
- Only host can start the game
- TODO: Implement actual Bluetooth connectivity

## Files Modified

### 1. player_nav_state.dart
**Changes**:
- Added `SelectPlayModeState`
- Added `CombatModeSetupState`
- Added `PairingRoomState` with `isHost` and `roomCode` properties
- Updated `PlayingState` to include `PlayMode`
- Updated `SetDifficultyState` to include `PlayMode`

### 2. player_nav_cubit.dart
**New Properties**:
- `_currentPlayMode`: Tracks selected mode
- `currentPlayMode` getter

**New Methods**:
- `showSelectPlayMode()`: Navigate to mode selection
- `selectPlayMode(PlayMode)`: Set mode and go to difficulty
- `showCombatModeSetup()`: Navigate to create/join screen
- `showPairingRoom({isHost, roomCode})`: Navigate to pairing

**Updated Methods**:
- `showPlay({playMode})`: Optional playMode parameter
- `showSetDifficulty({playMode})`: Optional playMode parameter

### 3. player_nav.dart
**Changes**:
- Added imports for new screens
- Updated navigation pages to include:
  - `SelectPlayModeScreen` (initial page)
  - `CombatModeSetupScreen`
  - `PairingRoomScreen`
  - `SetDifficultyScreen`
- Fixed import conflicts by using const.dart's `lang` function

## Localization Keys Added

### English (app_en.arb)
```json
"selectPlayMode": "Select Play Mode"
"soloMode": "Solo Mode"
"soloModeDescription": "Play alone and challenge yourself to beat your high score"
"combatMode": "Combat Mode"
"combatModeDescription": "Play with another player via Bluetooth connection and take turns"
"createRoom": "Create Room"
"createRoomDescription": "Host a new game and wait for another player to join"
"joinRoom": "Join Room"
"joinRoomDescription": "Enter a room code to join an existing game"
"hostRoom": "Host Room"
"roomCode": "Room Code"
"shareCodeWithPlayer": "Share this code with another player"
"enterRoomCode": "Enter Room Code"
"connect": "Connect"
"searchingForPlayers": "Searching for players..."
"pairedWith": "Paired with {playerName}!"
```

### Vietnamese (app_vi.arb)
- All corresponding Vietnamese translations added

## Current Implementation Status

### ✅ Completed
1. PlayMode enum and state management
2. Navigation flow with new screens
3. UI for all screens (mode selection, room setup, pairing)
4. Localization (English + Vietnamese)
5. Room code generation (3-digit)
6. Visual feedback for connection states
7. Host/Guest role differentiation

### ⏳ TODO - Bluetooth Implementation
1. **Permission Handling**:
   ```dart
   // Add to CombatModeSetupScreen._checkBluetoothPermissionAndNavigate
   - Request Bluetooth permissions (Android/iOS)
   - Handle permission denial gracefully
   ```

2. **Bluetooth Connection**:
   ```dart
   // Implement in PairingRoomScreen
   - Actual Bluetooth device discovery
   - Connection establishment
   - Data transmission protocol
   - Connection error handling
   ```

3. **Package Dependencies**:
   ```yaml
   # Add to pubspec.yaml
   flutter_blue_plus: ^latest  # or similar Bluetooth package
   permission_handler: ^latest
   ```

4. **Turn-Based Gameplay**:
   ```dart
   // Modify TurnBloc for combat mode
   - Track current turn (host/guest)
   - Sync game state between devices
   - Handle disconnection during gameplay
   ```

## Testing Checklist

### Solo Mode (Existing)
- [x] Mode selection works
- [x] Navigates to difficulty selection
- [x] Game plays as before

### Combat Mode UI
- [x] Create room generates code
- [x] Join room accepts code input
- [x] Pairing screen shows correct view for host/guest
- [x] Localization works in both languages

### Bluetooth (Not Implemented)
- [ ] Permission requests work on Android
- [ ] Permission requests work on iOS
- [ ] Devices can discover each other
- [ ] Room code pairing works
- [ ] Game state syncs correctly
- [ ] Disconnection handling works

## Next Steps

1. **Add Bluetooth Package**:
   ```bash
   flutter pub add flutter_blue_plus
   flutter pub add permission_handler
   ```

2. **Implement Permission Handler**:
   - Create `BluetoothPermissionHelper` class
   - Add platform-specific permission requests
   - Update AndroidManifest.xml and Info.plist

3. **Create Bluetooth Service**:
   - `BluetoothConnectionService` for managing connections
   - Protocol for sending/receiving game data
   - Connection state management

4. **Update TurnBloc for Combat Mode**:
   - Add turn tracking
   - Sync events between devices
   - Handle disconnection recovery

5. **Add Connection Timeout**:
   - Implement timeout for pairing (e.g., 60 seconds)
   - Show error message if no connection established

6. **Test on Real Devices**:
   - Bluetooth requires physical devices
   - Test Android-Android pairing
   - Test iOS-iOS pairing
   - Test cross-platform pairing

## Architecture Notes

### State Management
- `PlayerNavCubit` manages navigation between screens
- `PlayMode` is stored in cubit and passed to states
- Each screen is responsible for its own UI logic
- Bluetooth logic should be in a separate service/bloc

### Room Code System
- 3-digit codes (100-999)
- Generated from timestamp milliseconds
- TODO: Add validation for existing codes
- TODO: Implement code expiration

### Turn-Based Gameplay Design
```
Host Turn:
1. Host plays their turn
2. Send result to guest
3. Wait for guest turn
4. Receive guest result
5. Compare scores
6. Next round or end game

Guest Turn:
1. Wait for host to finish
2. Receive "your turn" signal
3. Play turn
4. Send result to host
5. Wait for next round
```

## Security Considerations

1. **Bluetooth Pairing**:
   - Room codes are short (3 digits) - consider longer codes for production
   - No encryption implemented yet
   - Vulnerable to nearby eavesdropping

2. **Recommendations**:
   - Increase code length to 4-6 digits
   - Add Bluetooth encryption
   - Implement code expiration (e.g., 5 minutes)
   - Add player name verification

## Performance Notes

- Room code generation is lightweight (timestamp-based)
- No network calls in current implementation
- Bluetooth will add latency - consider timeouts
- UI remains responsive during connection attempts

---

**Created**: November 29, 2025
**Status**: UI Complete, Bluetooth Pending
**Priority**: Bluetooth Implementation Required for Full Functionality
