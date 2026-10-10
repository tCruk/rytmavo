import Foundation
import SwiftUI

// Shared by the watch app and the complication extension (add this file to
// both targets). Mirrors lib/features/watch/domain/entities/watch_snapshot.dart.

struct WatchDay: Codable, Hashable {
  let date: String  // yyyy-MM-dd, local calendar day
  let kind: String  // early | late | night | off | custom | none
  let name: String?
  let abbr: String?
  let color: Int64?  // 32-bit ARGB
  let start: String?  // HH:mm
  let end: String?
  let override: Bool?

  var hasShift: Bool { kind != "none" }
  var isOff: Bool { kind == "off" }
  var isOverride: Bool { override ?? false }

  var title: String {
    hasShift ? (name ?? "") : String(localized: "watch.noEntry")
  }

  /// "06:00–14:00", or nil for days off and shifts without times.
  var timeRange: String? {
    guard let start, let end else { return nil }
    return "\(start)–\(end)"
  }

  var tint: Color {
    guard let color else { return .gray }
    return Color(
      red: Double((color >> 16) & 0xFF) / 255,
      green: Double((color >> 8) & 0xFF) / 255,
      blue: Double(color & 0xFF) / 255)
  }

  var calendarDate: Date? { WatchDay.formatter.date(from: date) }

  static let formatter: DateFormatter = {
    let f = DateFormatter()
    f.calendar = Calendar(identifier: .gregorian)
    f.locale = Locale(identifier: "en_US_POSIX")
    f.timeZone = .current
    f.dateFormat = "yyyy-MM-dd"
    return f
  }()

  static func key(for date: Date) -> String { formatter.string(from: date) }
}

struct WatchSnapshot: Codable {
  static let supportedVersion = 1

  let v: Int
  let days: [WatchDay]

  func day(for date: Date) -> WatchDay? {
    let key = WatchDay.key(for: date)
    return days.first { $0.date == key }
  }

  /// Days from [date] on (inclusive), in order.
  func days(from date: Date) -> [WatchDay] {
    let key = WatchDay.key(for: date)
    return days.filter { $0.date >= key }
  }

  /// First work shift strictly after [date].
  func nextWorkDay(after date: Date) -> WatchDay? {
    let key = WatchDay.key(for: date)
    return days.first { $0.date > key && $0.hasShift && !$0.isOff }
  }
}

/// Persists the latest snapshot in the App Group so the complication
/// extension can read what the watch app received.
enum SnapshotStore {
  // Must match the App Group configured on both watch targets.
  static let appGroup = "group.com.rytmavo.rytmavo"
  private static let key = "snapshot"

  private static var defaults: UserDefaults {
    UserDefaults(suiteName: appGroup) ?? .standard
  }

  static func load() -> WatchSnapshot? {
    guard let json = defaults.string(forKey: key) else { return nil }
    return decode(json)
  }

  static func save(json: String) {
    defaults.set(json, forKey: key)
  }

  static func decode(_ json: String) -> WatchSnapshot? {
    guard let data = json.data(using: .utf8),
      let snapshot = try? JSONDecoder().decode(WatchSnapshot.self, from: data),
      snapshot.v <= WatchSnapshot.supportedVersion
    else { return nil }
    return snapshot
  }
}
