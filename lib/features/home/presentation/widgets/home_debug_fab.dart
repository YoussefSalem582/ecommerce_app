import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';

/// Debug FAB that opens the Talker logs route (shown only in debug builds).
class HomeDebugFab extends StatelessWidget {
  /// Creates the debug logs FAB.
  const HomeDebugFab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return FloatingActionButton.small(
      tooltip: l10n.debugLogs,
      onPressed: () => context.push(AppRoutes.debugLogs),
      child: const Icon(Icons.bug_report_outlined),
    );
  }
}
