import 'package:shop_flow/core/l10n/gen/app_localizations.dart';

/// Picks a localized snackbar line for auth credential failure messages.
///
/// Transport-layer failures stay generic so reviewers see friendly copy; API
/// bodies (e.g. validation) pass through unchanged.
String authCredentialFailureSnackBarMessage(
  AppLocalizations l10n,
  String message,
) {
  final lower = message.toLowerCase();
  if (lower.contains('connection reset') ||
      lower.contains('timed out') ||
      lower.contains('dns / offline') ||
      lower.contains("can't reach") ||
      lower == 'network error') {
    return l10n.authErrorNetworkUnreachable;
  }
  return message;
}
