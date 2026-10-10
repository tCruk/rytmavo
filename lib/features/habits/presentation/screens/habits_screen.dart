import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RyPage(
      title: l10n.habitsTitle,
      actions: const [SettingsAction()],
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RyEmptyState(
            icon: Icons.check_circle_outline,
            title: l10n.habitsEmptyTitle,
            body: l10n.habitsEmptyBody,
            action: RyButton(
              label: l10n.habitsAddAction,
              icon: Icons.add,
              onPressed: null,
            ),
          ),
        ),
      ],
    );
  }
}
