/// A calendar on the device (e.g. "Privat", "Arbeit", a Google account).
final class DeviceCalendarInfo {
  const DeviceCalendarInfo({
    required this.id,
    required this.name,
    this.accountName,
    this.colorValue,
  });

  final String id;
  final String name;

  /// Account or source the calendar belongs to, if the OS reports one.
  final String? accountName;

  /// 32-bit ARGB colour as shown by the OS calendar app.
  final int? colorValue;

  @override
  bool operator ==(Object other) =>
      other is DeviceCalendarInfo &&
      other.id == id &&
      other.name == name &&
      other.accountName == accountName &&
      other.colorValue == colorValue;

  @override
  int get hashCode => Object.hash(id, name, accountName, colorValue);

  @override
  String toString() => 'DeviceCalendarInfo($id, $name)';
}
