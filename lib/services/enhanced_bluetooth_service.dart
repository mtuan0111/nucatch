import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'package:permission_handler/permission_handler.dart' show Permission;

/// Enhanced Bluetooth service that works around Android BLE peripheral limitations
/// Uses mutual scanning approach - both devices advertise in scan response data
class EnhancedBluetoothService {
  static final EnhancedBluetoothService _instance =
      EnhancedBluetoothService._internal();
  factory EnhancedBluetoothService() => _instance;
  EnhancedBluetoothService._internal();

  String? _currentRoomCode;
  bool _isHost = false;
  String? _playerId;

  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;
  StreamSubscription? _scanSubscription;
  StreamSubscription? _deviceStateSubscription;
  StreamSubscription? _characteristicSubscription;

  // Write queue to prevent write busy errors
  final List<String> _writeQueue = [];
  bool _isWriting = false;

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
  bool get isHost => _isHost;
  String? get playerId => _playerId;

  final List<ScanResult> _discoveredDevices = [];
  bool _isScanning = false;

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

  /// Open app settings to allow user to manually grant permissions
  Future<bool> openAppSettings() async {
    return await permission_handler.openAppSettings();
  }

  /// Start room as host - uses scanning with special advertisement
  Future<String> startRoom(String roomCode, String hostId) async {
    _currentRoomCode = roomCode;
    _playerId = hostId;
    _isHost = true;

    print('🏠 [Enhanced BT] Starting room as host: $roomCode');

    // Start scanning for guests trying to join this room
    await _startMutualScanning();

    return 'Host-$roomCode';
  }

  /// Join room as guest - uses scanning to find host
  Future<void> joinRoom(String roomCode, String guestId) async {
    _currentRoomCode = roomCode;
    _playerId = guestId;
    _isHost = false;

    print('🚪 [Enhanced BT] Joining room as guest: $roomCode');

    // Start scanning for host of this room
    await _startMutualScanning();
  }

  /// Enhanced mutual scanning - both host and guest scan with device name advertisement
  Future<void> _startMutualScanning() async {
    if (_isScanning) {
      await FlutterBluePlus.stopScan();
    }

    _discoveredDevices.clear();
    _isScanning = true;

    print(
        '🔍 [Enhanced BT] Starting mutual scanning for room: $_currentRoomCode');
    print('🔍 [Enhanced BT] Role: ${_isHost ? "Host" : "Guest"}');
    print('🔍 [Enhanced BT] Player ID: $_playerId');

    try {
      // Start scanning - look for devices with NuCatch in the name
      await FlutterBluePlus.startScan(
        timeout: const Duration(seconds: 60), // Longer timeout
        androidUsesFineLocation: true,
      );

      _scanSubscription = FlutterBluePlus.scanResults.listen((results) {
        _processScanResults(results);
      });
    } catch (e) {
      print('❌ [Enhanced BT] Failed to start scanning: $e');
      _isScanning = false;
      rethrow;
    }
  }

  void _processScanResults(List<ScanResult> results) {
    if (results.isEmpty) return;

    print('🔍 [Enhanced BT] Processing ${results.length} scan results...');
    _discoveredDevices.clear();

    for (var result in results) {
      final deviceName = result.device.platformName.isNotEmpty
          ? result.device.platformName
          : result.device.remoteId.toString();
      final advName = result.advertisementData.advName;

      // More aggressive matching - look for any connectable device for now
      if (result.rssi > -80) {
        // Only consider devices with reasonable signal
        print('📱 [Enhanced BT] Found nearby device:');
        print('   Device Name: $deviceName');
        print('   Advertisement Name: $advName');
        print('   RSSI: ${result.rssi} dBm');
        print('   ID: ${result.device.remoteId}');
        print('   Connectable: ${result.advertisementData.connectable}');

        _discoveredDevices.add(result);

        // Try to connect to any reasonably strong device for testing
        if (!isConnected &&
            result.advertisementData.connectable &&
            result.rssi > -70) {
          print('🎯 [Enhanced BT] Attempting connection to nearby device');
          _attemptConnection(result.device);
        }
      }
    }

    print('🔍 [Enhanced BT] Found ${_discoveredDevices.length} nearby devices');
    _discoveredDevicesController.add(List.from(_discoveredDevices));
  }

