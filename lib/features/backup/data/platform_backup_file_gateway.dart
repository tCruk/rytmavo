import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../domain/gateways/backup_file_gateway.dart';

/// share_plus + file_picker implementation. The export is written to the
/// app's temporary directory and handed to the share sheet; nothing leaves
/// the device unless the user picks a target.
final class PlatformBackupFileGateway implements BackupFileGateway {
  const PlatformBackupFileGateway();

  @override
  Future<void> shareJson({
    required String json,
    required String fileName,
  }) async {
    final dir = await getTemporaryDirectory();
    final file = File(p.join(dir.path, fileName));
    await file.writeAsString(json, flush: true);
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'application/json')],
          fileNameOverrides: [fileName],
          subject: fileName,
        ),
      );
    } finally {
      // The share target has its own copy by now; don't leave ours around.
      if (file.existsSync()) file.deleteSync();
    }
  }

  @override
  Future<String?> pickJson() async {
    final picked = await FilePicker.pickFile();
    if (picked == null) return null;
    final bytes = await picked.readAsBytes();
    return utf8.decode(bytes, allowMalformed: true);
  }
}
