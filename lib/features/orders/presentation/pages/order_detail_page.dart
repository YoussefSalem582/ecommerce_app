import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/order_line_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_bloc.dart';
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_event.dart';
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_state.dart';

/// Receipt drill-down with fulfillment timeline (mock stages).
class OrderDetailPage extends StatelessWidget {
  /// Binds `/order/:orderId`GoRouter parameter.
  const OrderDetailPage({required this.orderId, super.key});

  /// Ledger primary key segment.
  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrderDetailBloc>(
      create: (_) => getIt<OrderDetailBloc>()
        ..add(OrderDetailLoadRequested(orderId)),
      child: _OrderDetailBody(orderId: orderId),
    );
  }
}

class _OrderDetailBody extends StatelessWidget {
  const _OrderDetailBody({required this.orderId});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orderDetailTitle)),
      body: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (BuildContext context, OrderDetailState state) {
          if (state is OrderDetailLoading ||
              state is OrderDetailInitial) {
            return const AppLoadingView();
          }
          if (state is OrderDetailFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context.read<OrderDetailBloc>().add(
                    OrderDetailLoadRequested(orderId),
                  ),
            );
          }
          if (state is OrderDetailLoaded) {
            final OrderEntity o = state.order;
            final DateFormat fmt = DateFormat.yMMMd(
              Localizations.localeOf(context).toString(),
            ).add_jm();
            final String dateStr = fmt.format(o.createdAt);
            final ShippingAddressEntity s = o.shipping;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    '${l10n.ordersOrderIdLabel}: ${o.id}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.orderTimelineTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  _Timeline(status: o.status, l10n: l10n, palette: palette),
                  const SizedBox(height: 24),
                  Text(
                    l10n.checkoutShippingSection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(s.fullName),
                          Text(s.street),
                          Text('${s.city}, ${s.postalCode}'),
                          Text(s.country),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    l10n.checkoutOrderSummarySection,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Card(
                    child: Column(
                      children: o.lines
                          .map(
                            (OrderLineEntity l) => ListTile(
                              title: Text(l.title),
                              subtitle: Text(
                                '${l.quantity} × ${PriceFormatter.formatUsd(context, l.unitPrice)}',
                              ),
                              trailing: Text(
                                PriceFormatter.formatUsd(context, l.lineTotal),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const Divider(),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '${l10n.cartSubtotalLabel}: ${PriceFormatter.formatUsd(context, o.total)}',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: palette.primary),
                    ),
                  ),
                  const SizedBox(height: 24),
                  OutlinedButton(
                    onPressed: () => context.go(AppRoutes.orders),
                    child: Text(l10n.ordersTitle),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({
    required this.status,
    required this.l10n,
    required this.palette,
  });

  final OrderStatus status;
  final AppLocalizations l10n;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final List<OrderStatus> steps = OrderStatus.values;
    final int activeIndex = steps.indexOf(status);
    return Column(
      children: List<Widget>.generate(steps.length, (int i) {
        final OrderStatus step = steps[i];
        final bool done = i <= activeIndex;
        final bool last = i == steps.length - 1;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                Icon(
                  done ? Icons.check_circle : Icons.radio_button_off,
                  color: done
                      ? palette.primary
                      : palette.onSurface.withValues(alpha: 0.35),
                  size: 28,
                ),
                if (!last)
                  Container(
                    width: 2,
                    height: 28,
                    color: done
                        ? palette.primary
                        : palette.onSurface.withValues(alpha: 0.2),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: last ? 0 : 8),
                child: Text(
                  _label(step),
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight:
                            i == activeIndex ? FontWeight.w700 : FontWeight.w400,
                      ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  String _label(OrderStatus step) {
    switch (step) {
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
