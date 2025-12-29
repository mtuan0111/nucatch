import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
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
  bool _hostPlayerReady = false;
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
    _roomStateSubscription =
        _nearbyService.roomStateStream.listen((state) async {
      if (!mounted) return;

      setState(() {
        _roomState = state;
      });

      // Handle state transitions
      if (state == RoomState.bothReady) {
        print('🚀 [Guest] Both players ready!');
        await _showBothReadyDialog();
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

    if (messageType == 'player_ready') {
      setState(() {
        _hostPlayerReady = true;
      });
      if (!_myPlayerReady) {
        _showOpponentReadyDialog();
      }
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

      dynamic dialogObject = showDialog(
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
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '✅ The host is ready!',
                style: LayoutConfig(context).boldSubtitleStyle(),
              ),
              const SizedBox(height: 8),
              const Text(
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
          Navigator.of(dialogObject, rootNavigator: true).pop();
        }
      });
    });
  }

  Future<void> _showBothReadyDialog() async {
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
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
              style: LayoutConfig(context).largeBoldStyle(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Waiting for host to select difficulty...',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );

    await Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pop();
      }
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
            (combatState.combatStatus == CombatStatus.playing ||
                combatState.combatStatus == CombatStatus.intro)) {
          print(
              '🎮 [Guest] Navigating to play screen with difficulty: ${combatState.difficultyModel?.difficulty}');

          // Navigate to play screen using CombatNavCubit
          context.read<CombatNavCubit>().showPlaying();
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
                                          style: LayoutConfig(context)
                                              .largeBoldStyle(),
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
                                          leading: CircleAvatar(
                                            backgroundColor: Colors.blue,
                                            child: Icon(
                                              Icons.person,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onPrimary,
                                            ),
                                          ),
                                          title: Text(
                                            endpointName,
                                            style: LayoutConfig(context)
                                                .boldSubtitleStyle(),
                                          ),
                                          subtitle: Text(
                                            'Tap to connect',
                                            style: LayoutConfig(context)
                                                .hintTextStyle(),
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
                                    style: LayoutConfig(context).largeBoldStyle(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Make sure a friend is hosting\nand both devices are close together',
                                    textAlign: TextAlign.center,
                                    style: LayoutConfig(context)
                                        .secondaryTextStyle(
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
                                    style: LayoutConfig(context).largeBoldStyle(
                                      color: _roomState == RoomState.bothReady
                                          ? Colors.green
                                          : Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if (_roomState == RoomState.guestJoined ||
                                      _roomState == RoomState.bothReady) ...[
                                    const SizedBox(height: 30),
                                    // Ready status indicators
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _buildReadyIndicator(
                                          label: lang(context).you,
                                          isReady: _myPlayerReady,
                                        ),
                                        const SizedBox(width: 48),
                                        _buildReadyIndicator(
                                          label: lang(context).opponent,
                                          isReady: _hostPlayerReady,
                                        ),
                                      ],
                                    ),
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
                                  style:
                                      LayoutConfig(context).secondaryTextStyle(
                                    color: _nearbyService.isConnected
                                        ? Colors.green
                                        : _isDiscovering
                                            ? Colors.orange
                                            : Colors.grey,
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

  Widget _buildReadyIndicator({
    required String label,
    required bool isReady,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady ? Colors.green : Colors.grey.withOpacity(0.3),
            border: Border.all(
              color: isReady ? Colors.green : Colors.grey,
              width: 3,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: 40,
            color: isReady ? Colors.white : Colors.grey,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          label,
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: LayoutConfig(context).contentSectionStyle(
            color: isReady ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
