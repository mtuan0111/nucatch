import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/helpers/combat_dialogs.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
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
  bool _guestPlayerReady = false;
  StreamSubscription? _roomStateSubscription;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionStateSubscription;

  @override
  void initState() {
    super.initState();
    _myPlayerId = _generatePlayerId();
    _myEndpointName =
        'Nuca-${Random().nextInt(9999).toString().padLeft(4, '0')}';

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
        await CombatDialogs.showBothReadyDialog(context);
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
        _showError(lang(context).failedToInitializeNearby);
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

    if (messageType == 'player_ready') {
      setState(() {
        _guestPlayerReady = true;
      });
      if (!_myPlayerReady) {
        CombatDialogs.showOpponentReadyDialog(
          context,
          title: lang(context).opponentReady,
          message: lang(context).yourOpponentIsReady,
        );
      }
    }
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _startAdvertising() async {
    if (!_isInitialized) {
      _showError(lang(context).nearbyNotInitialized);
      return;
    }

    try {
      await _nearbyService.startAdvertising(_myEndpointName!, _myPlayerId!);
      print('✅ [Host] Advertising started as: $_myEndpointName');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang(context).advertisingRoomWaiting),
            backgroundColor: Colors.blue,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      _showError(lang(context).failedToStartAdvertising(e.toString()));
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
      _showError(lang(context).failedToSetReady(e.toString()));
    }
  }

  void _showGuestJoinedNotification() {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(lang(context).opponentJoinedReady),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _startGameAndNavigate() async {
    try {
      print('🎮 [Host] Starting game with Easy difficulty...');

      await _nearbyService.startGame();

      if (mounted) {
        print(
            '📤 [Host] Initializing combat game and navigating to play screen');

        // Initialize combat game with Easy difficulty (default)
        context.read<CombatNavCubit>().showSetDifficulty();
      }
    } catch (e) {
      print('❌ [Host] Failed to start game: $e');
      _showError(lang(context).failedToStartGame(e.toString()));
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
        return lang(context).advertisingRoomStatus;
      case RoomState.guestJoined:
        return lang(context).opponentConnectedStatus;
      case RoomState.bothReady:
        return lang(context).bothPlayersReadyStatus;
      case RoomState.playing:
        return lang(context).settingUpDifficulty;
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shadowColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                pinned: true,
                stretch: true,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final double appBarHeight = constraints.biggest.height;
                    final bool isCollapsed = appBarHeight <=
                        kToolbarHeight + MediaQuery.of(context).padding.top;

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: isCollapsed
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        titlePadding: EdgeInsets.zero,
                        title: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            lang(context).hostRoom,
                            textAlign: TextAlign.center,
                            style: LayoutConfig(context).displaySmallStyle(
                              isActiveShadow: true,
                              isItalic: true,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                leading: IconButton(
                  onPressed: () async {
                    await _nearbyService.stopAdvertising();
                    if (mounted) {
                      context.read<CombatNavCubit>().showSetup();
                    }
                  },
                  icon: const Icon(FontAwesomeIcons.chevronLeft),
                ),
                expandedHeight: 100,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverToBoxAdapter(
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
                          lang(context).advertisingAs,
                          style: LayoutConfig(context).titleSectionStyle(),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _myEndpointName ?? 'Unknown',
                            style: LayoutConfig(context).displaySmallStyle(
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          _getRoomStateText(),
                          style: LayoutConfig(context).subtitleStyle(),
                          textAlign: TextAlign.center,
                        ),

                        if (_roomState == RoomState.guestJoined ||
                            _roomState == RoomState.bothReady) ...[
                          const SizedBox(height: 30),
                          // Ready status indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildReadyIndicator(
                                label: lang(context).you,
                                isReady: _myPlayerReady,
                              ),
                              const SizedBox(width: 48),
                              _buildReadyIndicator(
                                label: lang(context).opponent,
                                isReady: _guestPlayerReady,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          if (!_myPlayerReady)
                            CustomElevatedButton(
                              onPressed: _setReady,
                              shapeAt: RoundedWithShapeAt.all,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const FaIcon(FontAwesomeIcons.check),
                                  const SizedBox(width: 8),
                                  Text(
                                    lang(context).ready,
                                    style: LayoutConfig(context)
                                        .boldSubtitleStyle(),
                                  ),
                                ],
                              ),
                            ),
                        ],
                        const SizedBox(height: 40),
                        // Distance Warning
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.orange.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline,
                                color: Colors.orange,
                                size: 20,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  lang(context).distanceWarning,
                                  style:
                                      LayoutConfig(context).secondaryTextStyle(
                                    color: Colors.orange,
                                  ),
                                ),
                              ),
                            ],
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
                                      : Colors.orange,
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  _nearbyService.isConnected
                                      ? lang(context).connectedViaNearby
                                      : lang(context).advertising,
                                  style:
                                      LayoutConfig(context).secondaryTextStyle(
                                    color: _nearbyService.isConnected
                                        ? Colors.green
                                        : Colors.orange,
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
