import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/core/widgets/continue_shopping_button.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Full cart review surface with swipe delete + quantity steppers.
class CartPage extends StatefulWidget {
  /// Creates Hive-backed cart route.
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<CartBloc>().add(const CartStarted());
    });
  }

  ProductEntity _productFromLine(CartLineEntity line) {
    return ProductEntity(
      id: line.productId,
      title: line.title,
      price: line.unitPrice,
      description: '',
      category: '',
      imageUrl: line.imageUrl,
      ratingRate: 0,
      ratingCount: 0,
    );
  }

  void _removeWithUndo(CartLineEntity line) {
    final l10n = AppLocalizations.of(context);
    context.read<CartBloc>().add(CartLineRemoved(line.productId));
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.cartItemRemovedSnackbar),
        action: SnackBarAction(
          label: l10n.cartUndoRemove,
          onPressed: () {
            context.read<CartBloc>().add(
                  CartProductAdded(
                    _productFromLine(line),
                    quantityDelta: line.quantity,
                  ),
                );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle)),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (BuildContext context, CartState state) {
          return switch (state) {
            CartInitial() || CartLoading() => const AppLoadingView(),
            CartLoaded(:final lines) when lines.isEmpty => AppEmptyView(
                icon: Icons.shopping_cart_outlined,
                title: l10n.cartEmptyTitle,
                body: l10n.cartEmptyBody,
                action: const ContinueShoppingButton(),
              ),
            CartLoaded(:final lines, :final subtotal) => _CartLoadedBody(
                lines: lines,
                subtotal: subtotal,
                l10n: l10n,
                palette: palette,
                onRemove: _removeWithUndo,
              ),
            CartFailure(:final message) => AppErrorView(
                message: message,
                onRetry: () =>
                    context.read<CartBloc>().add(const CartRefreshRequested()),
              ),
          };
        },
      ),
    );
  }
}

class _CartLoadedBody extends StatelessWidget {
  const _CartLoadedBody({
    required this.lines,
    required this.subtotal,
    required this.l10n,
    required this.palette,
    required this.onRemove,
  });

  final List<CartLineEntity> lines;
  final double subtotal;
  final AppLocalizations l10n;
  final AppPalette palette;
  final ValueChanged<CartLineEntity> onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: RefreshIndicator(
            color: palette.primary,
            onRefresh: () async {
              context.read<CartBloc>().add(const CartRefreshRequested());
              await context.read<CartBloc>().stream.firstWhere(
                    (CartState s) => s is CartLoaded || s is CartFailure,
                  );
            },
            child: Semantics(
              label: l10n.swipeToDeleteA11y,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 120),
                itemCount: lines.length,
                itemBuilder: (BuildContext context, int index) {
                  final CartLineEntity line = lines[index];
                  return Dismissible(
                    key: ValueKey<int>(line.productId),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: palette.error.withValues(alpha: 0.15),
                      child: Icon(Icons.delete_outline, color: palette.error),
                    ),
                    onDismissed: (_) => onRemove(line),
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: line.imageUrl,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                          errorWidget: (_, __, ___) => Container(
                            width: 56,
                            height: 56,
                            color: palette.surface,
                            child: Icon(
                              Icons.image_not_supported_outlined,
                              color: palette.muted,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        line.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        PriceFormatter.formatUsd(context, line.unitPrice),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            tooltip: l10n.decreaseQuantityA11y,
                            onPressed: line.quantity <= 1
                                ? null
                                : () => context.read<CartBloc>().add(
                                      CartQuantityChanged(
                                        line.productId,
                                        line.quantity - 1,
                                      ),
                                    ),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          Text(
                            '${line.quantity}',
                            semanticsLabel: l10n.cartQuantityA11y(line.quantity),
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            tooltip: l10n.increaseQuantityA11y,
                            onPressed: () => context.read<CartBloc>().add(
                                  CartQuantityChanged(
                                    line.productId,
                                    line.quantity + 1,
                                  ),
                                ),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
        Material(
          elevation: 8,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        l10n.cartSubtotalLabel,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        PriceFormatter.formatUsd(context, subtotal),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: palette.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    key: TestKeys.cartCheckoutButton,
                    onPressed: () => context.push(AppRoutes.checkout),
                    child: Text(l10n.cartCheckoutLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
