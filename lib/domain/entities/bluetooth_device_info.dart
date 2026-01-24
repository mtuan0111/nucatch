class BluetoothDeviceInfo {
  final String id;
  final String name;
  final int rssi;

  const BluetoothDeviceInfo({
    required this.id,
    required this.name,
    required this.rssi,
  });

  String get roomCode {
    // Extract room code from device name (e.g., "ChatApp-5599" -> "5599")
    if (name.contains('-')) {
      return name.split('-').last;
    }
    return '';
  }

  String get signalStrength {
    if (rssi >= -50) return 'Strong';
    if (rssi >= -70) return 'Medium';
    return 'Weak';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BluetoothDeviceInfo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          rssi == other.rssi;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ rssi.hashCode;
}
