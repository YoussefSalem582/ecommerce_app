import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Post-checkout celebration route with optional Lottie asset.
class OrderSuccessPage extends StatelessWidget {
  /// Displays confirmation for [orderId] ledger row.
  const OrderSuccessPage({required this.orderId, super.key});

  /// Saved Hive primary key string.
  final String orderId;

  void _copyOrderId(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.orderIdCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final bool disableMotion =
        kIsWeb || MediaQuery.of(context).disableAnimations;

    Widget mark = Icon(
      Icons.check_circle_rounded,
      size: 120,
      color: palette.primary,
    );
    if (!disableMotion) {
      mark = mark
          .animate()
          .scale(duration: 520.ms, curve: Curves.elasticOut);
    }

    final Widget graphic = disableMotion
        ? mark
        : SizedBox(
            height: 180,
            child: Lottie.asset(
              'assets/lottie/order_success.json',
              repeat: false,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => mark,
            ),
          );

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              graphic,
              const SizedBox(height: 24),
              Text(
                key: TestKeys.orderSuccessTitle,
                l10n.orderSuccessTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.orderSuccessSubtitle(orderId),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _copyOrderId(context, l10n),
                icon: const Icon(Icons.copy_rounded),
                label: Text(l10n.copyOrderId),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go(AppRoutes.home),
                child: Text(l10n.orderContinueShopping),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go(AppRoutes.orders),
                child: Text(l10n.ordersTitle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