  Future<void> _attemptConnection(BluetoothDevice device) async {
    if (isConnected) return;

    try {
      print(
          '🔗 [Enhanced BT] Attempting connection to: ${device.platformName}');

      await FlutterBluePlus.stopScan();
      _isScanning = false;

      // Try connection with extended timeout
      await device.connect(
        timeout: const Duration(seconds: 10),
        autoConnect: false,
      );

      _connectedDevice = device;

      // Listen to connection state
      _deviceStateSubscription = device.connectionState.listen((state) {
        print('🔗 [Enhanced BT] Connection state: $state');
        _connectionStateController.add(state);

        if (state == BluetoothConnectionState.disconnected) {
          _handleDisconnection();
        }
      });

      // Try to create bond for secure communication
      try {
        print('🔐 [Enhanced BT] Attempting to create bond...');
        await device.createBond();
        print('✅ [Enhanced BT] Bond created successfully');
      } catch (e) {
        print('⚠️ [Enhanced BT] Bond creation failed (may already exist): $e');
        // Continue anyway, some devices don't require explicit bonding
      }

      // Small delay after bonding
      await Future.delayed(const Duration(seconds: 1));

      // Discover services and setup communication
      await _setupCommunication(device);

      print('✅ [Enhanced BT] Successfully connected to ${device.platformName}');
    } catch (e) {
      print('❌ [Enhanced BT] Connection failed: $e');

      // Retry scanning if connection fails
      if (!_isScanning) {
        await _startMutualScanning();
      }
    }
  }

  Future<void> _setupCommunication(BluetoothDevice device) async {
    print('🔍 [Enhanced BT] Discovering services...');

    final services = await device.discoverServices();
    print('✅ [Enhanced BT] Found ${services.length} services');

    // Look for a writable characteristic
    for (var service in services) {
      print(
          '🔍 [Enhanced BT] Checking service ${service.uuid} with ${service.characteristics.length} characteristics');
      for (var characteristic in service.characteristics) {
        print(
            '🔍 [Enhanced BT] Characteristic ${characteristic.uuid}: write=${characteristic.properties.write}, notify=${characteristic.properties.notify}');
        if (characteristic.properties.write) {
          print(
              '✅ [Enhanced BT] Found writable characteristic: ${characteristic.uuid}');
          _characteristic = characteristic;

          // Enable notifications if supported
          if (characteristic.properties.notify) {
            try {
              try {
                await characteristic
                    .setNotifyValue(true)
                    .timeout(const Duration(seconds: 5));
                print('✅ [Enhanced BT] Notifications enabled');
              } on TimeoutException {
                print(
                    '⚠️ [Enhanced BT] Notification setup timed out, continuing without notifications');
              }

              // Listen for messages
              _characteristicSubscription =
                  characteristic.lastValueStream.listen((value) {
                if (value.isNotEmpty) {
                  final message = utf8.decode(value);
                  print('📨 [Enhanced BT] Received: $message');
                  _messageController.add(message);
                }
              });
            } catch (e) {
              print('⚠️ [Enhanced BT] Could not enable notifications: $e');
              // Continue anyway, we can still send messages
            }
          }

          // Small delay before sending handshake to avoid write busy
          await Future.delayed(const Duration(milliseconds: 500));

          // Send connection handshake
          await _sendHandshake();
          return;
        }
      }
    }

    throw Exception('No suitable characteristic found');
  }

