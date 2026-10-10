import 'dart:convert';

import '../../../../core/date/local_date.dart';
import '../../../../core/date/local_time.dart';
import '../../../../core/result/failure.dart';
import '../../../../core/result/result.dart';
import '../../../habits/domain/entities/habit.dart';
import '../../../habits/domain/entities/habit_completion.dart';
import '../../../habits/domain/entities/habit_rule.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../shifts/domain/entities/rotation_pattern.dart';
import '../../../shifts/domain/entities/shift_override.dart';
import '../../../shifts/domain/entities/shift_type.dart';
import '../entities/backup_document.dart';

/// JSON encoding of [BackupDocument] (schema v1) with strict validation on
/// decode, so a damaged or foreign file never reaches the database.
abstract final class BackupCodec {
  static const String fileExtension = 'json';

  static String encode(BackupDocument doc) =>
      const JsonEncoder.withIndent('  ').convert(toJson(doc));

  static Result<BackupDocument> decode(String text) {
    final Object? raw;
    try {
      raw = jsonDecode(text);
    } on FormatException {
      return const Result.failure(ValidationFailure('not valid JSON'));
    }
    if (raw is! Map<String, Object?>) {
      return const Result.failure(ValidationFailure('root is not an object'));
    }
    try {
      return Result.success(fromJson(raw));
    } on _BackupFormatException catch (e) {
      return Result.failure(ValidationFailure(e.message, field: e.field));
    }
  }

  static Map<String, Object?> toJson(BackupDocument doc) => {
    'app': 'rytmavo',
    'schemaVersion': BackupDocument.schemaVersion,
    'exportedAt': doc.exportedAt.toUtc().toIso8601String(),
    'appVersion': doc.appVersion,
    'shiftTypes': [
      for (final t in doc.shiftTypes)
        {
          'id': t.id,
          'kind': t.kind.name,
          'name': t.name,
          'abbreviation': t.abbreviation,
          'color': t.colorValue,
          'start': t.start?.toIsoString(),
          'end': t.end?.toIsoString(),
          'sortOrder': t.sortOrder,
          'isArchived': t.isArchived,
        },
    ],
    'rotationPatterns': [
      for (final p in doc.rotationPatterns)
        {
          'id': p.id,
          'validFrom': p.validFrom.toIsoString(),
          'anchorDate': p.anchorDate.toIsoString(),
          'slots': p.slots,
        },
    ],
    'shiftOverrides': [
      for (final o in doc.shiftOverrides)
        {'date': o.date.toIsoString(), 'shiftTypeId': o.shiftTypeId},
    ],
    'habits': [
      for (final h in doc.habits)
        {
          'id': h.id,
          'name': h.name,
          'description': h.description,
          'iconKey': h.iconKey,
          'color': h.colorValue,
          'createdOn': h.createdOn.toIsoString(),
          'archivedOn': h.archivedOn?.toIsoString(),
          'sortOrder': h.sortOrder,
        },
    ],
    'habitRules': [
      for (final r in doc.habitRules)
        {
          'id': r.id,
          'habitId': r.habitId,
          'validFrom': r.validFrom.toIsoString(),
          'targetShiftTypeIds': r.targetShiftTypeIds.toList()..sort(),
          'weekdays': r.weekdays?.toList()?..sort(),
          'reminders': r.reminders?.map((k, v) => MapEntry(k, v.toIsoString())),
        },
    ],
    'habitCompletions': [
      for (final c in doc.habitCompletions)
        {
          'habitId': c.habitId,
          'date': c.date.toIsoString(),
          'completedAt': c.completedAt.toUtc().toIso8601String(),
        },
    ],
    'settings': {
      'themeMode': doc.settings.themeMode.name,
      'language': doc.settings.language.name,
      'onboardingCompleted': doc.settings.onboardingCompleted,
      'remindersEnabled': doc.settings.remindersEnabled,
      // Calendar ids are device-specific and deliberately not exported.
      'calendarConflictsEnabled': doc.settings.calendarConflictsEnabled,
      'conflictRemindersEnabled': doc.settings.conflictRemindersEnabled,
    },
  };

