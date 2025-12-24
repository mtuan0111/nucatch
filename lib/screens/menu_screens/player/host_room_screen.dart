import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/services/combat_nearby_service.dart';

/// Host room screen for advertising via Nearby Connections
class HostRoomScreen extends StatefulWidget {
  const HostRoomScreen({super.key});

  @override
  State<HostRoomScreen> createState() => _HostRoomScreenState();
}

class _HostRoomScreenState extends State<HostRoomScreen> {
  final CombatNearbyService _nearbyService = CombatNearbyService();

  String? _myPlayerId;
  String? _myEndpointName;
  RoomState _roomState = RoomState.waiting;
  bool _isInitialized = false;
  bool _myPlayerReady = false;
  StreamSubscription? _roomStateSubscription;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _myPlayerId = _generatePlayerId();
    _myEndpointName =
        'Host-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    // Listen to incoming messages
    _messageSubscription = _nearbyService.messageStream.listen((message) {
      _handleIncomingMessage(message);
    });

    // Listen to room state
    _roomStateSubscription =
        _nearbyService.roomStateStream.listen((state) async {
      if (!mounted) return;

      setState(() {
        _roomState = state;
      });

      // Handle state transitions
      if (state == RoomState.bothReady) {
        print('🚀 [Host] Both players ready!');
        // Show dialog and wait for it to dismiss before navigating
        await _showBothReadyDialog();
        await _startGameAndNavigate();
      } else if (state == RoomState.guestJoined) {
        _showGuestJoinedNotification();
      }
    });

    // Listen to connection state
    _connectionStateSubscription =
        _nearbyService.connectionStateStream.listen((state) {
      print('🔗 [Host] Connection state: $state');
    });

    // CombatGameStarted will reset state when game starts

    // Initialize on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNearby();
    });
  }

  Future<void> _initializeNearby() async {
    try {
      print('📡 [Host] Initializing Nearby Connections...');

      final initialized = await _nearbyService.initialize();
      if (!initialized) {
        _showError(
            'Failed to initialize Nearby Connections. Please grant location permissions.');
        return;
      }

      setState(() {
        _isInitialized = true;
      });

      await _startAdvertising();
    } catch (e) {
      print('❌ [Host] Nearby initialization failed: $e');
      _showError('Failed to initialize: $e');
    }
  }

  @override
  void dispose() {
    _roomStateSubscription?.cancel();
    _messageSubscription?.cancel();
    _connectionStateSubscription?.cancel();

    if (_roomState != RoomState.playing && _roomState != RoomState.ended) {
      _nearbyService.stopAdvertising();
    }

    super.dispose();
  }

  void _handleIncomingMessage(Map<String, dynamic> message) {
    if (!mounted) return;

    final messageType = message['type'];

    if (messageType == 'player_ready' && !_myPlayerReady) {
      _showOpponentReadyDialog();
    }
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _startAdvertising() async {
    if (!_isInitialized) {
      _showError('Nearby Connections is not initialized');
      return;
    }

    try {
      await _nearbyService.startAdvertising(_myEndpointName!, _myPlayerId!);
      print('✅ [Host] Advertising started as: $_myEndpointName');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🎮 Advertising room! Waiting for opponent...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      _showError('Failed to start advertising: $e');
    }
  }

  Future<void> _setReady() async {
    try {
      setState(() {
        _myPlayerReady = true;
      });

      await _nearbyService.setPlayerReady();
      print('✅ Host marked as ready');
    } catch (e) {
      setState(() {
        _myPlayerReady = false;
      });
      _showError('Failed to set ready: $e');
    }
  }

  void _showGuestJoinedNotification() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Opponent joined! Press Ready when you\'re prepared.'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showOpponentReadyDialog() {
    bool dialogDismissed = false;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (dialogContext) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.blue, size: 32),
              SizedBox(width: 12),
              Text('Opponent Ready!'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✅ Your opponent is ready!',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Press Ready when you\'re prepared to start.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                dialogDismissed = true;
                Navigator.of(dialogContext).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Auto-dismiss after 3 seconds if not manually dismissed
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && !dialogDismissed) {
          dialogDismissed = true;
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    });
  }

  Future<void> _showBothReadyDialog() async {
    if (!mounted) return;

    // Show dialog without awaiting (non-blocking)
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 32),
            SizedBox(width: 12),
            Text('Both Players Ready!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '🚀 Game is starting...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Proceeding to difficulty selection...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    // Wait for 2 seconds to let user see the message
    await Future.delayed(const Duration(seconds: 2));

    // Dismiss the dialog
    if (mounted) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  Future<void> _startGameAndNavigate() async {
    try {
      print('🎮 [Host] Starting game with Easy difficulty...');

      await _nearbyService.startGame();

      if (mounted) {
        print(
            '📤 [Host] Initializing combat game and navigating to play screen');

        // Initialize combat game with Easy difficulty (default)
        final combatBloc = context.read<CombatBloc>();
        combatBloc.add(CombatGameStarted(
          difficulty: Difficulty.easy,
          isHost: true,
        ));

        // Send difficulty to guest (this will also start the first turn)
        combatBloc.add(CombatDifficultyChanged(difficulty: Difficulty.easy));

        // Pop the HostRoomScreen and navigate to play screen
        Navigator.of(context).pop();
        context.read<PlayerNavCubit>().showPlay(playMode: PlayMode.combat);
      }
    } catch (e) {
      print('❌ [Host] Failed to start game: $e');
      _showError('Failed to start game: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _getRoomStateText() {
    switch (_roomState) {
      case RoomState.waiting:
        return 'Advertising room...\nWaiting for opponent to discover and connect.';
      case RoomState.guestJoined:
        return 'Opponent connected!\nPress Ready when both players are ready.';
      case RoomState.bothReady:
        return '✅ Both players ready! Starting game...';
      case RoomState.playing:
        return '🎮 Setting up game difficulty...';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const FaIcon(FontAwesomeIcons.arrowLeft),
                      onPressed: () async {
                        await _nearbyService.stopAdvertising();
                        if (mounted) {
                          context.read<MenuBloc>().add(ShowMenu());
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        'Host Room',
                        style: LayoutConfig(context).titleSectionStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.wifi_tethering,
                          size: 80,
                          color: Colors.blue,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Advertising as:',
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimary
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _myEndpointName ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _getRoomStateText(),
                          style: TextStyle(
                            fontSize: 16,
                            color: _roomState == RoomState.bothReady
                                ? Colors.green
                                : Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        if (_roomState == RoomState.guestJoined ||
                            _roomState == RoomState.bothReady) ...[
                          const SizedBox(height: 30),
                          if (!_myPlayerReady)
                            ElevatedButton.icon(
                              onPressed: _setReady,
                              icon: const FaIcon(FontAwesomeIcons.check),
                              label: const Text('Ready'),
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 40, vertical: 15),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(25),
                                border:
                                    Border.all(color: Colors.green, width: 2),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(FontAwesomeIcons.check,
                                      color: Colors.green, size: 16),
                                  SizedBox(width: 8),
                                  Text(
                                    'Ready!',
                                    style: TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        const SizedBox(height: 40),
                        // Connection Status Indicator
                        Column(
                          children: [
                            const Divider(),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.settings_input_antenna,
                                  color: _nearbyService.isConnected
                                      ? Colors.green
                                      : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _nearbyService.isConnected
                                      ? 'Connected via Nearby'
                                      : 'Advertising...',
                                  style: TextStyle(
                                    color: _nearbyService.isConnected
                                        ? Colors.green
                                        : Colors.orange,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
