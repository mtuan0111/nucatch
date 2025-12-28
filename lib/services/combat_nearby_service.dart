import 'dart:async';
import 'dart:convert';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

/// Room states for combat mode
enum RoomState { waiting, guestJoined, bothReady, playing, ended }

/// Service for managing combat connections using Google Nearby Connections API
/// Replaces the complex BLE stack with simplified P2P communication
class CombatNearbyService {
  static final CombatNearbyService _instance = CombatNearbyService._internal();
  factory CombatNearbyService() => _instance;
  CombatNearbyService._internal();

  static const String serviceId = "com.nucatch.combat";
  static const Strategy strategy = Strategy.P2P_STAR; // One-to-one connection

  String? _myEndpointName;
  String? _playerId;
  String? _connectedEndpointId;
  bool _isHost = false;
  bool _isAdvertising = false;
  bool _isDiscovering = false;
  bool _isReady = false;
  bool _opponentReady = false;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _roomStateController = StreamController<RoomState>.broadcast();
  final _endpointsController =
      StreamController<Map<String, String>>.broadcast();
  final _connectionStateController = StreamController<String>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<RoomState> get roomStateStream => _roomStateController.stream;
  Stream<Map<String, String>> get endpointsStream =>
      _endpointsController.stream;
  Stream<String> get connectionStateStream => _connectionStateController.stream;

  // Discovered endpoints: endpointId -> endpointName
  final Map<String, String> _discoveredEndpoints = {};

  String? get playerId => _playerId;
  bool get isHost => _isHost;
  String? get connectedEndpointId => _connectedEndpointId;
  bool get isConnected => _connectedEndpointId != null;
  bool get isReady => _isReady;
  bool get opponentReady => _opponentReady;

  /// Initialize and request necessary permissions
  Future<bool> initialize() async {
    try {
      print('📡 [Nearby] Requesting permissions...');

      // Get Android version to determine required permissions
      final deviceInfo = DeviceInfoPlugin();
      int androidVersion = 0;
      try {
        final androidInfo = await deviceInfo.androidInfo;
        androidVersion = androidInfo.version.sdkInt;
      } catch (e) {
        print('⚠️ [Nearby] Not on Android, skipping version check');
      }

      // Request location permission (required for Nearby Connections)
      PermissionStatus locationStatus = await Permission.location.status;
      if (!locationStatus.isGranted) {
        locationStatus = await Permission.location.request();
      }

      if (!locationStatus.isGranted) {
        print('❌ [Nearby] Location permission denied');
        return false;
      }

      // Request Bluetooth permissions for Android 12+ (API 31+)
      if (androidVersion >= 31) {
        final bluetoothStatuses = await [
          Permission.bluetoothAdvertise,
          Permission.bluetoothConnect,
          Permission.bluetoothScan,
        ].request();

        if (bluetoothStatuses.values.any((status) => !status.isGranted)) {
          print('❌ [Nearby] Bluetooth permissions denied');
          return false;
        }
      } else {
        // For older Android versions, check basic Bluetooth permission
        final bluetoothStatus = await Permission.bluetooth.request();
        if (!bluetoothStatus.isGranted) {
          print('❌ [Nearby] Bluetooth permission denied');
          return false;
        }
      }

      // Request nearby WiFi devices permission for Android 13+ (API 33+)
      if (androidVersion >= 33) {
        final nearbyWifiStatus = await Permission.nearbyWifiDevices.request();
        if (!nearbyWifiStatus.isGranted) {
          print(
              '⚠️ [Nearby] Nearby WiFi devices permission denied, may affect connectivity');
        }
      }

      // Check if location service is enabled
      final locationServiceEnabled =
          await Permission.location.serviceStatus.isEnabled;
      if (!locationServiceEnabled) {
        print(
            '⚠️ [Nearby] Location service is disabled - connections may be unstable');
        // Note: User must manually enable location in settings
      }

      print('✅ [Nearby] Permissions granted');
      return true;
    } catch (e) {
      print('❌ [Nearby] Permission error: $e');
      return false;
    }
  }

  /// Reset the service state (useful after hot reload or before starting new session)
  Future<void> reset() async {
    print('🔄 [Nearby] Resetting service state...');

    try {
      // Stop all active sessions first
      await stopAdvertising();
      await stopDiscovery();

      // Use stopAllEndpoints for thorough cleanup
      // This disconnects ALL endpoints, ensuring no stale connections
      try {
        await Nearby().stopAllEndpoints();
        print('✅ [Nearby] All endpoints stopped');
      } catch (e) {
        print('⚠️ [Nearby] Error stopping all endpoints: $e');
      }

      // Reset all state
      _connectedEndpointId = null;
      _isReady = false;
      _opponentReady = false;
      _discoveredEndpoints.clear();

      // Small delay to let Nearby Connections fully reset
      await Future.delayed(const Duration(milliseconds: 100));

      print('✅ [Nearby] Service reset complete');
    } catch (e) {
      print('⚠️ [Nearby] Error during reset: $e');
    }
  }

