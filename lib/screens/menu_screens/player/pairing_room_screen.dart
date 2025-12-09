import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/menu/menu_state.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/combat/combat_bloc.dart';
import 'package:nucatch/blocs/objects/combat/combat_event.dart';
import 'package:nucatch/blocs/objects/combat/combat_state.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/helper.dart';
import 'package:nucatch/helpers/template.dart';
import 'package:nucatch/services/combat_ble_service.dart';

/// Pairing room screen using pure BLE (no internet required)
class PairingRoomScreen extends StatefulWidget {
  final bool isHost;
  final String? roomCode;

  const PairingRoomScreen({
    super.key,
    required this.isHost,
    this.roomCode,
  });

  @override
  State<PairingRoomScreen> createState() => _PairingRoomScreenState();
}

class _PairingRoomScreenState extends State<PairingRoomScreen> {
  final TextEditingController _passcodeController = TextEditingController();
  final CombatBLEService _roomService = CombatBLEService();

  String? _myPlayerId;
  RoomState _roomState = RoomState.waiting;
  bool _isBluetoothReady = false;
  bool _hasInitialized = false;
  StreamSubscription? _roomStateSubscription;

  @override
  void initState() {
    super.initState();
    _myPlayerId = _generatePlayerId();

    // Listen to room state
    _roomStateSubscription = _roomService.roomStateStream.listen((state) {
      setState(() {
        _roomState = state;
      });

      // Handle state transitions
      if (state == RoomState.bothReady) {
        _showBothReadyDialog();
      } else if (state == RoomState.playing) {
        _handleGameStarted();
      } else if (state == RoomState.deleted) {
        _handleRoomDeleted();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize Bluetooth only once after dependencies are ready
    if (!_hasInitialized) {
      _hasInitialized = true;
      _initializeBluetooth();
    }
  }

  Future<void> _initializeBluetooth() async {
    try {
      // Check Bluetooth support
      final isSupported = await _roomService.bleService.isBluetoothSupported();
      if (!isSupported) {
        _showBluetoothError('Bluetooth is not supported on this device');
        return;
      }

      // Check permissions
      final hasPermissions = await _roomService.bleService.hasPermissions();
      if (!hasPermissions) {
        final granted = await _roomService.bleService.requestPermissions();
        if (!granted) {
          _showBluetoothError('Bluetooth permissions are required');
          return;
        }
      }

      // Check if Bluetooth is enabled
      final isEnabled = await _roomService.bleService.isBluetoothEnabled();
      if (!isEnabled) {
        try {
          await _roomService.bleService.turnOnBluetooth();
        } catch (e) {
          _showBluetoothError('Please enable Bluetooth to continue');
          return;
        }
      }

      setState(() {
        _isBluetoothReady = true;
      });

      // Create room after Bluetooth is ready
      if (widget.isHost && widget.roomCode != null) {
        _createRoom();
      }
    } catch (e) {
      print('❌ [Pairing] Bluetooth initialization failed: $e');
      _showBluetoothError('Failed to initialize Bluetooth: $e');
    }
  }

  void _showBluetoothError(String message) {
    // Use addPostFrameCallback to ensure widget tree is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Bluetooth Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (mounted) {
                  context.read<MenuBloc>().add(ShowMenu());
                }
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    _roomStateSubscription?.cancel();

    // Only leave room if game hasn't started yet
    if (_roomState != RoomState.playing && _roomState != RoomState.ended) {
      _roomService.leaveRoom();
    }

    super.dispose();
  }

  String _generatePlayerId() {
    return 'player_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(1000)}';
  }

  Future<void> _createRoom() async {
    if (!_isBluetoothReady) {
      _showError('Bluetooth is not ready');
      return;
    }

    try {
      await _roomService.createRoom(widget.roomCode!, _myPlayerId!);
      print('✅ Room created: ${widget.roomCode}');
    } catch (e) {
      _showError('Failed to create room: $e');
    }
  }

  Future<void> _joinRoom() async {
    if (!_isBluetoothReady) {
      _showError('Bluetooth is not ready');
      return;
    }

    final roomCode = _passcodeController.text;

    if (roomCode.isEmpty || roomCode.length != 3) {
      _showError('Please enter a valid 3-digit room code');
      return;
    }

    try {
      await _roomService.joinRoom(roomCode, _myPlayerId!);
      print('✅ Joining room: $roomCode');
    } catch (e) {
      _showError('Failed to join room: $e');
    }
  }

  Future<void> _setReady() async {
    try {
      await _roomService.setPlayerReady();
      print('✅ Player marked as ready');
    } catch (e) {
      _showError('Failed to set ready: $e');
    }
  }

  void _showBothReadyDialog() {
    if (widget.isHost) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Both Players Ready!'),
          content: const Text('Start the game?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startGame();
              },
              child: const Text('Start Game'),
            ),
          ],
        ),
      );
    }
  }

  void _handleRoomDeleted() {
    _showError('Room was deleted by host');
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.read<MenuBloc>().add(ShowMenu());
      }
    });
  }

  void _handleGameStarted() {
    print('🎮 [Pairing] Game started');
    if (mounted) {
      if (widget.isHost) {
        // Host navigates to difficulty selection
        print('🎮 [Pairing] Host navigating to difficulty screen');
        context
            .read<PlayerNavCubit>()
            .showSetDifficulty(playMode: PlayMode.combat);
      } else {
        // Guest stays on pairing screen, waiting for difficulty
        print('🎮 [Pairing] Guest waiting for host to select difficulty');
        setState(() {
          // UI will show "Waiting for host to select difficulty"
        });
      }
    }
  }

  Future<void> _startGame() async {
    if (!widget.isHost) return;

    try {
      await _roomService.startGame();

      // Navigate to difficulty selection
      if (mounted) {
        context
            .read<PlayerNavCubit>()
            .showSetDifficulty(playMode: PlayMode.combat);
      }
    } catch (e) {
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
        return 'Waiting for opponent...';
      case RoomState.guestJoined:
        return 'Opponent joined!';
      case RoomState.bothReady:
        return 'Both players ready!';
      case RoomState.playing:
        return widget.isHost
            ? 'Game in progress'
            : 'Waiting for host to select difficulty...';
      case RoomState.ended:
        return 'Game ended';
      case RoomState.deleted:
        return 'Room deleted';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CombatBloc, CombatState>(
      listener: (context, combatState) {
        // Guest auto-navigates when difficulty and turn are ready
        if (!widget.isHost &&
            combatState.difficultyModel != null &&
            combatState.status == CombatStatus.playing) {
          context.read<PlayerNavCubit>().showPlay(playMode: PlayMode.combat);
        }
      },
      child: BlocBuilder<CombatBloc, CombatState>(
        builder: (context, combatState) {
          // If game is playing, show reused play screen components
          if (combatState.status == CombatStatus.playing) {
            return _buildCombatPlayingView(combatState);
          }

          // Otherwise show pairing UI
          return _buildPairingView();
        },
      ),
    );
  }

  Widget _buildPairingView() {
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
                        // Leave room before navigating back
                        await _roomService.leaveRoom();
                        if (mounted) {
                          context.read<MenuBloc>().add(ShowMenu());
                        }
                      },
                    ),
                    Expanded(
                      child: Text(
                        widget.isHost ? 'Host Room' : 'Join Room',
                        style: LayoutConfig(context).titleSectionStyle(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.isHost) ...[
                        _buildHostView(),
                      ] else ...[
                        _buildGuestView(),
                      ],
                      const SizedBox(height: 40),
                      _buildProximityIndicator(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHostView() {
    return Column(
      children: [
        Text(
          'Room Code',
          style: LayoutConfig(context).titleSectionStyle(),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Text(
            widget.roomCode ?? '---',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          _getRoomStateText(),
          style: TextStyle(
            fontSize: 18,
            color:
                _roomState == RoomState.bothReady ? Colors.green : Colors.white,
          ),
        ),
        if (_roomState == RoomState.guestJoined ||
            _roomState == RoomState.bothReady) ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _roomState == RoomState.guestJoined ? _setReady : null,
            icon: const FaIcon(FontAwesomeIcons.check),
            label: const Text('Ready'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
          ),
        ],
        if (_roomState == RoomState.bothReady && widget.isHost) ...[
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _startGame,
            icon: const FaIcon(FontAwesomeIcons.play),
            label: const Text('Start Game'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGuestView() {
    return Column(
      children: [
        Text(
          'Enter Room Code',
          style: LayoutConfig(context).titleSectionStyle(),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: TextField(
            controller: _passcodeController,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 3,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: '---',
              filled: true,
              fillColor: Colors.white.withOpacity(0.1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        ElevatedButton.icon(
          onPressed: _roomState == RoomState.waiting ? _joinRoom : null,
          icon: const FaIcon(FontAwesomeIcons.rightToBracket),
          label: const Text('Join Room'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          ),
        ),
        if (_roomState != RoomState.waiting) ...[
          const SizedBox(height: 20),
          Text(
            _getRoomStateText(),
            style: TextStyle(
              fontSize: 18,
              color: _roomState == RoomState.bothReady
                  ? Colors.green
                  : Colors.white,
            ),
          ),
          if (_roomState == RoomState.guestJoined) ...[
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _setReady,
              icon: const FaIcon(FontAwesomeIcons.check),
              label: const Text('Ready'),
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
            ),
          ],
        ],
      ],
    );
  }

  Widget _buildProximityIndicator() {
    // Show BLE connection status
    final isConnected = _roomService.bleService.isConnected;

    return Column(
      children: [
        const Divider(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FontAwesomeIcons.bluetooth,
              color: isConnected ? Colors.blue : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 10),
            Text(
              isConnected
                  ? 'Connected via Bluetooth'
                  : 'Waiting for connection...',
              style: TextStyle(
                color: isConnected ? Colors.blue : Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Combat playing view that reuses play_screen components
  Widget _buildCombatPlayingView(CombatState combatState) {
    return Scaffold(
      body: Container(
        decoration: LayoutConfig(context).gradientDecoration,
        child: SafeArea(
          child: DeviceWrapper(
            child: Column(
              children: [
                // Combat header with turn indicator and scores
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      // Turn indicator and scores row
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: [
                            // My info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Helper.getIconFromDifficulty(
                                            context,
                                            combatState
                                                .difficultyModel?.difficulty),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        'You',
                                        style: LayoutConfig(context)
                                            .contentSectionStyle()
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Icon(FontAwesomeIcons.chartLine,
                                          size: 12),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${combatState.myScore}',
                                        style: LayoutConfig(context)
                                            .contentSectionStyle(),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 2,
                                    children: List.generate(
                                      combatState.myLives,
                                      (_) => Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Turn indicator
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: combatState.isMyTurn
                                    ? Colors.green
                                    : Colors.orange,
                                borderRadius: BorderRadius.circular(20),
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Text(
                                combatState.isMyTurn
                                    ? "Your Turn"
                                    : "Opponent's Turn",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),

                            // Opponent info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Opponent',
                                    style: LayoutConfig(context)
                                        .contentSectionStyle()
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(FontAwesomeIcons.chartLine,
                                          size: 12),
                                      const SizedBox(width: 5),
                                      Text(
                                        '${combatState.opponentScore}',
                                        style: LayoutConfig(context)
                                            .contentSectionStyle(),
                                      ),
                                    ],
                                  ),
                                  Wrap(
                                    spacing: 2,
                                    children: List.generate(
                                      combatState.opponentLives,
                                      (_) => Icon(
                                        FontAwesomeIcons.solidStar,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                        size: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Challenge display (reusing play_screen style)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (combatState.currentRequirement != null) ...[
                                Text(
                                  'Solve:',
                                  style: LayoutConfig(context)
                                      .contentSectionStyle(),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  combatState.currentRequirement!,
                                  style: LayoutConfig(context)
                                      .displaySmallStyle(
                                        isActiveShadow: true,
                                      )
                                      .copyWith(
                                          fontSize: 48,
                                          fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 30),
                                Text(
                                  'Answer:',
                                  style: LayoutConfig(context)
                                      .contentSectionStyle(),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        color: Colors.white.withOpacity(0.5),
                                        width: 2),
                                  ),
                                  child: Text(
                                    combatState.myInput.isEmpty
                                        ? '___'
                                        : combatState.myInput,
                                    style: LayoutConfig(context)
                                        .displaySmallStyle()
                                        .copyWith(
                                          fontSize: 36,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 4,
                                        ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                              if (!combatState.isMyTurn)
                                Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    combatState.isWaitingForOpponent
                                        ? 'Waiting for opponent...'
                                        : 'Opponent is playing...',
                                    style: LayoutConfig(context)
                                        .contentSectionStyle()
                                        .copyWith(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.orange,
                                        ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Keyboard (reused from play_screen)
                if (combatState.canTap && combatState.isMyTurn)
                  Expanded(
                    flex: 2,
                    child: _buildCombatKeyboard(combatState),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCombatKeyboard(CombatState combatState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final keys = keyboardArray.entries.toList();
        const columns = 3;
        const rows = 4;
        final buttonWidth = constraints.maxWidth / columns;
        final buttonHeight = constraints.maxHeight / rows;
        const buttonSpacing = 20.0;
        const tableGap = 10.0;

        List<TableRow> tableRows = [];
        for (int r = 0; r < rows; r++) {
          List<Widget> rowChildren = [];
          for (int c = 0; c < columns; c++) {
            int idx = r * columns + c;
            Widget cell;
            if (idx < keys.length) {
              final e = keys[idx];
              Widget button;

              if (e.key == KeyboardOption.reset) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.arrowsRotate,
                  isEnable: false, // No reset in combat
                  onPressed: () {},
                );
              } else if (e.key == KeyboardOption.mainMenu) {
                button = AnimatedButton(
                  context,
                  iconData: FontAwesomeIcons.bars,
                  onPressed: () async {
                    final confirmed = await Helper.pressMainMenu(context);
                    if (confirmed && mounted) {
                      await _roomService.leaveRoom();
                      context.read<MenuBloc>().add(ShowMenu());
                    }
                  },
                );
              } else {
                button = AnimatedButton(
                  context,
                  text: e.value.toString(),
                  style: LayoutConfig(context).boldedStyle,
                  isEnable: combatState.canTap && combatState.isMyTurn,
                  onPressed: () =>
                      _handleCombatTap(e.value.toString(), combatState),
                );
              }

              cell = SizedBox(
                width: buttonWidth - buttonSpacing,
                height: buttonHeight - buttonSpacing,
                child: button,
              );
            } else {
              cell = SizedBox(
                width: buttonWidth - buttonSpacing,
                height: buttonHeight - buttonSpacing,
              );
            }

            if (c < columns - 1) {
              rowChildren.add(Padding(
                padding: const EdgeInsets.only(right: tableGap),
                child: cell,
              ));
            } else {
              rowChildren.add(cell);
            }
          }

          tableRows.add(TableRow(children: rowChildren));
          if (r < rows - 1) {
            tableRows.add(
              TableRow(
                children: List.generate(
                  columns,
                  (_) => const SizedBox(height: tableGap),
                ),
              ),
            );
          }
        }

        return Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: tableRows,
        );
      },
    );
  }

  void _handleCombatTap(String input, CombatState combatState) {
    if (!combatState.canTap || !combatState.isMyTurn) return;

    final combatBloc = context.read<CombatBloc>();
    final newInput = combatState.myInput + input;
    final pointsEarned = combatState.difficultyModel?.pointEachTurn ?? 1;

    if (newInput == combatState.currentTarget) {
      // Correct answer
      combatBloc.add(TurnCompleted(
        wasCorrect: true,
        playerInput: newInput,
        pointsScored: combatState.myScore + pointsEarned,
        livesRemaining: combatState.myLives,
      ));
    } else if (newInput.length == combatState.currentTarget?.length) {
      // Wrong answer
      combatBloc.add(TurnCompleted(
        wasCorrect: false,
        playerInput: newInput,
        pointsScored: combatState.myScore,
        livesRemaining: combatState.myLives - 1,
      ));
    } else {
      // Still typing
      combatBloc.add(InputUpdated(input: newInput));
    }
  }
}
