import 'dart:async';
import 'dart:convert';
import 'package:nucatch/services/enhanced_bluetooth_service.dart';

/// Service for managing combat room connections via pure BLE (no internet required)
/// Uses EnhancedBluetoothService for reliable cross-platform BLE communication
class CombatBLEService {
  static final CombatBLEService _instance = CombatBLEService._internal();
  factory CombatBLEService() => _instance;
  CombatBLEService._internal();

  final EnhancedBluetoothService _bleService = EnhancedBluetoothService();

  String? _currentRoomCode;
  String? _playerId;
  bool _isHost = false;
  bool _isReady = false;
  bool _opponentReady = false;
  String? _gameStatus; // 'waiting', 'ready', 'playing', 'ended'

  StreamSubscription? _bleMessageSubscription;
  StreamSubscription? _bleConnectionSubscription;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _roomStateController = StreamController<RoomState>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<RoomState> get roomStateStream => _roomStateController.stream;

  String? get currentRoomCode => _currentRoomCode;
  String? get playerId => _playerId;
  bool get isHost => _isHost;
  
  /// Check if device is bonded (for authentication troubleshooting)
  Future<bool> isBonded() async {
    return await _bleService.isBonded();
  }

  /// Create a new combat room as host (advertise via BLE)
  Future<String> createRoom(String roomCode, String hostId) async {
    _currentRoomCode = roomCode;
    _playerId = hostId;
    _isHost = true;
    _isReady = false;
    _opponentReady = false;
    _gameStatus = 'waiting';

    print('🏠 [BLE Room] Creating room: $roomCode');

    try {
      // Start room as host
      await _bleService.startRoom(roomCode, hostId);

      // Listen to BLE messages
      _subscribeToBLE();

      // Listen to BLE connection state
      _bleConnectionSubscription =
          _bleService.connectionStateStream.listen((state) {
        print('🔗 [BLE Room] Connection state: $state');

        if (state.toString().contains('connected')) {
          print('✅ [BLE Room] Guest connected!');
          _roomStateController.add(RoomState.guestJoined);
        } else if (state.toString().contains('disconnected')) {
          print('❌ [BLE Room] Guest disconnected!');
          _handleDisconnection();
        }
      });

      _roomStateController.add(RoomState.waiting);

      print('✅ [BLE Room] Room created successfully (BLE advertising)');
      return roomCode;
    } catch (e) {
      print('❌ [BLE Room] Failed to create room: $e');
      rethrow;
    }
  }

  /// Join an existing combat room as guest (scan and connect via BLE)
  Future<void> joinRoom(String roomCode, String guestId) async {
    _currentRoomCode = roomCode;
    _playerId = guestId;
    _isHost = false;
    _isReady = false;
    _opponentReady = false;
    _gameStatus = 'waiting';

    print('🚪 [BLE Room] Joining room: $roomCode');

    try {
      // Join room as guest
      await _bleService.joinRoom(roomCode, guestId);

      // Listen to BLE messages
      _subscribeToBLE();

      // Listen to connection state
      _bleConnectionSubscription =
          _bleService.connectionStateStream.listen((state) {
        if (state.toString().contains('connected')) {
          print('✅ [BLE Room] Connected!');
          _roomStateController.add(RoomState.guestJoined);
          
          // Send join notification
          sendMessage({
            'type': 'guest_joined',
            'guestId': guestId,
          });
        } else if (state.toString().contains('disconnected')) {
          print('❌ [BLE Room] Disconnected!');
          _handleDisconnection();
        }
      });

      print('✅ [BLE Room] Scanning for host...');
    } catch (e) {
      print('❌ [BLE Room] Failed to join room: $e');
      rethrow;
    }
  }

  /// Subscribe to BLE messages
  void _subscribeToBLE() {
    _bleMessageSubscription?.cancel();

    _bleMessageSubscription = _bleService.messageStream.listen((message) {
      try {
        // Skip room code verification messages
        if (message.startsWith('ROOM_CODE:')) {
          return;
        }

        final data = jsonDecode(message) as Map<String, dynamic>;
        print('📨 [BLE Room] Received: ${data['type']}');

        // Handle ready state changes
        if (data['type'] == 'player_ready') {
          _opponentReady = true;
          if (_isReady && _opponentReady) {
            _gameStatus = 'ready';
            _roomStateController.add(RoomState.bothReady);
          }
        } else if (data['type'] == 'game_started') {
          _gameStatus = 'playing';
          _roomStateController.add(RoomState.playing);
        } else if (data['type'] == 'game_ended') {
          _gameStatus = 'ended';
          _roomStateController.add(RoomState.ended);
        }

        // Forward message to app
        _messageController.add(data);
      } catch (e) {
        print('❌ [BLE Room] Failed to parse message: $e');
      }
    });
  }

