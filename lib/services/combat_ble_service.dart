import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:ble_plat_services/ble_plat_services.dart';
import '../core/utils/room_code_generator.dart';

/// Room states for combat mode (matching CombatNearbyService)
enum RoomState { waiting, guestJoined, bothReady, playing, ended }

/// Service layer that wraps BluetoothRepository
/// Provides high-level methods for Combat BLoC layer and UI screens
class CombatBleService {
  final BluetoothRepository repository;

  CombatBleService({required this.repository}) {
    _setupStreamListeners();
  }

  // Getters
  bool get isHost => _isHost;
  String? get currentRoomCode => repository.hostRoomCode;
  String? get currentUserName => _currentUserName;
  String? get connectedEndpointId => _connectedEndpointId;
  String? get playerId =>
      _currentUserName; // Use userName as playerId for compatibility
  bool get isConnected => _connectedEndpointId != null;
  bool get isReady => _isReady;
  bool get opponentReady => _opponentReady;

  // Internal state
  bool _isHost = false;
  String? _currentUserName;
  String? _connectedEndpointId;
  bool _isReady = false;
  bool _opponentReady = false;
  RoomState _currentRoomState = RoomState.waiting;

  // Stream controllers
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _roomStateController = StreamController<RoomState>.broadcast();
  final _endpointsController =
      StreamController<Map<String, String>>.broadcast();
  final _connectionStateController = StreamController<String>.broadcast();

  // Stream subscriptions
  StreamSubscription? _incomingDataSubscription;
  StreamSubscription? _devicesSubscription;
  StreamSubscription? _connectionRequestSubscription;

  // Streams (matching CombatNearbyService interface)
  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<RoomState> get roomStateStream => _roomStateController.stream;
  Stream<Map<String, String>> get endpointsStream =>
      _endpointsController.stream;
  Stream<String> get connectionStateStream => _connectionStateController.stream;

  // Original BLE streams
  Stream<List<BluetoothDeviceInfo>> get devicesStream =>
      repository.devicesStream;
  Stream<Map<String, dynamic>> get incomingDataStream =>
      repository.incomingDataStream;
  Stream<Map<String, dynamic>> get connectionRequestStream =>
      repository.connectionRequestStream;

  /// Setup stream listeners to transform BLE events to room events
  void _setupStreamListeners() {
    // Listen to incoming data and forward to message stream
    _incomingDataSubscription = repository.incomingDataStream.listen((data) {
      _handleIncomingData(data);
    });

    // Transform devices stream to endpoints stream (deviceId -> "Nucatch-XXXX")
    _devicesSubscription = repository.devicesStream.listen((devices) {
      final endpoints = <String, String>{};
      for (final device in devices) {
        endpoints[device.id] = device.name;
      }
      _endpointsController.add(endpoints);
    });

    // Listen to connection requests (host side)
    _connectionRequestSubscription =
        repository.connectionRequestStream.listen((request) {
      debugPrint('🔗 [CombatBLE] Connection request received: $request');
      // Connection requests are handled by the UI screens
    });
  }

  /// Handle incoming data from BLE
  void _handleIncomingData(Map<String, dynamic> data) {
    final type = data['type'];
    debugPrint('📥 [CombatBLE] Received data type: $type');

    switch (type) {
      case 'connection_accepted':
        // Connection established
        // Only update _connectedEndpointId if deviceId is provided (host side)
        // Guest already set it in connectToDevice()
        if (data['deviceId'] != null) {
          _connectedEndpointId = data['deviceId'];
        }
        _connectionStateController.add('connected');
        _updateRoomState(RoomState.guestJoined);
        break;

      case 'player_ready':
        // Opponent is ready
        _opponentReady = true;
        _messageController.add(data);

        // Check if both ready
        if (_isReady && _opponentReady) {
          _updateRoomState(RoomState.bothReady);
        }
        break;

      case 'game_started':
        _updateRoomState(RoomState.playing);
        _messageController.add(data);
        break;

      case 'opponent_disconnected':
      case 'disconnected':
        _connectedEndpointId = null;
        _connectionStateController.add('disconnected');
        _updateRoomState(RoomState.ended);
        _messageController.add({'type': 'opponent_disconnected'});
        break;

      case 'connection_failed':
        _connectionStateController.add('failed');
        break;

      default:
        // Forward all other messages (game messages)
        _messageController.add(data);
        break;
    }
  }

  /// Update room state and notify listeners
  void _updateRoomState(RoomState newState) {
    if (_currentRoomState != newState) {
      _currentRoomState = newState;
      _roomStateController.add(newState);
      debugPrint('🎮 [CombatBLE] Room state changed to: $newState');
    }
  }

  /// Request Bluetooth permissions (matching chat_bluetooth pattern)
  Future<bool> requestPermissions() async {
    debugPrint('📡 [CombatBLE] Initializing...');
    final granted = await repository.requestPermissions();
    if (granted) {
      debugPrint('✅ [CombatBLE] Permissions granted');
    } else {
      debugPrint('❌ [CombatBLE] Permissions denied');
    }
    return granted;
  }

  /// Start advertising as host (matching CombatNearbyService.startAdvertising)
  Future<void> startAdvertising(String hostName, String hostId) async {
    _isHost = true;
    _currentUserName = hostName;
    _isReady = false;
    _opponentReady = false;

    final roomCode = RoomCodeGenerator.generate();
    await repository.startAdvertising(roomCode, hostName);

    _updateRoomState(RoomState.waiting);
    debugPrint(
        '📢 [CombatBLE] Advertising as: $hostName with room code: $roomCode');
  }

