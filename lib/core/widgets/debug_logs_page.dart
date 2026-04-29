import 'package:flutter/material.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Full-screen Talker log viewer (reachable from debug affordances).
class DebugLogsPage extends StatelessWidget {
  /// Creates the Talker log screen when dependencies are initialized.
  const DebugLogsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final talker = getIt<Talker>();
    final l10n = AppLocalizations.of(context);
    return TalkerScreen(
      talker: talker,
      appBarTitle: l10n.debugLogs,
    );
  }
}
