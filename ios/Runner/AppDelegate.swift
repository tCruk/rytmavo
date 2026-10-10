import Flutter
import UIKit
import WatchConnectivity

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let watchBridge = WatchBridge()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Lets flutter_local_notifications show reminders while the app is open.
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }
    watchBridge.activate()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let registrar = engineBridge.pluginRegistry.registrar(forPlugin: "RytmavoWatchBridge") {
      watchBridge.attach(to: registrar.messenger())
    }
  }
}

/// Forwards the shift snapshot from Flutter (`com.rytmavo/watch`) to the
/// paired Apple Watch. `updateApplicationContext` keeps only the latest
/// value and delivers it when the watch is reachable – directly between
/// the devices, no server involved.
final class WatchBridge: NSObject, WCSessionDelegate {
  private var pendingSnapshot: String?

  func activate() {
    guard WCSession.isSupported() else { return }
    WCSession.default.delegate = self
    WCSession.default.activate()
  }

  func attach(to messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(name: "com.rytmavo/watch", binaryMessenger: messenger)
    channel.setMethodCallHandler { [weak self] call, result in
      guard call.method == "publishSnapshot", let json = call.arguments as? String else {
        result(FlutterMethodNotImplemented)
        return
      }
      self?.publish(json, result: result)
    }
  }

  private func publish(_ json: String, result: FlutterResult) {
    guard WCSession.isSupported() else {
      result(nil)  // iPad or no watch support: nothing to do.
      return
    }
    let session = WCSession.default
    guard session.activationState == .activated else {
      pendingSnapshot = json  // sent once activation completes
      result(nil)
      return
    }
    guard session.isPaired, session.isWatchAppInstalled else {
      result(nil)
      return
    }
    do {
      try session.updateApplicationContext(["snapshot": json])
      result(nil)
    } catch {
      result(FlutterError(code: "watch_send_failed", message: error.localizedDescription, details: nil))
    }
  }

  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    guard activationState == .activated, let json = pendingSnapshot else { return }
    pendingSnapshot = nil
    if session.isPaired, session.isWatchAppInstalled {
      try? session.updateApplicationContext(["snapshot": json])
    }
  }

  func sessionDidBecomeInactive(_ session: WCSession) {}

  func sessionDidDeactivate(_ session: WCSession) {
    // Switching to another paired watch: reactivate so it gets data too.
    session.activate()
  }
}
