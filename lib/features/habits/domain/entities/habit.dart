import '../../../../core/date/local_date.dart';

/// A habit the user wants to keep on certain shifts.
final class Habit {
  const Habit({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.colorValue,
    required this.createdOn,
    required this.sortOrder,
    this.description,
    this.archivedOn,
  });

  final String id;
  final String name;
  final String? description;

  /// Key into [HabitIcons] (presentation); the domain stays Flutter-free.
  final String iconKey;
  final int colorValue;

  /// The habit is never due before this day.
  final LocalDate createdOn;

  /// From this day on (inclusive) the habit is archived, or `null`.
  final LocalDate? archivedOn;
  final int sortOrder;

  bool isArchivedOn(LocalDate date) =>
      archivedOn != null && !archivedOn!.isAfter(date);

  /// Archived as of today → hidden from the list and never due again.
  bool get isArchived => archivedOn != null;

  Habit copyWith({
    String? name,
    String? description,
    bool clearDescription = false,
    String? iconKey,
    int? colorValue,
    LocalDate? archivedOn,
    bool clearArchived = false,
    int? sortOrder,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: clearDescription ? null : description ?? this.description,
      iconKey: iconKey ?? this.iconKey,
      colorValue: colorValue ?? this.colorValue,
      createdOn: createdOn,
      archivedOn: clearArchived ? null : archivedOn ?? this.archivedOn,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Habit &&
      other.id == id &&
      other.name == name &&
      other.description == description &&
      other.iconKey == iconKey &&
      other.colorValue == colorValue &&
      other.createdOn == createdOn &&
      other.archivedOn == archivedOn &&
      other.sortOrder == sortOrder;

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    iconKey,
    colorValue,
    createdOn,
    archivedOn,
    sortOrder,
  );

  @override
  String toString() => 'Habit($id, $name)';
}
