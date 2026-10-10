import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RyPage(
      title: l10n.statsTitle,
      actions: const [SettingsAction()],
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RyEmptyState(
            icon: Icons.insights_outlined,
            title: l10n.statsEmptyTitle,
            body: l10n.statsEmptyBody,
          ),
        ),
      ],
    );
  }
}
