import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';

void main() {
  group('LocalDate', () {
    test('parses and formats ISO dates', () {
      final d = LocalDate.parse('2026-02-28');
      expect(d, const LocalDate(2026, 2, 28));
      expect(d.toIsoString(), '2026-02-28');
      expect(const LocalDate(800, 1, 5).toIsoString(), '0800-01-05');
    });

    test('rejects invalid or non-existent dates', () {
      expect(() => LocalDate.parse('2025-02-29'), throwsFormatException);
      expect(() => LocalDate.parse('2025-13-01'), throwsFormatException);
      expect(() => LocalDate.parse('2025-1-1'), throwsFormatException);
      expect(() => LocalDate.parse('garbage'), throwsFormatException);
      expect(LocalDate.tryParse('2025-04-31'), isNull);
      expect(LocalDate.tryParse('2024-02-29'), const LocalDate(2024, 2, 29));
    });

    test('leap years', () {
      expect(LocalDate.isLeap(2024), isTrue);
      expect(LocalDate.isLeap(2100), isFalse);
      expect(LocalDate.isLeap(2000), isTrue);
      expect(LocalDate.isLeap(2026), isFalse);
      expect(LocalDate.daysInMonth(2024, 2), 29);
      expect(LocalDate.daysInMonth(2025, 2), 28);
    });

    test('addDays crosses month, year and 29 February', () {
      expect(
        const LocalDate(2024, 2, 28).addDays(1),
        const LocalDate(2024, 2, 29),
      );
      expect(
        const LocalDate(2024, 2, 29).addDays(1),
        const LocalDate(2024, 3, 1),
      );
      expect(
        const LocalDate(2025, 12, 31).addDays(1),
        const LocalDate(2026, 1, 1),
      );
      expect(
        const LocalDate(2026, 1, 1).addDays(-1),
        const LocalDate(2025, 12, 31),
      );
      expect(
        const LocalDate(2026, 3, 1).addDays(-1),
        const LocalDate(2026, 2, 28),
      );
    });

    test('daysSince is a whole calendar-day difference, also negative', () {
      const a = LocalDate(2026, 3, 29); // DST switch in Europe
      const b = LocalDate(2026, 3, 30);
      expect(b.daysSince(a), 1);
      expect(a.daysSince(b), -1);
      expect(
        const LocalDate(2025, 1, 1).daysSince(const LocalDate(2024, 1, 1)),
        366,
      );
      expect(
        const LocalDate(2026, 1, 1).daysSince(const LocalDate(2025, 1, 1)),
        365,
      );
    });

    test('addMonths clamps the day', () {
      expect(
        const LocalDate(2026, 1, 31).addMonths(1),
        const LocalDate(2026, 2, 28),
      );
      expect(
        const LocalDate(2026, 12, 15).addMonths(1),
        const LocalDate(2027, 1, 15),
      );
      expect(
        const LocalDate(2026, 1, 15).addMonths(-1),
        const LocalDate(2025, 12, 15),
      );
      expect(
        const LocalDate(2026, 1, 15).addMonths(-13),
        const LocalDate(2024, 12, 15),
      );
    });

    test('weekday follows ISO numbering', () {
      expect(const LocalDate(2026, 10, 10).weekday, DateTime.saturday);
      expect(const LocalDate(2026, 10, 12).weekday, DateTime.monday);
      expect(const LocalDate(2026, 10, 11).weekday, DateTime.sunday);
    });

    test('ordering and equality', () {
      const earlier = LocalDate(2026, 1, 31);
      const later = LocalDate(2026, 2, 1);
      expect(earlier.isBefore(later), isTrue);
      expect(later.isAfter(earlier), isTrue);
      expect(earlier == LocalDate.parse('2026-01-31'), isTrue);
      expect(earlier.hashCode, LocalDate.parse('2026-01-31').hashCode);
      final sorted = [later, earlier]..sort();
      expect(sorted, [earlier, later]);
    });

    test('fromDateTime ignores time and zone', () {
      final d = LocalDate.fromDateTime(DateTime(2026, 10, 10, 23, 59));
      expect(d, const LocalDate(2026, 10, 10));
      expect(
        LocalDate.fromDateTime(DateTime.utc(2026, 10, 10, 0, 30)),
        const LocalDate(2026, 10, 10),
      );
    });

    test('month helpers', () {
      const d = LocalDate(2026, 2, 14);
      expect(d.firstDayOfMonth, const LocalDate(2026, 2, 1));
      expect(d.lastDayOfMonth, const LocalDate(2026, 2, 28));
      expect(d.lengthOfMonth, 28);
      expect(d.isSameMonth(const LocalDate(2026, 2, 1)), isTrue);
      expect(d.isSameMonth(const LocalDate(2025, 2, 1)), isFalse);
    });
  });

  group('floorMod', () {
    test('is non-negative for negative values', () {
      expect(floorMod(-1, 8), 7);
      expect(floorMod(-8, 8), 0);
      expect(floorMod(-9, 8), 7);
      expect(floorMod(0, 8), 0);
      expect(floorMod(9, 8), 1);
      expect(floorMod(5, 1), 0);
    });
  });
}
