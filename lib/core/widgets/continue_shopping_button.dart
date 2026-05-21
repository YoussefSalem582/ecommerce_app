import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';

/// Standard empty-state CTA that navigates to the catalog home tab.
class ContinueShoppingButton extends StatelessWidget {
  /// Creates a continue-shopping button.
  const ContinueShoppingButton({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return FilledButton.tonal(
      onPressed: () => context.go(AppRoutes.home),
      child: Text(l10n.orderContinueShopping),
    );
  }
}
