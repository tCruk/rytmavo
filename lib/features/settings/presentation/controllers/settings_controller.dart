import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/providers.dart';
import '../../domain/entities/app_settings.dart';

/// Holds the current [AppSettings] and persists changes.
final settingsControllerProvider =
    AsyncNotifierProvider<SettingsController, AppSettings>(
      SettingsController.new,
    );

class SettingsController extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    final repo = ref.watch(settingsRepositoryProvider);
    final sub = repo.watch().listen((settings) {
      state = AsyncData(settings);
    });
    ref.onDispose(sub.cancel);
    return repo.load();
  }

  Future<void> setThemeMode(AppThemeMode mode) =>
      _update((s) => s.copyWith(themeMode: mode));

  Future<void> setLanguage(AppLanguage language) =>
      _update((s) => s.copyWith(language: language));

  Future<void> setOnboardingCompleted({required bool completed}) =>
      _update((s) => s.copyWith(onboardingCompleted: completed));

  Future<void> setRemindersEnabled({required bool enabled}) =>
      _update((s) => s.copyWith(remindersEnabled: enabled));

  Future<void> setCalendarConflictsEnabled({required bool enabled}) =>
      _update((s) => s.copyWith(calendarConflictsEnabled: enabled));

  /// Empty [ids] means "all calendars".
  Future<void> setConflictCalendarIds(List<String> ids) =>
      _update((s) => s.copyWith(conflictCalendarIds: List.unmodifiable(ids)));

  Future<void> setConflictRemindersEnabled({required bool enabled}) =>
      _update((s) => s.copyWith(conflictRemindersEnabled: enabled));

  Future<void> _update(AppSettings Function(AppSettings) change) async {
    final current = state.value ?? AppSettings.defaults;
    final next = change(current);
    if (next == current) return;
    // Optimistic update; the repository stream confirms it.
    state = AsyncData(next);
    await ref.read(settingsRepositoryProvider).save(next);
  }
}
