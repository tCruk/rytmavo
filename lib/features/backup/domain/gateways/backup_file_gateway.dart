/// Port for the platform's share sheet and file picker.
abstract interface class BackupFileGateway {
  /// Hands [json] to the OS share sheet as a file named [fileName].
  Future<void> shareJson({required String json, required String fileName});

  /// Lets the user pick a file; returns its text or `null` when cancelled.
  Future<String?> pickJson();
}
