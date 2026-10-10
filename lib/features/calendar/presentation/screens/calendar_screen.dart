import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/date/local_date.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../device_calendar/domain/entities/calendar_event.dart';
import '../../../device_calendar/domain/entities/shift_conflict.dart';
import '../../../device_calendar/presentation/calendar_conflict_providers.dart';
import '../../../shifts/domain/entities/shift_setup.dart';
import '../../../shifts/presentation/controllers/shift_providers.dart';
import '../../../shifts/presentation/widgets/shift_visuals.dart';
import '../widgets/day_sheet.dart';
import '../widgets/month_grid.dart';

/// Month view of the resolved schedule. Tapping a day opens [showDaySheet]
/// to override or restore that day's shift.
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  /// Page index of the current month; pages before it are earlier months.
  static const int _todayPage = 1200;

  final PageController _pages = PageController(initialPage: _todayPage);
  int _page = _todayPage;

  @override
  void dispose() {
    _pages.dispose();
    super.dispose();
  }

  void _goTo(int page) => _pages.animateToPage(
    page,
    duration: AppMotion.durationFor(
      AppMotion.normal,
      reducedMotion: MediaQuery.disableAnimationsOf(context),
    ),
    curve: AppMotion.standard,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final today = ref.watch(todayProvider);
    final month = today.firstDayOfMonth.addMonths(_page - _todayPage);
    final setupAsync = ref.watch(shiftSetupProvider);

    return RyPage(
      title: l10n.calendarTitle,
      actions: [
        IconButton(
          tooltip: l10n.calendarJumpToToday,
          icon: const Icon(Icons.today_outlined),
          onPressed: () => _goTo(_todayPage),
        ),
        if (setupAsync.value?.hasRotation ?? false) const EditShiftsAction(),
        const SettingsAction(),
      ],
      slivers: [
        switch (setupAsync) {
          AsyncData(:final value) when !value.hasRotation =>
            SliverFillRemaining(
              hasScrollBody: false,
              child: RyEmptyState(
                icon: Icons.calendar_month_outlined,
                title: l10n.todayEmptyTitle,
                body: l10n.todayEmptyBody,
                action: RyButton(
                  label: l10n.todaySetupAction,
                  icon: Icons.tune,
                  onPressed: () => context.push(AppRoutes.onboarding),
                ),
              ),
            ),
          AsyncData(:final value) => RySliverPadding(
            sliver: SliverList.list(
              children: [
                _MonthHeader(
                  month: month,
                  onPrevious: () => _goTo(_page - 1),
                  onNext: () => _goTo(_page + 1),
                ),
                // Swipe left/right to change the month, like the system
                // calendar. Six rows keep the height stable while paging.
                SizedBox(
                  height: MonthGrid.heightFor(context),
                  child: PageView.builder(
                    controller: _pages,
                    onPageChanged: (page) => setState(() => _page = page),
                    itemBuilder: (context, page) => _MonthPage(
                      month: today.firstDayOfMonth.addMonths(page - _todayPage),
                      today: today,
                      setup: value,
                      onDayTap: (date, events, conflicts) =>
                          _openDay(context, value, date, events, conflicts),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _Legend(setup: value),
              ],
            ),
          ),
          AsyncError() => SliverFillRemaining(
            hasScrollBody: false,
            child: RyEmptyState(
              icon: Icons.error_outline,
              title: l10n.errorGenericTitle,
              body: l10n.errorGenericBody,
            ),
          ),
          _ => const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: CircularProgressIndicator()),
          ),
        },
      ],
    );
  }

  Future<void> _openDay(
    BuildContext context,
    ShiftSetup setup,
    LocalDate date,
    List<CalendarEvent> events,
    List<ShiftConflict> conflicts,
  ) async {
    final l10n = AppLocalizations.of(context);
    final outcome = await showDaySheet(
      context,
      setup: setup,
      date: date,
      events: events,
      conflicts: conflicts,
    );
    if (!context.mounted || outcome == null) return;
    final dateText = MaterialLocalizations.of(context)
        .formatMediumDate(date.toLocalDateTime());
    showRySnackBar(context, switch (outcome) {
      DaySheetOutcome.changed => l10n.daySheetSaved(dateText),
      DaySheetOutcome.restored => l10n.daySheetResetDone(dateText),
      DaySheetOutcome.failed => l10n.onboardingSaveError,
    });
  }
}

/// One month of the pager. Watches the device calendar conflicts for
/// exactly the month it shows, so swiping loads each month on demand.
class _MonthPage extends ConsumerWidget {
  const _MonthPage({
    required this.month,
    required this.today,
    required this.setup,
    required this.onDayTap,
  });

  final LocalDate month;
  final LocalDate today;
  final ShiftSetup setup;
  final void Function(
    LocalDate date,
    List<CalendarEvent> events,
    List<ShiftConflict> conflicts,
  )
  onDayTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final span = (from: month, days: month.lengthOfMonth);
    final conflicts = ref.watch(shiftConflictsProvider(span));
    final eventsByDay = ref.watch(calendarEventsByDayProvider(span));
    return MonthGrid(
      month: month,
      today: today,
      setup: setup,
      conflictDates: {for (final c in conflicts) c.date},
      eventDates: eventsByDay.keys.toSet(),
      onDayTap: (date) => onDayTap(date, eventsByDay[date] ?? const [], [
        for (final c in conflicts)
          if (c.date == date) c,
      ]),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  final LocalDate month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = MaterialLocalizations.of(context)
        .formatMonthYear(month.toLocalDateTime());
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          IconButton(
            tooltip: l10n.calendarPrevMonth,
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
          IconButton(
            tooltip: l10n.calendarNextMonth,
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend({required this.setup});

  final ShiftSetup setup;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Wrap(
      spacing: AppSpacing.lg,
      runSpacing: AppSpacing.sm,
      children: [
        for (final type in setup.activeTypes)
          LegendItem(type: type, label: type.displayName(l10n)),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(l10n.calendarChanged, style: theme.textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
