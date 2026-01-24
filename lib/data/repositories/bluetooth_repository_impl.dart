import '../../domain/entities/bluetooth_device_info.dart';
import '../../domain/repositories/bluetooth_repository.dart';
import '../datasources/ble_data_source.dart';

class BluetoothRepositoryImpl implements BluetoothRepository {
  final BleDataSource dataSource;

  BluetoothRepositoryImpl({required this.dataSource});

  @override
  Stream<List<BluetoothDeviceInfo>> get devicesStream =>
      dataSource.devicesStream;

  @override
  Stream<Map<String, dynamic>> get connectionRequestStream =>
      dataSource.connectionRequestStream.map(
        (request) => {
          'type': 'connection_request',
          'endpointId': request.deviceId,
          'endpointName': request.deviceName,
          'authenticationToken': request.authenticationToken,
        },
      );

  @override
  Stream<Map<String, dynamic>> get incomingDataStream =>
      dataSource.incomingDataStream;

  @override
  Future<void> startAdvertising(String roomCode, String userName) {
    return dataSource.startAdvertising(roomCode, userName);
  }

  @override
  Future<void> stopAdvertising() {
    return dataSource.stopAdvertising();
  }

  @override
  Future<void> startDiscovery(String userName) {
    return dataSource.startDiscovery(userName);
  }

  @override
  Future<void> stopDiscovery() {
    return dataSource.stopDiscovery();
  }

  @override
  Future<void> requestConnection(String endpointId, String userName) {
    return dataSource.requestConnection(endpointId, userName);
  }

  @override
  Future<void> acceptConnection(String endpointId) {
    return dataSource.acceptConnection(endpointId);
  }

  @override
  Future<void> rejectConnection(String endpointId) {
    return dataSource.rejectConnection(endpointId);
  }

  @override
  Future<void> disconnect() {
    return dataSource.disconnect();
  }

  @override
  Future<void> sendData(Map<String, dynamic> data) {
    return dataSource.sendData(data);
  }

  @override
  Future<bool> requestPermissions() {
    return dataSource.requestPermissions();
  }

  @override
  Future<String> getDeviceName() {
    return dataSource.getDeviceName();
  }

  @override
  String? get hostRoomCode => dataSource.hostRoomCode;
}
