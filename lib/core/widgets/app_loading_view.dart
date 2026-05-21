import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Branded loading indicator respecting reduced-motion preferences.
class AppLoadingView extends StatelessWidget {
  /// Creates a centered loading indicator.
  const AppLoadingView({super.key, this.message});

  /// Optional status copy below the spinner.
  final String? message;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final disableAnimations = MediaQuery.of(context).disableAnimations;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (disableAnimations)
              Icon(Icons.hourglass_top_rounded, size: 48, color: palette.primary)
            else
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: palette.primary,
                ),
              ),
            if (message != null) ...<Widget>[
              const SizedBox(height: 16),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
