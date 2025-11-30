part of 'bluetooth_bloc.dart';

abstract class BluetoothState {
  final bool permissionsGranted;
  final bool isBluetoothEnabled;
  final List<ScanResult> discoveredDevices;
  final BluetoothDevice? connectedDevice;
  final String? errorMessage;

  const BluetoothState({
    this.permissionsGranted = false,
    this.isBluetoothEnabled = false,
    this.discoveredDevices = const [],
    this.connectedDevice,
    this.errorMessage,
  });
}

class BluetoothInitialState extends BluetoothState {
  const BluetoothInitialState();
}

class BluetoothPermissionCheckingState extends BluetoothState {
  const BluetoothPermissionCheckingState();
}

class BluetoothPermissionDeniedState extends BluetoothState {
  const BluetoothPermissionDeniedState({String? errorMessage})
      : super(errorMessage: errorMessage);
}

class BluetoothDisabledState extends BluetoothState {
  const BluetoothDisabledState();
}

class BluetoothReadyState extends BluetoothState {
  const BluetoothReadyState({
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
  }) : super(
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}

class BluetoothHostingState extends BluetoothState {
  final String roomCode;
  final String deviceName;

  const BluetoothHostingState({
    required this.roomCode,
    required this.deviceName,
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
  }) : super(
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}

class BluetoothScanningState extends BluetoothState {
  final String? roomCodeFilter;

  const BluetoothScanningState({
    this.roomCodeFilter,
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
    List<ScanResult> discoveredDevices = const [],
  }) : super(
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
          discoveredDevices: discoveredDevices,
        );

  BluetoothScanningState copyWith({
    List<ScanResult>? discoveredDevices,
  }) {
    return BluetoothScanningState(
      roomCodeFilter: roomCodeFilter,
      permissionsGranted: permissionsGranted,
      isBluetoothEnabled: isBluetoothEnabled,
      discoveredDevices: discoveredDevices ?? this.discoveredDevices,
    );
  }
}

class BluetoothConnectingState extends BluetoothState {
  final BluetoothDevice device;

  const BluetoothConnectingState({
    required this.device,
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
  }) : super(
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}

class BluetoothConnectedState extends BluetoothState {
  final String peerName;

  const BluetoothConnectedState({
    required BluetoothDevice connectedDevice,
    required this.peerName,
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
  }) : super(
          connectedDevice: connectedDevice,
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}

class BluetoothDisconnectedState extends BluetoothState {
  final String? reason;

  const BluetoothDisconnectedState({
    this.reason,
    required bool permissionsGranted,
    required bool isBluetoothEnabled,
  }) : super(
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}

class BluetoothErrorState extends BluetoothState {
  const BluetoothErrorState({
    required String errorMessage,
    bool permissionsGranted = false,
    bool isBluetoothEnabled = false,
  }) : super(
          errorMessage: errorMessage,
          permissionsGranted: permissionsGranted,
          isBluetoothEnabled: isBluetoothEnabled,
        );
}
