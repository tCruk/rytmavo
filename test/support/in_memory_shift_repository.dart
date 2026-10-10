import 'dart:async';

import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/result/result.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_override.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_setup.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/repositories/shift_repository.dart';

/// Shift repository without a database, for widget tests.
final class InMemoryShiftRepository implements ShiftRepository {
  InMemoryShiftRepository({
    List<ShiftType> types = const [],
    List<RotationPattern> patterns = const [],
    List<ShiftOverride> overrides = const [],
  }) : _types = {for (final t in types) t.id: t},
       _patterns = {for (final p in patterns) p.validFrom: p},
       _overrides = {for (final o in overrides) o.date: o};

  final Map<String, ShiftType> _types;
  final Map<LocalDate, RotationPattern> _patterns;
  final Map<LocalDate, ShiftOverride> _overrides;
  final _controller = StreamController<ShiftSetup>.broadcast();

  ShiftSetup get current => ShiftSetup(
    types: _types.values.toList(),
    patterns: _patterns.values.toList(),
    overrides: _overrides.values.toList(),
  );

  void _emit() => _controller.add(current);

  @override
  Future<ShiftSetup> load() async => current;

  @override
  Stream<ShiftSetup> watch() async* {
    yield current;
    yield* _controller.stream;
  }

  @override
  Future<Result<void>> saveShiftTypes(List<ShiftType> types) async {
    for (final t in types) {
      _types[t.id] = t;
    }
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> addRotationVersion(
    RotationPattern pattern, {
    bool replaceHistory = false,
  }) async {
    if (replaceHistory) _patterns.clear();
    _patterns[pattern.validFrom] = pattern;
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> setOverride(ShiftOverride override) async {
    _overrides[override.date] = override;
    _emit();
    return const Result.success(null);
  }

  @override
  Future<Result<void>> removeOverride(LocalDate date) async {
    _overrides.remove(date);
    _emit();
    return const Result.success(null);
  }

  Future<void> dispose() => _controller.close();
}
