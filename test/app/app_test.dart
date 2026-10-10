import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
import 'package:rytmavo/features/reminders/domain/gateways/notification_gateway.dart';
import 'package:rytmavo/features/reminders/presentation/reminder_scheduler.dart';
import 'package:rytmavo/features/settings/domain/entities/app_settings.dart';

import '../support/in_memory_habit_repository.dart';
import '../support/in_memory_settings_repository.dart';
import '../support/in_memory_shift_repository.dart';

void main() {
  late InMemorySettingsRepository settingsRepo;
  late InMemoryShiftRepository shiftRepo;
  late InMemoryHabitRepository habitRepo;

  setUp(() {
    settingsRepo = InMemorySettingsRepository();
    shiftRepo = InMemoryShiftRepository();
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
    ],
    child: const RytmavoApp(),
  );

  /// Pumps a few frames instead of `pumpAndSettle`, which never settles
  /// while the NavigationBar's indicator animation is pending in tests.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> start(WidgetTester tester) async {
    tester.platformDispatcher.localesTestValue = const [Locale('de', 'DE')];
    addTearDown(tester.platformDispatcher.clearLocalesTestValue);
    // Disposes the tree inside the test zone (also on failure) so Riverpod's
    // scheduled clean-up timers run before the pending-timer check.
    addTearDown(() async {
      await tester.pumpWidget(const SizedBox.shrink());
      await settle(tester);
    });
    await tester.pumpWidget(app());
    await settle(tester);
  }

  testWidgets('starts on Today and navigates through all tabs (German)', (
    tester,
  ) async {
    await start(tester);

    expect(find.text('Noch kein Schichtplan'), findsOneWidget);

    await tester.tap(find.text('Kalender'));
    await settle(tester);
    expect(find.widgetWithText(AppBar, 'Kalender'), findsOneWidget);

    await tester.tap(find.text('Gewohnheiten'));
    await settle(tester);
    expect(find.text('Noch keine Gewohnheiten'), findsOneWidget);

    await tester.tap(find.text('Auswertung'));
    await settle(tester);
    expect(find.text('Noch keine Auswertung'), findsOneWidget);
  });

  testWidgets('settings: switching to English persists and re-renders', (
    tester,
  ) async {
    await start(tester);

    await tester.tap(find.byTooltip('Einstellungen öffnen'));
    await settle(tester);
    expect(find.text('Einstellungen'), findsWidgets);

    await tester.tap(find.text('Sprache'));
    await settle(tester);
    await tester.tap(find.text('Englisch'));
    await settle(tester);

    expect(find.text('Settings'), findsWidgets);
    expect(find.text('Language'), findsOneWidget);
    expect(settingsRepo.current.language, AppLanguage.en);
  });

  testWidgets('settings: dark theme applies', (tester) async {
    await start(tester);
    await tester.tap(find.byTooltip('Einstellungen öffnen'));
    await settle(tester);
    await tester.tap(find.text('Erscheinungsbild'));
    await settle(tester);
    await tester.tap(find.text('Dunkel'));
    await settle(tester);

    final context = tester.element(find.text('Erscheinungsbild'));
    expect(Theme.of(context).brightness, Brightness.dark);
    expect(settingsRepo.current.themeMode, AppThemeMode.dark);
  });

  testWidgets('settings: about pages open and show the version row', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 3600);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);
    await start(tester);
    await tester.tap(find.byTooltip('Einstellungen öffnen'));
    await settle(tester);

    await tester.ensureVisible(find.text('Datenschutz'));
    await tester.tap(find.text('Datenschutz'));
    await settle(tester);
    expect(
      find.textContaining('ausschließlich auf diesem Gerät'),
      findsOneWidget,
    );

    await tester.tap(find.byType(BackButton));
    await settle(tester);
    await tester.ensureVisible(find.text('Support'));
    await tester.tap(find.text('Support'));
    await settle(tester);
    expect(find.textContaining('App-Version'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await settle(tester);
    expect(find.text('Version'), findsOneWidget);
    expect(find.text('Unbekannt'), findsOneWidget);
  });

  testWidgets(
    'renders Today and Settings at 200 % text scale without overflow',
    (tester) async {
      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      tester.platformDispatcher.textScaleFactorTestValue = 2.0;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

      await start(tester);
      expect(find.text('Noch kein Schichtplan'), findsOneWidget);

      await tester.tap(find.byTooltip('Einstellungen öffnen'));
      await settle(tester);
      expect(find.text('Einstellungen'), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('navigation bar touch targets are at least 48 px', (
    tester,
  ) async {
    await start(tester);
    final size = tester.getSize(find.byType(NavigationBar));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
