import 'package:flutter/material.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Branded Google OAuth-style sign-in button.
class GoogleSignInButton extends StatelessWidget {
  /// Creates a Google sign-in button.
  const GoogleSignInButton({
    required this.onPressed,
    super.key,
  });

  /// Invoked when the user taps the button.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: palette.onSurface,
        side: BorderSide(color: palette.muted.withValues(alpha: 0.35)),
        padding: const EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.g_mobiledata_rounded, size: 28, color: palette.primary),
          const SizedBox(width: 8),
          Text(l10n.googleSignInButton),
        ],
      ),
    );
  }
}
