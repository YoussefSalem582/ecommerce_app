import 'package:flutter/material.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';

/// Home app bar title with optional welcome subtitle.
class HomeAppBarTitle extends StatelessWidget {
  /// Creates the catalog screen title column.
  const HomeAppBarTitle({required this.authState, super.key});

  /// Current auth state for welcome line.
  final AuthState authState;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final String username = switch (authState) {
      AuthAuthenticated(:final user) => user.username,
      _ => '',
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(l10n.homeTitle),
        if (authState is AuthAuthenticated)
          Text(
            l10n.welcomeUser(username),
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: palette.muted),
          ),
      ],
    );
  }
}
