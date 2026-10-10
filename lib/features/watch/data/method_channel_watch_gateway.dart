import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../domain/gateways/watch_gateway.dart';

/// Talks to the native watch bridge in `AppDelegate.swift` (iOS) and
/// `MainActivity.kt` (Android). Both send data directly to the paired watch
/// over Bluetooth/Wi-Fi Direct; nothing leaves the user's devices.
final class MethodChannelWatchGateway implements WatchGateway {
  MethodChannelWatchGateway([
    this._channel = const MethodChannel('com.rytmavo/watch'),
  ]);

  final MethodChannel _channel;

  @override
  Future<void> publish(String json) async {
    try {
      await _channel.invokeMethod<void>('publishSnapshot', json);
    } on MissingPluginException {
      // Platform without a bridge (tests, desktop): the watch is optional.
    } on PlatformException catch (e) {
      // No paired watch or the link is down. The watch keeps its last
      // snapshot and the next change retries, so this is logged only.
      debugPrint('Watch sync skipped: ${e.code} ${e.message}');
    }
  }
}
