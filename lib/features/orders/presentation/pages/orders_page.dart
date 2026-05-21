import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
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
            return RefreshIndicator(
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
                    child: ListTile(
                      title: Text('${l10n.ordersOrderIdLabel}: ${o.id}'),
                      subtitle: Text(
                        '$dateStr · ${_statusLabel(l10n, o.status)}',
                      ),
                      trailing: Text(
                        PriceFormatter.formatUsd(context, o.total),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: palette.primary),
                      ),
                      onTap: () => context.push(AppRoutes.order(o.id)),
                    ),
                  );
                },
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return l10n.orderStatusPending;
      case OrderStatus.processing:
        return l10n.orderStatusProcessing;
      case OrderStatus.shipped:
        return l10n.orderStatusShipped;
      case OrderStatus.delivered:
        return l10n.orderStatusDelivered;
    }
  }
}