  static BackupDocument fromJson(Map<String, Object?> json) {
    final version = json['schemaVersion'];
    if (version is! int) {
      throw const _BackupFormatException('no schemaVersion');
    }
    if (version > BackupDocument.schemaVersion) {
      throw _BackupFormatException(
        'schema $version is newer than supported',
        field: 'schemaVersion',
      );
    }
    final shiftTypes = [
      for (final m in _list(json, 'shiftTypes'))
        ShiftType(
          id: _str(m, 'id'),
          kind: _enum(ShiftKind.values, m, 'kind'),
          name: _str(m, 'name', fallback: ''),
          abbreviation: _str(m, 'abbreviation', fallback: ''),
          colorValue: _int(m, 'color'),
          start: _timeOrNull(m, 'start'),
          end: _timeOrNull(m, 'end'),
          sortOrder: _int(m, 'sortOrder'),
          isArchived: m['isArchived'] == true,
        ),
    ];
    final typeIds = {for (final t in shiftTypes) t.id};
    if (typeIds.length != shiftTypes.length) {
      throw const _BackupFormatException('duplicate shift type id');
    }
    final patterns = [
      for (final m in _list(json, 'rotationPatterns'))
        RotationPattern(
          id: _str(m, 'id'),
          validFrom: _date(m, 'validFrom'),
          anchorDate: _date(m, 'anchorDate'),
          slots: _strList(m, 'slots', allowEmpty: false),
        ),
    ];
    for (final p in patterns) {
      for (final slot in p.slots) {
        if (!typeIds.contains(slot)) {
          throw _BackupFormatException(
            'rotation ${p.id} uses unknown shift type $slot',
            field: 'rotationPatterns',
          );
        }
      }
    }
    final overrides = [
      for (final m in _list(json, 'shiftOverrides'))
        ShiftOverride(
          date: _date(m, 'date'),
          shiftTypeId: _str(m, 'shiftTypeId'),
        ),
    ];
    for (final o in overrides) {
      if (!typeIds.contains(o.shiftTypeId)) {
        throw _BackupFormatException(
          'override ${o.date} uses unknown shift type ${o.shiftTypeId}',
          field: 'shiftOverrides',
        );
      }
    }
    final habits = [
      for (final m in _list(json, 'habits'))
        Habit(
          id: _str(m, 'id'),
          name: _str(m, 'name'),
          description: m['description'] is String
              ? m['description']! as String
              : null,
          iconKey: _str(m, 'iconKey', fallback: 'check'),
          colorValue: _int(m, 'color'),
          createdOn: _date(m, 'createdOn'),
          archivedOn: _dateOrNull(m, 'archivedOn'),
          sortOrder: _int(m, 'sortOrder'),
        ),
    ];
    final habitIds = {for (final h in habits) h.id};
    if (habitIds.length != habits.length) {
      throw const _BackupFormatException('duplicate habit id');
    }
    final rules = [
      for (final m in _list(json, 'habitRules'))
        HabitRule(
          id: _str(m, 'id'),
          habitId: _str(m, 'habitId'),
          validFrom: _date(m, 'validFrom'),
          targetShiftTypeIds: _strList(m, 'targetShiftTypeIds').toSet(),
          weekdays: _intSetOrNull(m, 'weekdays'),
          reminders: _remindersOrNull(m, 'reminders'),
        ),
    ];
    for (final r in rules) {
      if (!habitIds.contains(r.habitId)) {
        throw _BackupFormatException(
          'rule ${r.id} references unknown habit ${r.habitId}',
          field: 'habitRules',
        );
      }
    }
    final completions = [
      for (final m in _list(json, 'habitCompletions'))
        HabitCompletion(
          habitId: _str(m, 'habitId'),
          date: _date(m, 'date'),
          completedAt: _dateTime(m, 'completedAt'),
        ),
    ];
    for (final c in completions) {
      if (!habitIds.contains(c.habitId)) {
        throw _BackupFormatException(
          'completion references unknown habit ${c.habitId}',
          field: 'habitCompletions',
        );
      }
    }
    final settingsJson = json['settings'];
    final settings = settingsJson is Map<String, Object?>
        ? AppSettings(
            themeMode: _enumOr(
              AppThemeMode.values,
              settingsJson['themeMode'],
              AppSettings.defaults.themeMode,
            ),
            language: _enumOr(
              AppLanguage.values,
              settingsJson['language'],
              AppSettings.defaults.language,
            ),
            onboardingCompleted: settingsJson['onboardingCompleted'] == true,
            remindersEnabled: settingsJson['remindersEnabled'] == true,
            calendarConflictsEnabled:
                settingsJson['calendarConflictsEnabled'] == true,
            conflictRemindersEnabled:
                settingsJson['conflictRemindersEnabled'] == true,
          )
        : AppSettings.defaults;

    return BackupDocument(
      exportedAt: _dateTimeOr(json['exportedAt'], DateTime.utc(1970)),
      appVersion: json['appVersion'] is String
          ? json['appVersion']! as String
          : '',
      shiftTypes: shiftTypes,
      rotationPatterns: patterns,
      shiftOverrides: overrides,
      habits: habits,
      habitRules: rules,
      habitCompletions: completions,
      settings: settings,
    );
  }

