import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nucatch/blocs/navs/menu/menu_bloc.dart';
import 'package:nucatch/blocs/navs/menu/menu_event.dart';
import 'package:nucatch/blocs/navs/player/player_nav_cubit.dart';
import 'package:nucatch/blocs/objects/bluetooth/bluetooth_bloc.dart';
import 'package:nucatch/helpers/const.dart';
import 'package:nucatch/helpers/template.dart';

class CombatModeSetupScreen extends StatefulWidget {
  const CombatModeSetupScreen({super.key});

  @override
  State<CombatModeSetupScreen> createState() => _CombatModeSetupScreenState();
}

class _CombatModeSetupScreenState extends State<CombatModeSetupScreen> {
  bool _isProcessing = false;
  bool _pendingIsHost = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize Bluetooth when screen loads (only once)
    if (!_initialized) {
      context.read<BluetoothBloc>().add(BluetoothInitializeEvent());
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BluetoothBloc, BluetoothState>(
      listener: (context, state) {
        print(
            '[CombatModeSetupScreen] Bloc state changed: ${state.runtimeType}');
        if (state is BluetoothErrorState) {
          print('[CombatModeSetupScreen] Error: ${state.errorMessage}');
          setState(() => _isProcessing = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? 'Bluetooth error occurred'),
              backgroundColor: Colors.red,
            ),
          );
        } else if (state is BluetoothPermissionPermanentlyDeniedState) {
          print('[CombatModeSetupScreen] Permanently denied');
          setState(() => _isProcessing = false);
          _showPermissionPermanentlyDeniedDialog(context);
        } else if (state is BluetoothPermissionDeniedState) {
          print('[CombatModeSetupScreen] Permission denied');
          setState(() => _isProcessing = false);
          _showPermissionPermanentlyDeniedDialog(context);
          // _showPermissionDeniedDialog(context);
        } else if (state is BluetoothDisabledState) {
          print('[CombatModeSetupScreen] Bluetooth disabled');
          setState(() => _isProcessing = false);
          _showBluetoothDisabledDialog(context);
        } else if (state is BluetoothReadyState &&
            state.permissionsGranted &&
            _isProcessing) {
          print('[CombatModeSetupScreen] Ready and processing, navigating...');
          // Permissions were just granted, proceed with navigation
          setState(() => _isProcessing = false);
          // Use a small delay to ensure dialog is dismissed
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) {
              _navigateToPairingRoom(context, isHost: _pendingIsHost);
            }
          });
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
                      lang(context).combatMode,
                      style: LayoutConfig(context).titleSectionStyle(),
                    ),
                  ),

                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Create Room Button
                            _ActionCard(
                              title: lang(context).createRoom,
                              description: lang(context).createRoomDescription,
                              icon: FontAwesomeIcons.plus,
                              color: Colors.green,
                              onTap: () {
                                _checkBluetoothPermissionAndNavigate(
                                  context,
                                  isHost: true,
                                );
                              },
                            ),

                            const SizedBox(height: 30),

                            // Join Room Button
                            _ActionCard(
                              title: lang(context).joinRoom,
                              description: lang(context).joinRoomDescription,
                              icon: FontAwesomeIcons.arrowRightToBracket,
                              color: Colors.purple,
                              onTap: () {
                                _checkBluetoothPermissionAndNavigate(
                                  context,
                                  isHost: false,
                                );
                              },
                            ),
                          ],
                        ),
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

  void _showPermissionDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(lang(context).bluetoothPermissionRequired),
        content: Text(lang(context).bluetoothPermissionMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              context.read<MenuBloc>().add(ShowMenu()); // Go back to main menu
            },
            child: Text(lang(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Request permissions again
              context
                  .read<BluetoothBloc>()
                  .add(BluetoothRequestPermissionsEvent());
            },
            child: Text(lang(context).grantPermission),
          ),
        ],
      ),
    );
  }

  void _showBluetoothDisabledDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(lang(context).bluetoothDisabled),
        content: Text(lang(context).bluetoothDisabledMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              context.read<MenuBloc>().add(ShowMenu()); // Go back to main menu
            },
            child: Text(lang(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Check again after user enables Bluetooth
              context
                  .read<BluetoothBloc>()
                  .add(BluetoothCheckPermissionsEvent());
            },
            child: Text(lang(context).checkAgain),
          ),
        ],
      ),
    );
  }

  void _showPermissionPermanentlyDeniedDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(lang(context).bluetoothPermissionRequired),
        content:
            Text(lang(context).bluetoothPermissionPermanentlyDeniedMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop(); // Close dialog
              context.read<MenuBloc>().add(ShowMenu()); // Go back to main menu
            },
            child: Text(lang(context).cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Open app settings
              context.read<BluetoothBloc>().add(BluetoothOpenSettingsEvent());
            },
            child: Text(lang(context).openSettings),
          ),
        ],
      ),
    );
  }

  Future<void> _checkBluetoothPermissionAndNavigate(
    BuildContext context, {
    required bool isHost,
  }) async {
    final bluetoothBloc = context.read<BluetoothBloc>();
    final bluetoothState = bluetoothBloc.state;

    // Save the host flag for later use if permission request is needed
    _pendingIsHost = isHost;

    // Check if permissions are already granted
    if (bluetoothState is BluetoothReadyState) {
      if (bluetoothState.permissionsGranted) {
        // Permissions already granted, proceed directly
        _navigateToPairingRoom(context, isHost: isHost);
        return;
      } else {
        // Request permissions
        setState(() => _isProcessing = true);
        bluetoothBloc.add(BluetoothRequestPermissionsEvent());
        // The listener will handle navigation after permission is granted
        return;
      }
    } else {
      // Not in ready state, request permissions
      setState(() => _isProcessing = true);
      bluetoothBloc.add(BluetoothRequestPermissionsEvent());
    }
  }

  void _navigateToPairingRoom(BuildContext context, {required bool isHost}) {
    // Generate room code if host
    String? roomCode;
    if (isHost) {
      // Generate a 3-digit room code
      roomCode = (100 + DateTime.now().millisecond % 900).toString();
    }

    context.read<PlayerNavCubit>().showPairingRoom(
          isHost: isHost,
          roomCode: roomCode,
        );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 60,
              color: color,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: LayoutConfig(context).titleSectionStyle().copyWith(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: LayoutConfig(context).contentSectionStyle(),
            ),
          ],
        ),
      ),
    );
  }
}
