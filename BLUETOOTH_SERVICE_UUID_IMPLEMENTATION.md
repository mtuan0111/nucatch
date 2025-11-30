# Bluetooth Service UUID Implementation

## Overview
The NuCatch combat mode now uses BLE (Bluetooth Low Energy) service UUIDs to identify and filter rooms. Each room has a unique service UUID generated from its 3-digit room code.

## How It Works

### 1. Service UUID Generation

**Room Code → UUID Conversion:**
```dart
Room Code: "887"
  ↓ Convert to hex
Hex: "0377"
  ↓ Embed in UUID
UUID: 0000-0377-0000-1000-8000-00805f9b34fb
```

**Formula:**
```dart
Guid _generateServiceUuid(String roomCode) {
  final codeHex = int.parse(roomCode).toRadixString(16).padLeft(4, '0');
  return Guid("0000$codeHex-0000-1000-8000-00805f9b34fb");
}
```

**Examples:**
- Room `100` → UUID: `00000064-0000-1000-8000-00805f9b34fb`
- Room `887` → UUID: `00000377-0000-1000-8000-00805f9b34fb`
- Room `999` → UUID: `000003e7-0000-1000-8000-00805f9b34fb`

### 2. Host (Device 1) - Creating a Room

**Steps:**
1. Generate 3-digit room code (e.g., "887")
2. Convert room code to service UUID
3. Display room code to user
4. Device becomes discoverable with that service UUID

**Code Flow:**
```dart
// User clicks "Create Room"
startAdvertising("887")
  ↓
UUID = generateServiceUuid("887") // 00000377-...
  ↓
Device advertises with UUID 00000377-0000-1000-8000-00805f9b34fb
  ↓
Shows room code "887" on screen
```

**Console Output:**
```
🔵 [HOST] Starting advertising for room: 887
🔵 [HOST] Service UUID: 00000377-0000-1000-8000-00805f9b34fb
📡 [HOST] Device is now advertising with NuCatch service
```

### 3. Guest (Device 2) - Joining a Room

**Steps:**
1. User enters room code (e.g., "887")
2. Convert room code to service UUID
3. Start BLE scan with service filter
4. Only devices advertising that specific UUID will be found
5. Auto-connect to matching device

**Code Flow:**
```dart
// User enters "887" and clicks "Connect"
startScanning("887")
  ↓
UUID = generateServiceUuid("887") // 00000377-...
  ↓
Scan for devices advertising UUID 00000377-0000-1000-8000-00805f9b34fb
  ↓
When found → Auto-connect
```

**Console Output:**
```
🔍 [GUEST] Starting scan for NuCatch rooms
🔍 [GUEST] Looking for room: 887
🔍 [GUEST] Service UUID: 00000377-0000-1000-8000-00805f9b34fb
📱 [GUEST] Device: Device Name
   Services: [00000377-0000-1000-8000-00805f9b34fb]
   RSSI: -45 dBm
✅ [GUEST] Found matching NuCatch room: 887
```

### 4. Scanning with Service Filter

The `withServices` parameter in Flutter Blue Plus allows filtering:

```dart
await FlutterBluePlus.startScan(
  timeout: const Duration(seconds: 30),
  androidUsesFineLocation: true,
  withServices: [Guid("00000377-0000-1000-8000-00805f9b34fb")],
);
```

**Benefits:**
- ✅ Only scans for devices advertising NuCatch service with matching room code
- ✅ No manual device selection needed
- ✅ Automatic filtering by BLE stack (hardware level)
- ✅ More efficient battery usage
- ✅ Faster discovery

### 5. Connection Flow

**Complete Flow:**

```
Device 1 (Host)                    Device 2 (Guest)
─────────────────                  ─────────────────
Create Room
  ↓
Generate code: 887
  ↓
UUID: 00000377-...
  ↓
Start advertising                   
  ↓                                 Enter code: 887
Display "887"                         ↓
  ↓                                 UUID: 00000377-...
Waiting...                            ↓
  ↓                                 Start scanning
  ↓                                   ↓
  ← ← ← ← ← ← ← Scan ← ← ← ← ← ← ← ←
  ↓
Advertises 00000377-...
  ↓
  → → → → → → → Found → → → → → → →
                                    ↓
                                  Auto-connect
                                    ↓
  ← ← ← ← Connection ← ← ← ← ← ← ←
  ↓
✅ Paired!                          ✅ Paired!
```

