import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Service for managing combat room connections via Firestore
/// BLE is used only for proximity detection, Firestore handles all data exchange
class CombatRoomService {
  static final CombatRoomService _instance = CombatRoomService._internal();
  factory CombatRoomService() => _instance;
  CombatRoomService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _currentRoomCode;
  String? _playerId;
  bool _isHost = false;

  StreamSubscription? _roomSubscription;
  StreamSubscription? _messagesSubscription;

  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  final _roomStateController = StreamController<RoomState>.broadcast();

  Stream<Map<String, dynamic>> get messageStream => _messageController.stream;
  Stream<RoomState> get roomStateStream => _roomStateController.stream;

  String? get currentRoomCode => _currentRoomCode;
  String? get playerId => _playerId;
  bool get isHost => _isHost;

  /// Create a new combat room as host
  Future<String> createRoom(String roomCode, String hostId) async {
    _currentRoomCode = roomCode;
    _playerId = hostId;
    _isHost = true;

    debugPrint('🏠 [Room] Creating room: $roomCode');

    try {
      // Create room document
      await _firestore.collection('combat_rooms').doc(roomCode).set({
        'roomCode': roomCode,
        'hostId': hostId,
        'guestId': null,
        'status': 'waiting', // waiting, ready, playing, ended
        'hostReady': false,
        'guestReady': false,
        'createdAt': FieldValue.serverTimestamp(),
        'lastActivity': FieldValue.serverTimestamp(),
      });

      // Listen to room changes
      _subscribeToRoom(roomCode);

      debugPrint('✅ [Room] Room created successfully');
      return roomCode;
    } catch (e) {
      debugPrint('❌ [Room] Failed to create room: $e');
      rethrow;
    }
  }

  /// Join an existing combat room as guest
  Future<void> joinRoom(String roomCode, String guestId) async {
    _currentRoomCode = roomCode;
    _playerId = guestId;
    _isHost = false;

    debugPrint('🚪 [Room] Joining room: $roomCode');

    try {
      final roomRef = _firestore.collection('combat_rooms').doc(roomCode);
      final roomDoc = await roomRef.get();

      if (!roomDoc.exists) {
        throw Exception('Room $roomCode does not exist');
      }

      final roomData = roomDoc.data()!;

      if (roomData['guestId'] != null && roomData['guestId'] != guestId) {
        throw Exception('Room is already full');
      }

      // Join the room
      await roomRef.update({
        'guestId': guestId,
        'status': 'ready',
        'lastActivity': FieldValue.serverTimestamp(),
      });

      // Listen to room changes
      _subscribeToRoom(roomCode);

      debugPrint('✅ [Room] Joined room successfully');
    } catch (e) {
      debugPrint('❌ [Room] Failed to join room: $e');
      rethrow;
    }
  }

  /// Subscribe to room state changes
  void _subscribeToRoom(String roomCode) {
    _roomSubscription?.cancel();

    _roomSubscription = _firestore
        .collection('combat_rooms')
        .doc(roomCode)
        .snapshots()
        .listen((snapshot) {
      if (!snapshot.exists) {
        _roomStateController.add(RoomState.deleted);
        return;
      }

      final data = snapshot.data()!;
      final status = data['status'] as String;
      final hostReady = data['hostReady'] as bool? ?? false;
      final guestReady = data['guestReady'] as bool? ?? false;
      final guestId = data['guestId'] as String?;

      // Determine room state
      if (status == 'ended') {
        _roomStateController.add(RoomState.ended);
      } else if (status == 'playing') {
        _roomStateController.add(RoomState.playing);
      } else if (guestId != null && hostReady && guestReady) {
        _roomStateController.add(RoomState.bothReady);
      } else if (guestId != null) {
        _roomStateController.add(RoomState.guestJoined);
      } else {
        _roomStateController.add(RoomState.waiting);
      }
    });

    // Subscribe to messages
    _subscribeToMessages(roomCode);
  }

