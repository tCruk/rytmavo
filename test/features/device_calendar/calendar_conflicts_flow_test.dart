import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/calendar_event.dart';
import 'package:rytmavo/features/device_calendar/domain/entities/device_calendar_info.dart';
import 'package:rytmavo/features/device_calendar/presentation/calendar_conflict_providers.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

import '../../support/fake_device_calendar_gateway.dart';
import '../../support/in_memory_habit_repository.dart';
import '../../support/in_memory_settings_repository.dart';
import '../../support/in_memory_shift_repository.dart';

void main() {
  // Saturday 2026-10-10 = slot 0 of conti4: E E L L N N O O.
  const today = LocalDate(2026, 10, 10);
  final clock = FixedClock(DateTime(2026, 10, 10, 7));
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;
  late FakeDeviceCalendarGateway calendar;

  final dentist = CalendarEvent(
    id: 'e1',
    calendarId: 'private',
    title: 'Zahnarzt',
    start: DateTime(2026, 10, 10, 9),
    end: DateTime(2026, 10, 10, 10),
  );
  final parents = CalendarEvent(
    id: 'e2',
    calendarId: 'family',
    title: 'Elternabend',
    start: DateTime(2026, 10, 12, 19),
    end: DateTime(2026, 10, 12, 21),
  );
  final evening = CalendarEvent(
    id: 'e3',
    calendarId: 'private',
    title: 'Kino',
    start: DateTime(2026, 10, 10, 20),
    end: DateTime(2026, 10, 10, 22),
  );

  final vacation = CalendarEvent(
    id: 'e4',
    calendarId: 'family',
    title: 'Urlaub',
    start: DateTime(2026, 10, 15),
    end: DateTime(2026, 10, 17),
    isAllDay: true,
  );

  setUp(() {
    shiftRepo = InMemoryShiftRepository(
      types: ShiftType.defaults,
      patterns: [
        RotationPattern(
          id: 'p',
          validFrom: RotationRules.firstVersionValidFrom,
          anchorDate: today,
          slots: RotationPreset.conti4.slots,
        ),
      ],
    );
    habitRepo = InMemoryHabitRepository();
    calendar = FakeDeviceCalendarGateway(
      calendarList: const [
        DeviceCalendarInfo(id: 'private', name: 'Privat'),
        DeviceCalendarInfo(id: 'family', name: 'Familie'),
      ],
      eventList: [dentist, parents, evening, vacation],
    );
  });
  tearDown(() async {
    await settingsRepo.dispose();
    await shiftRepo.dispose();
    await habitRepo.dispose();
  });

  Widget app() => ProviderScope(
    overrides: [
      settingsRepositoryProvider.overrideWithValue(settingsRepo),
      shiftRepositoryProvider.overrideWithValue(shiftRepo),
      habitRepositoryProvider.overrideWithValue(habitRepo),
      notificationGatewayProvider.overrideWithValue(
        const NoopNotificationGateway(),
      ),
      deviceCalendarGatewayProvider.overrideWithValue(calendar),
      clockProvider.overrideWithValue(clock),
    ],
    child: const RytmavoApp(),
  );

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> start(WidgetTester tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await settle(tester);
    });
    await tester.pumpWidget(app());
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  /// Calendar cells live in a horizontal PageView; ensureVisible would
  /// scroll the pager, so they are tapped in place.
  Future<void> tapDay(WidgetTester tester, String pattern) async {
    await tester.tap(find.bySemanticsLabel(RegExp(pattern)));
    await settle(tester);
  }

  testWidgets('off by default: nothing is read and nothing is shown', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(onboardingCompleted: true),
    );
    calendar.granted = true;
    await start(tester);
    expect(find.text('Terminkonflikte'), findsNothing);
    expect(calendar.queriedCalendarIds, isEmpty);
  });

  testWidgets('turning it on asks for access and flags conflicts on Today', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(onboardingCompleted: true),
    );
    await start(tester);
    await tap(tester, find.byTooltip('Einstellungen öffnen'));
    await tap(
      tester,
      find.widgetWithText(SwitchListTile, 'Kalendertermine anzeigen'),
    );
    expect(calendar.requestCalls, 1);
    expect(settingsRepo.current.calendarConflictsEnabled, isTrue);
    expect(find.text('Alle Kalender'), findsOneWidget);

    await tap(tester, find.byType(BackButton));
    expect(find.text('Terminkonflikte'), findsOneWidget);
    // Early shift 06–14 today, late shift 14–22 on Monday.
    expect(find.text('Zahnarzt'), findsOneWidget);
    expect(find.text('Elternabend'), findsOneWidget);
    // 20:00 today is after the early shift.
    expect(find.text('Kino'), findsNothing);
  });

  testWidgets('denied access keeps the switch off', (tester) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(onboardingCompleted: true),
    );
    calendar.grantOnRequest = false;
    await start(tester);
    await tap(tester, find.byTooltip('Einstellungen öffnen'));
    await tap(
      tester,
      find.widgetWithText(SwitchListTile, 'Kalendertermine anzeigen'),
    );
    expect(settingsRepo.current.calendarConflictsEnabled, isFalse);
    expect(
      find.text(
        'Kein Zugriff auf den Kalender. Erlaube ihn für Rytmavo in den '
        'Systemeinstellungen.',
      ),
      findsOneWidget,
    );
  });

  testWidgets('choosing calendars limits what is checked', (tester) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(
        onboardingCompleted: true,
        calendarConflictsEnabled: true,
      ),
    );
    calendar.granted = true;
    await start(tester);
    await tap(tester, find.byTooltip('Einstellungen öffnen'));
    await tap(tester, find.text('Alle Kalender'));
    await tap(tester, find.widgetWithText(CheckboxListTile, 'Familie'));
    await tap(tester, find.text('Übernehmen'));
    expect(settingsRepo.current.conflictCalendarIds, ['private']);
    expect(find.text('1 von 2 Kalendern'), findsOneWidget);

    await tap(tester, find.byType(BackButton));
    expect(find.text('Zahnarzt'), findsOneWidget);
    expect(find.text('Elternabend'), findsNothing);
  });

  testWidgets('calendar marks conflict days and the day sheet lists them', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(
        onboardingCompleted: true,
        calendarConflictsEnabled: true,
      ),
    );
    calendar.granted = true;
    await start(tester);
    await tap(tester, find.byIcon(Icons.calendar_month_outlined).first);
    expect(find.byIcon(Icons.event_busy), findsNWidgets(2));
    // Dots on the 10th, 12th, 15th and 16th (all-day, end exclusive).
    expect(find.byKey(const ValueKey('event-dot')), findsNWidgets(4));
    expect(
      find.bySemanticsLabel(RegExp(r'12\..*Spät, Termine, Terminkonflikte')),
      findsOneWidget,
    );
    await tapDay(tester, r'12\..*Spät, Termine, Terminkonflikte');
    expect(find.text('Termine'), findsWidgets);
    expect(find.text('Elternabend'), findsOneWidget);
    expect(find.text('Zahnarzt'), findsNothing);
  });

  testWidgets('day sheet lists every appointment, conflicts flagged', (
    tester,
  ) async {
    settingsRepo = InMemorySettingsRepository(
      const AppSettings(
        onboardingCompleted: true,
        calendarConflictsEnabled: true,
      ),
    );
    calendar.granted = true;
    await start(tester);
    await tap(tester, find.byIcon(Icons.calendar_month_outlined).first);
    await tapDay(tester, r'(^|\D)10\..*Früh, Termine');
    expect(find.text('Zahnarzt'), findsOneWidget);
    expect(find.text('Kino'), findsOneWidget);
    // Only the dentist overlaps the early shift.
    expect(find.byIcon(Icons.event_busy_outlined), findsOneWidget);
    expect(find.byIcon(Icons.event_outlined), findsOneWidget);
    await tester.tapAt(const Offset(10, 10));
    await settle(tester);

    await tapDay(tester, r'(^|\D)15\..*, Termine');
    expect(find.text('Urlaub'), findsOneWidget);
    expect(find.text('Ganztägig'), findsOneWidget);
  });
}