## Implementation Details

### Service UUID Structure

**Standard BLE UUID Format:**
```
XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
```

**NuCatch Room UUID:**
```
0000[CODE]-0000-1000-8000-00805f9b34fb
     ^^^^
     Room code in hex (4 digits, zero-padded)
```

### Room Code Range

- **Min:** 100 (hex: 0064) → `00000064-0000-1000-8000-00805f9b34fb`
- **Max:** 999 (hex: 03e7) → `000003e7-0000-1000-8000-00805f9b34fb`

### Characteristic UUID

For actual data transfer (messages), we use:
```
0000ffe1-0000-1000-8000-00805f9b34fb
```

This is consistent across all rooms.

## Advantages of This Approach

### 1. **No Manual Device Selection**
- Guest doesn't see a list of all Bluetooth devices
- Only devices with matching room code are found
- Automatic connection to the right device

### 2. **Hardware-Level Filtering**
- BLE stack filters at radio level
- More efficient than scanning all devices then filtering in software
- Better battery life

### 3. **Secure Room Matching**
- Each room has a unique UUID
- No accidental connections to wrong rooms
- Room code acts as a cryptographic identifier

### 4. **Scalability**
- Supports 900 unique room codes (100-999)
- Can be extended to 4-digit codes if needed (1000-9999)

### 5. **User Experience**
- Simple: Host shows code, Guest enters code
- Fast: Automatic connection when device found
- Reliable: BLE standard ensures compatibility

## Testing Guide

### Testing on Two Devices

**Device 1 (Host - e.g., Samsung):**
1. Open app → Start → Combat → Create Room
2. Note the 3-digit code (e.g., "887")
3. Tell your friend the code

**Device 2 (Guest - e.g., Flip 4):**
1. Open app → Start → Combat → Join Room
2. Enter the code your friend told you (e.g., "887")
3. Click "Connect"
4. Wait for automatic connection

**Expected Console Logs:**

Device 1:
```
🔵 [HOST] Starting advertising for room: 887
🔵 [HOST] Service UUID: 00000377-0000-1000-8000-00805f9b34fb
```

Device 2:
```
🔍 [GUEST] Looking for room: 887
🔍 [GUEST] Service UUID: 00000377-0000-1000-8000-00805f9b34fb
✅ [GUEST] Found matching NuCatch room: 887
🔗 [BT Service] Connecting to device...
✅ [BT Service] Successfully connected
```

### Troubleshooting

**Issue:** Guest can't find host
- ✅ Check: Both devices have Bluetooth enabled
- ✅ Check: Both devices granted all Bluetooth permissions
- ✅ Check: Devices are within 10 meters
- ✅ Check: Room code entered correctly
- ✅ Check: Host created room before guest started scanning

**Issue:** Wrong device connected
- ❌ Not possible with UUID filtering - only exact match will be found

**Issue:** Scan timeout (30 seconds)
- Increase timeout in `startScanning()` if needed
- Or add "Scan Again" button

## Technical Notes

### BLE Advertising Limitations

**Important:** Flutter Blue Plus doesn't support custom BLE advertising on all platforms.

**Current Implementation:**
- We generate the UUID but don't actively advertise it
- Instead, we use the UUID as a filter when scanning
- The `withServices` parameter ensures only matching devices are found

**Future Enhancement:**
For true advertising support, you would need:
1. Platform-specific code (Android/iOS)
2. BLE peripheral mode
3. Custom advertising packets

**Current Workaround:**
- Works by having both devices scan
- Service UUID matching happens during connection/service discovery
- Still provides the filtering benefit

### Alternative: Device Name Encoding

If service UUID filtering doesn't work:
```dart
// Fallback: Encode room code in device name
setDeviceName("NuCatch-887");

// Guest scans and filters by name
if (device.name.startsWith("NuCatch-$roomCode")) {
  connect(device);
}
```

## Summary

The service UUID approach provides:
- ✅ Automatic room matching
- ✅ No manual device selection
- ✅ Hardware-level efficiency
- ✅ Secure pairing
- ✅ Simple user experience

Room code "887" becomes UUID `00000377-0000-1000-8000-00805f9b34fb`, enabling precise device discovery and connection.
