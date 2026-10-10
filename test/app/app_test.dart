import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rytmavo/app/app.dart';
import 'package:rytmavo/app/di/providers.dart';
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

  testWidgets('navigation bar touch targets are at least 48 px', (
    tester,
  ) async {
    await start(tester);
    final size = tester.getSize(find.byType(NavigationBar));
    expect(size.height, greaterThanOrEqualTo(48));
  });
}
