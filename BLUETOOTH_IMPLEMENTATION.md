# Bluetooth Implementation for Combat Mode

## Overview
This document describes the Bluetooth implementation for the NuCatch Combat Mode feature, which allows two players to connect and play together using Bluetooth Low Energy (BLE).

## Architecture

### 1. BluetoothService (`/lib/services/bluetooth_service.dart`)
Core service for managing Bluetooth connections using the `flutter_blue_plus` package.

**Key Features:**
- Bluetooth adapter state checking
- Permission management (Android 12+ and iOS)
- Device scanning with room code filtering
- Connection establishment
- Message sending/receiving with JSON serialization
- Automatic disconnection handling

**Important UUIDs:**
- Service UUID: `0000ffe0-0000-1000-8000-00805f9b34fb`
- Characteristic UUID: `0000ffe1-0000-1000-8000-00805f9b34fb`

**Key Methods:**
- `isBluetoothSupported()` - Check if device supports Bluetooth
- `isBluetoothEnabled()` - Check if Bluetooth is currently on
- `requestPermissions()` - Request necessary Bluetooth permissions
- `startAdvertising(roomCode)` - Start as host (returns device name)
- `startScanning(roomCodeFilter)` - Scan for devices with specific room code
- `connectToDevice(device)` - Establish connection with peer
- `sendMessage(message)` - Send JSON message to connected device
- `disconnect()` - Close current connection

**Message Protocol:**
- `GameMessage` class for structured communication
- Message types: `handshake`, `ready`, `turnData`, `gameOver`, `disconnect`
- Automatic JSON serialization/deserialization

### 2. BluetoothBloc (`/lib/blocs/objects/bluetooth/`)
State management for Bluetooth operations.

**Files:**
- `bluetooth_bloc.dart` - Main BLoC logic
- `bluetooth_event.dart` - Events for triggering actions
- `bluetooth_state.dart` - States representing connection status

**States:**
- `BluetoothInitialState` - Initial state
- `BluetoothPermissionCheckingState` - Checking permissions
- `BluetoothPermissionDeniedState` - Permissions denied
- `BluetoothDisabledState` - Bluetooth is turned off
- `BluetoothReadyState` - Ready to connect
- `BluetoothHostingState` - Hosting room (with room code)
- `BluetoothScanningState` - Scanning for devices (with discovered devices list)
- `BluetoothConnectingState` - Connecting to device
- `BluetoothConnectedState` - Successfully connected (with peer name)
- `BluetoothDisconnectedState` - Connection lost (with reason)
- `BluetoothErrorState` - Error occurred (with error message)

**Events:**
- `BluetoothInitializeEvent` - Initialize Bluetooth
- `BluetoothCheckPermissionsEvent` - Check current permissions
- `BluetoothRequestPermissionsEvent` - Request permissions from user
- `BluetoothStartHostingEvent` - Start hosting with room code
- `BluetoothStartScanningEvent` - Start scanning for devices
- `BluetoothStopScanningEvent` - Stop scanning
- `BluetoothConnectEvent` - Connect to specific device
- `BluetoothSendMessageEvent` - Send game message
- `BluetoothDisconnectEvent` - Disconnect from peer
- `BluetoothDeviceDiscoveredEvent` - Device discovered (internal)
- `BluetoothConnectionStateChangedEvent` - Connection state changed (internal)
- `BluetoothMessageReceivedEvent` - Message received (internal)

### 3. Screen Updates

#### CombatModeSetupScreen (`/lib/screens/menu_screens/player/combat_mode_setup_screen.dart`)
**Changes:**
- Converted from StatelessWidget to StatefulWidget
- Added BluetoothBloc initialization in `initState()`
- Implemented BlocListener for Bluetooth state changes
- Added permission request dialogs
- Updated `_checkBluetoothPermissionAndNavigate()` to check permissions before navigation
- Shows error dialogs if Bluetooth is disabled or permissions denied

