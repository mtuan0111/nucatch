import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:ble_peripheral/ble_peripheral.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../domain/entities/bluetooth_device_info.dart';
import '../../core/constants/bluetooth_constants.dart';

/// BLE Data Source for cross-platform P2P communication
/// Supports iOS-iOS, iOS-Android, and Android-Android connections
class BleDataSource {
  final FlutterReactiveBle _ble = FlutterReactiveBle();

  // GATT Service and Characteristic UUIDs
  static const String chatServiceUuid = '0000FFF0-0000-1000-8000-00805F9B34FB';
  static const String messageCharUuid = '0000FFF1-0000-1000-8000-00805F9B34FB';
  static const String roomCodeCharUuid = '0000FFF2-0000-1000-8000-00805F9B34FB';

  String? _connectedDeviceId;
  String? _hostRoomCode;
  bool _isHost = false;
  String? _currentUserName;

  // Stream subscriptions
  StreamSubscription? _scanSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _characteristicSubscription;

  // Stream controllers
  final StreamController<Map<String, dynamic>> _dataController =
      StreamController<Map<String, dynamic>>.broadcast();

  final StreamController<List<BluetoothDeviceInfo>> _devicesController =
      StreamController<List<BluetoothDeviceInfo>>.broadcast();

  final StreamController<ConnectionRequest> _connectionRequestController =
      StreamController<ConnectionRequest>.broadcast();

  // Discovered devices
  final Map<String, BluetoothDeviceInfo> _discoveredDevices = {};

  // Message chunking
  final Map<String, List<int>> _messageChunks = {};

  // Write request buffer for chunked messages from iOS
  final Map<String, List<int>> _writeRequestBuffer = {};

  // Notification buffer for chunked notifications from Android
  final Map<String, List<int>> _notificationBuffer = {};

  // Streams
  Stream<Map<String, dynamic>> get incomingDataStream => _dataController.stream;
  Stream<List<BluetoothDeviceInfo>> get devicesStream =>
      _devicesController.stream;
  Stream<ConnectionRequest> get connectionRequestStream =>
      _connectionRequestController.stream;
  String? get hostRoomCode => _hostRoomCode;

  /// Request necessary Bluetooth permissions
  Future<bool> requestPermissions() async {
    debugPrint('🔐 BLE: Requesting Bluetooth permissions...');

    if (Platform.isAndroid) {
      debugPrint('🔐 BLE: Platform: Android');
      // Android 12+ requires specific Bluetooth permissions (not the old BLUETOOTH permission)
      final permissions = await [
        Permission.location,
        // Permission.bluetooth is deprecated on Android 12+, don't request it
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
        Permission.bluetoothAdvertise,
      ].request();

      final granted = permissions.values.every(
        (status) => status.isGranted || status.isLimited,
      );

      debugPrint('🔐 BLE: Permissions granted: $granted');
      permissions.forEach((permission, status) {
        final statusStr = status.toString();
        final emoji = (status.isGranted || status.isLimited) ? '✅' : '❌';
        debugPrint('  $emoji ${permission.toString()}: $statusStr');
      });

      // Log denied permissions specifically
      if (!granted) {
        debugPrint('⚠️ BLE: DENIED PERMISSIONS:');
        permissions.forEach((permission, status) {
          if (!status.isGranted && !status.isLimited) {
            debugPrint(
              '  ❌ ${permission.toString()} - Status: ${status.toString()}',
            );
          }
        });
      }

      return granted;
    } else if (Platform.isIOS) {
      debugPrint('🔐 BLE: Platform: iOS');
      // iOS 13+ only needs bluetoothScan and bluetoothConnect (NO location permission needed!)
      final permissions = await [
        Permission.bluetoothScan,
        Permission.bluetoothConnect,
      ].request();

      final granted = permissions.values.every(
        (status) => status.isGranted || status.isLimited,
      );

      debugPrint('🔐 BLE: Permissions granted: $granted');
      permissions.forEach((permission, status) {
        final statusStr = status.toString();
        final emoji = (status.isGranted || status.isLimited) ? '✅' : '❌';
        debugPrint('  $emoji ${permission.toString()}: $statusStr');
      });

      // Log denied permissions specifically
      if (!granted) {
        debugPrint('⚠️ BLE: DENIED PERMISSIONS:');
        permissions.forEach((permission, status) {
          if (!status.isGranted && !status.isLimited) {
            debugPrint(
              '  ❌ ${permission.toString()} - Status: ${status.toString()}',
            );
          }
        });
      }

      return granted;
    }
    return false;
  }

  /// Get device name
  Future<String> getDeviceName() async {
    if (Platform.isAndroid) {
      return 'Android Device';
    } else if (Platform.isIOS) {
      return 'iPhone';
    }
    return 'Unknown Device';
  }

