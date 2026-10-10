/// Hands the serialized snapshot to the platform's watch link
/// (WatchConnectivity on iOS, Wearable Data Layer on Android).
abstract interface class WatchGateway {
  /// Publishes [json]. Completes normally when no watch is paired or the
  /// platform has no watch support; the watch simply keeps its last data.
  Future<void> publish(String json);
}
