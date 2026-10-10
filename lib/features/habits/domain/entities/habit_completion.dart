import '../../../../core/date/local_date.dart';

/// The user ticked [habitId] off on [date]. At most one per habit and day.
final class HabitCompletion {
  const HabitCompletion({
    required this.habitId,
    required this.date,
    required this.completedAt,
  });

  final String habitId;
  final LocalDate date;
  final DateTime completedAt;

  @override
  bool operator ==(Object other) =>
      other is HabitCompletion &&
      other.habitId == habitId &&
      other.date == date &&
      other.completedAt == completedAt;

  @override
  int get hashCode => Object.hash(habitId, date, completedAt);
}
