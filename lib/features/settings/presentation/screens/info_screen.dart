import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/generated/app_localizations.dart';
import '../../../../core/ui/components/components.dart';
import '../../../../core/ui/tokens/tokens.dart';
import '../../../backup/presentation/backup_actions.dart';

/// Which legal / support page to show.
enum InfoKind { privacy, imprint, support }

extension InfoKindRoute on InfoKind {
  /// URL segment; also what [InfoKind.fromSegment] parses.
  String get segment => name;

  static InfoKind? fromSegment(String? segment) {
    for (final k in InfoKind.values) {
      if (k.segment == segment) return k;
    }
    return null;
  }
}

/// Plain-text page for privacy notice, imprint and support. The texts live
/// in the ARB files so both languages stay in sync; placeholders that the
/// operator still has to fill are marked in the text itself.
class InfoScreen extends ConsumerWidget {
  const InfoScreen({required this.kind, super.key});

  final InfoKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final version = ref.watch(appVersionProvider).value;
    final (title, body) = switch (kind) {
      InfoKind.privacy => (l10n.infoPrivacyTitle, l10n.infoPrivacyBody),
      InfoKind.imprint => (l10n.infoImprintTitle, l10n.infoImprintBody),
      InfoKind.support => (
        l10n.infoSupportTitle,
        l10n.infoSupportBody(
          version == null || version.isEmpty ? '–' : version,
        ),
      ),
    };
    final paragraphs = body.split('\n\n');
    final textTheme = Theme.of(context).textTheme;

    return RyPage(
      title: title,
      leading: BackButton(onPressed: () => Navigator.of(context).maybePop()),
      slivers: [
        RySliverPadding(
          sliver: SliverList.separated(
            itemCount: paragraphs.length,
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final text = paragraphs[index];
              final isHeading = text.startsWith('# ');
              return isHeading
                  ? Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.sm),
                      child: Text(
                        text.substring(2),
                        style: textTheme.titleMedium,
                      ),
                    )
                  : Text(text, style: textTheme.bodyMedium);
            },
          ),
        ),
      ],
    );
  }
}
