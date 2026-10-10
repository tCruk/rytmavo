import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_time.dart';

void main() {
  test('LocalTime parses, formats and compares', () {
    final t = LocalTime.parse('6:05');
    expect(t, const LocalTime(6, 5));
    expect(t.toIsoString(), '06:05');
    expect(t.minutesSinceMidnight, 365);
    expect(LocalTime.fromMinutes(365), t);
    expect(LocalTime.fromMinutes(24 * 60 + 5), const LocalTime(0, 5));
    expect(const LocalTime(22, 0).compareTo(const LocalTime(6, 0)) > 0, isTrue);
    expect(() => LocalTime.parse('24:00'), throwsFormatException);
    expect(() => LocalTime.parse('12:60'), throwsFormatException);
    expect(() => LocalTime.parse('noon'), throwsFormatException);
  });
}
