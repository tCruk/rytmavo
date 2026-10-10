import '../../../../core/date/local_date.dart';
import '../../../../core/date/local_time.dart';

/// One version of a habit's due rule. The version in effect on a day is the
/// one with the greatest `validFrom <= day`, so editing a habit never
/// changes how past days are judged.
final class HabitRule {
  HabitRule({
    required this.id,
    required this.habitId,
    required this.validFrom,
    required Set<String> targetShiftTypeIds,
    Set<int>? weekdays,
    Map<String, LocalTime>? reminders,
  }) : targetShiftTypeIds = Set.unmodifiable(targetShiftTypeIds),
       weekdays = weekdays == null ? null : Set.unmodifiable(weekdays),
       reminders = reminders == null ? null : Map.unmodifiable(reminders);

  final String id;
  final String habitId;
  final LocalDate validFrom;

  /// Shift type ids on which the habit is due. Empty = every day,
  /// whatever the shift (also days without a resolved shift).
  final Set<String> targetShiftTypeIds;

  /// ISO weekdays (1 = Monday … 7 = Sunday) that additionally restrict
  /// due days, or `null` for no restriction.
  final Set<int>? weekdays;

  /// Reminder time per shift type id (Phase 4), or `null`.
  final Map<String, LocalTime>? reminders;

  bool get appliesToEveryShift => targetShiftTypeIds.isEmpty;

  /// Whether the rule makes the habit due on a day with [shiftTypeId]
  /// (`null` = no shift resolved) and ISO [weekday].
  bool matches({required String? shiftTypeId, required int weekday}) {
    if (weekdays != null && !weekdays!.contains(weekday)) return false;
    if (appliesToEveryShift) return true;
    return shiftTypeId != null && targetShiftTypeIds.contains(shiftTypeId);
  }

  HabitRule copyWith({
    String? id,
    LocalDate? validFrom,
    Set<String>? targetShiftTypeIds,
    Set<int>? weekdays,
    bool clearWeekdays = false,
    Map<String, LocalTime>? reminders,
    bool clearReminders = false,
  }) {
    return HabitRule(
      id: id ?? this.id,
      habitId: habitId,
      validFrom: validFrom ?? this.validFrom,
      targetShiftTypeIds: targetShiftTypeIds ?? this.targetShiftTypeIds,
      weekdays: clearWeekdays ? null : weekdays ?? this.weekdays,
      reminders: clearReminders ? null : reminders ?? this.reminders,
    );
  }

  /// True when the rule content (not id/validFrom) is identical.
  bool sameTermsAs(HabitRule other) =>
      _setEquals(targetShiftTypeIds, other.targetShiftTypeIds) &&
      _setEquals(weekdays, other.weekdays) &&
      _mapEquals(reminders, other.reminders);

  @override
  bool operator ==(Object other) =>
      other is HabitRule &&
      other.id == id &&
      other.habitId == habitId &&
      other.validFrom == validFrom &&
      sameTermsAs(other);

  @override
  int get hashCode => Object.hash(
    id,
    habitId,
    validFrom,
    Object.hashAllUnordered(targetShiftTypeIds),
    weekdays == null ? null : Object.hashAllUnordered(weekdays!),
    reminders?.length,
  );

  @override
  String toString() =>
      'HabitRule($id, $habitId, from $validFrom, $targetShiftTypeIds)';
}

bool _setEquals<T>(Set<T>? a, Set<T>? b) {
  if (a == null || b == null) return a == b;
  return a.length == b.length && a.containsAll(b);
}

bool _mapEquals<K, V>(Map<K, V>? a, Map<K, V>? b) {
  if (a == null || b == null) return a == b;
  if (a.length != b.length) return false;
  for (final e in a.entries) {
    if (b[e.key] != e.value) return false;
  }
  return true;
}
