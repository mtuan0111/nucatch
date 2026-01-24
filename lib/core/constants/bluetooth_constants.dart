class BluetoothConstants {
  // BLE Service and Characteristic UUIDs
  static const String chatServiceUuid = '0000FFF0-0000-1000-8000-00805F9B34FB';
  static const String roomCodeCharUuid = '0000FFF2-0000-1000-8000-00805F9B34FB';
  static const String messageTxCharUuid =
      '0000FFF1-0000-1000-8000-00805F9B34FB';
  static const String messageRxCharUuid =
      '0000FFF3-0000-1000-8000-00805F9B34FB';
  static const String statusCharUuid = '0000FFF4-0000-1000-8000-00805F9B34FB';

  // BLE Configuration
  static const int maxMtuSize = 512;
  static const int chunkSize = 480; // Leave room for headers
  static const Duration scanDuration = Duration(seconds: 10);
  static const Duration connectionTimeout = Duration(seconds: 15);

  // Device identification
  static const String deviceNamePrefix = 'ChatApp';
  static const int roomCodeLength = 4;

  // User display name for connection
  static const String defaultUserName = 'Anonymous';
}
