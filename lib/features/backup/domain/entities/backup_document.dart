import '../../../habits/domain/entities/habit.dart';
import '../../../habits/domain/entities/habit_completion.dart';
import '../../../habits/domain/entities/habit_rule.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../shifts/domain/entities/rotation_pattern.dart';
import '../../../shifts/domain/entities/shift_override.dart';
import '../../../shifts/domain/entities/shift_type.dart';

/// Everything the app stores, as one portable snapshot. Backup schema v1.
final class BackupDocument {
  const BackupDocument({
    required this.exportedAt,
    required this.appVersion,
    required this.shiftTypes,
    required this.rotationPatterns,
    required this.shiftOverrides,
    required this.habits,
    required this.habitRules,
    required this.habitCompletions,
    required this.settings,
  });

  static const int schemaVersion = 1;

  final DateTime exportedAt;
  final String appVersion;
  final List<ShiftType> shiftTypes;
  final List<RotationPattern> rotationPatterns;
  final List<ShiftOverride> shiftOverrides;
  final List<Habit> habits;
  final List<HabitRule> habitRules;
  final List<HabitCompletion> habitCompletions;
  final AppSettings settings;

  bool get isEmpty =>
      shiftTypes.isEmpty &&
      rotationPatterns.isEmpty &&
      habits.isEmpty &&
      habitCompletions.isEmpty;
}
