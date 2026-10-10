import 'local_date.dart';

/// Source of "now". Injected so that every date-dependent calculation is
/// deterministic in tests.
abstract interface class Clock {
  DateTime now();

  LocalDate today() => LocalDate.fromDateTime(now());
}

/// Uses the device clock in the device's local time zone.
final class SystemClock implements Clock {
  const SystemClock();

  @override
  DateTime now() => DateTime.now();

  @override
  LocalDate today() => LocalDate.fromDateTime(now());
}

/// A clock frozen at a fixed instant – for tests and previews.
final class FixedClock implements Clock {
  const FixedClock(this._now);

  final DateTime _now;

  @override
  DateTime now() => _now;

  @override
  LocalDate today() => LocalDate.fromDateTime(_now);
}