  // --- field helpers -------------------------------------------------------

  static List<Map<String, Object?>> _list(Map<String, Object?> m, String key) {
    final v = m[key];
    if (v == null) return const [];
    if (v is! List) {
      throw _BackupFormatException('$key is not a list', field: key);
    }
    return [
      for (final e in v)
        if (e is Map<String, Object?>)
          e
        else
          throw _BackupFormatException(
            '$key contains a non-object',
            field: key,
          ),
    ];
  }

  static String _str(Map<String, Object?> m, String key, {String? fallback}) {
    final v = m[key];
    if (v is String) return v;
    if (v == null && fallback != null) return fallback;
    throw _BackupFormatException('$key missing or not a string', field: key);
  }

  static int _int(Map<String, Object?> m, String key) {
    final v = m[key];
    if (v is int) return v;
    throw _BackupFormatException('$key missing or not an integer', field: key);
  }

  static LocalDate _date(Map<String, Object?> m, String key) {
    final v = m[key];
    final d = v is String ? LocalDate.tryParse(v) : null;
    if (d == null) {
      throw _BackupFormatException('$key is not a date', field: key);
    }
    return d;
  }

  static LocalDate? _dateOrNull(Map<String, Object?> m, String key) =>
      m[key] == null ? null : _date(m, key);

  static LocalTime? _timeOrNull(Map<String, Object?> m, String key) {
    final v = m[key];
    if (v == null) return null;
    final t = v is String ? LocalTime.tryParse(v) : null;
    if (t == null) {
      throw _BackupFormatException('$key is not a time', field: key);
    }
    return t;
  }

  static DateTime _dateTime(Map<String, Object?> m, String key) {
    final v = m[key];
    final d = v is String ? DateTime.tryParse(v) : null;
    if (d == null) {
      throw _BackupFormatException('$key is not a timestamp', field: key);
    }
    return d;
  }

  static DateTime _dateTimeOr(Object? v, DateTime fallback) =>
      (v is String ? DateTime.tryParse(v) : null) ?? fallback;

  static List<String> _strList(
    Map<String, Object?> m,
    String key, {
    bool allowEmpty = true,
  }) {
    final v = m[key];
    if (v is! List || v.any((e) => e is! String)) {
      throw _BackupFormatException('$key is not a string list', field: key);
    }
    if (!allowEmpty && v.isEmpty) {
      throw _BackupFormatException('$key is empty', field: key);
    }
    return v.cast<String>();
  }

  static Set<int>? _intSetOrNull(Map<String, Object?> m, String key) {
    final v = m[key];
    if (v == null) return null;
    if (v is! List || v.any((e) => e is! int)) {
      throw _BackupFormatException('$key is not an integer list', field: key);
    }
    return v.cast<int>().toSet();
  }

  static Map<String, LocalTime>? _remindersOrNull(
    Map<String, Object?> m,
    String key,
  ) {
    final v = m[key];
    if (v == null) return null;
    if (v is! Map<String, Object?>) {
      throw _BackupFormatException('$key is not an object', field: key);
    }
    final result = <String, LocalTime>{};
    for (final e in v.entries) {
      final t = e.value is String
          ? LocalTime.tryParse(e.value! as String)
          : null;
      if (t == null) {
        throw _BackupFormatException('$key.${e.key} is not a time', field: key);
      }
      result[e.key] = t;
    }
    return result;
  }

  static T _enum<T extends Enum>(
    List<T> values,
    Map<String, Object?> m,
    String key,
  ) {
    final v = m[key];
    for (final e in values) {
      if (e.name == v) return e;
    }
    throw _BackupFormatException('$key has unknown value $v', field: key);
  }

  static T _enumOr<T extends Enum>(List<T> values, Object? v, T fallback) {
    for (final e in values) {
      if (e.name == v) return e;
    }
    return fallback;
  }
}

final class _BackupFormatException implements Exception {
  const _BackupFormatException(this.message, {this.field});

  final String message;
  final String? field;
}
