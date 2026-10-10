import '../../../../core/result/result.dart';
import '../entities/backup_document.dart';

abstract interface class BackupRepository {
  /// Snapshot of every table plus settings.
  Future<Result<BackupDocument>> exportDocument({
    required DateTime now,
    required String appVersion,
  });

  /// Replaces **all** local data with [doc] in one transaction.
  Future<Result<void>> importDocument(BackupDocument doc);

  /// Removes every row from every table (settings included).
  Future<Result<void>> deleteAll();
}
