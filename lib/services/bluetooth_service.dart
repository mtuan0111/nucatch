import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_ble_peripheral/flutter_ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart' show Permission;

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  // Service UUID for NuCatch - will be customized per room
  static const String serviceUuidBase = "0000ffe";
  static final Guid characteristicUuid =
      Guid("0000ffe1-0000-1000-8000-00805f9b34fb");

  // Current room code being used for verification after connection
  String? _currentRoomCode;
  bool _isHost = false;

  // BLE Peripheral for host advertising
  final FlutterBlePeripheral _blePeripheral = FlutterBlePeripheral();
  bool _isAdvertising = false;

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _deviceStateSubscription;
  StreamSubscription? _characteristicSubscription;

  final _messageController = StreamController<String>.broadcast();
  final _connectionStateController =
      StreamController<BluetoothConnectionState>.broadcast();
  final _discoveredDevicesController =
      StreamController<List<ScanResult>>.broadcast();

  Stream<String> get messageStream => _messageController.stream;
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _connectionStateController.stream;
  Stream<List<ScanResult>> get discoveredDevicesStream =>
      _discoveredDevicesController.stream;

  BluetoothDevice? get connectedDevice => _connectedDevice;
  bool get isConnected => _connectedDevice != null;
  bool get isAdvertising => _isAdvertising;
  bool get isHost => _isHost;

  final List<ScanResult> _discoveredDevices = [];

  /// Check if Bluetooth is supported on this device
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

  /// Check if Bluetooth permissions are already granted
  Future<bool> hasPermissions() async {
    if (Platform.isAndroid) {
      // Android 12+ requires different permissions
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
        // Android 11 and below
        final bluetooth = await Permission.bluetooth.status;
        final location = await Permission.locationWhenInUse.status;

        return bluetooth.isGranted && location.isGranted;
      }
    } else if (Platform.isIOS) {
      // On iOS 13+, Bluetooth permission is granted automatically when Bluetooth APIs are used
      // There's no separate permission dialog. Just check if Bluetooth is available.
      // The permission_handler's bluetooth permission doesn't work the same way on iOS
      final bluetooth = await Permission.bluetooth.status;
      print('[BluetoothService] iOS Bluetooth permission status: $bluetooth');

      // On iOS, if status is denied, it means the user hasn't used Bluetooth yet
      // or the Info.plist keys are missing. Return true to allow the app to proceed
      // and trigger the automatic permission when using Bluetooth APIs
      if (bluetooth.isDenied ||
          bluetooth.isLimited ||
          bluetooth.isGranted ||
          bluetooth.isProvisional) {
        print(
            '[BluetoothService] iOS: Bluetooth available (status: $bluetooth)');
        return true;
      }

      // Only return false if permanently denied
      print(
          '[BluetoothService] iOS: Bluetooth not available (status: $bluetooth)');
      return !bluetooth.isPermanentlyDenied;
    }
    return false;
  }

  /// Request Bluetooth permissions
  /// Returns true if permissions granted, false otherwise
  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Android 12+ requires different permissions
      if (Platform.version.contains('12') ||
          Platform.version.contains('13') ||
          Platform.version.contains('14') ||
          Platform.version.contains('15')) {
        final bluetoothScan = await Permission.bluetoothScan.request();
        final bluetoothConnect = await Permission.bluetoothConnect.request();
        final bluetoothAdvertise =
            await Permission.bluetoothAdvertise.request();
        // Location permission is still required for Bluetooth scanning
        final location = await Permission.locationWhenInUse.request();

        return bluetoothScan.isGranted &&
            bluetoothConnect.isGranted &&
            bluetoothAdvertise.isGranted &&
            location.isGranted;
      } else {
        // Android 11 and below
        final bluetooth = await Permission.bluetooth.request();
        final location = await Permission.locationWhenInUse.request();

        return bluetooth.isGranted && location.isGranted;
      }
    } else if (Platform.isIOS) {
      // On iOS, Bluetooth permission is granted automatically when the app uses Bluetooth APIs
      // We don't need to explicitly request it. Just check the current status.
      print('[BluetoothService] iOS: Checking Bluetooth availability...');
      final bluetooth = await Permission.bluetooth.status;
      print('[BluetoothService] iOS Bluetooth permission status: $bluetooth');

      // On iOS, return true unless permanently denied
      // The actual permission will be granted when we start using Bluetooth
      if (bluetooth.isPermanentlyDenied) {
        print('[BluetoothService] iOS: Bluetooth permanently denied');
        return false;
      }

      print(
          '[BluetoothService] iOS: Bluetooth available, will be granted when used');
      return true;
    }
    return false;
  }

  /// Check if Bluetooth permissions are permanently denied
  Future<bool> isPermissionPermanentlyDenied() async {
    if (Platform.isAndroid) {
      if (Platform.version.contains('12') ||
          Platform.version.contains('13') ||
          Platform.version.contains('14') ||
          Platform.version.contains('15')) {
        final bluetoothScan = await Permission.bluetoothScan.status;
        final bluetoothConnect = await Permission.bluetoothConnect.status;
        final bluetoothAdvertise = await Permission.bluetoothAdvertise.status;
        final location = await Permission.locationWhenInUse.status;

        return bluetoothScan.isPermanentlyDenied ||
            bluetoothConnect.isPermanentlyDenied ||
            bluetoothAdvertise.isPermanentlyDenied ||
            location.isPermanentlyDenied;
      } else {
        final bluetooth = await Permission.bluetooth.status;
        final location = await Permission.locationWhenInUse.status;

        return bluetooth.isPermanentlyDenied || location.isPermanentlyDenied;
      }
    } else if (Platform.isIOS) {
      final bluetooth = await Permission.bluetooth.status;
      print(
          '[BluetoothService] iOS Bluetooth permission permanently denied check: ${bluetooth.isPermanentlyDenied}, status: $bluetooth');
      return bluetooth.isPermanentlyDenied;
    }
    return false;
  }

  /// Open app settings to allow user to manually grant permissions
  /// Use this when permissions are permanently denied
  Future<bool> openAppSettings() async {
    return await permission_handler.openAppSettings();
  }

  /// Turn on Bluetooth (Android only)
  Future<void> turnOnBluetooth() async {
    if (Platform.isAndroid) {
      try {
        await FlutterBluePlus.turnOn();
      } catch (e) {
        // User may need to manually enable Bluetooth
        throw Exception('Please enable Bluetooth manually');
      }
    }
  }

  /// Generate service UUID based on room code
  String _generateServiceUuid(String roomCode) {
    final codeHex = int.parse(roomCode).toRadixString(16).padLeft(4, '0');
    return "0000$codeHex-0000-1000-8000-00805f9b34fb";
  }

  /// Start advertising as host using BLE Peripheral
  Future<String> startAdvertising(String roomCode) async {
    _currentRoomCode = roomCode;
    _isHost = true;
    final serviceUuid = _generateServiceUuid(roomCode);
    final advertisedName = 'NuCatch-$roomCode';

    print('🔵 [HOST] Starting BLE peripheral advertising for room: $roomCode');
    print('🔵 [HOST] Service UUID: $serviceUuid');
    print('🔵 [HOST] Device name: $advertisedName');

    try {
      // Stop any existing advertising
      if (_isAdvertising) {
        await stopAdvertising();
      }

      // Create advertising data
      final advertiseData = AdvertiseData(
        serviceUuid: serviceUuid.toString(),
        localName: advertisedName,
        manufacturerId: 0x004C, // Apple manufacturer ID for compatibility
        manufacturerData: utf8.encode(roomCode),
        includeDeviceName: true,
      );

      // Start advertising
      await _blePeripheral.start(advertiseData: advertiseData);
      _isAdvertising = true;

      print('✅ [HOST] BLE peripheral advertising started');
      print(
          '📡 [HOST] Guests can now discover this device as: $advertisedName');

      return advertisedName;
    } catch (e) {
      print('❌ [HOST] Failed to start advertising: $e');
      _isAdvertising = false;
      rethrow;
    }
  }

  /// Stop BLE peripheral advertising
  Future<void> stopAdvertising() async {
    if (_isAdvertising) {
      try {
        await _blePeripheral.stop();
        _isAdvertising = false;
        print('🛑 [HOST] Stopped advertising');
      } catch (e) {
        print('❌ [HOST] Error stopping advertising: $e');
      }
    }
  }

  /// Join a room as guest - scans for host device with specific service UUID
  Future<void> joinRoom(String roomCode) async {
    _currentRoomCode = roomCode;
    _isHost = false;
    final serviceUuid = _generateServiceUuid(roomCode);

    print('🔵 [GUEST] Joining room: $roomCode');
    print('🔵 [GUEST] Scanning for service UUID: $serviceUuid');
    print('🔵 [GUEST] Looking for device: NuCatch-$roomCode');

    // Guest scans to find the host
    await startScanning(roomCode);
  }

  /// Scan for nearby Bluetooth devices
  /// Filters by service UUID and device name for room-based matching
  Future<void> startScanning(String? roomCodeFilter) async {
    print('🔍 [SCAN] Starting scan for devices');
    if (roomCodeFilter != null) {
      _currentRoomCode = roomCodeFilter;
      final targetServiceUuid = _generateServiceUuid(roomCodeFilter);
      final targetName = 'NuCatch-$roomCodeFilter';
      print('🔍 [SCAN] Filtering by service UUID: $targetServiceUuid');
      print('🔍 [SCAN] Filtering by device name: $targetName');
    }

    _discoveredDevices.clear();

    // Scan with service UUID filter if guest has room code
    final List<String> serviceFilters = [];
    if (roomCodeFilter != null) {
      serviceFilters.add(_generateServiceUuid(roomCodeFilter));
    }

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 30),
      androidUsesFineLocation: true,
      withServices: serviceFilters.isNotEmpty
          ? serviceFilters.map((uuid) => Guid(uuid)).toList()
          : [],
    );

    _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
      print('🔍 [SCAN] Scan results: ${results.length} devices found');
      _discoveredDevices.clear();

      for (var result in results) {
        final deviceName = result.device.platformName.isNotEmpty
            ? result.device.platformName
            : result.device.remoteId.toString();
        final advName = result.advertisementData.advName;

        print('📱 [SCAN] Device: $deviceName');
        print('   Advertisement Name: $advName');
        print('   ID: ${result.device.remoteId}');
        print('   Services: ${result.advertisementData.serviceUuids}');
        print(
            '   Manufacturer Data: ${result.advertisementData.manufacturerData}');
        print('   RSSI: ${result.rssi} dBm');

        // Filter by room code if specified
        if (roomCodeFilter != null) {
          final targetName = 'NuCatch-$roomCodeFilter';
          final targetServiceUuid = _generateServiceUuid(roomCodeFilter);

          // Check if device matches by name, service UUID, or manufacturer data
          final nameMatches =
              deviceName.toLowerCase().contains(targetName.toLowerCase()) ||
                  advName.toLowerCase().contains(targetName.toLowerCase());

          final serviceMatches = result.advertisementData.serviceUuids.any(
              (uuid) =>
                  uuid.toString().toLowerCase() ==
                  targetServiceUuid.toString().toLowerCase());

          final manufacturerMatches =
              result.advertisementData.manufacturerData.entries.any((entry) {
            try {
              final data = utf8.decode(entry.value);
              return data.contains(roomCodeFilter);
            } catch (e) {
              return false;
            }
          });

          if (nameMatches || serviceMatches || manufacturerMatches) {
            print('✅ [SCAN] Found matching NuCatch room: $roomCodeFilter');
            if (nameMatches) print('   ✓ Matched by name');
            if (serviceMatches) print('   ✓ Matched by service UUID');
            if (manufacturerMatches) print('   ✓ Matched by manufacturer data');
            _discoveredDevices.add(result);
          }
        } else {
          // No filter - show all devices with names
          if (deviceName.isNotEmpty || advName.isNotEmpty) {
            _discoveredDevices.add(result);
          }
        }
      }

      print('🔍 [SCAN] Emitting ${_discoveredDevices.length} matching devices');
      _discoveredDevicesController.add(_discoveredDevices);
    });
  }

  /// Stop scanning for devices
  Future<void> stopScanning() async {
    await _scanSubscription?.cancel();
    await FlutterBluePlus.stopScan();
  }

  /// Check if device might need special Samsung-to-Samsung handling
  bool _needsSamsungOptimization(BluetoothDevice device) {
    final deviceName = device.platformName.toLowerCase();
    return deviceName.contains('samsung') || deviceName.contains('galaxy') || 
           deviceName.contains('sm-') || deviceName.contains('a05') || 
           deviceName.contains('flip');
  }

  /// Aggressive connection attempt with minimal timeout
  Future<bool> _tryQuickConnect(BluetoothDevice device) async {
    try {
      print('⚡ [BT Service] Quick connect attempt (2s timeout)');
      print('📱 [BT Service] Device: ${device.platformName}');
      
      // Force disconnect first with longer delay for Samsung devices
      try {
        await device.disconnect();
        final delay = _needsSamsungOptimization(device) ? 100 : 50;
        await Future.delayed(Duration(milliseconds: delay));
      } catch (_) {}
      
      // Try very fast connection
      await device.connect(
        timeout: const Duration(seconds: 2),
        autoConnect: false,
      );
      
      // Samsung devices need longer verification
      if (_needsSamsungOptimization(device)) {
        await Future.delayed(const Duration(milliseconds: 200));
        final state = await device.connectionState.first;
        if (state != BluetoothConnectionState.connected) {
          throw Exception('Samsung device connection verification failed');
        }
      }
      
      print('✅ [BT Service] Quick connect successful!');
      return true;
    } catch (e) {
      print('❌ [BT Service] Quick connect failed: $e');
      return false;
    }
  }

  /// Connect to a Bluetooth device and verify room code
  Future<bool> connectToDevice(BluetoothDevice device) async {
    // First try the quick connect approach
    if (await _tryQuickConnect(device)) {
      _connectedDevice = device;
      // Skip to service discovery with minimal delay
      await Future.delayed(const Duration(milliseconds: 100));
    } else {
      // Quick connect failed, try normal connection with retries
      try {
      print(
          '🔗 [BT Service] Connecting to device: ${device.platformName} (${device.remoteId})');

      // Stop scanning before connecting to avoid interference
      await stopScanning();
      
      // Add small delay to let scanning stop completely
      await Future.delayed(const Duration(milliseconds: 300));
      
      // Check if device is already connected or connecting
      final currentState = await device.connectionState.first;
      if (currentState == BluetoothConnectionState.connected) {
        print('✅ [BT Service] Device already connected!');
        _connectedDevice = device;
        // Skip to service discovery
      } else {
        // Disconnect if in any intermediate state
        if (currentState != BluetoothConnectionState.disconnected) {
          try {
            await device.disconnect();
            await Future.delayed(const Duration(milliseconds: 200));
          } catch (_) {}
        }
        
        // Use very short timeout for fast failure and retry
        await device.connect(
          timeout: const Duration(seconds: 4),
          autoConnect: false,
        );
      }

      print('✅ [BT Service] Connection established');
      _connectedDevice = device;

      // Samsung devices need longer stabilization delay
      final stabilizationDelay = _needsSamsungOptimization(device) ? 800 : 400;
      await Future.delayed(Duration(milliseconds: stabilizationDelay));
      
      // Verify we're still connected after stabilization (multiple checks for Samsung)
      if (_needsSamsungOptimization(device)) {
        // Samsung devices: verify connection stability with multiple checks
        for (int i = 0; i < 3; i++) {
          final connectionState = await device.connectionState.first;
          if (connectionState != BluetoothConnectionState.connected) {
            print('❌ [BT Service] Samsung device connection lost during verification $i');
            throw Exception('Samsung device connection unstable after connection');
          }
          if (i < 2) await Future.delayed(const Duration(milliseconds: 100));
        }
        print('✅ [BT Service] Samsung device connection verified as stable');
      } else {
        // Standard device: single verification
        final connectionState = await device.connectionState.first;
        if (connectionState != BluetoothConnectionState.connected) {
          print('❌ [BT Service] Connection lost during stabilization');
          throw Exception('Connection unstable after connection');
        }
      }

      // Listen to device state changes
      _deviceStateSubscription = device.connectionState.listen((state) {
        print('🔗 [BT Service] Connection state changed: $state');
        _connectionStateController.add(state);

        if (state == BluetoothConnectionState.disconnected) {
          print('❌ [BT Service] Device disconnected');
          _handleDisconnection();
        }
      });

      // Discover services
      print('🔍 [BT Service] Discovering services...');
      final services = await device.discoverServices();
      print('✅ [BT Service] Found ${services.length} services');

      // Find the standard BLE characteristic
      // Since we can't advertise custom services, look for any writable characteristic
      for (var service in services) {
        print('🔍 [BT Service] Service UUID: ${service.uuid}');

        for (var characteristic in service.characteristics) {
          // Look for writable and notifiable characteristics
          if (characteristic.properties.write &&
              characteristic.properties.notify) {
            print(
                '✅ [BT Service] Found writable/notifiable characteristic: ${characteristic.uuid}');
            _characteristic = characteristic;

            // Enable notifications
            await characteristic.setNotifyValue(true);

            // Listen for incoming messages
            _characteristicSubscription =
                characteristic.lastValueStream.listen((value) async {
              if (value.isNotEmpty) {
                final message = utf8.decode(value);
                print('📨 [BT Service] Received message: $message');

                // Handle room code verification messages automatically
                if (message.startsWith('ROOM_CODE:') &&
                    !_isHost &&
                    _currentRoomCode != null) {
                  // Guest receives host's room code, verify and respond
                  final hostRoomCode = message.replaceFirst('ROOM_CODE:', '');
                  print('🔐 [GUEST] Received host room code: $hostRoomCode');
                  print('🔐 [GUEST] Our room code: $_currentRoomCode');

                  if (hostRoomCode == _currentRoomCode) {
                    print(
                        '✅ [GUEST] Room codes match! Sending confirmation...');
                    await sendMessage('ROOM_CODE:$_currentRoomCode');
                  } else {
                    print('❌ [GUEST] Room code mismatch! Disconnecting...');
                    await disconnect();
                    return;
                  }
                }

                // Add message to stream for app to handle
                _messageController.add(message);
              }
            });

            // Verify room code after connection (host initiates)
            if (_currentRoomCode != null && _isHost) {
              print('🔐 [HOST] Verifying room code with peer...');
              final verified = await _verifyRoomCode(_currentRoomCode!);
              if (!verified) {
                print('❌ [HOST] Room code verification failed!');
                await disconnect();
                return false;
              }
              print('✅ [HOST] Room code verified successfully!');
            } else if (_currentRoomCode != null && !_isHost) {
              print('🔐 [GUEST] Waiting for host to verify room code...');
            }

            break;
          }
        }

        if (_characteristic != null) break; // Found a suitable characteristic
      }

      if (_characteristic == null) {
        print('❌ [BT Service] No suitable characteristic found');
        await disconnect();
        return false;
      }

      print('✅ [BT Service] Successfully connected to ${device.platformName}');
      return true;
      } catch (e) {
      print('❌ [BT Service] Initial connection failed: $e');
      
      // Enhanced retry for Samsung device compatibility and timeout errors
      if (e.toString().contains('Timed out') || 
          e.toString().contains('GATT_CONNECTION_TIMEOUT') || 
          e.toString().contains('147') ||
          e.toString().contains('timeout')) {
        
        // Samsung devices get more attempts with longer timeouts
        final maxRetries = _needsSamsungOptimization(device) ? 5 : 3;
        final isSamsung = _needsSamsungOptimization(device);
        
        print('📱 [BT Service] Device optimization: ${isSamsung ? "Samsung" : "Standard"} mode');
        
        for (int attempt = 1; attempt <= maxRetries; attempt++) {
          print('🔄 [BT Service] ${isSamsung ? "Samsung" : "Fast"} retry attempt $attempt/$maxRetries for timeout');
          
          try {
            // Ensure device is completely disconnected with Samsung-specific delays
            try {
              await device.disconnect();
              final disconnectDelay = isSamsung ? 200 : 100;
              await Future.delayed(Duration(milliseconds: disconnectDelay));
            } catch (_) {}
            
            // Samsung devices need longer delays between retries
            final baseDelay = isSamsung ? 400 : 200;
            await Future.delayed(Duration(milliseconds: baseDelay + (attempt * 150)));
            
            // Samsung devices get longer timeouts
            final retryTimeout = isSamsung ? 
                Duration(seconds: 4 + attempt) : // Samsung: 5s, 6s, 7s, 8s, 9s
                Duration(seconds: 3 + attempt);  // Standard: 4s, 5s, 6s
            print('🔄 [BT Service] ${isSamsung ? "Samsung" : "Standard"} retry with ${retryTimeout.inSeconds}s timeout');
            
            await device.connect(
              timeout: retryTimeout,
              autoConnect: false,
            );
            
            print('✅ [BT Service] Connection successful on retry $attempt');
            _connectedDevice = device;
            
            // Samsung devices need longer stabilization after retry
            final stabilizationDelay = _needsSamsungOptimization(device) ? 600 : 300;
            await Future.delayed(Duration(milliseconds: stabilizationDelay));
            
            // Verify connection stability for Samsung devices
            if (_needsSamsungOptimization(device)) {
              final connectionState = await device.connectionState.first;
              if (connectionState != BluetoothConnectionState.connected) {
                throw Exception('Samsung device retry connection verification failed');
              }
              print('✅ [BT Service] Samsung device retry connection verified');
            }
            
            // Continue with normal flow after successful retry
            // Listen to device state changes
            _deviceStateSubscription = device.connectionState.listen((state) {
              print('🔗 [BT Service] Connection state changed: $state');
              _connectionStateController.add(state);

              if (state == BluetoothConnectionState.disconnected) {
                print('❌ [BT Service] Device disconnected');
                _handleDisconnection();
              }
            });
            
            // Discover services after successful retry
            print('🔍 [BT Service] Discovering services after retry...');
            final services = await device.discoverServices();
            print('✅ [BT Service] Found ${services.length} services after retry');
            
            // Process services and characteristics (same as main flow)
            bool foundCharacteristic = false;
            for (var service in services) {
              print('🔍 [BT Service] Service UUID: ${service.uuid}');

              for (var characteristic in service.characteristics) {
                print('🔍 [BT Service] Checking characteristic: ${characteristic.uuid}');
                print('   Properties: Write=${characteristic.properties.write}, Notify=${characteristic.properties.notify}, Read=${characteristic.properties.read}');

                if (characteristic.properties.write) {
                  print('✅ [BT Service] Found writable characteristic: ${characteristic.uuid}');
                  _characteristic = characteristic;

                  // Enable notifications if supported
                  if (characteristic.properties.notify) {
                    try {
                      await characteristic.setNotifyValue(true);
                      print('✅ [BT Service] Notifications enabled after retry');
                    } catch (e) {
                      print('⚠️ [BT Service] Could not enable notifications after retry: $e');
                    }
                  }

                  // Listen for incoming messages
                  _characteristicSubscription = characteristic.lastValueStream.listen((value) async {
                    if (value.isNotEmpty) {
                      final message = utf8.decode(value);
                      print('📨 [BT Service] Received message: $message');
                      _messageController.add(message);
                    }
                  });

                  foundCharacteristic = true;
                  break;
                }
              }

              if (foundCharacteristic) break;
            }
            
            if (!foundCharacteristic) {
              print('❌ [BT Service] No suitable characteristic found after retry');
              await disconnect();
              return false;
            }
            
            print('✅ [BT Service] Successfully connected after retry to ${device.platformName}');
            return true;
            
          } catch (retryError) {
            print('❌ [BT Service] ${_needsSamsungOptimization(device) ? "Samsung" : "Standard"} retry $attempt failed: $retryError');
            
            if (attempt == maxRetries) {
              final deviceType = _needsSamsungOptimization(device) ? "Samsung" : "Standard";
              print('❌ [BT Service] All $maxRetries $deviceType retries exhausted');
              await disconnect();
              return false;
            }
            
            // Extra delay before next retry for Samsung devices
            if (_needsSamsungOptimization(device)) {
              await Future.delayed(const Duration(milliseconds: 200));
            }
          }
        }
        
        // If we get here after retry loop, connection succeeded but something else failed
        print('❌ [BT Service] Connection retry succeeded but setup failed');
        await disconnect();
        return false;
      } else {
        // Non-timeout error, don't retry
        await disconnect();
        return false;
      }
      }
    }
    
    // Continue with service discovery for both quick connect and normal connect
    // Listen to device state changes
    _deviceStateSubscription = device.connectionState.listen((state) {
      print('🔗 [BT Service] Connection state changed: $state');
      _connectionStateController.add(state);

      if (state == BluetoothConnectionState.disconnected) {
        print('❌ [BT Service] Device disconnected');
        _handleDisconnection();
      }
    });

    // Discover services
    print('🔍 [BT Service] Discovering services...');
    final services = await device.discoverServices();
    print('✅ [BT Service] Found ${services.length} services');

    // Find the standard BLE characteristic
    // Since we can't advertise custom services, look for any writable characteristic
    for (var service in services) {
      print('🔍 [BT Service] Service UUID: ${service.uuid}');

      for (var characteristic in service.characteristics) {
        print('🔍 [BT Service] Checking characteristic: ${characteristic.uuid}');
        print('   Properties: Write=${characteristic.properties.write}, Notify=${characteristic.properties.notify}, Read=${characteristic.properties.read}');

        // Look for writable characteristics (notify is optional for Android-to-Android)
        if (characteristic.properties.write) {
          print('✅ [BT Service] Found writable characteristic: ${characteristic.uuid}');
          _characteristic = characteristic;

          // Enable notifications if supported
          if (characteristic.properties.notify) {
            try {
              await characteristic.setNotifyValue(true);
              print('✅ [BT Service] Notifications enabled');
            } catch (e) {
              print('⚠️ [BT Service] Could not enable notifications: $e');
            }
          } else {
            print('ℹ️ [BT Service] Characteristic does not support notifications');
          }

          // Listen for incoming messages
          _characteristicSubscription = characteristic.lastValueStream.listen((value) async {
            if (value.isNotEmpty) {
              final message = utf8.decode(value);
              print('📨 [BT Service] Received message: $message');

              // Handle room code verification messages automatically
              if (message.startsWith('ROOM_CODE:') &&
                  !_isHost &&
                  _currentRoomCode != null) {
                // Guest receives host's room code, verify and respond
                final hostRoomCode = message.replaceFirst('ROOM_CODE:', '');
                print('🔐 [GUEST] Received host room code: $hostRoomCode');
                print('🔐 [GUEST] Our room code: $_currentRoomCode');

                if (hostRoomCode == _currentRoomCode) {
                  print('✅ [GUEST] Room codes match! Sending confirmation...');
                  await sendMessage('ROOM_CODE:$_currentRoomCode');
                } else {
                  print('❌ [GUEST] Room code mismatch! Disconnecting...');
                  await disconnect();
                  return;
                }
              }

              // Add message to stream for app to handle
              _messageController.add(message);
            }
          });

          // Verify room code after connection (host initiates)
          if (_currentRoomCode != null && _isHost) {
            print('🔐 [HOST] Verifying room code with peer...');
            final verified = await _verifyRoomCode(_currentRoomCode!);
            if (!verified) {
              print('❌ [HOST] Room code verification failed!');
              await disconnect();
              return false;
            }
            print('✅ [HOST] Room code verified successfully!');
          } else if (_currentRoomCode != null && !_isHost) {
            print('🔐 [GUEST] Waiting for host to verify room code...');
          }

          break;
        }
      }

      if (_characteristic != null) break; // Found a suitable characteristic
    }

    if (_characteristic == null) {
      print('❌ [BT Service] No suitable characteristic found');
      await disconnect();
      return false;
    }

    print('✅ [BT Service] Successfully connected to ${device.platformName}');
    return true;
  }

  /// Verify room code with connected peer
  /// Returns true if room codes match, false otherwise
  Future<bool> _verifyRoomCode(String roomCode) async {
    try {
      // Send our room code to peer
      final verifyMessage = 'ROOM_CODE:$roomCode';
      await sendMessage(verifyMessage);

      // Wait for peer's room code response
      final response = await messageStream
          .firstWhere(
            (msg) => msg.startsWith('ROOM_CODE:'),
            orElse: () => '',
          )
          .timeout(
            const Duration(seconds: 5),
            onTimeout: () => '',
          );

      if (response.isEmpty) {
        print('❌ [VERIFY] No room code response from peer');
        return false;
      }

      final peerRoomCode = response.replaceFirst('ROOM_CODE:', '');
      final matches = peerRoomCode == roomCode;

      print('🔐 [VERIFY] Our room code: $roomCode');
      print('🔐 [VERIFY] Peer room code: $peerRoomCode');
      print('🔐 [VERIFY] Match: $matches');

      return matches;
    } catch (e) {
      print('❌ [VERIFY] Room code verification error: $e');
      return false;
    }
  }

  /// Send a message to the connected device
  Future<bool> sendMessage(String message) async {
    if (_characteristic == null || _connectedDevice == null) {
      return false;
    }

    try {
      final bytes = utf8.encode(message);

      // Split message into chunks if needed (BLE has MTU limitations)
      const maxChunkSize = 512;
      for (var i = 0; i < bytes.length; i += maxChunkSize) {
        final end =
            (i + maxChunkSize < bytes.length) ? i + maxChunkSize : bytes.length;
        final chunk = bytes.sublist(i, end);
        await _characteristic!.write(chunk, withoutResponse: false);
      }

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disconnect from the current device
  Future<void> disconnect() async {
    await _characteristicSubscription?.cancel();
    await _deviceStateSubscription?.cancel();

    // Stop advertising if host
    if (_isHost) {
      await stopAdvertising();
    }

    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (e) {
        // Ignore disconnect errors
      }
    }

    _connectedDevice = null;
    _characteristic = null;
    _isHost = false;
  }

  /// Handle disconnection
  void _handleDisconnection() {
    _connectedDevice = null;
    _characteristic = null;
    _characteristicSubscription?.cancel();
  }

  /// Get list of bonded devices (Android only)
  Future<List<BluetoothDevice>> getBondedDevices() async {
    try {
      return await FlutterBluePlus.bondedDevices;
    } catch (e) {
      return [];
    }
  }

  /// Dispose resources
  void dispose() {
    _scanSubscription?.cancel();
    _deviceStateSubscription?.cancel();
    _characteristicSubscription?.cancel();
    stopAdvertising();
    _messageController.close();
    _connectionStateController.close();
    _discoveredDevicesController.close();
  }
}

/// Message types for game communication
enum GameMessageType {
  handshake,
  ready,
  turnData,
  gameOver,
  disconnect,
}

/// Game message structure
class GameMessage {
  final GameMessageType type;
  final Map<String, dynamic> data;

  GameMessage({required this.type, required this.data});

  String toJson() {
    return jsonEncode({
      'type': type.toString().split('.').last,
      'data': data,
    });
  }

  static GameMessage fromJson(String jsonString) {
    final map = jsonDecode(jsonString);
    final typeStr = map['type'] as String;
    final type = GameMessageType.values.firstWhere(
      (e) => e.toString().split('.').last == typeStr,
    );
    return GameMessage(
      type: type,
      data: map['data'] as Map<String, dynamic>,
    );
  }
}
