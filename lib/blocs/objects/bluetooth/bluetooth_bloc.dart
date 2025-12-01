import 'dart:async';
import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../../../services/bluetooth_service.dart' as bt_service;

part 'bluetooth_event.dart';
part 'bluetooth_state.dart';

class BluetoothBloc extends Bloc<BluetoothEvent, BluetoothState> {
  final bt_service.BluetoothService _bluetoothService;
  StreamSubscription? _messageSubscription;
  StreamSubscription? _connectionSubscription;
  StreamSubscription? _devicesSubscription;

  BluetoothBloc({bt_service.BluetoothService? bluetoothService})
      : _bluetoothService = bluetoothService ?? bt_service.BluetoothService(),
        super(const BluetoothInitialState()) {
    on<BluetoothInitializeEvent>(_onInitialize);
    on<BluetoothCheckPermissionsEvent>(_onCheckPermissions);
    on<BluetoothRequestPermissionsEvent>(_onRequestPermissions);
    on<BluetoothStartHostingEvent>(_onStartHosting);
    on<BluetoothStartScanningEvent>(_onStartScanning);
    on<BluetoothStopScanningEvent>(_onStopScanning);
    on<BluetoothConnectEvent>(_onConnect);
    on<BluetoothSendMessageEvent>(_onSendMessage);
    on<BluetoothDisconnectEvent>(_onDisconnect);
    on<BluetoothDeviceDiscoveredEvent>(_onDeviceDiscovered);
    on<BluetoothConnectionStateChangedEvent>(_onConnectionStateChanged);
    on<BluetoothMessageReceivedEvent>(_onMessageReceived);
    on<BluetoothOpenSettingsEvent>(_onOpenSettings);

    // Subscribe to service streams
    _setupSubscriptions();
  }

  void _setupSubscriptions() {
    _messageSubscription = _bluetoothService.messageStream.listen((message) {
      try {
        final gameMessage = bt_service.GameMessage.fromJson(message);
        add(BluetoothMessageReceivedEvent(gameMessage));
      } catch (e) {
        // Invalid message format
      }
    });

    _connectionSubscription =
        _bluetoothService.connectionStateStream.listen((connectionState) {
      add(BluetoothConnectionStateChangedEvent(connectionState));
    });

    _devicesSubscription =
        _bluetoothService.discoveredDevicesStream.listen((devices) {
      add(BluetoothDeviceDiscoveredEvent(devices));
    });
  }

  Future<void> _onInitialize(
    BluetoothInitializeEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    add(BluetoothCheckPermissionsEvent());
  }

  Future<void> _onCheckPermissions(
    BluetoothCheckPermissionsEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    print('[BluetoothBloc] Checking permissions...');
    emit(const BluetoothPermissionCheckingState());

    final isSupported = await _bluetoothService.isBluetoothSupported();
    if (!isSupported) {
      print('[BluetoothBloc] Bluetooth not supported');
      emit(const BluetoothErrorState(
        errorMessage: 'Bluetooth is not supported on this device',
      ));
      return;
    }

    final isEnabled = await _bluetoothService.isBluetoothEnabled();
    print('[BluetoothBloc] Bluetooth enabled: $isEnabled');

    if (!isEnabled) {
      print('[BluetoothBloc] Emitting BluetoothDisabledState');
      emit(const BluetoothDisabledState());
      return;
    }

    // Check if we already have permissions
    final hasPermissions = await _bluetoothService.hasPermissions();
    print('[BluetoothBloc] Has permissions: $hasPermissions');

    emit(BluetoothReadyState(
      permissionsGranted: hasPermissions,
      isBluetoothEnabled: isEnabled,
    ));
  }