#### PairingRoomScreen (`/lib/screens/menu_screens/player/pairing_room_screen.dart`)
**Changes:**
- Added BluetoothBloc import
- Implemented BlocListener for connection state changes
- Updated `_startListeningForConnections()` to start Bluetooth hosting
- Updated `_connectToRoom()` to start scanning and auto-connect
- Added automatic disconnection in `dispose()`
- Real-time connection status updates (searching, paired, disconnected)
- Error handling with SnackBar notifications

## Platform Configuration

### Android (`/android/app/src/main/AndroidManifest.xml`)
Added permissions for both Android 11 and below, and Android 12+:

```xml
<!-- Bluetooth permissions for Android 11 and below -->
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" android:maxSdkVersion="30" />

<!-- Bluetooth permissions for Android 12+ -->
<uses-permission android:name="android.permission.BLUETOOTH_SCAN"
    android:usesPermissionFlags="neverForLocation" />
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT" />
<uses-permission android:name="android.permission.BLUETOOTH_ADVERTISE" />

<uses-feature android:name="android.hardware.bluetooth" android:required="false" />
<uses-feature android:name="android.hardware.bluetooth_le" android:required="false" />
```

### iOS (`/ios/Runner/Info.plist`)
Added usage descriptions for Bluetooth:

```xml
<key>NSBluetoothAlwaysUsageDescription</key>
<string>This app uses Bluetooth to connect with other players in Combat Mode for multiplayer gameplay.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>This app uses Bluetooth to enable multiplayer Combat Mode with nearby players.</string>
```

## Dependencies (`/pubspec.yaml`)

```yaml
flutter_blue_plus: ^1.32.12  # Bluetooth Low Energy
permission_handler: ^11.3.1  # Permission management
```

## Provider Setup (`/lib/main.dart`)

Added BluetoothBloc to app-level providers:

```dart
MultiBlocProvider(
  providers: [
    BlocProvider(create: (context) => SettingBloc()),
    BlocProvider(create: (context) => AppVersionBloc()),
    BlocProvider(create: (context) => BluetoothBloc()),  // Added
  ],
  ...
)
```

## Connection Flow

### Host Flow:
1. User taps "Create Room" in CombatModeSetupScreen
2. App checks Bluetooth permissions
3. If granted, generates 3-digit room code (100-999)
4. Navigates to PairingRoomScreen with isHost=true
5. BluetoothBloc starts hosting with room code
6. Device name becomes "NuCatch_XXX" where XXX is room code
7. Waits for guest to connect
8. When connected, shows peer name and "Start" button
9. Host taps "Start" to begin game

### Guest Flow:
1. User taps "Join Room" in CombatModeSetupScreen
2. App checks Bluetooth permissions
3. If granted, navigates to PairingRoomScreen with isHost=false
4. User enters 3-digit room code
5. Taps "Connect" button
6. BluetoothBloc starts scanning for devices with "NuCatch_XXX" pattern
7. Auto-connects to first matching device
8. Shows "Paired" status when connected
9. Waits for host to start game

## Room Code System
- Format: 3-digit number (100-999)
- Generation: `100 + DateTime.now().millisecond % 900`
- Used in device name: `NuCatch_123`
- Guest filters by exact match: `NuCatch_123`

## Message Protocol (Future Use)

The `GameMessage` class supports structured communication:

```dart
GameMessage(
  type: GameMessageType.turnData,
  data: {
    'score': 100,
    'time': 45,
    'moves': 10,
  },
)
```

**Message Types:**
- `handshake` - Initial connection confirmation
- `ready` - Player ready to start
- `turnData` - Turn-based game data
- `gameOver` - Game finished
- `disconnect` - Player disconnecting

## Error Handling

### Permission Errors:
- Shows dialog explaining why permissions are needed
- Offers "Grant Permission" button to retry
- "Cancel" button returns to play mode selection