  /// Start discovery as guest (matching CombatNearbyService.startDiscovery)
  Future<void> startDiscovery(String guestName, String guestId) async {
    _isHost = false;
    _currentUserName = guestName;
    _isReady = false;
    _opponentReady = false;

    await repository.startDiscovery(guestName);

    _updateRoomState(RoomState.waiting);
    debugPrint('🔍 [CombatBLE] Discovery started as: $guestName');
  }

  /// Create a new room (Host) - alternative method
  Future<String> createRoom(String userName) async {
    _isHost = true;
    _currentUserName = userName;
    _isReady = false;
    _opponentReady = false;

    final roomCode = RoomCodeGenerator.generate();
    await repository.startAdvertising(roomCode, userName);

    _updateRoomState(RoomState.waiting);
    return roomCode;
  }

  /// Start scanning for rooms (Guest) - alternative method
  Future<void> startScanning(String userName) async {
    _isHost = false;
    _currentUserName = userName;
    await repository.startDiscovery(userName);
  }

  /// Request connection to discovered endpoint (guest initiates)
  Future<void> requestConnection(String endpointId) async {
    debugPrint('🤝 [CombatBLE] Requesting connection to: $endpointId');
    _connectedEndpointId = endpointId;
    await repository.requestConnection(endpointId, _currentUserName!);
  }

  /// Connect to a device (alternative method)
  Future<void> connectToDevice({
    required String endpointId,
    required String roomCode,
    required String userName,
  }) async {
    _currentUserName = userName;
    _connectedEndpointId = endpointId; // Set immediately for guest
    debugPrint('🤝 [CombatBLE] Guest connecting to: $endpointId');
    await repository.requestConnection(endpointId, userName);
  }

  /// Accept incoming connection (Host)
  Future<void> acceptConnection(String endpointId, [String? guestName]) async {
    _connectedEndpointId = endpointId;
    await repository.acceptConnection(endpointId);
    _updateRoomState(RoomState.guestJoined);
    debugPrint('✅ [CombatBLE] Connection accepted from: $endpointId');
  }

  /// Reject incoming connection (Host)
  Future<void> rejectConnection(String endpointId) async {
    await repository.rejectConnection(endpointId);
    debugPrint('❌ [CombatBLE] Connection rejected: $endpointId');
  }

  /// Set player ready state
  Future<void> setPlayerReady() async {
    _isReady = true;
    await sendMessage({'type': 'player_ready'});

    // Check if both ready
    if (_opponentReady) {
      debugPrint('🎮 [CombatBLE] Both players ready!');
      _updateRoomState(RoomState.bothReady);
    }
  }

  /// Start game (host only)
  Future<void> startGame() async {
    if (!_isHost) {
      debugPrint('⚠️ [CombatBLE] Only host can start game');
      return;
    }

    await sendMessage({'type': 'game_started'});
    _updateRoomState(RoomState.playing);
  }

  /// Send message to connected device
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_connectedEndpointId == null) {
      debugPrint('⚠️ [CombatBLE] Cannot send message: not connected');
      return;
    }

    // Add metadata
    message['senderId'] = playerId;
    message['timestamp'] = DateTime.now().millisecondsSinceEpoch;

    await repository.sendData(message);
    debugPrint('📤 [CombatBLE] Message sent: ${message['type']}');
  }

  /// Stop advertising
  Future<void> stopAdvertising() async {
    await repository.stopAdvertising();
    debugPrint('🛑 [CombatBLE] Advertising stopped');
  }

  /// Stop discovery
  Future<void> stopDiscovery() async {
    await repository.stopDiscovery();
    debugPrint('🛑 [CombatBLE] Discovery stopped');
  }

  /// Reset service state (call when leaving room)
  Future<void> reset() async {
    debugPrint('🔄 [CombatBLE] Resetting service state...');

    // Reset all state variables
    _isHost = false;
    _currentUserName = null;
    _connectedEndpointId = null;
    _isReady = false;
    _opponentReady = false;
    _currentRoomState = RoomState.waiting;

    // Stop any active connections
    await stopAdvertising();
    await stopDiscovery();
    if (_connectedEndpointId != null) {
      await repository.disconnect();
    }

    debugPrint('✅ [CombatBLE] Service reset complete');
  }

  /// Stop scanning (alias for stopDiscovery)
  Future<void> stopScanning() async {
    await repository.stopDiscovery();
    await repository.stopAdvertising();
  }

  /// Disconnect from current connection
  Future<void> disconnect() async {
    if (_connectedEndpointId != null) {
      await sendMessage({'type': 'opponent_left'});
      await repository.disconnect();
      _connectedEndpointId = null;
      _updateRoomState(RoomState.ended);
      debugPrint('🔌 [CombatBLE] Disconnected');
    }
  }

  /// Send data to connected device
  Future<void> sendData(Map<String, dynamic> data) async {
    await sendMessage(data);
  }

  /// Send a combat game message (convenience method for CombatBloc)
  Future<void> sendGameData(Map<String, dynamic> gameData) async {
    await sendMessage(gameData);
  }

  /// Notify partner of disconnect (convenience method for CombatBloc)
  Future<void> notifyDisconnect() async {
    debugPrint('📤 BLE: Sending disconnect notification to partner...');
    await sendMessage({
      'type': 'opponent_disconnected',
      'timestamp': DateTime.now().toIso8601String(),
    });
    debugPrint('✅ BLE: Disconnect notification sent');
  }

  /// Cleanup
  Future<void> cleanup() async {
    await disconnect();
    await stopScanning();
  }

  /// Dispose and cleanup resources
  void dispose() {
    _incomingDataSubscription?.cancel();
    _devicesSubscription?.cancel();
    _connectionRequestSubscription?.cancel();
    _messageController.close();
    _roomStateController.close();
    _endpointsController.close();
    _connectionStateController.close();
  }
}
