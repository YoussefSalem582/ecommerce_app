import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/preferences/notification_prefs_cubit.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/widgets/brand_badge.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';

/// Post-checkout celebration route with optional Lottie asset.
class OrderSuccessPage extends StatefulWidget {
  /// Displays confirmation for [orderId] ledger row.
  const OrderSuccessPage({required this.orderId, super.key});

  /// Saved Hive primary key string.
  final String orderId;

  @override
  State<OrderSuccessPage> createState() => _OrderSuccessPageState();
}

class _OrderSuccessPageState extends State<OrderSuccessPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowNotificationDemo());
  }

  void _maybeShowNotificationDemo() {
    if (!mounted) {
      return;
    }
    final bool enabled = context.read<NotificationPrefsCubit>().state;
    if (!enabled) {
      return;
    }
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.orderUpdateNotificationDemo)),
    );
  }

  void _copyOrderId(BuildContext context, AppLocalizations l10n) {
    Clipboard.setData(ClipboardData(text: widget.orderId));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.orderIdCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final bool disableMotion =
        kIsWeb || MediaQuery.of(context).disableAnimations;

    Widget mark = const BrandBadge(icon: Icons.check_rounded, size: 120);
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
                l10n.orderSuccessSubtitle(widget.orderId),
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              TextButton.icon(
                onPressed: () => _copyOrderId(context, l10n),
                icon: const Icon(Icons.copy_rounded),
                label: Text(l10n.copyOrderId),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppGradientButton(
                label: l10n.orderContinueShopping,
                onPressed: () => context.go(AppRoutes.home),
              ),
              const SizedBox(height: AppSpacing.sm),
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
