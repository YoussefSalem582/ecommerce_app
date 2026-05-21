import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Centered empty state with icon, title, body, and optional action.
class AppEmptyView extends StatelessWidget {
  /// Creates an empty placeholder.
  const AppEmptyView({
    required this.icon,
    required this.title,
    required this.body,
    this.action,
    super.key,
  });

  /// Leading icon for the empty state.
  final IconData icon;

  /// Primary heading.
  final String title;

  /// Supporting copy.
  final String body;

  /// Optional CTA widget (e.g. [ContinueShoppingButton]).
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              icon,
              size: 72,
              color: palette.primary.withValues(alpha: 0.35),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: 24),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