  /// Send a message via BLE
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_playerId == null) {
      throw Exception('Not in a room');
    }

    try {
      final messageWithSender = {
        ...message,
        'senderId': _playerId,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final jsonMessage = jsonEncode(messageWithSender);
      final success = await _bleService.sendMessage(jsonMessage);

      if (!success) {
        throw Exception('Failed to send BLE message');
      }

      print('📤 [BLE Room] Sent: ${message['type']}');
    } catch (e) {
      print('❌ [BLE Room] Failed to send message: $e');
      rethrow;
    }
  }

  /// Mark player as ready
  Future<void> setPlayerReady() async {
    if (_currentRoomCode == null) {
      throw Exception('Not in a room');
    }

    try {
      _isReady = true;

      await sendMessage({
        'type': 'player_ready',
      });

      // Check if both ready
      if (_isReady && _opponentReady) {
        _gameStatus = 'ready';
        _roomStateController.add(RoomState.bothReady);
      }

      print('✅ [BLE Room] Player marked as ready');
    } catch (e) {
      print('❌ [BLE Room] Failed to set ready state: $e');
      rethrow;
    }
  }

  /// Start the game (host only)
  Future<void> startGame() async {
    if (_currentRoomCode == null || !_isHost) {
      throw Exception('Only host can start the game');
    }

    try {
      _gameStatus = 'playing';

      await sendMessage({
        'type': 'game_started',
      });

      _roomStateController.add(RoomState.playing);

      print('✅ [BLE Room] Game started');
    } catch (e) {
      print('❌ [BLE Room] Failed to start game: $e');
      rethrow;
    }
  }

  /// End the game
  Future<void> endGame(Map<String, dynamic> results) async {
    if (_currentRoomCode == null) {
      throw Exception('Not in a room');
    }

    try {
      _gameStatus = 'ended';

      await sendMessage({
        'type': 'game_ended',
        'results': results,
      });

      _roomStateController.add(RoomState.ended);

      print('✅ [BLE Room] Game ended');
    } catch (e) {
      print('❌ [BLE Room] Failed to end game: $e');
      rethrow;
    }
  }

  /// Leave the current room
  Future<void> leaveRoom() async {
    if (_currentRoomCode == null) {
      return;
    }

    print('👋 [BLE Room] Leaving room: $_currentRoomCode');

    try {
      // Notify opponent
      try {
        await sendMessage({'type': 'opponent_left'});
      } catch (e) {
        // Ignore send errors when leaving
      }

      // Disconnect BLE
      await _bleService.disconnect();
      await _bleService.stopScanning();

      // Cancel subscriptions
      _bleMessageSubscription?.cancel();
      _bleConnectionSubscription?.cancel();

      _currentRoomCode = null;
      _playerId = null;
      _isHost = false;
      _isReady = false;
      _opponentReady = false;
      _gameStatus = null;

      print('✅ [BLE Room] Left room successfully');
    } catch (e) {
      print('❌ [BLE Room] Failed to leave room: $e');
    }
  }

  /// Handle disconnection
  void _handleDisconnection() {
    _opponentReady = false;

    if (_gameStatus == 'playing') {
      _messageController.add({
        'type': 'opponent_disconnected',
      });
    } else {
      _roomStateController.add(RoomState.waiting);
    }
  }

  /// Get BLE service (for permission/state checks in UI)
  EnhancedBluetoothService get bleService => _bleService;

  /// Dispose resources
  void dispose() {
    _bleMessageSubscription?.cancel();
    _bleConnectionSubscription?.cancel();
    _messageController.close();
    _roomStateController.close();
    _bleService.disconnect();
  }
}

/// Room state enum
enum RoomState {
  waiting, // Waiting for guest to join
  guestJoined, // Guest has joined but not ready
  bothReady, // Both players are ready
  playing, // Game is in progress
  ended, // Game has ended
  deleted, // Room was deleted (not applicable for BLE, but kept for compatibility)
}
