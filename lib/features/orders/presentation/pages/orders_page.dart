import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/core/widgets/continue_shopping_button.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_event.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_state.dart';

/// Chronological Hive receipts list for authenticated shoppers.
class OrdersPage extends StatefulWidget {
  /// Creates orders journal route.
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<OrdersBloc>().add(const OrdersStarted());
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ordersTitle)),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (BuildContext context, OrdersState state) {
          if (state is OrdersLoading || state is OrdersInitial) {
            return const AppLoadingView();
          }
          if (state is OrdersFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () =>
                  context.read<OrdersBloc>().add(const OrdersRefreshRequested()),
            );
          }
          if (state is OrdersLoaded && state.orders.isEmpty) {
            return AppEmptyView(
              icon: Icons.receipt_long_outlined,
              title: l10n.ordersEmptyTitle,
              body: l10n.ordersEmptyBody,
              action: const ContinueShoppingButton(),
            );
          }
          if (state is OrdersLoaded) {
            final List<OrderEntity> orders = state.orders;
            final listView = RefreshIndicator(
              color: palette.primary,
              onRefresh: () async {
                context.read<OrdersBloc>().add(const OrdersRefreshRequested());
                await context.read<OrdersBloc>().stream.firstWhere(
                      (OrdersState s) =>
                          s is OrdersLoaded || s is OrdersFailure,
                    );
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final OrderEntity o = orders[index];
                  final String dateStr = DateFormat.yMMMd(
                    Localizations.localeOf(context).toString(),
                  ).format(o.createdAt);
                  return Card(
                    key: index == 0 ? TestKeys.firstOrderTile : null,
                    child: ListTile(
                      leading: Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: palette.primary.withValues(alpha: 0.10),
                          borderRadius: AppRadius.brMd,
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: palette.primary,
                        ),
                      ),
                      title: Text('${l10n.ordersOrderIdLabel}: ${o.id}'),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xxs),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                dateStr,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                            _OrderStatusPill(status: o.status, l10n: l10n),
                          ],
                        ),
                      ),
                      trailing: Text(
                        PriceFormatter.formatUsd(context, o.total),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: palette.primary,
                              fontWeight: FontWeight.w800,
                            ),
                      ),
                      onTap: () => context.push(AppRoutes.order(o.id)),
                    ),
                  );
                },
              ),
            );

            return LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                if (constraints.maxWidth < AppBreakpoints.tablet) {
                  return listView;
                }
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 800),
                    child: listView,
                  ),
                );
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

}

/// Coloured pill conveying an order's fulfilment status.
class _OrderStatusPill extends StatelessWidget {
  const _OrderStatusPill({required this.status, required this.l10n});

  final OrderStatus status;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final Color color = switch (status) {
      OrderStatus.pending => palette.warning,
      OrderStatus.processing => palette.primary,
      OrderStatus.shipped => palette.secondary,
      OrderStatus.delivered => palette.success,
    };
    final String label = switch (status) {
      OrderStatus.pending => l10n.orderStatusPending,
      OrderStatus.processing => l10n.orderStatusProcessing,
      OrderStatus.shipped => l10n.orderStatusShipped,
      OrderStatus.delivered => l10n.orderStatusDelivered,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: AppRadius.brPill,
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
      ),
    );
  }
}
