import '../entities/bluetooth_device_info.dart';

abstract class BluetoothRepository {
  Stream<List<BluetoothDeviceInfo>> get devicesStream;
  Stream<Map<String, dynamic>> get connectionRequestStream;
  Stream<Map<String, dynamic>> get incomingDataStream;

  Future<void> startAdvertising(String roomCode, String userName);
  Future<void> stopAdvertising();
  Future<void> startDiscovery(String userName);
  Future<void> stopDiscovery();
  Future<void> requestConnection(String endpointId, String userName);
  Future<void> acceptConnection(String endpointId);
  Future<void> rejectConnection(String endpointId);
  Future<void> disconnect();
  Future<void> sendData(Map<String, dynamic> data);
  Future<bool> requestPermissions();
  Future<String> getDeviceName();
  String? get hostRoomCode;
}