  /// Start advertising as host (BLE Peripheral mode with GATT server)
  /// Creates GATT service with message and room code characteristics
  Future<void> startAdvertising(String roomCode, String userName) async {
    try {
      _isHost = true;
      _hostRoomCode = roomCode;
      _currentUserName = userName;

      debugPrint('📡 BLE: ========== STARTING GATT SERVER ==========');
      debugPrint('📡 BLE: Room Code: $roomCode');
      debugPrint('📡 BLE: User Name: $userName');
      debugPrint('📡 BLE: Service UUID: $chatServiceUuid');

      // Stop any existing advertising session first
      try {
        debugPrint('📡 BLE: Stopping any existing advertising...');
        await BlePeripheral.stopAdvertising();
        await BlePeripheral.clearServices();
        debugPrint('✅ BLE: Cleared previous advertising session');
      } catch (e) {
        debugPrint('⚠️ BLE: No previous session to clear: $e');
      }

      // Initialize BLE Peripheral
      debugPrint('📡 BLE: Initializing BLE Peripheral...');
      await BlePeripheral.initialize();

      // Add GATT service with characteristics
      debugPrint('📡 BLE: Adding GATT service...');
      await BlePeripheral.addService(
        BleService(
          uuid: chatServiceUuid,
          primary: true,
          characteristics: [
            // Message characteristic (read, writeWithoutResponse, notify)
            BleCharacteristic(
              uuid: messageCharUuid,
              properties: [
                CharacteristicProperties.read.index,
                CharacteristicProperties.writeWithoutResponse.index,
                CharacteristicProperties.notify.index,
              ],
              value: null,
              permissions: [
                AttributePermissions.readable.index,
                AttributePermissions.writeable.index,
              ],
            ),
            // Room code characteristic (read only)
            BleCharacteristic(
              uuid: roomCodeCharUuid,
              properties: [CharacteristicProperties.read.index],
              value: utf8.encode(roomCode),
              permissions: [AttributePermissions.readable.index],
            ),
          ],
        ),
      );

      // Set up callbacks for incoming connections and messages
      debugPrint('📡 BLE: Setting up callbacks...');

      BlePeripheral.setWriteRequestCallback(_onWriteRequest);
      BlePeripheral.setCharacteristicSubscriptionChangeCallback(
        _onSubscriptionChange,
      );

      // Wait for GATT server to be fully initialized
      debugPrint('⏳ BLE: Waiting for GATT server to be fully ready...');
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('✅ BLE: GATT server is ready');

      // Start advertising
      debugPrint('📡 BLE: Starting advertising...');
      debugPrint('📡 BLE: Room Code to advertise: $roomCode');
      debugPrint('📡 BLE: Device Name to advertise: ChatApp-$roomCode');
      await BlePeripheral.startAdvertising(
        services: [chatServiceUuid],
        localName: 'ChatApp-$roomCode',
      );

      debugPrint('✅ BLE: GATT server started successfully!');
      debugPrint('📡 BLE: Advertising as: ChatApp-$roomCode');
      debugPrint('📡 BLE: Host is now discoverable');
    } catch (e, stackTrace) {
      debugPrint('❌ BLE: Error starting GATT server: $e');
      debugPrint('❌ BLE: Stack trace: $stackTrace');
      throw Exception('Failed to start GATT server: $e');
    }
  }

