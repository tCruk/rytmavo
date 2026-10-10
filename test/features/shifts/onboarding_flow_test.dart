import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
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
  // Saturday 2026-10-10; the calendar shows October 2026 (starts Thursday).
  final clock = FixedClock(DateTime(2026, 10, 10, 9));
  const today = LocalDate(2026, 10, 10);
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;

  setUp(() {
    settingsRepo = InMemorySettingsRepository();
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
    // Tall viewport so lazily built list items (buttons below the fold)
    // exist for the finders.
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    // Dispose the tree inside the test zone, also when the test fails, so
    // Riverpod's clean-up timers never leak into the next test.
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await settle(tester);
    });
    await tester.pumpWidget(app());
    await settle(tester);
  }

  Future<void> tapButton(WidgetTester tester, String label) async {
    final finder = find.text(label);
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  Future<void> tapNext(WidgetTester tester) => tapButton(tester, 'Weiter');

  testWidgets('onboarding creates a rotation and today shows it', (
    tester,
  ) async {
    shiftRepo = InMemoryShiftRepository();
    await start(tester);

    await tester.tap(find.text('Schichtsystem einrichten').last);
    await settle(tester);
    expect(find.text('Wie arbeitest du?'), findsOneWidget);

    await tapButton(tester, 'Konti, 4 Gruppen');
    await tapNext(tester);
    expect(find.text('Dein Rhythmus'), findsOneWidget);
    expect(find.text('8 Tage'), findsOneWidget);

    // Day 8 (off) becomes early after one tap.
    await tester.tap(find.bySemanticsLabel('Tag 8, Frei'));
    await settle(tester);
    expect(find.bySemanticsLabel('Tag 8, Früh'), findsOneWidget);

    await tapNext(tester);
    expect(find.text('Welcher Tag ist heute?'), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('Tag 5, Nacht'));
    await settle(tester);

    await tapNext(tester);
    expect(find.text('Schichtzeiten'), findsOneWidget);
    await tapButton(tester, 'Fertig');

    // Back on Today: Saturday is position 4 → night.
    final setup = shiftRepo.current;
    expect(setup.hasRotation, isTrue);
    expect(setup.dayOn(today).shift?.id, 'night');
    expect(setup.dayOn(today.addDays(3)).shift?.id, 'early');
    expect(settingsRepo.current.onboardingCompleted, isTrue);
    expect(find.text('Nacht'), findsWidgets);
    expect(find.textContaining('endet am Folgetag'), findsOneWidget);
    expect(find.text('Nächste Tage'), findsOneWidget);
  });

  testWidgets('calendar: override a day and restore it', (tester) async {
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
    await start(tester);

    await tester.tap(find.text('Kalender'));
    await settle(tester);
    expect(find.text('Oktober 2026'), findsOneWidget);

    // 12 Oct is position 2 → late. Change it to off.
    await tester.tap(find.bySemanticsLabel(RegExp(r'12\. Okt.*, Spät$')));
    await settle(tester);
    expect(find.text('Laut Rhythmus: Spät'), findsOneWidget);
    await tester.tap(find.widgetWithText(RadioListTile<String>, 'Frei'));
    await settle(tester);

    expect(
      shiftRepo.current.dayOn(const LocalDate(2026, 10, 12)).shift?.id,
      'off',
    );
    expect(
      find.bySemanticsLabel(RegExp(r'12\. Okt.*, Frei, geändert$')),
      findsOneWidget,
    );

    await tester.tap(
      find.bySemanticsLabel(RegExp(r'12\. Okt.*, Frei, geändert$')),
    );
    await settle(tester);
    await tester.tap(find.text('Rhythmus wiederherstellen'));
    await settle(tester);
    expect(shiftRepo.current.overrideCount, 0);
    expect(find.bySemanticsLabel(RegExp(r'12\. Okt.*, Spät$')), findsOneWidget);

    // Month navigation.
    await tester.tap(find.byTooltip('Nächster Monat'));
    await settle(tester);
    expect(find.text('November 2026'), findsOneWidget);
    await tester.tap(find.byTooltip('Zu heute springen'));
    await settle(tester);
    expect(find.text('Oktober 2026'), findsOneWidget);
  });
}
