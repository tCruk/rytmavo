import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_setup.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/watch/domain/entities/watch_snapshot.dart';
import 'package:rytmavo/features/watch/domain/services/watch_snapshot_builder.dart';

void main() {
  const today = LocalDate(2026, 12, 28);

  WatchSnapshot build(ShiftSetup setup) => WatchSnapshotBuilder.build(
    setup: setup,
    today: today,
    nameOf: (s) => 'name:${s.id}',
    abbreviationOf: (s) => s.id.substring(0, 1).toUpperCase(),
  );

  ShiftSetup conti4({List<ShiftOverride> overrides = const []}) => ShiftSetup(
    types: ShiftType.defaults,
    patterns: [
      RotationPattern(
        id: 'p',
        validFrom: today,
        anchorDate: today,
        slots: RotationPreset.conti4.slots,
      ),
    ],
    overrides: overrides,
  );

  test('covers a two-week window across the year boundary', () {
    final days = build(conti4()).days;
    expect(days, hasLength(WatchSnapshotBuilder.windowDays));
    expect(days.first.date, today);
    expect(days.last.date, const LocalDate(2027, 1, 10));
    expect(days.map((d) => d.kind).take(8), [
      ShiftKind.early,
      ShiftKind.early,
      ShiftKind.late,
      ShiftKind.late,
      ShiftKind.night,
      ShiftKind.night,
      ShiftKind.off,
      ShiftKind.off,
    ]);
  });

  test('carries resolved labels, colour and times', () {
    final night = build(conti4()).days[4];
    expect(night.name, 'name:night');
    expect(night.abbreviation, 'N');
    expect(night.colorValue, 0xFF3B4A8C);
    expect(night.start, const LocalTime(22, 0));
    expect(night.end, const LocalTime(6, 0));
    expect(night.isOverride, isFalse);
  });

  test('marks overridden days', () {
    final days = build(
      conti4(
        overrides: [ShiftOverride(date: today.addDays(1), shiftTypeId: 'off')],
      ),
    ).days;
    expect(days[1].kind, ShiftKind.off);
    expect(days[1].isOverride, isTrue);
  });

  test('days without a rotation have no shift', () {
    final days = build(ShiftSetup.empty).days;
    expect(days.every((d) => !d.hasShift), isTrue);
  });

  test('serializes to the documented JSON shape', () {
    final json = build(conti4()).toJson();
    expect(json['v'], WatchSnapshot.formatVersion);
    final days = json['days']! as List<Object?>;
    expect(days.first, {
      'date': '2026-12-28',
      'kind': 'early',
      'name': 'name:early',
      'abbr': 'E',
      'color': 0xFF9A5E0B,
      'start': '06:00',
      'end': '14:00',
      'override': false,
    });
    expect((build(ShiftSetup.empty).toJson()['days']! as List<Object?>).first, {
      'date': '2026-12-28',
      'kind': 'none',
    });
  });
}
