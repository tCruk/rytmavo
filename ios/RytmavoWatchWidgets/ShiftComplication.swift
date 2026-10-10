import SwiftUI
import WidgetKit

// Watch face complications (WidgetKit accessory families). Needs
// RytmavoWatch/Shared/WatchSnapshot.swift and the Localizable.strings files
// in this target as well.

struct ShiftEntry: TimelineEntry {
  let date: Date
  let today: WatchDay?
  let next: WatchDay?
}

struct ShiftProvider: TimelineProvider {
  func placeholder(in context: Context) -> ShiftEntry {
    ShiftEntry(date: .now, today: .preview, next: nil)
  }

  func getSnapshot(in context: Context, completion: @escaping (ShiftEntry) -> Void) {
    completion(context.isPreview ? placeholder(in: context) : entry(at: .now, in: SnapshotStore.load()))
  }

  /// One entry per calendar day in the snapshot, switching at midnight, so
  /// the complication stays right for two weeks without the phone.
  func getTimeline(in context: Context, completion: @escaping (Timeline<ShiftEntry>) -> Void) {
    let snapshot = SnapshotStore.load()
    let calendar = Calendar.current
    var entries = [entry(at: .now, in: snapshot)]
    var day = calendar.startOfDay(for: .now)
    for _ in 0..<14 {
      guard let nextDay = calendar.date(byAdding: .day, value: 1, to: day) else { break }
      day = nextDay
      entries.append(entry(at: day, in: snapshot))
    }
    completion(Timeline(entries: entries, policy: .atEnd))
  }

  private func entry(at date: Date, in snapshot: WatchSnapshot?) -> ShiftEntry {
    ShiftEntry(
      date: date,
      today: snapshot?.day(for: date),
      next: snapshot?.nextWorkDay(after: date))
  }
}

struct ShiftComplicationView: View {
  @Environment(\.widgetFamily) private var family
  let entry: ShiftEntry

  var body: some View {
    switch family {
    case .accessoryCircular:
      ZStack {
        AccessoryWidgetBackground()
        VStack(spacing: 0) {
          Text(entry.today?.hasShift == true ? (entry.today?.abbr ?? "–") : "–")
            .font(.system(.title3, design: .rounded).weight(.semibold))
          if let start = entry.today?.start {
            Text(start).font(.system(size: 10)).monospacedDigit()
          }
        }
      }
      .widgetAccentable()
    case .accessoryInline:
      Text(inlineText)
    case .accessoryCorner:
      Text(entry.today?.abbr ?? "–")
        .font(.system(.title3, design: .rounded).weight(.semibold))
        .widgetLabel { Text(entry.today?.timeRange ?? entry.today?.title ?? "") }
    default:  // .accessoryRectangular
      VStack(alignment: .leading, spacing: 1) {
        Text("watch.today").font(.caption2).foregroundStyle(.secondary)
        Text(entry.today?.title ?? "Rytmavo")
          .font(.headline)
          .widgetAccentable()
        if let range = entry.today?.timeRange {
          Text(range).font(.caption).monospacedDigit()
        }
      }
      .frame(maxWidth: .infinity, alignment: .leading)
    }
  }

  private var inlineText: String {
    guard let today = entry.today else { return "Rytmavo" }
    if let range = today.timeRange { return "\(today.title) \(range)" }
    return today.title
  }
}

@main
struct ShiftComplication: Widget {
  var body: some WidgetConfiguration {
    StaticConfiguration(kind: "com.rytmavo.shift", provider: ShiftProvider()) { entry in
      ShiftComplicationView(entry: entry)
        .containerBackground(.fill.tertiary, for: .widget)
    }
    .configurationDisplayName("watch.widget.name")
    .description("watch.widget.description")
    .supportedFamilies([
      .accessoryCircular, .accessoryRectangular, .accessoryInline, .accessoryCorner,
    ])
  }
}

extension WatchDay {
  static let preview = WatchDay(
    date: WatchDay.key(for: .now), kind: "early", name: "Früh", abbr: "F",
    color: 0xFF9A_5E0B, start: "06:00", end: "14:00", override: false)
}
