import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/navs/player/player_nav_state.dart';
import 'package:nucatch/blocs/objects/bluetooth/bluetooth_bloc.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

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
  bool _isPaired = false;
  String? _pairedPlayerName;
  bool _isSearching = false;
  List<fbp.ScanResult> _discoveredDevices = [];
  BluetoothBloc? _bluetoothBloc;

  @override
  void initState() {
    super.initState();
    if (widget.isHost) {
      // Host starts advertising
      _startListeningForConnections();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Save reference to BluetoothBloc for use in dispose()
    _bluetoothBloc = context.read<BluetoothBloc>();
  }

  @override
  void dispose() {
    _passcodeController.dispose();
    // Disconnect Bluetooth if connected using saved reference
    _bluetoothBloc?.add(BluetoothDisconnectEvent());
    super.dispose();
  }

  void _startListeningForConnections() {
    setState(() {
      _isSearching = true;
    });

    // Start Bluetooth hosting
    if (widget.roomCode != null) {
      context.read<BluetoothBloc>().add(
            BluetoothStartHostingEvent(widget.roomCode!),
          );
    }
  }

  void _connectToRoom() {
    if (_passcodeController.text.isEmpty ||
        _passcodeController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 3-digit room code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Start scanning for the specific room code
    context.read<BluetoothBloc>().add(
          BluetoothStartScanningEvent(
            roomCodeFilter: _passcodeController.text,
          ),
        );
  }

  void _rescanRoom() {
    if (_passcodeController.text.isEmpty ||
        _passcodeController.text.length != 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid 3-digit room code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Stop current scan
    context.read<BluetoothBloc>().add(BluetoothStopScanningEvent());

    // Wait a bit and restart scan
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isSearching = true;
      });

      // Start scanning again for the specific room code
      context.read<BluetoothBloc>().add(
            BluetoothStartScanningEvent(
              roomCodeFilter: _passcodeController.text,
            ),
          );
    });
  }

  void _startGame() {
    // Only host can start the game
    if (!widget.isHost || !_isPaired) {
      return;
    }

    // Navigate to difficulty selection (host chooses for both players)
    context.read<PlayerNavCubit>().showSetDifficulty(playMode: PlayMode.combat);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BluetoothBloc, BluetoothState>(
      listener: (context, state) {
        if (state is BluetoothConnectedState) {
          setState(() {
            _isPaired = true;
            _pairedPlayerName = state.peerName;
            _isSearching = false;
          });
        } else if (state is BluetoothScanningState) {
          // Update discovered devices list
          setState(() {
            _discoveredDevices = state.discoveredDevices;
          });
        } else if (state is BluetoothHostingState) {
          // Hosting started successfully
          setState(() {
            _isSearching = true;
          });
        } else if (state is BluetoothErrorState) {
          setState(() {
            _isSearching = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Bluetooth error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is BluetoothDisconnectedState) {
          setState(() {
            _isPaired = false;
            _pairedPlayerName = null;
            _isSearching = false;
          });

          if (state.reason != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Disconnected: ${state.reason}'),
                backgroundColor: Colors.orange,
              ),
            );
          }
        }
      },
      child: Scaffold(
        body: Container(
          decoration: LayoutConfig(context).gradientDecoration,
          child: SafeArea(
            child: DeviceWrapper(
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.isHost
                          ? lang(context).hostRoom
                          : lang(context).joinRoom,
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (widget.isHost) ...[
                            // Host view: Show room code
                            _buildHostView(),
                          ] else ...[
                            // Guest view: Enter room code
                            _buildGuestView(),
                          ],

                          const SizedBox(height: 40),

                          // Connection status
                          if (_isSearching) ...[
                            const CircularProgressIndicator(),
                            const SizedBox(height: 20),
                            Text(
                              lang(context).searchingForPlayers,
                              style:
                                  LayoutConfig(context).contentSectionStyle(),
                            ),
                          ] else if (_isPaired) ...[
                            Icon(
                              FontAwesomeIcons.circleCheck,
                              size: 60,
                              color: Colors.green,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              lang(context)
                                  .pairedWith(_pairedPlayerName ?? "Player"),
                              style: LayoutConfig(context).titleSectionStyle(),
                              textAlign: TextAlign.center,
                            ),
                            if (widget.isHost) ...[
                              const SizedBox(height: 30),
                              CustomElevatedButton(
                                text: lang(context).start,
                                shapeAt: RoundedWithShapeAt.all,
                                backgroundColor: Colors.green,
                                onPressed: _startGame,
                              ),
                            ] else ...[
                              const SizedBox(height: 20),
                              Text(
                                'Waiting for host to start...',
                                style:
                                    LayoutConfig(context).contentSectionStyle(),
                                textAlign: TextAlign.center,
                              ),
                              // TODO: Listen for Bluetooth message from host to start game
                              // When host chooses difficulty and starts, guest should receive
                              // a message and navigate directly to play screen
                            ],
                          ],
                        ],
                      ),
                    ),
                  ),

                  // Back Button
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CustomElevatedButton(
                      text: lang(context).mainMenu,
                      shapeAt: RoundedWithShapeAt.all,
                      onPressed: () {
                        context.read<MenuBloc>().add(ShowMenu());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHostView() {
    return Column(
      children: [
        Text(
          lang(context).roomCode,
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Colors.white.withOpacity(0.5),
              width: 2,
            ),
          ),
          child: Text(
            widget.roomCode ?? "---",
            style: LayoutConfig(context).displaySmallStyle().copyWith(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          lang(context).shareCodeWithPlayer,
          style: LayoutConfig(context).contentSectionStyle(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildGuestView() {
    if (_isPaired) {
      // Already connected - status shown in main view
      return Container();
    }

    return Column(
      children: [
        // Room Code Input
        Text(
          lang(context).enterRoomCode,
          style: LayoutConfig(context).contentSectionStyle(),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 200,
          child: TextField(
            controller: _passcodeController,
            keyboardType: TextInputType.number,
            maxLength: 3,
            textAlign: TextAlign.center,
            style: LayoutConfig(context).displaySmallStyle().copyWith(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8,
                ),
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: Colors.white.withOpacity(0.2),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: Colors.white.withOpacity(0.5),
                  width: 2,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        if (!_isSearching)
          CustomElevatedButton(
            text: lang(context).connect,
            shapeAt: RoundedWithShapeAt.all,
            backgroundColor: Colors.blue,
            onPressed: _connectToRoom,
          )
        else ...[
          // Searching indicator
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          const SizedBox(height: 20),
          Text(
            'Searching for "NuCatch-${_passcodeController.text}"...',
            style: LayoutConfig(context).contentSectionStyle(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Looking for devices advertising room ${_passcodeController.text}',
            style: LayoutConfig(context).contentSectionStyle().copyWith(
                  fontSize: 12,
                  color: Colors.white70,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          // Re-scan button
          TextButton.icon(
            onPressed: _rescanRoom,
            icon: const FaIcon(
              FontAwesomeIcons.rotate,
              size: 20,
              color: Colors.white,
            ),
            label: Text(
              'Scan Again',
              style: LayoutConfig(context).contentSectionStyle(),
            ),
          ),
          const SizedBox(height: 20),
          // Device list
          if (_discoveredDevices.isNotEmpty) ...[
            Text(
              'Found ${_discoveredDevices.length} matching device(s):',
              style: LayoutConfig(context).contentSectionStyle().copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
            ),
            const SizedBox(height: 10),
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _discoveredDevices.length,
                itemBuilder: (context, index) {
                  final device = _discoveredDevices[index];
                  final deviceName = device.device.platformName.isNotEmpty
                      ? device.device.platformName
                      : device.device.remoteId.toString();
                  final advName = device.advertisementData.advName;
                  final displayName = advName.isNotEmpty ? advName : deviceName;
                  final rssi = device.rssi;

                  return Card(
                    color: Colors.white.withOpacity(0.2),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: _getSignalColor(rssi),
                      ),
                      title: Text(
                        displayName,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (advName.isNotEmpty && advName != deviceName)
                            Text(
                              'Device: $deviceName',
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                          Text(
                            'Signal: $rssi dBm',
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () {
                          context.read<BluetoothBloc>().add(
                                BluetoothConnectEvent(device.device),
                              );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Connect'),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ],
    );
  }

  Color _getSignalColor(int rssi) {
    if (rssi >= -50) return Colors.green;
    if (rssi >= -70) return Colors.orange;
    return Colors.red;
  }
}