  /// Start discovery (BLE Central mode - scanning)
  Future<void> startDiscovery(String userName) async {
    try {
      _isHost = false;
      _currentUserName = userName;
      _discoveredDevices.clear();

      debugPrint('🔍 BLE: ========== STARTING DISCOVERY ==========');
      debugPrint('🔍 BLE: User Name: $userName');
      debugPrint(
        '🔍 BLE: Scanning for service: ${BluetoothConstants.chatServiceUuid}',
      );
      debugPrint('🔍 BLE: Scan mode: lowLatency');

      // Cancel any existing scan first (iOS requirement)
      if (_scanSubscription != null) {
        debugPrint('🔍 BLE: Canceling existing scan subscription');
        await _scanSubscription?.cancel();
        _scanSubscription = null;
        // Small delay to ensure iOS BLE stack is ready
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Start scanning for devices advertising our chat service
      _scanSubscription = _ble.scanForDevices(
        withServices: [Uuid.parse(BluetoothConstants.chatServiceUuid)],
        scanMode: ScanMode.lowLatency,
      ).listen(
        (device) {
          debugPrint('🔍 BLE: ========== DEVICE FOUND ==========');
          debugPrint('🔍 BLE: Device ID: ${device.id}');
          debugPrint('🔍 BLE: Device Name: ${device.name}');
          debugPrint('🔍 BLE: RSSI: ${device.rssi}');
          debugPrint(
            '🔍 BLE: Manufacturer Data: ${device.manufacturerData}',
          );
          debugPrint('🔍 BLE: Service Data: ${device.serviceData}');

          // Extract room code from manufacturer data or service data
          final roomCode = _extractRoomCode(device);
          debugPrint('🔍 BLE: Extracted room code: $roomCode');

          if (roomCode != null) {
            final deviceInfo = BluetoothDeviceInfo(
              id: device.id,
              name: '${BluetoothConstants.deviceNamePrefix}-$roomCode',
              rssi: device.rssi,
            );

            _discoveredDevices[device.id] = deviceInfo;
            debugPrint('✅ BLE: Added device to list: ${deviceInfo.name}');
            debugPrint(
              '🔍 BLE: Total devices discovered: ${_discoveredDevices.length}',
            );

            _devicesController.add(_discoveredDevices.values.toList());
          } else {
            debugPrint('⚠️ BLE: Skipping device - no room code found');
          }
        },
        onError: (error) {
          debugPrint('❌ BLE: Scan error: $error');
        },
      );

      debugPrint('✅ BLE: Discovery started successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ BLE: Failed to start discovery: $e');
      debugPrint('❌ BLE: Stack trace: $stackTrace');
      throw Exception('Failed to start discovery: $e');
    }
  }

  /// Extract room code from scan result
  String? _extractRoomCode(DiscoveredDevice device) {
    // First, try to extract from device name (ble_peripheral uses this format: "ChatApp-XXXX")
    if (device.name.isNotEmpty) {
      try {
        // Expected format: "ChatApp-7007" or similar
        if (device.name.startsWith('ChatApp-')) {
          final roomCode = device.name.substring('ChatApp-'.length);
          if (roomCode.isNotEmpty) {
            debugPrint(
              '🔍 BLE: Extracted room code from device name: $roomCode',
            );
            return roomCode;
          }
        }
      } catch (e) {
        debugPrint('❌ BLE: Error extracting room code from device name: $e');
      }
    }

    // Try to extract from manufacturer data (flutter_ble_peripheral approach)
    if (device.manufacturerData.isNotEmpty) {
      try {
        // manufacturerData is Uint8List
        // Format: [manufacturerIdLow, manufacturerIdHigh, ...roomCodeBytes]
        // Skip first 2 bytes (manufacturer ID) and extract room code
        final data = device.manufacturerData;
        if (data.length >= 6) {
          // Skip manufacturer ID (2 bytes) and get next 4 bytes for room code
          return String.fromCharCodes(data.sublist(2, 6));
        }
      } catch (e) {
        debugPrint(
          '❌ BLE: Error extracting room code from manufacturer data: $e',
        );
      }
    }

    // Try to extract from service data
    if (device.serviceData.isNotEmpty) {
      try {
        final data = device.serviceData.values.first;
        if (data.length >= 4) {
          return String.fromCharCodes(data.sublist(0, 4));
        }
      } catch (e) {
        debugPrint('❌ BLE: Error extracting from service data: $e');
      }
    }

    return null;
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    try {
      await BlePeripheral.stopAdvertising();
      await BlePeripheral.clearServices();
      _hostRoomCode = null;
      debugPrint('✅ BLE: Stopped advertising and cleared services');
    } catch (e) {
      debugPrint('❌ BLE: Error stopping advertising: $e');
    }
  }

  /// Handle incoming write requests from guest (host side)
  WriteRequestResult? _onWriteRequest(
    String deviceId,
    String characteristicId,
    int offset,
    Uint8List? value,
  ) {
    debugPrint('📥 BLE: ========== WRITE REQUEST ==========');
    debugPrint('📥 BLE: Device: $deviceId');
    debugPrint('📥 BLE: Characteristic: $characteristicId');
    debugPrint('📥 BLE: Offset: $offset');
    debugPrint('📥 BLE: Value length: ${value?.length ?? 0} bytes');

    if (value == null) {
      debugPrint('⚠️ BLE: Received null value');
      return null;
    }

    if (characteristicId.toUpperCase() == messageCharUuid.toUpperCase()) {
      try {
        // Buffer the incoming data
        final bufferKey = deviceId;
        _writeRequestBuffer[bufferKey] ??= [];
        _writeRequestBuffer[bufferKey]!.addAll(value);

        debugPrint('📦 BLE: Added ${value.length} bytes to buffer');
        debugPrint(
          '📦 BLE: Total buffer size: ${_writeRequestBuffer[bufferKey]!.length} bytes',
        );

        // Try to decode and split by newlines
        try {
          final bufferedData = _writeRequestBuffer[bufferKey]!;
          final fullString = utf8.decode(bufferedData);

          debugPrint('🔍 BLE: Decoded buffer, looking for newline delimiters');
          debugPrint(
            '🔍 BLE: Buffer content (first 150 chars): ${fullString.length > 150 ? fullString.substring(0, 150) : fullString}',
          );
          debugPrint('🔍 BLE: Contains newline? ${fullString.contains('\n')}');
          debugPrint(
            '🔍 BLE: Buffer bytes (first 20): ${bufferedData.take(20).toList()}',
          );

          // Check if we have complete messages (ending with newline)
          if (fullString.contains('\n')) {
            final messages = fullString.split('\n');
            debugPrint('📨 BLE: Found ${messages.length} parts after split');

            // Process all complete messages (all but the last, which might be incomplete)
            for (int i = 0; i < messages.length - 1; i++) {
              final message = messages[i].trim();
              if (message.isNotEmpty) {
                debugPrint('✅ BLE: Processing complete message: $message');

                try {
                  // Parse and emit the message directly (not wrapped)
                  final parsed = jsonDecode(message) as Map<String, dynamic>;
                  _dataController.add(parsed);
                  debugPrint('✅ BLE: Message emitted successfully');
                } catch (e) {
                  debugPrint('❌ BLE: Failed to parse message: $e');
                }
              }
            }

            // Keep the incomplete part in buffer
            final lastPart = messages.last;
            if (lastPart.isEmpty) {
              // All messages were complete, clear buffer
              _writeRequestBuffer.remove(bufferKey);
              debugPrint('🧹 BLE: All messages processed, buffer cleared');
            } else {
              // Keep incomplete part for next chunk
              _writeRequestBuffer[bufferKey] = utf8.encode(lastPart);
              debugPrint(
                '⏳ BLE: Kept incomplete part (${lastPart.length} chars) for next chunk',
              );
            }
          } else {
            // No complete messages yet, keep buffering
            debugPrint(
              '⏳ BLE: No complete messages yet (no newline found), buffering...',
            );
          }

          return null; // Success
        } catch (e) {
          debugPrint('❌ BLE: Error processing buffer: $e');
          // Clear buffer on error
          _writeRequestBuffer.remove(deviceId);
          return WriteRequestResult(status: 1); // Error
        }
      } catch (e) {
        debugPrint('❌ BLE: Error processing write request: $e');
        // Clear buffer on error
        _writeRequestBuffer.remove(deviceId);
        return WriteRequestResult(status: 1); // Error
      }
    }

    return null; // Success for other characteristics
  }

  /// Handle guest subscription changes (connection established)
  void _onSubscriptionChange(
    String deviceId,
    String characteristicId,
    bool isSubscribed,
    String? name,
  ) {
    debugPrint('🔔 BLE: ========== SUBSCRIPTION CHANGE ==========');
    debugPrint('🔔 BLE: Device: $deviceId');
    debugPrint('🔔 BLE: Characteristic: $characteristicId');
    debugPrint('🔔 BLE: Subscribed: $isSubscribed');
    debugPrint('🔔 BLE: Name: $name');

    if (characteristicId.toUpperCase() == messageCharUuid.toUpperCase()) {
      if (isSubscribed) {
        _connectedDeviceId = deviceId;

        // Host-side: Guest has subscribed, emit connection accepted
        if (_isHost) {
          // Use the current room code to construct the device name
          // instead of relying on the potentially cached 'name' parameter
          final deviceName = 'ChatApp-$_hostRoomCode';

          debugPrint('✅ BLE: Guest connected and subscribed (Host side)');
          debugPrint('📤 BLE: Emitting connection_accepted event to stream');
          debugPrint('📤 BLE: Partner name: $deviceName');
          debugPrint('📤 BLE: Device ID: $deviceId');
          debugPrint('📤 BLE: Current room code: $_hostRoomCode');

          _dataController.add({
            'type': 'connection_accepted',
            'userName': deviceName,
            'deviceId': deviceId,
          });

          debugPrint('✅ BLE: connection_accepted event emitted successfully');
        } else {
          // Guest-side: Should not happen, but handle it
          _onDeviceConnected(deviceId);
        }

        debugPrint('✅ BLE: Guest connected and subscribed');
      } else {
        _onDeviceDisconnected(deviceId);
        debugPrint('⚠️ BLE: Guest unsubscribed');
      }
    }
  }

  /// Stop discovery
  Future<void> stopDiscovery() async {
    try {
      await _scanSubscription?.cancel();
      _scanSubscription = null;
      _discoveredDevices.clear();
      debugPrint('BLE: Stopped discovery');
    } catch (e) {
      debugPrint('BLE: Error stopping discovery: $e');
    }
  }

  /// Request connection to a device
  Future<void> requestConnection(String deviceId, String userName) async {
    try {
      debugPrint('🔗 BLE: ========== REQUESTING CONNECTION ==========');
      debugPrint('🔗 BLE: Device ID: $deviceId');
      debugPrint('🔗 BLE: User Name: $userName');
      debugPrint('🔗 BLE: Timeout: ${BluetoothConstants.connectionTimeout}');

      if (Platform.isIOS) {
      } else {
        // Cancel any existing connection subscription to prevent conflicts
        if (_connectionSubscription != null) {
          debugPrint('🔗 BLE: Canceling previous connection subscription...');
          await _connectionSubscription?.cancel();
          _connectionSubscription = null;
          debugPrint('✅ BLE: Previous connection subscription canceled');
        }
      }

      // Connect to the device
      debugPrint('🔗 BLE: Creating connection subscription...');
      _connectionSubscription = _ble
          .connectToDevice(
        id: deviceId,
        connectionTimeout: BluetoothConstants.connectionTimeout,
      )
          .listen(
        (connectionState) async {
          debugPrint(
            '🔗 BLE: Connection state changed: ${connectionState.connectionState}',
          );
          debugPrint('🔗 BLE: Device ID: ${connectionState.deviceId}');
          debugPrint('🔗 BLE: Failure: ${connectionState.failure}');

          if (connectionState.connectionState ==
              DeviceConnectionState.connected) {
            debugPrint('✅ BLE: Device connected successfully!');
            _connectedDeviceId = deviceId;

            // Wrap in try-catch to prevent errors from cancelling connection
            try {
              debugPrint('🔧 BLE: About to call _onDeviceConnected');
              await _onDeviceConnected(deviceId);
              debugPrint(
                '✅ BLE: _onDeviceConnected completed successfully',
              );
            } catch (e, stackTrace) {
              debugPrint('❌ BLE: Error in _onDeviceConnected: $e');
              debugPrint('❌ BLE: Stack trace: $stackTrace');
              // Don't rethrow - we want to keep the connection alive
            }
          } else if (connectionState.connectionState ==
              DeviceConnectionState.disconnected) {
            debugPrint('⚠️ BLE: Device disconnected');
            _onDeviceDisconnected(deviceId);
          } else if (connectionState.connectionState ==
              DeviceConnectionState.connecting) {
            debugPrint('🔗 BLE: Connecting...');
          }
        },
        onError: (error) {
          debugPrint('❌ BLE: Connection stream error: $error');
          _dataController.add({
            'type': 'connection_failed',
            'deviceId': deviceId,
          });
        },
        onDone: () {
          debugPrint('⚠️ BLE: Connection stream completed (onDone called)');
          debugPrint(
            '⚠️ BLE: This should NOT happen during active connection',
          );
        },
        cancelOnError: false, // Don't cancel subscription on errors
      );

      debugPrint('✅ BLE: Connection subscription created successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ BLE: Failed to request connection: $e');
      debugPrint('❌ BLE: Stack trace: $stackTrace');
      throw Exception('Failed to request connection: $e');
    }
  }

  /// Handle device connected
  Future<void> _onDeviceConnected(String deviceId) async {
    try {
      debugPrint('✅ BLE: Device connected: $deviceId');

      // Wait a bit for the GATT server to be fully ready
      debugPrint('⏳ BLE: Waiting for GATT server to be ready...');
      await Future.delayed(const Duration(milliseconds: 500));
      debugPrint('✅ BLE: GATT server should be ready now');

      // Discover services
      debugPrint('🔍 BLE: Starting service discovery...');
      final services = await _ble.discoverServices(deviceId);
      debugPrint('✅ BLE: Discovered ${services.length} services');

      // Log all discovered services for debugging
      debugPrint('📋 BLE: Discovered services:');
      for (final service in services) {
        debugPrint('  - Service UUID: ${service.serviceId}');
      }

      // Find our chat service - use exact UUID match
      debugPrint(
        '🔍 BLE: Looking for chat service: ${BluetoothConstants.chatServiceUuid}',
      );

      final targetUuid = BluetoothConstants.chatServiceUuid.toUpperCase();
      final chatService = services.firstWhere((service) {
        if (Platform.isIOS) {
          // Compare UUIDs in uppercase to handle both short (fff0) and long (0000fff0-...) formats
          final serviceUuidStr = service.serviceId.toString().toUpperCase();
          final targetUuidStr =
              BluetoothConstants.chatServiceUuid.toUpperCase();

          // Check if the service UUID contains the target UUID (handles short vs long format)
          return serviceUuidStr.contains(
                targetUuidStr.replaceAll('-', '').substring(0, 4),
              ) ||
              targetUuidStr.contains(serviceUuidStr.replaceAll('-', ''));
        } else {
          final serviceUuid = service.serviceId.toString().toUpperCase();
          debugPrint('  🔍 BLE: Checking service: $serviceUuid');
          // Exact match on the full UUID
          return serviceUuid == targetUuid;
        }
      }, orElse: () => throw Exception('Chat service not found: $targetUuid'));

      debugPrint('✅ BLE: Found chat service');

      // Subscribe to message characteristic for incoming messages
      debugPrint('📝 BLE: Creating QualifiedCharacteristic for subscription');
      debugPrint('📝 BLE: Service ID: ${chatService.serviceId}');
      debugPrint('📝 BLE: Characteristic ID: $messageCharUuid');
      debugPrint('📝 BLE: Device ID: $deviceId');

      final messageCharacteristic = QualifiedCharacteristic(
        serviceId: chatService.serviceId,
        characteristicId: Uuid.parse(messageCharUuid),
        deviceId: deviceId,
      );

      debugPrint('✅ BLE: QualifiedCharacteristic created successfully');
      debugPrint('📡 BLE: Attempting to subscribe to characteristic...');

      _characteristicSubscription =
          _ble.subscribeToCharacteristic(messageCharacteristic).listen(
        (data) {
          debugPrint(
            '📨 BLE: ========== DATA RECEIVED FROM CHARACTERISTIC ==========',
          );
          debugPrint('📨 BLE: Data length: ${data.length} bytes');
          debugPrint('📨 BLE: Raw data: $data');
          debugPrint('📨 BLE: Device ID: $deviceId');
          try {
            final decoded = utf8.decode(data);
            debugPrint('📨 BLE: Decoded string: $decoded');
          } catch (e) {
            debugPrint('⚠️ BLE: Could not decode as UTF-8: $e');
          }
          _handleIncomingData(data);
        },
        onError: (error) {
          debugPrint('❌ BLE: Subscription error: $error');
          _dataController.add({
            'type': 'connection_failed',
            'deviceId': deviceId,
          });
        },
        onDone: () {
          debugPrint('⚠️ BLE: Subscription stream closed');
        },
      );

      debugPrint('✅ BLE: Subscription established successfully');

      // Send connection accepted message
      debugPrint('📤 BLE: Emitting connection_accepted event');
      _dataController.add({
        'type': 'connection_accepted',
        'userName': _currentUserName,
      });
      debugPrint('✅ BLE: connection_accepted event emitted');
    } catch (e, stackTrace) {
      debugPrint('❌ BLE: Error in _onDeviceConnected: $e');
      debugPrint('❌ BLE: Stack trace: $stackTrace');
      _dataController.add({'type': 'connection_failed', 'deviceId': deviceId});
    }
  }

  /// Handle device disconnected
  void _onDeviceDisconnected(String deviceId) {
    debugPrint('BLE: Device disconnected: $deviceId');
    _connectedDeviceId = null;
    _dataController.add({'type': 'disconnected', 'deviceId': deviceId});
  }

  /// Handle incoming data from characteristic (notifications from Android to iOS)
  void _handleIncomingData(List<int> data) {
    try {
      debugPrint(
        '🔍 BLE: _handleIncomingData called with ${data.length} bytes',
      );

      // Check if this is a chunked message with 0xFF header
      if (data.length > 2 && data[0] == 0xFF) {
        debugPrint('🔍 BLE: Detected 0xFF chunked message');
        // Chunked message format: [0xFF, chunkIndex, totalChunks, ...data]
        final chunkIndex = data[1];
        final totalChunks = data[2];
        final chunkData = data.sublist(3);

        final key = '$_connectedDeviceId-$totalChunks';
        _messageChunks[key] ??= [];
        _messageChunks[key]!.addAll(chunkData);

        // Check if we have all chunks
        if (chunkIndex == totalChunks - 1) {
          final completeData = _messageChunks[key]!;
          _messageChunks.remove(key);
          _processCompleteMessage(completeData);
        }
      } else {
        // Notification data - buffer using newline delimiter (same as write requests)
        debugPrint('🔍 BLE: Buffering notification data');
        final bufferKey = _connectedDeviceId ?? 'unknown';
        _notificationBuffer[bufferKey] ??= [];
        _notificationBuffer[bufferKey]!.addAll(data);

        debugPrint(
          '📦 BLE: Notification buffer size: ${_notificationBuffer[bufferKey]!.length} bytes',
        );
        debugPrint('📦 BLE: Buffer bytes: ${_notificationBuffer[bufferKey]}');

        // Try to decode and split by newlines
        try {
          final bufferedData = _notificationBuffer[bufferKey]!;
          final fullString = utf8.decode(bufferedData);

          debugPrint(
            '🔍 BLE: Decoded notification buffer, checking for newlines',
          );
          debugPrint(
            '🔍 BLE: Decoded string: ${fullString.replaceAll('\n', '\\n')}',
          );

          // Check if we have complete messages (ending with newline)
          if (fullString.contains('\n')) {
            final messages = fullString.split('\n');
            debugPrint('📨 BLE: Found ${messages.length} parts after split');

            // Process all complete messages (all but the last, which might be incomplete)
            for (int i = 0; i < messages.length - 1; i++) {
              final message = messages[i].trim();
              if (message.isNotEmpty) {
                debugPrint(
                  '✅ BLE: Processing complete notification message: $message',
                );

                try {
                  // Parse and emit the message
                  final parsed = jsonDecode(message);
                  _dataController.add(parsed);
                  debugPrint(
                    '✅ BLE: Notification message emitted successfully',
                  );
                } catch (e) {
                  debugPrint('❌ BLE: Failed to parse notification message: $e');
                }
              }
            }

            // Keep the incomplete part in buffer
            final lastPart = messages.last;
            if (lastPart.isEmpty) {
              // All messages were complete, clear buffer
              _notificationBuffer.remove(bufferKey);
              debugPrint(
                '🧹 BLE: All notification messages processed, buffer cleared',
              );
            } else {
              // Keep incomplete part for next chunk
              _notificationBuffer[bufferKey] = utf8.encode(lastPart);
              debugPrint(
                '⏳ BLE: Kept incomplete notification part (${lastPart.length} chars) for next chunk',
              );
            }
          } else {
            // No complete messages yet, keep buffering
            debugPrint(
              '⏳ BLE: No complete notification messages yet (no newline found), buffering...',
            );
          }
        } catch (e) {
          debugPrint('❌ BLE: Error processing notification buffer: $e');
          // Clear buffer on error
          _notificationBuffer.remove(bufferKey);
        }
      }
    } catch (e) {
      debugPrint('BLE: Error handling incoming data: $e');
    }
  }

  /// Process complete message
  void _processCompleteMessage(List<int> data) {
    try {
      final jsonString = utf8.decode(data);
      final Map<String, dynamic> message = jsonDecode(jsonString);
      _dataController.add(message);
    } catch (e) {
      debugPrint('BLE: Error processing message: $e');
    }
  }

  /// Accept connection (for host)
  Future<void> acceptConnection(String deviceId) async {
    try {
      debugPrint('BLE: Accepting connection from: $deviceId');
      // In BLE, connection is already established
      // This is more of a logical accept
      _connectedDeviceId = deviceId;
    } catch (e) {
      throw Exception('Failed to accept connection: $e');
    }
  }

  /// Reject connection (for host)
  Future<void> rejectConnection(String deviceId) async {
    try {
      debugPrint('BLE: Rejecting connection from: $deviceId');
      await disconnect();
    } catch (e) {
      throw Exception('Failed to reject connection: $e');
    }
  }

  /// Send data to connected device
  Future<void> sendData(Map<String, dynamic> data) async {
    if (_connectedDeviceId == null) {
      throw Exception('Not connected to any device');
    }

    try {
      debugPrint('📤 BLE: sendData called with: $data');
      final jsonString = jsonEncode(data);
      debugPrint('📤 BLE: JSON encoded: $jsonString');
      // Add newline delimiter to separate messages
      final messageWithDelimiter = '$jsonString\n';
      final bytes = utf8.encode(messageWithDelimiter);

      debugPrint(
        '📤 BLE: Sending message with delimiter (${bytes.length} bytes)',
      );
      debugPrint('📤 BLE: First 50 bytes: ${bytes.take(50).toList()}');
      debugPrint(
        '📤 BLE: Last 10 bytes: ${bytes.skip(bytes.length >= 10 ? bytes.length - 10 : 0).toList()}',
      );

      // Check if we need to chunk the message
      if (bytes.length > BluetoothConstants.chunkSize) {
        await _sendChunkedMessage(bytes);
      } else {
        await _sendSingleMessage(bytes);
      }
    } catch (e) {
      throw Exception('Failed to send data: $e');
    }
  }

  /// Send single message
  Future<void> _sendSingleMessage(List<int> bytes) async {
    if (_isHost) {
      // Android (Host) sending to iOS (Guest) via notification
      // Need to chunk notifications because iOS MTU is typically 20 bytes
      debugPrint('📤 BLE: Sending notification to iOS guest');
      debugPrint('📤 BLE: Device ID: $_connectedDeviceId');
      debugPrint('📤 BLE: Data length: ${bytes.length} bytes');

      const notificationChunkSize = 20; // iOS MTU limitation
      final totalChunks = (bytes.length / notificationChunkSize).ceil();

      debugPrint(
        '📤 BLE: Splitting into $totalChunks chunks of $notificationChunkSize bytes',
      );

      for (var i = 0; i < totalChunks; i++) {
        final start = i * notificationChunkSize;
        final end = (start + notificationChunkSize > bytes.length)
            ? bytes.length
            : start + notificationChunkSize;
        final chunk = bytes.sublist(start, end);

        debugPrint(
          '📤 BLE: Sending chunk ${i + 1}/$totalChunks (${chunk.length} bytes)',
        );

        await BlePeripheral.updateCharacteristic(
          characteristicId: messageCharUuid,
          value: Uint8List.fromList(chunk),
          deviceId: _connectedDeviceId,
        );

        // Small delay between chunks to ensure iOS receives them in order
        if (i < totalChunks - 1) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }

      debugPrint('✅ BLE: All notification chunks sent successfully');
    } else {
      // iOS (Guest) sending to Android (Host) via write
      // Need to chunk writes because BLE has MTU limitations
      debugPrint('📤 BLE: Writing to Android host characteristic');
      debugPrint('📤 BLE: Data length: ${bytes.length} bytes');

      const writeChunkSize = 20; // BLE MTU limitation
      final totalChunks = (bytes.length / writeChunkSize).ceil();

      debugPrint(
        '📤 BLE: Splitting into $totalChunks chunks of $writeChunkSize bytes',
      );

      // Use messageCharUuid (same as host's GATT server characteristic)
      final characteristic = QualifiedCharacteristic(
        serviceId: Uuid.parse(chatServiceUuid),
        characteristicId: Uuid.parse(messageCharUuid),
        deviceId: _connectedDeviceId!,
      );

      for (var i = 0; i < totalChunks; i++) {
        final start = i * writeChunkSize;
        final end = (start + writeChunkSize > bytes.length)
            ? bytes.length
            : start + writeChunkSize;
        final chunk = bytes.sublist(start, end);

        debugPrint(
          '📤 BLE: Sending write chunk ${i + 1}/$totalChunks (${chunk.length} bytes)',
        );

        await _ble.writeCharacteristicWithoutResponse(
          characteristic,
          value: chunk,
        );

        // Small delay between chunks to ensure Android receives them in order
        if (i < totalChunks - 1) {
          await Future.delayed(const Duration(milliseconds: 50));
        }
      }

      debugPrint('✅ BLE: All write chunks sent successfully');
    }
  }

  /// Send chunked message
  Future<void> _sendChunkedMessage(List<int> bytes) async {
    final chunkSize =
        BluetoothConstants.chunkSize - 3; // Reserve 3 bytes for header
    final totalChunks = (bytes.length / chunkSize).ceil();

    for (var i = 0; i < totalChunks; i++) {
      final start = i * chunkSize;
      final end =
          (start + chunkSize > bytes.length) ? bytes.length : start + chunkSize;
      final chunk = bytes.sublist(start, end);

      // Add chunk header: [0xFF, chunkIndex, totalChunks, ...data]
      final chunkedData = [0xFF, i, totalChunks, ...chunk];

      await _sendSingleMessage(chunkedData);

      // Small delay between chunks
      await Future.delayed(const Duration(milliseconds: 50));
    }
  }

  /// Disconnect from current device
  Future<void> disconnect() async {
    try {
      debugPrint('🔌 BLE: Starting disconnect...');

      // Cancel subscriptions
      await _connectionSubscription?.cancel();
      await _characteristicSubscription?.cancel();
      _connectionSubscription = null;
      _characteristicSubscription = null;

      // Reset connection state
      _connectedDeviceId = null;

      // Reset host state if we were hosting
      if (_isHost) {
        debugPrint('🔌 BLE: Stopping advertising (was host)');
        await stopAdvertising();
        _isHost = false;
      }

      // Reset guest state if we were guest
      if (!_isHost) {
        debugPrint('🔌 BLE: Stopping discovery (was guest)');
        await stopDiscovery();
      }

      // Clear message chunks and write request buffer
      _messageChunks.clear();
      _writeRequestBuffer.clear();
      _notificationBuffer.clear();

      debugPrint('✅ BLE: Disconnected and reset all state');
    } catch (e) {
      debugPrint('❌ BLE: Error during disconnect: $e');
      // Force reset state even on error
      _connectedDeviceId = null;
      _isHost = false;
      _hostRoomCode = null;
      _messageChunks.clear();
      _writeRequestBuffer.clear();
      _notificationBuffer.clear();
    }
  }

  /// Stop all operations
  Future<void> stopAll() async {
    try {
      await disconnect();
      await stopAdvertising();
      await stopDiscovery();
      debugPrint('BLE: Stopped all operations');
    } catch (e) {
      debugPrint('BLE: Error stopping all: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _dataController.close();
    _devicesController.close();
    _connectionRequestController.close();
  }
}

/// Connection request model
class ConnectionRequest {
  final String deviceId;
  final String deviceName;
  final String authenticationToken;

  ConnectionRequest({
    required this.deviceId,
    required this.deviceName,
    required this.authenticationToken,
  });
}
