import 'dart:async';

import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/settings/domain/repositories/settings_repository.dart';

/// Settings repository without a database, for widget tests.
final class InMemorySettingsRepository implements SettingsRepository {
  InMemorySettingsRepository([this._current = AppSettings.defaults]);

  AppSettings _current;
  final _controller = StreamController<AppSettings>.broadcast();

  AppSettings get current => _current;

  @override
  Future<AppSettings> load() async => _current;

  @override
  Future<void> save(AppSettings settings) async {
    _current = settings;
    _controller.add(settings);
  }

  @override
  Stream<AppSettings> watch() async* {
    yield _current;
    yield* _controller.stream;
  }

  Future<void> dispose() => _controller.close();
}
