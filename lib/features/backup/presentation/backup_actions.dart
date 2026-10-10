import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/di/providers.dart';
import '../../../core/result/failure.dart';
import '../../../core/result/result.dart';
import '../../habits/presentation/controllers/habit_providers.dart';
import '../../settings/presentation/controllers/settings_controller.dart';
import '../../shifts/presentation/controllers/shift_providers.dart';
import '../data/platform_backup_file_gateway.dart';
import '../domain/entities/backup_document.dart';
import '../domain/gateways/backup_file_gateway.dart';
import '../domain/services/backup_codec.dart';

final backupFileGatewayProvider = Provider<BackupFileGateway>(
  (ref) => const PlatformBackupFileGateway(),
);

/// App version for the about screen and the backup header. Falls back to
/// an empty string where the platform channel is unavailable (tests).
final appVersionProvider = FutureProvider<String>((ref) async {
  try {
    final info = await PackageInfo.fromPlatform();
    return '${info.version}+${info.buildNumber}';
  } on Object {
    return '';
  }
});

final backupActionsProvider = Provider<BackupActions>(BackupActions.new);

/// Use cases behind the Settings → Data tiles.
final class BackupActions {
  BackupActions(this._ref);

  final Ref _ref;

  /// Exports everything and opens the share sheet.
  Future<Result<void>> exportAndShare() async {
    final now = _ref.read(clockProvider).now();
    final version = _ref.read(appVersionProvider).value ?? '';
    final result = await _ref
        .read(backupRepositoryProvider)
        .exportDocument(now: now, appVersion: version);
    switch (result) {
      case Error(:final failure):
        return Result.failure(failure);
      case Success(:final value):
        final date = now.toIso8601String().substring(0, 10);
        try {
          await _ref
              .read(backupFileGatewayProvider)
              .shareJson(
                json: BackupCodec.encode(value),
                fileName: 'rytmavo-backup-$date.${BackupCodec.fileExtension}',
              );
          return const Result.success(null);
        } on Object catch (e) {
          return Result.failure(PlatformFailure('share failed', e));
        }
    }
  }

  /// Lets the user pick a file and validates it. `Success(null)` means the
  /// picker was cancelled.
  Future<Result<BackupDocument?>> pickAndValidate() async {
    final String? text;
    try {
      text = await _ref.read(backupFileGatewayProvider).pickJson();
    } on Object catch (e) {
      return Result.failure(PlatformFailure('pick failed', e));
    }
    if (text == null) return const Result.success(null);
    return BackupCodec.decode(text).map((doc) => doc);
  }

  Future<Result<void>> import(BackupDocument doc) async {
    final result = await _ref
        .read(backupRepositoryProvider)
        .importDocument(doc);
    if (result.isSuccess) _refreshAll();
    return result;
  }

  Future<Result<void>> deleteAll() async {
    final result = await _ref.read(backupRepositoryProvider).deleteAll();
    if (result.isSuccess) _refreshAll();
    return result;
  }

  /// The backup repository writes past the feature repositories, so their
  /// streams and the settings notifier are re-created explicitly.
  void _refreshAll() {
    _ref.invalidate(shiftSetupProvider);
    _ref.invalidate(habitPlanProvider);
    _ref.invalidate(settingsControllerProvider);
  }
}
