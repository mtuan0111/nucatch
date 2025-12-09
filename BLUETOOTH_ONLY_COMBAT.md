# Bluetooth-Only Combat Mode

## Overview
Combat mode now uses **pure Bluetooth (BLE) for all communication** - no internet connection required!

## Architecture

### Services
- **CombatBLEService** (`lib/services/combat_ble_service.dart`)
  - Manages combat rooms using pure BLE
  - Uses BluetoothService for all data exchange
  - Completely offline - no Firestore dependency
  - Host advertises via BLE, guest scans and connects

### Key Components

#### 1. CombatBLEService
```dart
// Create room (host)
await combatBLEService.createRoom(roomCode, hostId);
// - Starts BLE advertising with room code
// - Waits for guest to connect

// Join room (guest)
await combatBLEService.joinRoom(roomCode, guestId);
// - Scans for BLE device advertising the room code
// - Connects automatically when found

// Send messages
await combatBLEService.sendMessage({
  'type': 'turn_start',
  'data': {...}
});
```

#### 2. Message Flow
All game messages flow through BLE:
- `guest_joined` - Guest connected
- `player_ready` - Player marked ready
- `game_started` - Host starts game
- `difficulty_selected` - Difficulty chosen
- `turn_start` - Turn data sent
- `move_completed` - Move result sent
- `game_ended` - Game over
- `opponent_left` - Player disconnected

#### 3. Room States
```dart
enum RoomState {
  waiting,      // Waiting for guest
  guestJoined,  // Guest connected via BLE
  bothReady,    // Both ready to start
  playing,      // Game in progress
  ended,        // Game finished
}
```

## Setup Flow

### Host
1. User creates room with 3-digit code
2. `CombatBLEService.createRoom()` called
3. BLE advertising starts with room code
4. Waits for guest to connect
5. Both players ready → Host starts game

### Guest
1. User enters 3-digit room code
2. `CombatBLEService.joinRoom()` called
3. BLE scan starts looking for room code
4. Auto-connects when host found
5. Sends `guest_joined` message
6. Both players ready → Game starts

## Bluetooth Requirements

### Permissions
- **Android 12+**: 
  - BLUETOOTH_SCAN
  - BLUETOOTH_CONNECT
  - BLUETOOTH_ADVERTISE
  - ACCESS_FINE_LOCATION

- **Android 11-**: 
  - BLUETOOTH
  - ACCESS_FINE_LOCATION

- **iOS**: 
  - Bluetooth permission (auto-granted)

### Features
- ✅ No internet required
- ✅ Direct device-to-device communication
- ✅ Room code based pairing
- ✅ Automatic connection when devices nearby
- ✅ Real-time turn-based gameplay
- ✅ Connection state monitoring

## Implementation Details

### BluetoothService Integration
CombatBLEService wraps BluetoothService which provides:
- BLE advertising (host)
- BLE scanning (guest)
- Device connection management
- Message sending/receiving
- Room code verification

### Message Format
```json
{
  "type": "turn_start",
  "senderId": "player_123456789",
  "timestamp": 1234567890,
  "data": {
    "isHostTurn": true,
    "requirement": "prime",
    "expect": "7"
  }
}
```

### Connection Process
1. **Host**: Advertises as `NuCatch-{roomCode}`
2. **Guest**: Scans for devices with matching service UUID
3. **Connection**: Guest connects to host device
4. **Verification**: Room codes exchanged and verified
5. **Ready**: Both devices ready for gameplay

## UI Components

### PairingRoomScreen
- Shows room code for host
- Input field for guest
- BLE connection status indicator
- Ready button when connected
- Start game button (host only)

### Connection Indicator
```dart
Widget _buildProximityIndicator() {
  final isConnected = _roomService.bleService.isConnected;
  return Row(
    children: [
      Icon(FontAwesomeIcons.bluetooth, 
        color: isConnected ? Colors.blue : Colors.grey),
      Text(isConnected 
        ? 'Connected via Bluetooth'
        : 'Waiting for connection...'),
    ],
  );
}
```

## Advantages over Firestore

### 1. No Internet Required
- Works completely offline
- No data costs
- No Firestore setup needed

### 2. Lower Latency
- Direct device-to-device communication
- No cloud round-trip
- Faster turn responses

### 3. Privacy
- Data stays local between devices
- No cloud storage
- No external dependencies

### 4. Simplicity
- No Firebase configuration
- No backend setup
- Pure peer-to-peer

## Troubleshooting

### "Bluetooth not ready"
- Check Bluetooth is enabled
- Grant all permissions
- Restart app if needed

### "Failed to create room"
- Ensure Bluetooth advertising permission granted
- Check no other app using BLE
- Try different room code

### "Failed to join room"
- Ensure devices are nearby (< 10 meters)
- Check room code is correct
- Verify host is advertising
- Try rescanning

### "Connection lost"
- Devices moved too far apart
- Bluetooth interference
- One device disabled Bluetooth
- App backgrounded on iOS

## Testing

### Test Scenarios
1. **Basic Flow**
   - Host creates room
   - Guest joins with code
   - Both ready
   - Play full game
   
2. **Disconnection**
   - Host/guest leaves
   - Bluetooth disabled
   - App backgrounded
   
3. **Error Cases**
   - Wrong room code
   - No permissions
   - Bluetooth disabled

### Test Devices
- Android-to-Android
- iOS-to-iOS
- Android-to-iOS (cross-platform)

## Migration from Firestore

### Old (Firestore)
```dart
import 'package:nucatch/services/combat_room_service.dart';

final service = CombatRoomService();
await service.createRoom(code, id); // Uses Firestore
```

### New (BLE)
```dart
import 'package:nucatch/services/combat_ble_service.dart';

final service = CombatBLEService();
await service.createRoom(code, id); // Uses BLE only
```

### Changes Made
1. Created `CombatBLEService` replacing `CombatRoomService`
2. Updated `CombatBloc` to use BLE service
3. Updated `PairingRoomScreen` for BLE-only mode
4. Removed Firestore dependencies from combat
5. Updated `menu_nav.dart` to inject BLE service

## Future Enhancements

### Possible Improvements
- [ ] Reconnection after disconnect
- [ ] Multiple simultaneous games
- [ ] Spectator mode
- [ ] Game replay via BLE
- [ ] Tournament brackets
- [ ] Group chat via BLE mesh

### Advanced Features
- [ ] BLE mesh networking for multi-player
- [ ] Automatic room discovery
- [ ] NFC tap-to-pair
- [ ] QR code room sharing
- [ ] Bluetooth 5.0 long range support
