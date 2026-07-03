import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_spacing.dart';
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
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 112,
              width: 112,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: <Color>[
                    palette.primary.withValues(alpha: 0.14),
                    palette.secondary.withValues(alpha: 0.14),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Icon(icon, size: 52, color: palette.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (action != null) ...<Widget>[
              const SizedBox(height: AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
