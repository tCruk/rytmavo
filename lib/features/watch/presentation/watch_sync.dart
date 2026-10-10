import 'dart:async';
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/di/providers.dart';
import '../../../app/l10n/app_localizations_for.dart';
import '../../settings/presentation/controllers/settings_controller.dart';
import '../../shifts/presentation/controllers/shift_providers.dart';
import '../../shifts/presentation/widgets/shift_visuals.dart';
import '../data/method_channel_watch_gateway.dart';
import '../domain/gateways/watch_gateway.dart';
import '../domain/services/watch_snapshot_builder.dart';

final watchGatewayProvider = Provider<WatchGateway>(
  (ref) => MethodChannelWatchGateway(),
);

/// Keeps the paired watch's shift list current. Re-sends (debounced) when
/// shifts or the app language change, and on demand via [WatchSync.sync]
/// (app start, resume). Unchanged snapshots are not sent again.
final watchSyncProvider = Provider<WatchSync>((ref) {
  final sync = WatchSync(ref);
  ref.listen(shiftSetupProvider, (_, _) => sync.scheduleSync());
  ref.listen(settingsControllerProvider, (_, _) => sync.scheduleSync());
  ref.onDispose(sync.dispose);
  return sync;
});

final class WatchSync {
  WatchSync(this._ref);

  final Ref _ref;
  Timer? _debounce;
  String? _lastSent;

  void scheduleSync() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), sync);
  }

  Future<void> sync() async {
    final settings = _ref.read(settingsControllerProvider).value;
    final setup = _ref.read(shiftSetupProvider).value;
    if (settings == null || setup == null) return; // listeners re-sync
    final l10n = appLocalizationsFor(settings.language);
    final snapshot = WatchSnapshotBuilder.build(
      setup: setup,
      today: _ref.read(clockProvider).today(),
      nameOf: (shift) => shift.displayName(l10n),
      abbreviationOf: (shift) => shift.displayAbbreviation(l10n),
    );
    final json = jsonEncode(snapshot.toJson());
    if (json == _lastSent) return;
    await _ref.read(watchGatewayProvider).publish(json);
    _lastSent = json;
  }

  void dispose() {
    _debounce?.cancel();
  }
}
