import SwiftUI
import WatchConnectivity
import WidgetKit

@main
struct RytmavoWatchApp: App {
  @StateObject private var receiver = SnapshotReceiver()

  var body: some Scene {
    WindowGroup {
      ContentView(snapshot: receiver.snapshot)
    }
  }
}

/// Receives the snapshot the iPhone sends via `updateApplicationContext`,
/// stores it for the complications and refreshes them.
final class SnapshotReceiver: NSObject, ObservableObject, WCSessionDelegate {
  @Published private(set) var snapshot: WatchSnapshot? = SnapshotStore.load()

  override init() {
    super.init()
    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }

  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    // The latest context may have arrived while the app was not running.
    apply(session.receivedApplicationContext)
  }

  func session(_ session: WCSession, didReceiveApplicationContext context: [String: Any]) {
    apply(context)
  }

  private func apply(_ context: [String: Any]) {
    guard let json = context["snapshot"] as? String,
      let decoded = SnapshotStore.decode(json)
    else { return }
    SnapshotStore.save(json: json)
    WidgetCenter.shared.reloadAllTimelines()
    DispatchQueue.main.async { self.snapshot = decoded }
  }
}
