import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart' show Permission;

/// Simplified Bluetooth service for proximity detection only
/// Actual data exchange happens via Firestore (CombatRoomService)
class BluetoothProximityService {
  static final BluetoothProximityService _instance =
      BluetoothProximityService._internal();
  factory BluetoothProximityService() => _instance;
  BluetoothProximityService._internal();

  // BLE Peripheral for advertising
  final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;

  StreamSubscription? _scanSubscription;
  final _nearbyDevicesController =
      StreamController<List<ProximityDevice>>.broadcast();

  Stream<List<ProximityDevice>> get nearbyDevicesStream =>
      _nearbyDevicesController.stream;

  bool get isAdvertising => _isAdvertising;

  final List<ProximityDevice> _nearbyDevices = [];

  /// Check if Bluetooth is supported
  Future<bool> isBluetoothSupported() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return await FlutterBluePlus.isSupported;
    }
    return false;
  }

  /// Check if Bluetooth is enabled
  Future<bool> isBluetoothEnabled() async {
    try {
      final adapterState = await FlutterBluePlus.adapterState.first;
      return adapterState == BluetoothAdapterState.on;
    } catch (e) {
      return false;
    }
  }

  /// Check if Bluetooth permissions are granted
  Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      if (Platform.version.contains('12') ||
          Platform.version.contains('13') ||
          Platform.version.contains('14') ||
          Platform.version.contains('15')) {
        final bluetoothScan = await Permission.bluetoothScan.status;
        final bluetoothConnect = await Permission.bluetoothConnect.status;
        final bluetoothAdvertise = await Permission.bluetoothAdvertise.status;
        final location = await Permission.locationWhenInUse.status;

        return bluetoothScan.isGranted &&
            bluetoothConnect.isGranted &&
            bluetoothAdvertise.isGranted &&
            location.isGranted;
      } else {
        final bluetooth = await Permission.bluetooth.status;
        final location = await Permission.locationWhenInUse.status;
        return bluetooth.isGranted && location.isGranted;
      }
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      return !bluetooth.isPermanentlyDenied;
    }
    return false;
  }

  /// Request Bluetooth permissions
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      if (Platform.version.contains('12') ||
          Platform.version.contains('13') ||
          Platform.version.contains('14') ||
          Platform.version.contains('15')) {
        final bluetoothScan = await Permission.bluetoothScan.request();
        final bluetoothConnect = await Permission.bluetoothConnect.request();
        final bluetoothAdvertise =
            await Permission.bluetoothAdvertise.request();
        final location = await Permission.locationWhenInUse.request();

        return bluetoothScan.isGranted &&
            bluetoothConnect.isGranted &&
            bluetoothAdvertise.isGranted &&
            location.isGranted;
      } else {
        final bluetooth = await Permission.bluetooth.request();
        final location = await Permission.locationWhenInUse.request();
        return bluetooth.isGranted && location.isGranted;
      }
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      return !bluetooth.isPermanentlyDenied;
    }
    return false;
  }

  /// Open app settings
  Future<bool> openAppSettings() async {
    return await permission_handler.openAppSettings();
  }

  /// Turn on Bluetooth (Android only)
  Future<void> turnOnBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        throw Exception('Please enable Bluetooth manually');
      }
    }
  }

  /// Generate manufacturer data from room code
  Uint8List _generateManufacturerData(String roomCode) {
    return Uint8List.fromList(utf8.encode(roomCode));
  }

  /// Start advertising presence for a room
  Future<void> startAdvertising(String roomCode) async {
    print('📡 [BLE Proximity] Advertising presence for room: $roomCode');

    try {
      if (_isAdvertising) {
        await stopAdvertising();
      }

      final advertiseData = AdvertiseData(
        localName: 'NuCatch-$roomCode',
        manufacturerId: 0x004C, // Apple manufacturer ID
        manufacturerData: _generateManufacturerData(roomCode),
        includeDeviceName: true,
      );

      await _blePeripheral.start(advertiseData: advertiseData);
      _isAdvertising = true;

      print('✅ [BLE Proximity] Advertising started');
    } catch (e) {
      print('❌ [BLE Proximity] Failed to start advertising: $e');
      _isAdvertising = false;
      rethrow;
    }
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    if (_isAdvertising) {
      try {
        await _blePeripheral.stop();
        _isAdvertising = false;
        print('🛑 [BLE Proximity] Stopped advertising');
      } catch (e) {
        print('❌ [BLE Proximity] Error stopping advertising: $e');
      }
    }
  }

  /// Scan for nearby devices in the same room
  Future<void> startScanning(String roomCode) async {
    print('🔍 [BLE Proximity] Scanning for room: $roomCode');

    try {
      _nearbyDevices.clear();

      // Start BLE scan
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 30),
        androidUsesFineLocation: true,
      );

      // Listen to scan results
      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        _nearbyDevices.clear();

        for (var result in results) {
          // Check if device is advertising the same room code
          final manufacturerData = result.advertisementData.manufacturerData;

          for (var entry in manufacturerData.entries) {
            if (entry.key == 0x004C) {
              try {
                final advertisedRoomCode = utf8.decode(entry.value);
                if (advertisedRoomCode == roomCode) {
                  _nearbyDevices.add(ProximityDevice(
                    name: result.advertisementData.advName.isNotEmpty
                        ? result.advertisementData.advName
                        : result.device.platformName,
                    rssi: result.rssi,
                    roomCode: advertisedRoomCode,
                    lastSeen: DateTime.now(),
                  ));

                  print(
                      '✅ [BLE Proximity] Found device in room $roomCode (RSSI: ${result.rssi} dBm)');
                }
              } catch (e) {
                // Invalid manufacturer data, skip
              }
            }
          }
        }

        // Emit updated list
        _nearbyDevicesController.add(List.from(_nearbyDevices));
      });
    } catch (e) {
      print('❌ [BLE Proximity] Failed to start scanning: $e');
      rethrow;
    }
  }

  /// Stop scanning
  Future<void> stopScanning() async {
    try {
      await FlutterBluePlus.stopScan();
      _scanSubscription?.cancel();
      _scanSubscription = null;
      print('🛑 [BLE Proximity] Stopped scanning');
    } catch (e) {
      print('❌ [BLE Proximity] Error stopping scan: $e');
    }
  }

  /// Check if any devices are nearby (proximity check)
  bool hasNearbyDevices() {
    // Consider devices within -70 dBm as "nearby"
    return _nearbyDevices.any((device) => device.rssi > -70);
  }

  /// Get count of nearby devices
  int getNearbyDeviceCount() {
    return _nearbyDevices.where((device) => device.rssi > -70).length;
  }

  /// Cleanup
  void dispose() {
    stopAdvertising();
    stopScanning();
    _nearbyDevicesController.close();
  }
}

/// Represents a nearby device detected via BLE
class ProximityDevice {
  final String name;
  final int rssi;
  final String roomCode;
  final DateTime lastSeen;

  ProximityDevice({
    required this.name,
    required this.rssi,
    required this.roomCode,
    required this.lastSeen,
  });

  bool get isNearby => rssi > -70; // Within ~5-10 meters
  bool get isVeryClose => rssi > -50; // Within ~2-3 meters
}
