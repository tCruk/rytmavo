import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/core/database/app_database.dart';
import 'package:rytmavo/core/database/database_factory.dart';
import 'package:rytmavo/core/date/clock.dart';
import 'package:rytmavo/core/date/local_date.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/shifts/presentation/controllers/shift_providers.dart';

/// End-to-end through the real drift repositories (in-memory SQLite):
/// edits must show up on screen without restarting the app.
void main() {
  final clock = FixedClock(DateTime(2026, 10, 10, 9));
  const today = LocalDate(2026, 10, 10);
  late AppDatabase db;
  late ProviderContainer container;

  setUp(() {
    db = openInMemoryDatabase();
    container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        clockProvider.overrideWithValue(clock),
        notificationGatewayProvider.overrideWithValue(
          const NoopNotificationGateway(),
        ),
      ],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

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
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const RytmavoApp(),
      ),
    );
    await settle(tester);
    // drift's first query result arrives asynchronously.
    await settle(tester);
  }

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await settle(tester);
    await tester.tap(finder);
    await settle(tester);
  }

  Future<void> tapText(WidgetTester tester, String text) =>
      tap(tester, find.text(text).last);

  testWidgets('shift model: create, then edit – Today updates live', (
    tester,
  ) async {
    await start(tester);
    await tapText(tester, 'Schichtsystem einrichten');
    await tapText(tester, 'Konti, 4 Gruppen');
    await tapText(tester, 'Weiter');
    await tapText(tester, 'Weiter');
    // Today = day 5 of the conti-4 cycle = night.
    await tap(tester, find.bySemanticsLabel('Tag 5, Nacht'));
    await tapText(tester, 'Weiter');
    await tapText(tester, 'Fertig');

    expect(find.text('Nacht'), findsWidgets);
    expect(
      container.read(shiftSetupProvider).value?.dayOn(today).shift?.id,
      'night',
    );

    // Edit from the Today app bar: switch to the 2-shift weekly preset.
    await tap(tester, find.byTooltip('Schichtmodell bearbeiten'));
    expect(find.text('Aktueller Rhythmus'), findsOneWidget);
    await tapText(tester, '2-Schicht, wöchentlich');
    await tapText(tester, 'Weiter');
    await tapText(tester, 'Weiter');
    await tap(tester, find.bySemanticsLabel('Tag 1, Früh'));
    await tapText(tester, 'Weiter');
    // ignore: avoid_print
    print(
      'before Fertig: onboarding=${find.text('Schichtzeiten').evaluate().length} '
      'error=${find.textContaining('fehlgeschlagen').evaluate().length}',
    );
    await tapText(tester, 'Fertig');

    final setup = container.read(shiftSetupProvider).value;
    expect(setup?.patterns.length, 2);
    expect(setup?.dayOn(today).shift?.id, 'early');
    expect(find.text('Früh'), findsWidgets);
    expect(find.text('Nacht'), findsNothing);
  });

  testWidgets('habit: rename shows in the list without restart', (
    tester,
  ) async {
    await start(tester);
    await tapText(tester, 'Gewohnheiten');
    await tapText(tester, 'Gewohnheit anlegen');
    await tester.enterText(find.byType(TextField).first, 'Dehnen');
    await tapText(tester, 'Speichern');
    expect(find.text('Dehnen'), findsOneWidget);

    await tapText(tester, 'Dehnen');
    await tester.enterText(find.byType(TextField).first, 'Yoga');
    await tapText(tester, 'Speichern');
    expect(find.text('Yoga'), findsOneWidget);
    expect(find.text('Dehnen'), findsNothing);
  });
}
