import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/core/result/failure.dart';
import 'package:rytmavo/core/result/result.dart';
import 'package:rytmavo/features/backup/domain/entities/backup_document.dart';
import 'package:rytmavo/features/backup/domain/services/backup_codec.dart';
import 'package:rytmavo/features/habits/domain/entities/habit.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_completion.dart';
import 'package:rytmavo/features/habits/domain/entities/habit_rule.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';

BackupDocument sampleDocument() => BackupDocument(
  exportedAt: DateTime.utc(2026, 10, 10, 12),
  appVersion: '0.1.0+1',
  shiftTypes: ShiftType.defaults,
  rotationPatterns: [
    RotationPattern(
      id: 'p1',
      validFrom: const LocalDate(2000, 1, 1),
      anchorDate: const LocalDate(2026, 9, 28),
      slots: const ['early', 'early', 'off', 'late', 'late', 'off', 'off'],
    ),
  ],
  shiftOverrides: const [
    ShiftOverride(date: LocalDate(2026, 10, 3), shiftTypeId: 'night'),
  ],
  habits: const [
    Habit(
      id: 'h1',
      name: 'Wasser',
      description: '2 l',
      iconKey: 'water',
      colorValue: 0xFF112233,
      createdOn: LocalDate(2026, 10, 1),
      archivedOn: LocalDate(2026, 10, 9),
      sortOrder: 0,
    ),
  ],
  habitRules: [
    HabitRule(
      id: 'r1',
      habitId: 'h1',
      validFrom: const LocalDate(2026, 10, 1),
      targetShiftTypeIds: const {'early', 'late'},
      weekdays: const {1, 3, 5},
      reminders: const {'early': LocalTime(7, 30), '*': LocalTime(20, 0)},
    ),
  ],
  habitCompletions: [
    HabitCompletion(
      habitId: 'h1',
      date: const LocalDate(2026, 10, 2),
      completedAt: DateTime.utc(2026, 10, 2, 8, 15),
    ),
  ],
  settings: const AppSettings(
    themeMode: AppThemeMode.dark,
    language: AppLanguage.en,
    onboardingCompleted: true,
    remindersEnabled: true,
  ),
);

void main() {
  group('BackupCodec', () {
    test('round-trips every table through JSON', () {
      final doc = sampleDocument();
      final result = BackupCodec.decode(BackupCodec.encode(doc));
      final back = switch (result) {
        Success(:final value) => value,
        Error(:final failure) => fail('decode failed: $failure'),
      };

      expect(back.exportedAt, doc.exportedAt);
      expect(back.appVersion, doc.appVersion);
      expect(back.shiftTypes.map((t) => t.id), [
        'early',
        'late',
        'night',
        'off',
      ]);
      expect(back.shiftTypes.first.start, const LocalTime(6, 0));
      expect(
        back.rotationPatterns.single.slots,
        doc.rotationPatterns.single.slots,
      );
      expect(back.shiftOverrides.single.shiftTypeId, 'night');
      expect(back.habits.single.archivedOn, const LocalDate(2026, 10, 9));
      expect(back.habits.single.description, '2 l');
      final rule = back.habitRules.single;
      expect(rule.targetShiftTypeIds, {'early', 'late'});
      expect(rule.weekdays, {1, 3, 5});
      expect(rule.reminders, {
        'early': const LocalTime(7, 30),
        '*': const LocalTime(20, 0),
      });
      expect(
        back.habitCompletions.single.completedAt,
        DateTime.utc(2026, 10, 2, 8, 15),
      );
      expect(back.settings.themeMode, AppThemeMode.dark);
      expect(back.settings.language, AppLanguage.en);
      expect(back.settings.remindersEnabled, isTrue);
    });

    test('writes a stable header', () {
      final json = BackupCodec.toJson(sampleDocument());
      expect(json['app'], 'rytmavo');
      expect(json['schemaVersion'], 1);
      expect(json['exportedAt'], '2026-10-10T12:00:00.000Z');
    });

    test('rejects non-JSON and non-object roots', () {
      expect(BackupCodec.decode('nope'), isA<Error<BackupDocument>>());
      expect(BackupCodec.decode('[1, 2]'), isA<Error<BackupDocument>>());
    });

    test('rejects newer schema versions', () {
      final result = BackupCodec.decode('{"schemaVersion": 99}');
      expect(result, isA<Error<BackupDocument>>());
      final failure = (result as Error<BackupDocument>).failure;
      expect(failure, isA<ValidationFailure>());
      expect((failure as ValidationFailure).field, 'schemaVersion');
    });

    Result<BackupDocument> decodeWith(
      void Function(Map<String, Object?> json) mutate,
    ) {
      final json = BackupCodec.toJson(sampleDocument());
      mutate(json);
      return BackupCodec.decode(jsonEncode(json));
    }

    test('rejects dangling references', () {
      expect(
        decodeWith(
          (j) => j['shiftOverrides'] = [
            {'date': '2026-10-03', 'shiftTypeId': 'ghost'},
          ],
        ),
        isA<Error<BackupDocument>>(),
      );
      expect(
        decodeWith(
          (j) => j['habitCompletions'] = [
            {
              'habitId': 'ghost',
              'date': '2026-10-02',
              'completedAt': '2026-10-02T08:15:00.000Z',
            },
          ],
        ),
        isA<Error<BackupDocument>>(),
      );
    });

    Map<String, Object?> firstOf(Map<String, Object?> json, String key) =>
        (json[key]! as List).first as Map<String, Object?>;

    test('rejects malformed field types', () {
      expect(
        decodeWith((j) => firstOf(j, 'habits')['color'] = 'red'),
        isA<Error<BackupDocument>>(),
      );
      expect(
        decodeWith(
          (j) => firstOf(j, 'rotationPatterns')['validFrom'] = 'gestern',
        ),
        isA<Error<BackupDocument>>(),
      );
      expect(
        decodeWith((j) => j['habits'] = 'not a list'),
        isA<Error<BackupDocument>>(),
      );
    });

    test('tolerates missing optional sections', () {
      final result = BackupCodec.decode('{"schemaVersion": 1}');
      final doc = (result as Success<BackupDocument>).value;
      expect(doc.isEmpty, isTrue);
      expect(doc.settings, AppSettings.defaults);
    });
  });
}
