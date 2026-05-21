import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.cartTitle)),
      body: BlocConsumer<CartBloc, CartState>(
        listener: (BuildContext context, CartState state) {
          if (state case CartFailure(:final message)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          }
        },
        builder: (BuildContext context, CartState state) {
          return switch (state) {
            CartInitial() || CartLoading() =>
              const Center(child: CircularProgressIndicator()),
            CartLoaded(:final lines) when lines.isEmpty => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 72,
                        color: palette.primary.withValues(alpha: 0.35),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.cartEmptyTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.cartEmptyBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            CartLoaded(:final lines, :final subtotal) => _CartLoadedBody(
                lines: lines,
                subtotal: subtotal,
                l10n: l10n,
                palette: palette,
              ),
            CartFailure(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(message, textAlign: TextAlign.center),
                ),
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
  });

  final List<CartLineEntity> lines;
  final double subtotal;
  final AppLocalizations l10n;
  final AppPalette palette;

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
                  onDismissed: (_) => context.read<CartBloc>().add(
                        CartLineRemoved(line.productId),
                      ),
                  child: ListTile(
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: line.imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
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
