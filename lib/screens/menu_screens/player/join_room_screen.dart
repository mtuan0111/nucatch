import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/combat_dialogs.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/helpers/ui_constants.dart';
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
        await CombatDialogs.showBothReadyDialog(context);
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
        _showError(lang(context).failedToInitializeNearby);
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
        CombatDialogs.showOpponentReadyDialog(
          context,
          title: lang(context).hostReady,
          message: lang(context).theHostIsReady,
        );
      }
    }
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _startDiscovery() async {
    if (!_isInitialized) {
      _showError(lang(context).nearbyNotInitialized);
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
          SnackBar(
            content: Text(lang(context).searchingForHosts),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 2),
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
          content: Text(lang(context).connectingToHost(endpointName)),
          backgroundColor: Theme.of(context).colorScheme.primary,
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
      _showError(lang(context).failedToSetReady(e.toString()));
    }
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
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  String _getRoomStateText() {
    switch (_roomState) {
      case RoomState.waiting:
        return _discoveredEndpoints.isEmpty
            ? lang(context).searchingForHosts
            : lang(context).selectHostToConnect;
      case RoomState.guestJoined:
        return lang(context).pressReadyWhenPrepared;
      case RoomState.bothReady:
        return lang(context).bothPlayersReadyStatus;
      case RoomState.playing:
        return lang(context).waitingForHostToSelectDifficulty;
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
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  shadowColor: Colors.transparent,
                  backgroundColor: Colors.transparent,
                  pinned: true,
                  stretch: true,
                  flexibleSpace: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
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
                              lang(context).joinRoom,
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
                      await _nearbyService.stopDiscovery();
                      await _nearbyService.disconnect();
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
                          // Icon
                          Icon(
                            _roomState == RoomState.waiting
                                ? Icons.radar
                                : _roomState == RoomState.bothReady
                                    ? Icons.check_circle
                                    : Icons.wifi_tethering,
                            size: kContainerSizeS,
                            color: _roomState == RoomState.bothReady
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: kSpaceXL),

                          // Discovery/Connection Status
                          if (_isDiscovering && _roomState == RoomState.waiting)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: kFontSizeXL,
                                  height: kFontSizeXL,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                                const SizedBox(width: kSpaceM),
                                Text(
                                  lang(context).searchingForHosts,
                                  style:
                                      LayoutConfig(context).titleSectionStyle(),
                                ),
                              ],
                            )
                          else
                            Text(
                              _getRoomStateText(),
                              style: LayoutConfig(context).subtitleStyle(),
                              textAlign: TextAlign.center,
                            ),
                          const SizedBox(height: kSpace2XL),

                          // Discovered Hosts List
                          if (_roomState == RoomState.waiting &&
                              _discoveredEndpoints.isNotEmpty)
                            SizedBox(
                              height: 400,
                              child: Card(
                                margin:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          Icon(Icons.radar,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary),
                                          const SizedBox(width: kSpaceSM),
                                          Text(
                                            lang(context).availableHosts(
                                                _discoveredEndpoints.length),
                                            style: LayoutConfig(context)
                                                .largeBoldStyle(),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),
                                    Flexible(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: _discoveredEndpoints.length,
                                        itemBuilder: (context, index) {
                                          final entry = _discoveredEndpoints
                                              .entries
                                              .elementAt(index);
                                          final endpointId = entry.key;
                                          final endpointName = entry.value;

                                          return ListTile(
                                            leading: CircleAvatar(
                                              backgroundColor: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
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
                                              lang(context).tapToConnect,
                                              style: LayoutConfig(context)
                                                  .hintTextStyle(),
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: kIconSizeS,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.search_off,
                                    size: kContainerSizeS,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant
                                        .withOpacity(0.4),
                                  ),
                                  const SizedBox(height: kSpaceXL),
                                  Text(
                                    lang(context).noHostsFoundNearby,
                                    style: LayoutConfig(context).largeBoldStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: kSpaceM),
                                  Text(
                                    lang(context).makeSureFriendHosting,
                                    textAlign: TextAlign.center,
                                    style: LayoutConfig(context)
                                        .secondaryTextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant
                                          .withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          // Ready Status Indicators (when connected)
                          if (_roomState == RoomState.guestJoined ||
                              _roomState == RoomState.bothReady) ...[
                            const SizedBox(height: kSpace2XL),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _buildReadyIndicator(
                                  label: lang(context).you,
                                  isReady: _myPlayerReady,
                                ),
                                const SizedBox(width: kSpace4XL),
                                _buildReadyIndicator(
                                  label: lang(context).opponent,
                                  isReady: _hostPlayerReady,
                                ),
                              ],
                            ),
                            const SizedBox(height: kSpace2XL),
                            if (!_myPlayerReady)
                              CustomElevatedButton(
                                onPressed: _setReady,
                                shapeAt: RoundedWithShapeAt.all,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const FaIcon(FontAwesomeIcons.check),
                                    const SizedBox(width: kSpaceS),
                                    Text(
                                      lang(context).ready,
                                      style: LayoutConfig(context)
                                          .boldSubtitleStyle(),
                                    ),
                                  ],
                                ),
                              ),
                          ],

                          const SizedBox(height: kSpace3XL),
                          // Distance Warning
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kPaddingXL, vertical: kPaddingML),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadiusM),
                              border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .error
                                    .withOpacity(0.3),
                                width: kStrokeWidthThin,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: kFontSizeXL,
                                ),
                                const SizedBox(width: kSpaceML),
                                Expanded(
                                  child: Text(
                                    lang(context).distanceWarning,
                                    style: LayoutConfig(context)
                                        .secondaryTextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: kSpaceXL),
                          // Connection Status Indicator
                          Column(
                            children: [
                              const Divider(),
                              const SizedBox(height: kSpaceM),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.settings_input_antenna,
                                    color: _nearbyService.isConnected
                                        ? Theme.of(context).colorScheme.tertiary
                                        : _isDiscovering
                                            ? Theme.of(context)
                                                .colorScheme
                                                .error
                                            : Theme.of(context)
                                                .colorScheme
                                                .onSurfaceVariant,
                                    size: kFontSizeXL,
                                  ),
                                  const SizedBox(width: kSpaceM),
                                  Text(
                                    _nearbyService.isConnected
                                        ? lang(context).connectedViaNearby
                                        : _isDiscovering
                                            ? lang(context).discovering
                                            : lang(context).notDiscovering,
                                    style: LayoutConfig(context)
                                        .secondaryTextStyle(
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
          width: kContainerSizeS,
          height: kContainerSizeS,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isReady
                ? Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
                : Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.3),
            border: Border.all(
              color: isReady
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
              width: kStrokeWidthMedium,
            ),
          ),
          child: Icon(
            isReady ? Icons.check : Icons.hourglass_empty,
            size: kIconSizeL,
            color: isReady
                ? Theme.of(context).colorScheme.onTertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: kSpaceL),
        Text(
          label,
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: LayoutConfig(context).contentSectionStyle(
            color: isReady
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
