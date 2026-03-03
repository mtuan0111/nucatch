import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/combat/combat_nav_cubit.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/helpers/combat_dialogs.dart';
import 'package:skeleton_core/skeleton_core.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';

import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/services/combat_ble_service.dart';
import 'package:nucatch/widgets/custom_sliver_app_bar.dart';

/// Host room screen for advertising via BLE
class HostRoomScreen extends StatefulWidget {
  const HostRoomScreen({super.key});

  @override
  State<HostRoomScreen> createState() => _HostRoomScreenState();
}

class _HostRoomScreenState extends State<HostRoomScreen> {
  CombatBleService? _bleService;

  String? _myPlayerId;
  String? _myEndpointName;
  String? _roomCode;
  RoomState _roomState = RoomState.waiting;
  bool _isInitialized = false;
  bool _myPlayerReady = false;
  bool _guestPlayerReady = false;
  StreamSubscription? _roomStateSubscription;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionStateSubscription;
  StreamSubscription? _connectionRequestSubscription;

  @override
  void initState() {
    super.initState();

    _myPlayerId = _generatePlayerId();
    _myEndpointName =
        '$kBlePlayerNamePrefix-${Random().nextInt(9999).toString().padLeft(4, '0')}';

    // Initialize on next frame to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setupBleService();
    });
  }

  void _setupBleService() async {
    // Get BLE service from CombatBloc
    final combatBloc = context.read<CombatBloc>();
    _bleService = combatBloc.roomService;

    // Reset service state to ensure clean start
    await _bleService?.reset();

    // Listen to incoming messages
    _messageSubscription = _bleService!.messageStream.listen((message) {
      _handleIncomingMessage(message);
    });

    // Listen to room state
    _roomStateSubscription = _bleService!.roomStateStream.listen((state) async {
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
        _bleService!.connectionStateStream.listen((state) {
      print('🔗 [Host] Connection state: $state');
    });

    // Listen to connection requests (BLE specific)
    _connectionRequestSubscription =
        _bleService!.connectionRequestStream.listen((request) {
      _handleConnectionRequest(request);
    });

    _initializeBle();
  }

  Future<void> _initializeBle() async {
    try {
      print('📡 [Host] Requesting Bluetooth permissions...');

      final permissionsGranted = await _bleService!.requestPermissions();
      if (!permissionsGranted) {
        print(
            '⚠️ [Host] Bluetooth permissions denied, but continuing anyway...');
        // Note: On iOS, BLE advertising can still work even with "denied" permissions
        // The permission_handler package may report "denied" but iOS BLE stack allows it
      }

      setState(() {
        _isInitialized = true;
      });

      await _startAdvertising();
    } catch (e) {
      print('❌ [Host] BLE initialization failed: $e');
      _showError('Failed to initialize: $e');
    }
  }

  @override
  void dispose() {
    _roomStateSubscription?.cancel();
    _messageSubscription?.cancel();
    _connectionStateSubscription?.cancel();
    _connectionRequestSubscription?.cancel();

    if (_roomState != RoomState.playing && _roomState != RoomState.ended) {
      _bleService?.stopAdvertising();
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

  void _handleConnectionRequest(Map<String, dynamic> request) {
    if (!mounted) return;

    final endpointId = request['endpointId'] as String?;
    final endpointName = request['endpointName'] as String?;

    if (endpointId == null || endpointName == null) {
      print('⚠️ [Host] Invalid connection request');
      return;
    }

    print('🔔 [Host] Connection request from: $endpointName ($endpointId)');

    // Show dialog to accept/reject connection
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Connection Request'),
        content: Text(
          'Player $endpointName wants to join. Accept?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _bleService?.rejectConnection(endpointId);
              print('❌ [Host] Connection rejected');
            },
            child: const Text('Reject'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _bleService?.acceptConnection(endpointId, endpointName);
              print('✅ [Host] Connection accepted');
            },
            child: const Text('Accept'),
          ),
        ],
      ),
    );
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _startAdvertising() async {
    if (!_isInitialized) {
      _showError('Bluetooth not initialized');
      return;
    }

    try {
      await _bleService!.startAdvertising(_myEndpointName!, _myPlayerId!);
      _roomCode = _bleService!.currentRoomCode;

      print('✅ [Host] Advertising started as: $_myEndpointName');
      print('📱 [Host] Room code: $_roomCode');

      if (mounted) {
        setState(() {}); // Update UI with room code

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(lang(context).advertisingRoomWaiting),
            backgroundColor: Theme.of(context).colorScheme.primary,
            duration: const Duration(seconds: 3),
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

      await _bleService!.setPlayerReady();
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
      SnackBar(
        content: Text(lang(context).opponentJoinedReady),
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _startGameAndNavigate() async {
    try {
      print('🎮 [Host] Starting game with Easy difficulty...');

      await _bleService!.startGame();

      if (mounted) {
        print(
            '📤 [Host] Initializing combat game and navigating to play screen');

        // Initialize combat game with Easy difficulty (default)
        context.read<CombatNavCubit>().showSetDifficulty();
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
          backgroundColor: Theme.of(context).colorScheme.error,
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
              CustomSliverAppBar(
                title: lang(context).hostRoom,
                onBackPressed: () async {
                  await _bleService?.reset();
                  if (mounted) {
                    context.read<CombatNavCubit>().showSetup();
                  }
                },
                expandedHeight: 100,
              ),
              SliverPadding(
                padding: const EdgeInsets.all(kPaddingXL),
                sliver: SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bluetooth,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: kSpaceXL),

                        // Room Code Display
                        if (_roomCode != null) ...[
                          Text(
                            'Room Code',
                            style: AppTextStyles.titleLarge(context),
                          ),
                          const SizedBox(height: kSpaceM),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kPadding2XL, vertical: kPaddingML),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(kBorderRadiusL),
                            ),
                            child: Text(
                              _roomCode!,
                              style: AppTextStyles.withFontFamily(
                                  AppTextStyles.displaySmall(context),
                                  'monospace'),
                            ),
                          ),
                          const SizedBox(height: kSpace2XL),
                        ],

                        Text(
                          _getRoomStateText(),
                          style: AppTextStyles.bodyLargeMedium(context),
                          textAlign: TextAlign.center,
                        ),

                        if (_roomState == RoomState.guestJoined ||
                            _roomState == RoomState.bothReady) ...[
                          const SizedBox(height: kSpace2XL),
                          // Ready status indicators
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
                                isReady: _guestPlayerReady,
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
                                  const SizedBox(width: kSpaceSM),
                                  Text(
                                    lang(context).ready,
                                    style: AppTextStyles.bodyLargeBold(context),
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
                            borderRadius: BorderRadius.circular(kBorderRadiusM),
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
                                  style: AppTextStyles.withColor(
                                      AppTextStyles.bodyMediumSecondary(
                                          context),
                                      Theme.of(context).colorScheme.error),
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
                                  Icons.bluetooth_connected,
                                  color: (_bleService?.isConnected ?? false)
                                      ? Theme.of(context).colorScheme.tertiary
                                      : Theme.of(context).colorScheme.error,
                                  size: kFontSizeXL,
                                ),
                                const SizedBox(width: kSpaceM),
                                Text(
                                  (_bleService?.isConnected ?? false)
                                      ? 'Connected via Bluetooth'
                                      : lang(context).advertising,
                                  style: AppTextStyles.withColor(
                                      AppTextStyles.bodyMediumSecondary(
                                          context),
                                      (_bleService?.isConnected ?? false)
                                          ? Theme.of(context)
                                              .colorScheme
                                              .tertiary
                                          : Theme.of(context)
                                              .colorScheme
                                              .error),
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
          style: AppTextStyles.bodyLarge(context),
        ),
        Text(
          isReady ? lang(context).ready : lang(context).waiting,
          style: AppTextStyles.withColor(
              AppTextStyles.bodyLarge(context),
              isReady
                  ? Theme.of(context).colorScheme.tertiary
                  : Theme.of(context).colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
