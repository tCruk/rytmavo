import 'package:flutter/material.dart';

import '../tokens/tokens.dart';

/// Page scaffold with a large title and consistent page margins.
///
/// Uses a [CustomScrollView] so content scrolls under a collapsing-style
/// app bar while the title stays readable at large text scales.
class RyPage extends StatelessWidget {
  const RyPage({
    required this.title,
    required this.slivers,
    super.key,
    this.actions,
    this.leading,
    this.floatingActionButton,
  });

  final String title;
  final List<Widget> slivers;
  final List<Widget>? actions;
  final Widget? leading;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: floatingActionButton,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              leading: leading,
              automaticallyImplyLeading: leading != null,
              title: Text(title),
              actions: actions,
            ),
            ...slivers,
            const SliverPadding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxxl),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sliver wrapper that applies the standard horizontal page margin.
class RySliverPadding extends StatelessWidget {
  const RySliverPadding({required this.sliver, super.key});

  final Widget sliver;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      sliver: sliver,
    );
  }
}
