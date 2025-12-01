part of 'bluetooth_bloc.dart';

abstract class BluetoothEvent {}

class BluetoothInitializeEvent extends BluetoothEvent {}

class BluetoothCheckPermissionsEvent extends BluetoothEvent {}

class BluetoothRequestPermissionsEvent extends BluetoothEvent {}

class BluetoothStartHostingEvent extends BluetoothEvent {
  final String roomCode;

  BluetoothStartHostingEvent(this.roomCode);
}

class BluetoothStartScanningEvent extends BluetoothEvent {
  final String? roomCodeFilter;

  BluetoothStartScanningEvent({this.roomCodeFilter});
}

class BluetoothStopScanningEvent extends BluetoothEvent {}

class BluetoothConnectEvent extends BluetoothEvent {
  final BluetoothDevice device;

  BluetoothConnectEvent(this.device);
}

class BluetoothSendMessageEvent extends BluetoothEvent {
  final bt_service.GameMessage message;

  BluetoothSendMessageEvent(this.message);
}

class BluetoothDisconnectEvent extends BluetoothEvent {}

class BluetoothDeviceDiscoveredEvent extends BluetoothEvent {
  final List<ScanResult> devices;

  BluetoothDeviceDiscoveredEvent(this.devices);
}

class BluetoothConnectionStateChangedEvent extends BluetoothEvent {
  final BluetoothConnectionState state;

  BluetoothConnectionStateChangedEvent(this.state);
}

class BluetoothMessageReceivedEvent extends BluetoothEvent {
  final bt_service.GameMessage message;

  BluetoothMessageReceivedEvent(this.message);
}

class BluetoothOpenSettingsEvent extends BluetoothEvent {}