  Future<void> _onRequestPermissions(
    BluetoothRequestPermissionsEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    print('[BluetoothBloc] Requesting permissions...');
    // First check if permissions are permanently denied
    final isPermanentlyDenied =
        await _bluetoothService.isPermissionPermanentlyDenied();
    print('[BluetoothBloc] Permanently denied: $isPermanentlyDenied');

    if (isPermanentlyDenied) {
      print(
          '[BluetoothBloc] Emitting BluetoothPermissionPermanentlyDeniedState');
      emit(
        BluetoothPermissionPermanentlyDeniedState(
          errorMessage:
              'Bluetooth permissions were denied. Please enable them in Settings to use Combat Mode.',
        ),
      );
      return;
    }

    final hasPermissions = await _bluetoothService.requestPermissions();
    print('[BluetoothBloc] Permissions granted: $hasPermissions');
    final isEnabled = await _bluetoothService.isBluetoothEnabled();

    if (!hasPermissions) {
      print('[BluetoothBloc] Emitting BluetoothPermissionDeniedState');
      emit(BluetoothPermissionDeniedState(
        errorMessage: 'Bluetooth permissions are required for combat mode',
      ));
      return;
    }

    print('[BluetoothBloc] Emitting BluetoothReadyState');
    emit(BluetoothReadyState(
      permissionsGranted: hasPermissions,
      isBluetoothEnabled: isEnabled,
    ));
  }

  Future<void> _onStartHosting(
    BluetoothStartHostingEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    try {
      final deviceName =
          await _bluetoothService.startAdvertising(event.roomCode);

      emit(BluetoothHostingState(
        roomCode: event.roomCode,
        deviceName: deviceName,
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    } catch (e) {
      log(e.toString());
      emit(BluetoothErrorState(
        errorMessage: 'Failed to start hosting: ${e.toString()}',
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    }
  }

  Future<void> _onStartScanning(
    BluetoothStartScanningEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    try {
      await _bluetoothService.startScanning(event.roomCodeFilter);

      emit(BluetoothScanningState(
        roomCodeFilter: event.roomCodeFilter,
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    } catch (e) {
      emit(BluetoothErrorState(
        errorMessage: 'Failed to start scanning: ${e.toString()}',
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    }
  }

  Future<void> _onStopScanning(
    BluetoothStopScanningEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    await _bluetoothService.stopScanning();

    emit(BluetoothReadyState(
      permissionsGranted: state.permissionsGranted,
      isBluetoothEnabled: state.isBluetoothEnabled,
    ));
  }

  Future<void> _onConnect(
    BluetoothConnectEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    emit(BluetoothConnectingState(
      device: event.device,
      permissionsGranted: state.permissionsGranted,
      isBluetoothEnabled: state.isBluetoothEnabled,
    ));

    final success = await _bluetoothService.connectToDevice(event.device);

    if (success) {
      emit(BluetoothConnectedState(
        connectedDevice: event.device,
        peerName: event.device.platformName,
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    } else {
      emit(BluetoothErrorState(
        errorMessage: 'Failed to connect to device',
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    }
  }

  Future<void> _onSendMessage(
    BluetoothSendMessageEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    final success = await _bluetoothService.sendMessage(event.message.toJson());

    if (!success) {
      emit(BluetoothErrorState(
        errorMessage: 'Failed to send message',
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    }
  }

  Future<void> _onDisconnect(
    BluetoothDisconnectEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    await _bluetoothService.disconnect();

    emit(BluetoothDisconnectedState(
      permissionsGranted: state.permissionsGranted,
      isBluetoothEnabled: state.isBluetoothEnabled,
    ));
  }

  void _onDeviceDiscovered(
    BluetoothDeviceDiscoveredEvent event,
    Emitter<BluetoothState> emit,
  ) {
    if (state is BluetoothScanningState) {
      emit((state as BluetoothScanningState).copyWith(
        discoveredDevices: event.devices,
      ));
    }
  }

  void _onConnectionStateChanged(
    BluetoothConnectionStateChangedEvent event,
    Emitter<BluetoothState> emit,
  ) {
    if (event.state == BluetoothConnectionState.disconnected) {
      emit(BluetoothDisconnectedState(
        reason: 'Connection lost',
        permissionsGranted: state.permissionsGranted,
        isBluetoothEnabled: state.isBluetoothEnabled,
      ));
    }
  }

  void _onMessageReceived(
    BluetoothMessageReceivedEvent event,
    Emitter<BluetoothState> emit,
  ) {
    // Handle incoming game messages
    // This can be extended to update game state based on message type
  }

  Future<void> _onOpenSettings(
    BluetoothOpenSettingsEvent event,
    Emitter<BluetoothState> emit,
  ) async {
    await _bluetoothService.openAppSettings();
  }

  @override
  Future<void> close() {
    _messageSubscription?.cancel();
    _connectionSubscription?.cancel();
    _devicesSubscription?.cancel();
    return super.close();
  }
}
