import 'dart:async';

import '../result/result.dart';

/// Lets a repository re-emit its `watch()` stream after its own writes,
/// independent of drift's table-update notifications.
///
/// drift notifies query streams itself, but that path runs through the
/// database isolate; this keeps the UI fresh even if that notification is
/// delayed or lost, which users otherwise see as "changes only appear
/// after a restart".
mixin WriteNotifier {
  // Closed in disposeWriteNotifier(); the lint can't see that through the
  // mixin, and repositories live as long as the database anyway.
  // ignore: close_sinks
  final StreamController<void> _writes = StreamController<void>.broadcast();

  /// Repositories live as long as the database; call this when a
  /// repository is discarded (tests).
  Future<void> disposeWriteNotifier() => _writes.close();

  /// Runs [body] under [guardStorage] and signals listeners on success.
  Future<Result<T>> write<T>(String context, Future<T> Function() body) async {
    final result = await guardStorage(context: context, body);
    if (result.isSuccess && !_writes.isClosed) _writes.add(null);
    return result;
  }

  /// Emits [load] once per event of [source] or per successful [write].
  Stream<T> reloadOn<T>(Stream<void> source, Future<T> Function() load) {
    late StreamController<void> controller;
    StreamSubscription<void>? sourceSub;
    StreamSubscription<void>? writeSub;
    controller = StreamController<void>(
      onListen: () {
        sourceSub = source.listen(controller.add, onError: controller.addError);
        writeSub = _writes.stream.listen(controller.add);
      },
      onCancel: () async {
        await sourceSub?.cancel();
        await writeSub?.cancel();
        await controller.close();
      },
    );
    return controller.stream.asyncMap((_) => load());
  }
}
