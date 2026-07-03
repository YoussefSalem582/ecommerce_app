import 'package:flutter/material.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Centered error state with optional retry action.
class AppErrorView extends StatelessWidget {
  /// Creates an error placeholder.
  const AppErrorView({
    required this.message,
    this.onRetry,
    super.key,
  });

  /// User-facing error copy.
  final String message;

  /// Invoked when the user taps retry; hidden when null.
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              height: 96,
              width: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: palette.error.withValues(alpha: 0.12),
              ),
              alignment: Alignment.center,
              child: Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: palette.error,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...<Widget>[
              const SizedBox(height: AppSpacing.lg),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 20),
                label: Text(l10n.retry),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