  /// Start advertising as host
  Future<void> startAdvertising(String hostName, String hostId) async {
    // Reset any previous state first
    await reset();

    _myEndpointName = hostName;
    _playerId = hostId;
    _isHost = true;
    _isReady = false;
    _opponentReady = false;

    print('📢 [Nearby] Starting advertising as: $hostName');

    try {
      await Nearby().startAdvertising(
        hostName,
        strategy,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
        serviceId: serviceId,
      );

      _isAdvertising = true;
      _roomStateController.add(RoomState.waiting);
      print('✅ [Nearby] Advertising started');
    } catch (e) {
      print('❌ [Nearby] Failed to start advertising: $e');
      rethrow;
    }
  }

  /// Start discovery as guest
  Future<void> startDiscovery(String guestName, String guestId) async {
    // Reset any previous state first
    await reset();

    _myEndpointName = guestName;
    _playerId = guestId;
    _isHost = false;
    _isReady = false;
    _opponentReady = false;

    print('🔍 [Nearby] Starting discovery as: $guestName');

    try {
      await Nearby().startDiscovery(
        guestName,
        strategy,
        onEndpointFound: _onEndpointFound,
        onEndpointLost: _onEndpointLost,
        serviceId: serviceId,
      );

      _isDiscovering = true;
      print('✅ [Nearby] Discovery started');
    } catch (e) {
      print('❌ [Nearby] Failed to start discovery: $e');
      rethrow;
    }
  }

  /// Request connection to discovered endpoint (guest initiates)
  Future<void> requestConnection(String endpointId) async {
    print('🤝 [Nearby] Requesting connection to: $endpointId');

    try {
      await Nearby().requestConnection(
        _myEndpointName!,
        endpointId,
        onConnectionInitiated: _onConnectionInitiated,
        onConnectionResult: _onConnectionResult,
        onDisconnected: _onDisconnected,
      );
      print('✅ [Nearby] Connection requested');
    } catch (e) {
      print('❌ [Nearby] Failed to request connection: $e');
      rethrow;
    }
  }

  /// Accept connection (called by both host and guest)
  Future<void> acceptConnection(String endpointId) async {
    print('✅ [Nearby] Accepting connection from: $endpointId');

    try {
      await Nearby().acceptConnection(
        endpointId,
        onPayLoadRecieved: _onPayloadReceived,
      );
      print('✅ [Nearby] Connection accepted');
    } catch (e) {
      print('❌ [Nearby] Failed to accept connection: $e');
      rethrow;
    }
  }

  /// Reject connection
  Future<void> rejectConnection(String endpointId) async {
    print('❌ [Nearby] Rejecting connection from: $endpointId');
    await Nearby().rejectConnection(endpointId);
  }

