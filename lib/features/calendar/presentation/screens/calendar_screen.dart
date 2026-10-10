import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RyPage(
      title: l10n.calendarTitle,
      actions: const [SettingsAction()],
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RyEmptyState(
            icon: Icons.calendar_month_outlined,
            title: l10n.todayEmptyTitle,
            body: l10n.todayEmptyBody,
          ),
        ),
      ],
    );
  }
}
