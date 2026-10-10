import '../entities/app_settings.dart';

abstract interface class SettingsRepository {
  Future<AppSettings> load();

  Future<void> save(AppSettings settings);

  /// Emits the current settings immediately and again after every change.
  Stream<AppSettings> watch();
}