  /// Send message to connected endpoint
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_connectedEndpointId == null) {
      print('⚠️ [Nearby] Cannot send message: not connected');
      return;
    }

    // Add metadata
    message['senderId'] = _playerId;
    message['timestamp'] = DateTime.now().millisecondsSinceEpoch;

    final jsonString = jsonEncode(message);
    final bytes = utf8.encode(jsonString);

    print('📤 [Nearby] Sending: ${message['type']}');

    try {
      await Nearby().sendBytesPayload(_connectedEndpointId!, bytes);
      print('✅ [Nearby] Message sent');
    } catch (e) {
      print('❌ [Nearby] Failed to send message: $e');
    }
  }

  /// Set player ready state
  Future<void> setPlayerReady() async {
    _isReady = true;
    await sendMessage({'type': 'player_ready'});

    // Check if both ready
    if (_opponentReady) {
      print('🎮 [Nearby] Both players ready!');
      _roomStateController.add(RoomState.bothReady);
    }
  }

  /// Start game (host only)
  Future<void> startGame() async {
    if (!_isHost) {
      print('⚠️ [Nearby] Only host can start game');
      return;
    }

    await sendMessage({'type': 'game_started'});
    _roomStateController.add(RoomState.playing);
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    if (_isAdvertising) {
      await Nearby().stopAdvertising();
      _isAdvertising = false;
      print('🛑 [Nearby] Advertising stopped');
    }
  }

  /// Stop discovery
  Future<void> stopDiscovery() async {
    if (_isDiscovering) {
      await Nearby().stopDiscovery();
      _isDiscovering = false;
      print('🛑 [Nearby] Discovery stopped');
    }
  }

  /// Disconnect from endpoint
  Future<void> disconnect() async {
    if (_connectedEndpointId != null) {
      await sendMessage({'type': 'opponent_left'});
      await Nearby().disconnectFromEndpoint(_connectedEndpointId!);
      _connectedEndpointId = null;
      print('🔌 [Nearby] Disconnected');
    }
  }

  /// Clean up resources
  Future<void> dispose() async {
    await stopAdvertising();
    await stopDiscovery();
    await disconnect();

    _messageController.close();
    _roomStateController.close();
    _endpointsController.close();
    _connectionStateController.close();

    _discoveredEndpoints.clear();
  }

  // ============================================================
  // CALLBACKS
  // ============================================================

  /// Called when a connection is initiated
  void _onConnectionInitiated(String endpointId, ConnectionInfo info) {
    print(
        '🔗 [Nearby] Connection initiated with: ${info.endpointName} ($endpointId)');

    // Auto-accept connection
    acceptConnection(endpointId);
  }

  /// Called when connection result is received
  void _onConnectionResult(String endpointId, Status status) {
    print('🔗 [Nearby] Connection result: ${status.toString()}');

    if (status == Status.CONNECTED) {
      _connectedEndpointId = endpointId;
      _connectionStateController.add('connected');

      // Stop advertising/discovery after connection
      if (_isHost) {
        stopAdvertising();
      } else {
        stopDiscovery();
        // Guest sends join notification
        sendMessage({'type': 'guest_joined', 'guestId': _playerId});
      }

      _roomStateController.add(RoomState.guestJoined);
      print('✅ [Nearby] Connected to: $endpointId');
    } else {
      _connectionStateController.add('failed');
      print('❌ [Nearby] Connection failed: ${status.toString()}');
    }
  }

  /// Called when disconnected
  void _onDisconnected(String endpointId) {
    print('🔌 [Nearby] Disconnected from: $endpointId');

    if (_connectedEndpointId == endpointId) {
      _connectedEndpointId = null;
      _connectionStateController.add('disconnected');
      _roomStateController.add(RoomState.ended);

      // Notify about opponent disconnect
      _messageController.add({'type': 'opponent_disconnected'});
    }
  }

  /// Called when endpoint is found during discovery
  void _onEndpointFound(
      String endpointId, String endpointName, String serviceId) {
    print('🔍 [Nearby] Found endpoint: $endpointName ($endpointId)');

    _discoveredEndpoints[endpointId] = endpointName;
    _endpointsController.add(Map.from(_discoveredEndpoints));
  }

  /// Called when endpoint is lost
  void _onEndpointLost(String? endpointId) {
    if (endpointId != null) {
      print('❌ [Nearby] Lost endpoint: $endpointId');
      _discoveredEndpoints.remove(endpointId);
      _endpointsController.add(Map.from(_discoveredEndpoints));
    }
  }

  /// Called when payload is received
  void _onPayloadReceived(String endpointId, Payload payload) {
    if (payload.type != PayloadType.BYTES) {
      print('⚠️ [Nearby] Received non-bytes payload, ignoring');
      return;
    }

    try {
      final bytes = payload.bytes;
      if (bytes == null) {
        print('⚠️ [Nearby] Received empty payload');
        return;
      }

      final jsonString = utf8.decode(bytes);
      final message = jsonDecode(jsonString) as Map<String, dynamic>;

      print('📥 [Nearby] Received: ${message['type']}');

      _handleMessage(message);
    } catch (e) {
      print('❌ [Nearby] Failed to parse payload: $e');
    }
  }

  /// Handle incoming messages
  void _handleMessage(Map<String, dynamic> message) {
    final type = message['type'];

    switch (type) {
      case 'guest_joined':
        print('👋 [Nearby] Guest joined!');
        _roomStateController.add(RoomState.guestJoined);
        break;

      case 'player_ready':
        print('✅ [Nearby] Opponent is ready!');
        _opponentReady = true;

        // Check if both ready
        if (_isReady) {
          print('🎮 [Nearby] Both players ready!');
          _roomStateController.add(RoomState.bothReady);
        }
        break;

      case 'game_started':
        print('🎮 [Nearby] Game started!');
        _roomStateController.add(RoomState.playing);
        break;

      case 'opponent_left':
        print('👋 [Nearby] Opponent left');
        _roomStateController.add(RoomState.ended);
        break;
    }

    // Forward to message stream
    _messageController.add(message);
  }
}
