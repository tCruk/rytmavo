import SwiftUI

struct ContentView: View {
  let snapshot: WatchSnapshot?

  var body: some View {
    TimelineView(.everyMinute) { context in
      if let snapshot, let today = snapshot.day(for: context.date) {
        List {
          Section {
            TodayCard(day: today)
          }
          Section("watch.nextDays") {
            ForEach(snapshot.days(from: context.date).dropFirst().prefix(6), id: \.self) { day in
              DayRow(day: day)
            }
          }
        }
        .navigationTitle("watch.today")
      } else {
        EmptyStateView()
      }
    }
  }
}

private struct TodayCard: View {
  let day: WatchDay

  var body: some View {
    VStack(alignment: .leading, spacing: 4) {
      Text("watch.today")
        .font(.caption)
        .foregroundStyle(.secondary)
      HStack(spacing: 8) {
        ShiftBadge(day: day, size: 36)
        VStack(alignment: .leading) {
          Text(day.title).font(.headline)
          if let range = day.timeRange {
            Text(range).font(.subheadline).monospacedDigit()
          }
        }
      }
      if day.isOverride {
        Text("watch.changed").font(.caption2).foregroundStyle(.secondary)
      }
    }
    .accessibilityElement(children: .combine)
  }
}

private struct DayRow: View {
  let day: WatchDay

  var body: some View {
    HStack(spacing: 8) {
      ShiftBadge(day: day, size: 26)
      VStack(alignment: .leading) {
        if let date = day.calendarDate {
          Text(date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated))
            .font(.caption2)
            .foregroundStyle(.secondary)
        }
        Text(day.title).font(.body)
      }
      Spacer()
      if let range = day.timeRange {
        Text(range).font(.caption2).monospacedDigit()
      }
    }
    .accessibilityElement(children: .combine)
  }
}

/// Coloured circle with the shift's abbreviation: meaning never relies on
/// colour alone, like in the phone app.
struct ShiftBadge: View {
  let day: WatchDay
  let size: CGFloat

  var body: some View {
    Text(day.hasShift ? (day.abbr ?? "") : "–")
      .font(.system(size: size * 0.45, weight: .semibold, design: .rounded))
      .foregroundStyle(.white)
      .frame(width: size, height: size)
      .background(Circle().fill(day.tint))
      .accessibilityHidden(true)
  }
}

private struct EmptyStateView: View {
  var body: some View {
    VStack(spacing: 8) {
      Image(systemName: "iphone")
        .font(.title2)
      Text("watch.empty")
        .font(.footnote)
        .multilineTextAlignment(.center)
    }
    .padding()
  }
}
