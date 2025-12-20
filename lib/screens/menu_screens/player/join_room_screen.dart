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
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/services/combat_nearby_service.dart';

/// Guest room screen for discovering and joining Nearby Connections combat rooms
class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final CombatNearbyService _nearbyService = CombatNearbyService();

  String? _myPlayerId;
  String? _myEndpointName;
  RoomState _roomState = RoomState.waiting;
  bool _isInitialized = false;
  bool _isDiscovering = false;
  bool _myPlayerReady = false;
  Map<String, String> _discoveredEndpoints = {}; // endpointId -> endpointName
  StreamSubscription? _roomStateSubscription;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _endpointsSubscription;
  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _myPlayerId = _generatePlayerId();
    _myEndpointName =
        'Guest-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    // Listen to room state
    _roomStateSubscription = _nearbyService.roomStateStream.listen((state) {
      if (!mounted) return;

      setState(() {
        _roomState = state;
      });

      // Handle state transitions
      if (state == RoomState.bothReady) {
        print('🚀 [Guest] Both players ready!');
        _showBothReadyDialog();
      } else if (state == RoomState.playing) {
        _handleGameStarted();
      }
    });

    // Listen to discovered endpoints
    _endpointsSubscription = _nearbyService.endpointsStream.listen((endpoints) {
      if (!mounted) return;

      setState(() {
        _discoveredEndpoints = endpoints;
      });
      print('📡 [Guest] Discovered ${endpoints.length} endpoints');
    });

    // Listen to connection state
    _connectionStateSubscription =
        _nearbyService.connectionStateStream.listen((state) {
      print('🔗 [Guest] Connection state: $state');
    });

    // Listen to incoming messages
    _messageSubscription = _nearbyService.messageStream.listen((message) {
      _handleIncomingMessage(message);
    });

    // CombatGameStarted will reset state when game starts

    // Initialize on next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeNearby();
    });
  }

  Future<void> _initializeNearby() async {
    try {
      print('📡 [Guest] Initializing Nearby Connections...');

      final initialized = await _nearbyService.initialize();
      if (!initialized) {
        _showError(
            'Failed to initialize Nearby Connections. Please grant location permissions.');
        return;
      }

      setState(() {
        _isInitialized = true;
      });

      await _startDiscovery();
    } catch (e) {
      print('❌ [Guest] Nearby initialization failed: $e');
      _showError('Failed to initialize: $e');
    }
  }

  @override
  void dispose() {
    _roomStateSubscription?.cancel();
    _endpointsSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _messageSubscription?.cancel();

    if (_roomState != RoomState.playing && _roomState != RoomState.ended) {
      _nearbyService.stopDiscovery();
      _nearbyService.disconnect();
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

  Future<void> _startDiscovery() async {
    if (!_isInitialized) {
      _showError('Nearby Connections is not initialized');
      return;
    }

    try {
      setState(() {
        _isDiscovering = true;
      });

      await _nearbyService.startDiscovery(_myEndpointName!, _myPlayerId!);
      print('✅ [Guest] Discovery started');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🔍 Searching for hosts...'),
            backgroundColor: Colors.blue,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isDiscovering = false;
      });
      _showError('Failed to start discovery: $e');
    }
  }

  Future<void> _connectToEndpoint(
      String endpointId, String endpointName) async {
    try {
      print('🤝 [Guest] Connecting to: $endpointName ($endpointId)');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Connecting to $endpointName...'),
          backgroundColor: Colors.blue,
        ),
      );

      await _nearbyService.requestConnection(endpointId);
    } catch (e) {
      _showError('Failed to connect: $e');
    }
  }

  Future<void> _setReady() async {
    try {
      setState(() {
        _myPlayerReady = true;
      });

      await _nearbyService.setPlayerReady();
      print('✅ Guest marked as ready');
    } catch (e) {
      setState(() {
        _myPlayerReady = false;
      });
      _showError('Failed to set ready: $e');
    }
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
              Text('Host Ready!'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✅ The host is ready!',
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

  void _showBothReadyDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

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
                'Waiting for host to select difficulty...',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    });
  }

  void _handleGameStarted() {
    print('🎮 [Guest] Game started - waiting for difficulty');
    if (mounted) {
      setState(() {
        // UI will show "Waiting for host to select difficulty"
      });
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
        return _discoveredEndpoints.isEmpty
            ? 'Searching for hosts...'
            : 'Select a host to connect';
      case RoomState.guestJoined:
        return 'Connected! Press Ready when you\'re prepared to play.';
      case RoomState.bothReady:
        return '✅ Both players ready! Waiting for host to start...';
      case RoomState.playing:
        return '⏳ Waiting for host to select difficulty...';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CombatBloc, CombatState>(
      listener: (context, combatState) {
        // Guest auto-navigates when difficulty is received and game is starting
        // Status will be 'starting' after receiving difficulty from host
        // It won't reach 'playing' until receiving the first turn_start message
        if (combatState.difficultyModel != null &&
            (combatState.combatStatus == CombatStatus.starting ||
                combatState.combatStatus == CombatStatus.playing)) {
          print(
              '🎮 [Guest] Navigating to play screen with difficulty: ${combatState.difficultyModel?.difficulty}');

          // Pop the JoinRoomScreen first
          Navigator.of(context).pop();

          // Navigate to play screen
          context.read<PlayerNavCubit>().showPlay(playMode: PlayMode.combat);
        }
      },
      child: Scaffold(
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
                          await _nearbyService.stopDiscovery();
                          await _nearbyService.disconnect();
                          if (mounted) {
                            context.read<MenuBloc>().add(ShowMenu());
                          }
                        },
                      ),
                      Expanded(
                        child: Text(
                          'Join Room',
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
                    child: Column(
                      children: [
                        // Discovery Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_isDiscovering)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            const SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                _getRoomStateText(),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Discovered Hosts List
                        if (_roomState == RoomState.waiting &&
                            _discoveredEndpoints.isNotEmpty)
                          Expanded(
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.radar,
                                            color: Colors.blue),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Available Hosts (${_discoveredEndpoints.length})',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Divider(height: 1),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _discoveredEndpoints.length,
                                      itemBuilder: (context, index) {
                                        final entry = _discoveredEndpoints
                                            .entries
                                            .elementAt(index);
                                        final endpointId = entry.key;
                                        final endpointName = entry.value;

                                        return ListTile(
                                          leading: const CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                            ),
                                          ),
                                          title: Text(
                                            endpointName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'Tap to connect',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 12,
                                            ),
                                          ),
                                          trailing: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 16,
                                          ),
                                          onTap: () => _connectToEndpoint(
                                              endpointId, endpointName),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Empty State
                        if (_roomState == RoomState.waiting &&
                            _discoveredEndpoints.isEmpty)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    'No hosts found nearby',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Make sure a friend is hosting\nand both devices are close together',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey[500],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        // Connected State
                        if (_roomState != RoomState.waiting)
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 80,
                                    color: _roomState == RoomState.bothReady
                                        ? Colors.green
                                        : Colors.blue,
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    _getRoomStateText(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: _roomState == RoomState.bothReady
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (_roomState == RoomState.guestJoined ||
                                      _roomState == RoomState.bothReady) ...[
                                    const SizedBox(height: 30),
                                    if (!_myPlayerReady)
                                      ElevatedButton.icon(
                                        onPressed: _setReady,
                                        icon: const FaIcon(
                                            FontAwesomeIcons.check),
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
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          border: Border.all(
                                              color: Colors.green, width: 2),
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
                                ],
                              ),
                            ),
                          ),

                        const SizedBox(height: 20),
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
                                      : _isDiscovering
                                          ? Colors.orange
                                          : Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _nearbyService.isConnected
                                      ? 'Connected via Nearby'
                                      : _isDiscovering
                                          ? 'Discovering...'
                                          : 'Not discovering',
                                  style: TextStyle(
                                    color: _nearbyService.isConnected
                                        ? Colors.green
                                        : _isDiscovering
                                            ? Colors.orange
                                            : Colors.grey,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
