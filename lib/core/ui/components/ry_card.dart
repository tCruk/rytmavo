import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Standard surface container. Optional [onTap] makes the whole card a
/// single, large touch target with ink feedback.
class RyCard extends StatelessWidget {
  const RyCard({
    required this.child,
    super.key,
    this.onTap,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.color,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final content = Padding(padding: padding, child: child);
    final card = Material(
      color: color ?? colors.surfaceElevated,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.lgAll,
        side: BorderSide(color: colors.outlineSoft),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
    if (semanticLabel == null) return card;
    return Semantics(label: semanticLabel, button: onTap != null, child: card);
  }
}

/// Section heading above a group of cards or list rows.
class RySectionHeader extends StatelessWidget {
  const RySectionHeader(this.title, {super.key, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.xl, bottom: AppSpacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                letterSpacing: 0.6,
              ),
              semanticsLabel: title,
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}