  Future<void> _sendHandshake() async {
    print('🤝 [Enhanced BT] Preparing handshake message');
    final handshake = jsonEncode({
      'type': 'handshake',
      'roomCode': _currentRoomCode,
      'playerId': _playerId,
      'isHost': _isHost,
    });

    print('🤝 [Enhanced BT] Sending handshake: $handshake');
    final success = await sendMessage(handshake);
    if (!success) {
      print('❌ [Enhanced BT] Handshake failed to send');
      throw Exception('Failed to send handshake message');
    }
    print('✅ [Enhanced BT] Handshake sent successfully');
  }

  /// Send a message to the connected device
  Future<bool> sendMessage(String message) async {
    print(
        '📝 [Enhanced BT] Attempting to send message: ${message.substring(0, message.length.clamp(0, 50))}...');

    if (_characteristic == null) {
      print('❌ [Enhanced BT] No characteristic available for sending');
      return false;
    }

    if (_connectedDevice == null) {
      print('❌ [Enhanced BT] No connected device available for sending');
      return false;
    }

    print(
        '✅ [Enhanced BT] Adding message to write queue (queue size: ${_writeQueue.length})');

    // Add to write queue
    _writeQueue.add(message);

    // Process queue if not already processing
    if (!_isWriting) {
      print('🔄 [Enhanced BT] Processing write queue immediately');
      return await _processWriteQueue();
    }

    print('⏳ [Enhanced BT] Message queued for later processing');
    return true; // Queued for sending
  }

  /// Process the write queue to prevent busy errors
  Future<bool> _processWriteQueue() async {
    if (_isWriting) {
      print('⚠️ [Enhanced BT] Write queue already processing');
      return false;
    }

    if (_writeQueue.isEmpty) {
      print('⚠️ [Enhanced BT] Write queue is empty');
      return false;
    }

    if (_characteristic == null) {
      print('❌ [Enhanced BT] No characteristic available for writing');
      return false;
    }

    print(
        '🔄 [Enhanced BT] Starting write queue processing (${_writeQueue.length} messages)');
    _isWriting = true;
    bool allSuccessful = true;

    while (_writeQueue.isNotEmpty) {
      final message = _writeQueue.removeAt(0);
      print(
          '📝 [Enhanced BT] Processing message: ${message.substring(0, message.length.clamp(0, 50))}...');

      try {
        final bytes = utf8.encode(message);
        print('📏 [Enhanced BT] Message encoded to ${bytes.length} bytes');

        // Split into chunks if needed
        const maxChunkSize = 512;
        final totalChunks = (bytes.length / maxChunkSize).ceil();

        for (var i = 0; i < bytes.length; i += maxChunkSize) {
          final end = (i + maxChunkSize < bytes.length)
              ? i + maxChunkSize
              : bytes.length;
          final chunk = bytes.sublist(i, end);
          final chunkIndex = (i / maxChunkSize).floor() + 1;

          print(
              '📦 [Enhanced BT] Writing chunk $chunkIndex/$totalChunks (${chunk.length} bytes)');
          await _characteristic!.write(chunk, withoutResponse: false);
        }

        print(
            '📤 [Enhanced BT] Successfully sent message: ${message.length} bytes');

        // Small delay between writes to prevent busy errors
        if (_writeQueue.isNotEmpty) {
          await Future.delayed(const Duration(milliseconds: 200));
        }
      } catch (e) {
        print('❌ [Enhanced BT] Failed to send message: $e');
        print('🔍 [Enhanced BT] Error type: ${e.runtimeType}');

        // Handle authentication error specifically
        if (e.toString().contains('GATT_INSUFFICIENT_AUTHENTICATION') ||
            e.toString().contains('authentication')) {
          print(
              '🔐 [Enhanced BT] Authentication required, attempting to create bond...');
          try {
            if (_connectedDevice != null) {
              await _connectedDevice!.createBond();
              print('✅ [Enhanced BT] Bond created, waiting before retry...');
              await Future.delayed(const Duration(seconds: 2));
            }
          } catch (bondError) {
            print('⚠️ [Enhanced BT] Bonding failed: $bondError');
          }
        }

        // Retry once after delay
        print('🔄 [Enhanced BT] Retrying after delay...');
        await Future.delayed(const Duration(milliseconds: 1000));
        try {
          final bytes = utf8.encode(message);

          // Try different write strategies
          bool writeSuccessful = false;

          // Strategy 1: Try with response (more secure)
          try {
            const maxChunkSize = 512;
            for (var i = 0; i < bytes.length; i += maxChunkSize) {
              final end = (i + maxChunkSize < bytes.length)
                  ? i + maxChunkSize
                  : bytes.length;
              final chunk = bytes.sublist(i, end);
              await _characteristic!.write(chunk, withoutResponse: false);
            }
            writeSuccessful = true;
            print(
                '📤 [Enhanced BT] Retry successful with response: ${message.length} bytes');
          } catch (responseError) {
            print(
                '⚠️ [Enhanced BT] Write with response failed: $responseError');

            // Strategy 2: Try without response (less secure but may work)
            try {
              const maxChunkSize = 20; // Smaller chunks for without response
              for (var i = 0; i < bytes.length; i += maxChunkSize) {
                final end = (i + maxChunkSize < bytes.length)
                    ? i + maxChunkSize
                    : bytes.length;
                final chunk = bytes.sublist(i, end);
                await _characteristic!.write(chunk, withoutResponse: true);
                await Future.delayed(const Duration(
                    milliseconds: 50)); // Small delay between chunks
              }
              writeSuccessful = true;
              print(
                  '📤 [Enhanced BT] Retry successful without response: ${message.length} bytes');
            } catch (noResponseError) {
              print(
                  '❌ [Enhanced BT] Write without response also failed: $noResponseError');
            }
          }

          if (!writeSuccessful) {
            allSuccessful = false;
          }
        } catch (retryError) {
          print('❌ [Enhanced BT] Retry failed: $retryError');
          print('🔍 [Enhanced BT] Retry error type: ${retryError.runtimeType}');
          allSuccessful = false;
        }
      }
    }

    _isWriting = false;
    print(
        '✅ [Enhanced BT] Write queue processing completed. Success: $allSuccessful');
    return allSuccessful;
  }

