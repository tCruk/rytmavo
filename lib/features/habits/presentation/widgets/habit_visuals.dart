import 'package:flutter/material.dart';

import '../../../../core/ui/tokens/tokens.dart';
import '../../domain/entities/habit.dart';

/// Icon catalogue for habits. Keys are stored in the database, so entries
/// may be added but never renamed or removed.
abstract final class HabitIcons {
  static const Map<String, IconData> all = {
    'check': Icons.check_circle_outline,
    'walk': Icons.directions_walk,
    'run': Icons.directions_run,
    'bike': Icons.directions_bike,
    'gym': Icons.fitness_center,
    'water': Icons.water_drop_outlined,
    'food': Icons.restaurant_outlined,
    'sleep': Icons.bedtime_outlined,
    'book': Icons.menu_book_outlined,
    'meditate': Icons.self_improvement,
    'medication': Icons.medication_outlined,
    'family': Icons.family_restroom,
    'music': Icons.music_note_outlined,
    'nature': Icons.park_outlined,
    'home': Icons.home_outlined,
    'money': Icons.savings_outlined,
    'phone': Icons.phone_outlined,
    'write': Icons.edit_note,
  };

  static const String defaultKey = 'check';

  static IconData of(String key) => all[key] ?? all[defaultKey]!;
}

/// Colour choices for habits (ARGB). Paired with white or black text by
/// contrast, see [habitForeground].
abstract final class HabitColors {
  static const List<int> all = [
    0xFF2E7D4F, // green
    0xFF1E6FB5, // blue
    0xFF6D4FB3, // violet
    0xFFB4473C, // terracotta
    0xFF9A5E0B, // ochre
    0xFF0F7F86, // teal
    0xFFB03A6E, // berry
    0xFF4E5D6C, // slate
  ];

  static const int defaultValue = 0xFF2E7D4F;
}

Color habitForeground(Color background) {
  final white = contrastRatio(background, const Color(0xFFFFFFFF));
  final black = contrastRatio(background, const Color(0xFF000000));
  return white >= black ? const Color(0xFFFFFFFF) : const Color(0xFF000000);
}

/// Round icon on the habit's colour.
class HabitAvatar extends StatelessWidget {
  const HabitAvatar({required this.habit, super.key, this.size = 40});

  final Habit habit;
  final double size;

  @override
  Widget build(BuildContext context) {
    final bg = Color(habit.colorValue);
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: size,
        child: DecoratedBox(
          decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
          child: Icon(
            HabitIcons.of(habit.iconKey),
            size: size * 0.55,
            color: habitForeground(bg),
          ),
        ),
      ),
    );
  }
}
