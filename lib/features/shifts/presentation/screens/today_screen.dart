import 'package:flutter/material.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../app/router/app_shell.dart';
import '../../../../core/ui/components/components.dart';

/// Phase 1 placeholder: shows the empty state until the shift system is
/// configured (Phase 2 adds schedule, Phase 3 adds habits).
class TodayScreen extends StatelessWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return RyPage(
      title: l10n.todayTitle,
      actions: const [SettingsAction()],
      slivers: [
        SliverFillRemaining(
          hasScrollBody: false,
          child: RyEmptyState(
            icon: Icons.wb_twilight_outlined,
            title: l10n.todayEmptyTitle,
            body: l10n.todayEmptyBody,
            action: RyButton(
              label: l10n.todaySetupAction,
              icon: Icons.tune,
              onPressed: null,
            ),
          ),
        ),
      ],
    );
  }
}
