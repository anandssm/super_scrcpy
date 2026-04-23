class AdbDevice {
  final String serial;
  final String state;
  final String? model;
  final String? product;
  final String? transportId;
  final bool isWifi;

  AdbDevice({
    required this.serial,
    required this.state,
    this.model,
    this.product,
    this.transportId,
    bool? isWifi,
  }) : isWifi = isWifi ?? serial.contains(':');

  String get displayName {
    if (model != null && model!.isNotEmpty) {
      return model!.replaceAll('_', ' ');
    }
    return serial;
  }

  String get connectionType => isWifi ? 'Wi-Fi' : 'USB';

  bool get isOnline => state == 'device';
  bool get isUnauthorized => state == 'unauthorized';
  bool get isOffline => state == 'offline';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AdbDevice &&
          runtimeType == other.runtimeType &&
          serial == other.serial;

  @override
  int get hashCode => serial.hashCode;

  @override
  String toString() => 'AdbDevice($serial, $state, $model)';
}