  /// Subscribe to room messages
  void _subscribeToMessages(String roomCode) {
    _messagesSubscription?.cancel();

    _messagesSubscription = _firestore
        .collection('combat_rooms')
        .doc(roomCode)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          final data = change.doc.data()!;

          // Only process messages not sent by this player
          if (data['senderId'] != _playerId) {
            _messageController.add(data);
          }
        }
      }
    });
  }

  /// Send a message to the room
  Future<void> sendMessage(Map<String, dynamic> message) async {
    if (_currentRoomCode == null || _playerId == null) {
      throw Exception('Not in a room');
    }

    try {
      await _firestore
          .collection('combat_rooms')
          .doc(_currentRoomCode!)
          .collection('messages')
          .add({
        ...message,
        'senderId': _playerId,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update room activity
      await _firestore
          .collection('combat_rooms')
          .doc(_currentRoomCode!)
          .update({
        'lastActivity': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint('❌ [Room] Failed to send message: $e');
      rethrow;
    }
  }

  /// Mark player as ready
  Future<void> setPlayerReady() async {
    if (_currentRoomCode == null) {
      throw Exception('Not in a room');
    }

    try {
      await _firestore
          .collection('combat_rooms')
          .doc(_currentRoomCode!)
          .update({
        _isHost ? 'hostReady' : 'guestReady': true,
        'lastActivity': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ [Room] Player marked as ready');
    } catch (e) {
      debugPrint('❌ [Room] Failed to set ready state: $e');
      rethrow;
    }
  }

  /// Start the game (host only)
  Future<void> startGame() async {
    if (_currentRoomCode == null || !_isHost) {
      throw Exception('Only host can start the game');
    }

    try {
      await _firestore
          .collection('combat_rooms')
          .doc(_currentRoomCode!)
          .update({
        'status': 'playing',
        'gameStartedAt': FieldValue.serverTimestamp(),
        'lastActivity': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ [Room] Game started');
    } catch (e) {
      debugPrint('❌ [Room] Failed to start game: $e');
      rethrow;
    }
  }

  /// End the game
  Future<void> endGame(Map<String, dynamic> results) async {
    if (_currentRoomCode == null) {
      throw Exception('Not in a room');
    }

    try {
      await _firestore
          .collection('combat_rooms')
          .doc(_currentRoomCode!)
          .update({
        'status': 'ended',
        'results': results,
        'endedAt': FieldValue.serverTimestamp(),
        'lastActivity': FieldValue.serverTimestamp(),
      });

      debugPrint('✅ [Room] Game ended');
    } catch (e) {
      debugPrint('❌ [Room] Failed to end game: $e');
      rethrow;
    }
  }

  /// Leave the current room
  Future<void> leaveRoom() async {
    if (_currentRoomCode == null) {
      return;
    }

    debugPrint('👋 [Room] Leaving room: $_currentRoomCode');

    try {
      final roomRef =
          _firestore.collection('combat_rooms').doc(_currentRoomCode!);

      if (_isHost) {
        // Host leaving - delete the room
        await roomRef.delete();
      } else {
        // Guest leaving - remove guest from room
        await roomRef.update({
          'guestId': null,
          'guestReady': false,
          'status': 'waiting',
          'lastActivity': FieldValue.serverTimestamp(),
        });
      }

      // Cancel subscriptions
      _roomSubscription?.cancel();
      _messagesSubscription?.cancel();

      _currentRoomCode = null;
      _playerId = null;
      _isHost = false;

      debugPrint('✅ [Room] Left room successfully');
    } catch (e) {
      debugPrint('❌ [Room] Failed to leave room: $e');
    }
  }

  /// Clean up old rooms (call periodically)
  Future<void> cleanupOldRooms() async {
    try {
      final cutoffTime = DateTime.now().subtract(const Duration(hours: 1));
      final oldRooms = await _firestore
          .collection('combat_rooms')
          .where('lastActivity', isLessThan: Timestamp.fromDate(cutoffTime))
          .get();

      for (var doc in oldRooms.docs) {
        await doc.reference.delete();
      }

      if (oldRooms.docs.isNotEmpty) {
        debugPrint('🧹 [Room] Cleaned up ${oldRooms.docs.length} old rooms');
      }
    } catch (e) {
      debugPrint('❌ [Room] Failed to cleanup old rooms: $e');
    }
  }

  /// Dispose resources
  void dispose() {
    _roomSubscription?.cancel();
    _messagesSubscription?.cancel();
    _messageController.close();
    _roomStateController.close();
  }
}

/// Room state enum
enum RoomState {
  waiting, // Waiting for guest to join
  guestJoined, // Guest has joined but not ready
  bothReady, // Both players are ready
  playing, // Game is in progress
  ended, // Game has ended
  deleted, // Room was deleted
}
