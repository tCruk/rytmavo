import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/core/date/local_time.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_pattern.dart';
import 'package:rytmavo/features/shifts/domain/entities/rotation_preset.dart';
import 'package:rytmavo/features/shifts/domain/entities/shift_type.dart';
import 'package:rytmavo/features/shifts/domain/services/rotation_rules.dart';

import '../../support/in_memory_habit_repository.dart';
import '../../support/in_memory_settings_repository.dart';
import '../../support/in_memory_shift_repository.dart';

void main() {
  // Saturday 2026-10-10 = slot 0 of conti4 → early shift today.
  final clock = FixedClock(DateTime(2026, 10, 10, 9));
  const today = LocalDate(2026, 10, 10);
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;

  setUp(() {
    settingsRepo = InMemorySettingsRepository();
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

  Future<void> tapText(WidgetTester tester, String text) async {
    final finder = find.text(text);
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  testWidgets('create a shift-bound habit, tick it off today, undo', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('Gewohnheiten'));
    await settle(tester);
    expect(find.text('Noch keine Gewohnheiten'), findsOneWidget);

    await tapText(tester, 'Gewohnheit anlegen');
    expect(find.text('Neue Gewohnheit'), findsOneWidget);

    // Empty name is rejected.
    await tapText(tester, 'Speichern');
    expect(find.text('Bitte gib einen Namen ein.'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Spaziergang');
    await tapText(tester, 'Nur an bestimmten Schichten');
    // "Früh" is pre-selected as the first shift; add "Nacht" too.
    await tapText(tester, 'Nacht');
    await tapText(tester, 'Speichern');

    // Back on the list with the new habit and its summary.
    expect(find.text('Spaziergang'), findsOneWidget);
    expect(find.text('An: Früh, Nacht'), findsOneWidget);
    final rule = habitRepo.current.currentRule(
      habitRepo.current.habits.single.id,
    );
    expect(rule?.targetShiftTypeIds, {'early', 'night'});
    expect(rule?.validFrom, today);

    // Today is an early shift → the habit is due and can be ticked.
    await tester.tap(find.text('Heute'));
    await settle(tester);
    expect(find.text('Gewohnheiten heute'), findsOneWidget);
    expect(find.text('0 von 1 erledigt'), findsOneWidget);
    await tapText(tester, 'Spaziergang');
    expect(find.text('1 von 1 erledigt'), findsOneWidget);
    expect(find.bySemanticsLabel('Spaziergang, erledigt'), findsOneWidget);
    final habitId = habitRepo.current.habits.single.id;
    expect(habitRepo.current.isCompleted(habitId, today), isTrue);

    // Undo from the snackbar.
    await tapText(tester, 'Rückgängig');
    expect(habitRepo.current.isCompleted(habitId, today), isFalse);
    expect(find.text('0 von 1 erledigt'), findsOneWidget);
  });

  testWidgets('insights show rate over due days only', (tester) async {
    await start(tester);
    await tester.tap(find.text('Gewohnheiten'));
    await settle(tester);
    await tapText(tester, 'Gewohnheit anlegen');
    await tester.enterText(find.byType(TextField).first, 'Lesen');
    await tapText(tester, 'Speichern');
    await tester.tap(find.text('Heute'));
    await settle(tester);
    await tapText(tester, 'Lesen');

    await tester.tap(find.text('Auswertung'));
    await settle(tester);
    // Created today → exactly one due day, completed.
    expect(find.text('1 von 1'), findsWidgets);
    expect(find.bySemanticsLabel('100 %'), findsWidgets);
  });

  testWidgets('reminder time is stored on the rule; settings switch', (
    tester,
  ) async {
    await start(tester);
    await tester.tap(find.text('Gewohnheiten'));
    await settle(tester);
    await tapText(tester, 'Gewohnheit anlegen');
    await tester.enterText(find.byType(TextField).first, 'Dehnen');

    // Open the time picker for the wildcard reminder and confirm 09:00.
    await tapText(tester, 'Keine Erinnerung');
    expect(find.text('Erinnern um'), findsWidgets);
    await tester.tap(find.text('OK'));
    await settle(tester);
    expect(find.text('Keine Erinnerung'), findsNothing);
    expect(
      find.text('Erinnerungen sind in den Einstellungen ausgeschaltet.'),
      findsOneWidget,
    );
    await tapText(tester, 'Speichern');

    final rule = habitRepo.current.currentRule(
      habitRepo.current.habits.single.id,
    );
    expect(rule?.reminders?['*'], const LocalTime(9, 0));

    // Turn reminders on in settings (noop gateway grants permission).
    await tester.tap(find.byTooltip('Einstellungen öffnen'));
    await settle(tester);
    await tester.ensureVisible(find.byType(SwitchListTile));
    await settle(tester);
    await tester.tap(find.byType(SwitchListTile));
    await settle(tester);
    expect(settingsRepo.current.remindersEnabled, isTrue);
    expect(
      find.text('An – du wirst an fällige Gewohnheiten erinnert.'),
      findsOneWidget,
    );
  });
}