  /// Stop scanning
  Future<void> stopScanning() async {
    if (_isScanning) {
      try {
        await FlutterBluePlus.stopScan();
        _scanSubscription?.cancel();
        _isScanning = false;
        print('🛑 [Enhanced BT] Stopped scanning');
      } catch (e) {
        print('❌ [Enhanced BT] Error stopping scan: $e');
      }
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    await _characteristicSubscription?.cancel();
    await _deviceStateSubscription?.cancel();

    if (_connectedDevice != null) {
      try {
        await _connectedDevice!.disconnect();
      } catch (e) {
        print('❌ [Enhanced BT] Disconnect error: $e');
      }
    }

    _connectedDevice = null;
    _characteristic = null;
    await stopScanning();
  }

  void _handleDisconnection() {
    _connectedDevice = null;
    _characteristic = null;
    _characteristicSubscription?.cancel();

    // Restart scanning if we were in a room
    if (_currentRoomCode != null && !_isScanning) {
      print('🔄 [Enhanced BT] Connection lost, restarting scan...');
      _startMutualScanning();
    }
  }

  /// Check if device is bonded
  Future<bool> isBonded() async {
    if (_connectedDevice != null) {
      try {
        final bondState = await _connectedDevice!.bondState.first;
        print('🔍 [Enhanced BT] Bond state: $bondState');
        return bondState == BluetoothBondState.bonded;
      } catch (e) {
        print('⚠️ [Enhanced BT] Failed to check bond state: $e');
        return false;
      }
    }
    return false;
  }

  /// Dispose resources
  void dispose() {
    _scanSubscription?.cancel();
    _deviceStateSubscription?.cancel();
    _characteristicSubscription?.cancel();
    stopScanning();
    _messageController.close();
    _connectionStateController.close();
    _discoveredDevicesController.close();
  }
}
