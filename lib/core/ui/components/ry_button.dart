import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

enum RyButtonVariant { primary, secondary, tertiary, destructive }

/// The app's button. Wraps Material buttons so every call site shares the
/// same sizes, shapes and semantics.
class RyButton extends StatelessWidget {
  const RyButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.variant = RyButtonVariant.primary,
    this.icon,
    this.expand = false,
    this.loading = false,
  });

  const RyButton.secondary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.expand = false,
    this.loading = false,
  }) : variant = RyButtonVariant.secondary;

  const RyButton.tertiary({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.expand = false,
    this.loading = false,
  }) : variant = RyButtonVariant.tertiary;

  const RyButton.destructive({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.expand = false,
    this.loading = false,
  }) : variant = RyButtonVariant.destructive;

  final String label;
  final VoidCallback? onPressed;
  final RyButtonVariant variant;
  final IconData? icon;

  /// Stretch to the available width (typical for primary CTAs).
  final bool expand;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final effectiveOnPressed = loading ? null : onPressed;
    final child = loading
        ? SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: _foreground(scheme),
            ),
          )
        : Text(label, overflow: TextOverflow.ellipsis);

    final Widget button = switch (variant) {
      RyButtonVariant.primary =>
        icon == null
            ? FilledButton(onPressed: effectiveOnPressed, child: child)
            : FilledButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: child,
              ),
      RyButtonVariant.secondary =>
        icon == null
            ? OutlinedButton(onPressed: effectiveOnPressed, child: child)
            : OutlinedButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: child,
              ),
      RyButtonVariant.tertiary =>
        icon == null
            ? TextButton(onPressed: effectiveOnPressed, child: child)
            : TextButton.icon(
                onPressed: effectiveOnPressed,
                icon: Icon(icon),
                label: child,
              ),
      RyButtonVariant.destructive => FilledButton.icon(
        onPressed: effectiveOnPressed,
        style: FilledButton.styleFrom(
          backgroundColor: scheme.error,
          foregroundColor: scheme.onError,
        ),
        icon: Icon(icon ?? Icons.delete_outline),
        label: child,
      ),
    };

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }

  Color _foreground(ColorScheme scheme) => switch (variant) {
    RyButtonVariant.primary => scheme.onPrimary,
    RyButtonVariant.destructive => scheme.onError,
    RyButtonVariant.secondary || RyButtonVariant.tertiary => scheme.primary,
  };
}

/// Spacing helper for buttons placed next to each other.
const SizedBox ryButtonGap = SizedBox(
  width: AppSpacing.md,
  height: AppSpacing.md,
);
