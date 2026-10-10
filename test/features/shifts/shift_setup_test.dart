import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/scheduled_day.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_setup.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

void main() {
  const anchor = LocalDate(2026, 3, 2); // a Monday
  final conti = RotationPattern(
    id: 'p1',
    validFrom: RotationRules.firstVersionValidFrom,
    anchorDate: anchor,
    slots: RotationPreset.conti4.slots, // EE LL NN OO
  );

  ShiftSetup setup({
    List<RotationPattern>? patterns,
    List<ShiftOverride> overrides = const [],
  }) => ShiftSetup(
    types: ShiftType.defaults,
    patterns: patterns ?? [conti],
    overrides: overrides,
  );

  String? idOn(ShiftSetup s, LocalDate d) => s.dayOn(d).shift?.id;

  group('rotation lookup', () {
    test('anchor day is slot 0 and the cycle repeats', () {
      final s = setup();
      expect(idOn(s, anchor), 'early');
      expect(idOn(s, anchor.addDays(2)), 'late');
      expect(idOn(s, anchor.addDays(4)), 'night');
      expect(idOn(s, anchor.addDays(7)), 'off');
      expect(idOn(s, anchor.addDays(8)), 'early');
      expect(idOn(s, anchor.addDays(8 * 50 + 5)), 'night');
    });

    test('days before the anchor wrap around (no negative index)', () {
      final s = setup();
      expect(idOn(s, anchor.addDays(-1)), 'off');
      expect(idOn(s, anchor.addDays(-3)), 'night');
      expect(idOn(s, anchor.addDays(-8)), 'early');
      expect(idOn(s, anchor.addDays(-801)), 'off');
    });

    test('is stable across DST, leap day and year boundary', () {
      final s = setup();
      // 2026-03-29 is the spring DST switch in the EU.
      for (final d in [
        const LocalDate(2026, 3, 29),
        const LocalDate(2026, 10, 25),
        const LocalDate(2028, 2, 29),
        const LocalDate(2026, 12, 31),
        const LocalDate(2027, 1, 1),
      ]) {
        final expected = conti.slots[floorMod(d.daysSince(anchor), 8)];
        expect(idOn(s, d), expected, reason: '$d');
      }
      // Consecutive days never skip or repeat a slot across the year end.
      final dec31 = conti.positionOf(const LocalDate(2026, 12, 31));
      final jan1 = conti.positionOf(const LocalDate(2027, 1, 1));
      expect(jan1, (dec31 + 1) % 8);
    });

    test('without any rotation every day resolves to none', () {
      final s = setup(patterns: []);
      final day = s.dayOn(anchor);
      expect(day.source, ShiftSource.none);
      expect(day.shift, isNull);
      expect(s.hasRotation, isFalse);
    });
  });

  group('versioned rotations', () {
    const change = LocalDate(2026, 6, 1);
    final weekly = RotationPattern(
      id: 'p2',
      validFrom: change,
      anchorDate: change,
      slots: RotationPreset.weekly2.slots,
    );

    test('a new version applies from its validFrom, history is kept', () {
      final s = setup(patterns: [weekly, conti]);
      final before = change.addDays(-1);
      expect(s.patternOn(before), conti);
      expect(idOn(s, before), conti.shiftIdOn(before));
      expect(s.patternOn(change), weekly);
      expect(idOn(s, change), 'early');
      expect(idOn(s, change.addDays(5)), 'off');
      expect(s.currentPattern, weekly);
    });

    test('days before the first version have no shift', () {
      final late = RotationPattern(
        id: 'p3',
        validFrom: change,
        anchorDate: change,
        slots: const ['early'],
      );
      final s = setup(patterns: [late]);
      expect(s.dayOn(change.addDays(-1)).source, ShiftSource.none);
      expect(s.dayOn(change).source, ShiftSource.rotation);
    });
  });

  group('overrides', () {
    test('override wins and remembers the rotation shift', () {
      final s = setup(
        overrides: [const ShiftOverride(date: anchor, shiftTypeId: 'night')],
      );
      final day = s.dayOn(anchor);
      expect(day.shift?.id, 'night');
      expect(day.source, ShiftSource.override);
      expect(day.rotationShift?.id, 'early');
      expect(day.isOverridden, isTrue);
      // Neighbouring days are unaffected.
      expect(idOn(s, anchor.addDays(1)), 'early');
    });

    test('override also applies where no rotation exists', () {
      final s = setup(
        patterns: [],
        overrides: [const ShiftOverride(date: anchor, shiftTypeId: 'late')],
      );
      expect(s.dayOn(anchor).shift?.id, 'late');
      expect(s.dayOn(anchor).rotationShift, isNull);
    });

    test('override with an unknown type falls back to the rotation', () {
      final s = setup(
        overrides: [const ShiftOverride(date: anchor, shiftTypeId: 'gone')],
      );
      expect(s.dayOn(anchor).source, ShiftSource.rotation);
    });
  });

  group('helpers', () {
    test('daysFrom returns consecutive days', () {
      final days = setup().daysFrom(anchor, 10);
      expect(days.map((d) => d.shift?.id), [
        ...RotationPreset.conti4.slots,
        'early',
        'early',
      ]);
      expect(days.last.date, anchor.addDays(9));
    });

    test('nextWorkDayAfter skips days off', () {
      final s = setup();
      final off = anchor.addDays(6); // first day off
      expect(s.nextWorkDayAfter(off)?.date, anchor.addDays(8));
    });

    test('night shift crosses midnight, day shifts do not', () {
      final night = ShiftType.defaults.firstWhere((t) => t.id == 'night');
      final early = ShiftType.defaults.firstWhere((t) => t.id == 'early');
      expect(night.crossesMidnight, isTrue);
      expect(night.durationMinutes, 8 * 60);
      expect(early.crossesMidnight, isFalse);
      expect(early.durationMinutes, 8 * 60);
      final off = ShiftType.defaults.firstWhere((t) => t.id == 'off');
      expect(off.hasTimes, isFalse);
      expect(off.durationMinutes, isNull);
      final short = early.copyWith(
        start: const LocalTime(23, 0),
        end: const LocalTime(23, 0),
      );
      expect(short.crossesMidnight, isTrue);
      expect(short.durationMinutes, 24 * 60);
    });
  });

  group('RotationRules', () {
    final known = {'early', 'late', 'night', 'off'};

    test('accepts every preset', () {
      for (final p in RotationPreset.values) {
        expect(RotationRules.validate(p.slots, known), isNull, reason: p.name);
      }
    });

    test('rejects empty, too long and unknown ids', () {
      expect(RotationRules.validate([], known), isNotNull);
      expect(
        RotationRules.validate(
          List.filled(RotationRules.maxCycleLength + 1, 'off'),
          known,
        ),
        isNotNull,
      );
      expect(RotationRules.validate(['early', 'x'], known), isNotNull);
    });

    test('anchorFor puts today on the chosen position', () {
      const today = LocalDate(2026, 10, 10);
      final anchorDate = RotationRules.anchorFor(
        today: today,
        todayPosition: 3,
      );
      final p = RotationPattern(
        id: 'x',
        validFrom: today,
        anchorDate: anchorDate,
        slots: RotationPreset.conti4.slots,
      );
      expect(p.positionOf(today), 3);
    });
  });
}