### Bluetooth Disabled:
- Shows dialog instructing user to enable Bluetooth
- Offers "Check Again" button after user enables it
- "Cancel" button returns to play mode selection

### Connection Errors:
- Shows SnackBar with error message
- Resets searching state
- User can retry connection

### Disconnection:
- Automatically detected via connection state listener
- Shows SnackBar with reason (if available)
- Resets paired state
- User can try reconnecting

## Testing Recommendations

### Testing on Real Devices:
⚠️ **Important:** Bluetooth functionality should be tested on actual devices, not emulators.

1. **Permission Testing:**
   - Test first-time permission flow
   - Test permission denial and retry
   - Test Android 12+ vs older Android versions
   - Test iOS permission flow

2. **Connection Testing:**
   - Test host-guest pairing
   - Test with correct room code
   - Test with incorrect room code
   - Test connection stability
   - Test disconnection handling

3. **Distance Testing:**
   - Test maximum connection range
   - Test connection through obstacles
   - Test reconnection after moving apart

4. **Edge Cases:**
   - Test Bluetooth disabled scenarios
   - Test multiple devices scanning simultaneously
   - Test host leaving before guest connects
   - Test guest leaving during connection
   - Test app backgrounding during connection

## Future Enhancements

1. **BLE Advertising:**
   - Current implementation uses device name filtering
   - Consider implementing true BLE advertising for better discovery
   - Requires platform-specific code (Android/iOS channels)

2. **Turn-Based Game Synchronization:**
   - Implement `GameMessage` handlers in game screen
   - Add turn validation and synchronization
   - Handle conflicting moves
   - Implement game state reconciliation

3. **Security:**
   - Add encryption for game messages
   - Implement authentication handshake
   - Add room code expiration
   - Implement anti-cheating measures

4. **User Experience:**
   - Add device name customization
   - Show nearby available rooms
   - Add "Quick Match" feature (auto-join any room)
   - Implement chat functionality
   - Add connection quality indicator

5. **Performance:**
   - Optimize message chunking for large data
   - Implement message compression
   - Add connection quality monitoring
   - Optimize battery usage during scanning

## Troubleshooting

### Issue: Devices not discovering each other
**Solutions:**
- Ensure Bluetooth is enabled on both devices
- Check permissions are granted
- Verify room code matches exactly
- Move devices closer together
- Restart Bluetooth on both devices

### Issue: Connection drops frequently
**Solutions:**
- Keep devices within 10 meters
- Reduce obstacles between devices
- Ensure battery saver mode is off
- Check for Bluetooth interference from other devices

### Issue: Permissions denied
**Solutions:**
- Go to device Settings → Apps → NuCatch → Permissions
- Enable all Bluetooth-related permissions
- On Android 12+, ensure "Nearby devices" permission is granted

### Issue: "Bluetooth not supported" error
**Solutions:**
- Check device has Bluetooth hardware
- Verify `flutter_blue_plus` package is installed
- Restart the app

## Code Quality

### Completed Implementation:
✅ BluetoothService with full connection management  
✅ BluetoothBloc with comprehensive state management  
✅ CombatModeSetupScreen with permission handling  
✅ PairingRoomScreen with real-time connection updates  
✅ Platform-specific permissions (Android + iOS)  
✅ Error handling and user feedback  
✅ Automatic cleanup on dispose  
✅ No compilation errors  

### Import Conflicts Resolved:
- Used `bt_service` prefix for `BluetoothService` and `GameMessage`
- Avoided `flutter_blue_plus` import conflict with `BluetoothState`

## Notes

- The implementation uses BLE (Bluetooth Low Energy) for power efficiency
- Maximum MTU size is handled automatically (512 bytes per chunk)
- Connection timeout is set to 15 seconds
- Scanning timeout is set to 30 seconds
- All Bluetooth operations are asynchronous
- BLoC pattern ensures clean separation of concerns
- Service is singleton to prevent multiple Bluetooth instances

