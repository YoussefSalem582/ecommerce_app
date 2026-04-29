import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/core/widgets/fly_to_cart_overlay.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_state.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// PDP with Hero gallery + offline-aware hydration.
class ProductDetailPage extends StatefulWidget {
  /// Binds PDP route parameters.
  const ProductDetailPage({required this.productId, super.key});

  /// SKU identifier from `/product/:id`.
  final int productId;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _addToCartButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<ProductDetailBloc>().add(
            ProductDetailLoadRequested(widget.productId),
          );
    });
  }

  void _handleAddToCart(
    BuildContext context,
    ProductEntity product,
    AppLocalizations l10n,
  ) {
    final BuildContext? btnCtx = _addToCartButtonKey.currentContext;
    final BuildContext? cartCtx = _cartIconKey.currentContext;
    if (btnCtx != null && cartCtx != null) {
      final RenderObject? roBtn = btnCtx.findRenderObject();
      final RenderObject? roCart = cartCtx.findRenderObject();
      if (roBtn is RenderBox && roCart is RenderBox) {
        final Rect start =
            roBtn.localToGlobal(Offset.zero) & roBtn.size;
        final Rect end =
            roCart.localToGlobal(Offset.zero) & roCart.size;
        FlyToCartOverlay.show(
          context,
          startRect: start,
          endRect: end,
          imageUrl: product.imageUrl,
        );
      }
    }
    context.read<CartBloc>().add(CartProductAdded(product));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.addToCartSuccess)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (BuildContext context, ProductDetailState state) {
            if (state is ProductDetailLoaded) {
              return Text(
                state.product.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              );
            }
            return Text(l10n.productDetailLoadingTitle);
          },
        ),
        actions: <Widget>[
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (BuildContext context, ProductDetailState detailState) {
              if (detailState is! ProductDetailLoaded) {
                return const SizedBox.shrink();
              }
              final product = detailState.product;
              return BlocBuilder<WishlistCubit, WishlistState>(
                builder: (BuildContext context, WishlistState wl) {
                  final bool isFav =
                      wl is WishlistReady && wl.contains(product.id);
                  return IconButton(
                    tooltip: l10n.wishlistToggleTooltip,
                    icon: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                    ),
                    onPressed: () =>
                        context.read<WishlistCubit>().toggleId(product.id),
                  );
                },
              );
            },
          ),
          BlocSelector<CartBloc, CartState, int>(
            selector: (CartState s) =>
                s is CartLoaded ? s.totalQuantity : 0,
            builder: (BuildContext context, int count) {
              return Badge(
                isLabelVisible: count > 0,
                label: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(
                      scale: animation,
                      child: child,
                    );
                  },
                  child: Text(
                    '$count',
                    key: ValueKey<int>(count),
                  ),
                ),
                child: IconButton(
                  key: _cartIconKey,
                  tooltip: l10n.cartTooltip,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => context.push(AppRoutes.cart),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
        builder: (BuildContext context, ProductDetailState state) {
          if (state is ProductDetailLoading ||
              state is ProductDetailInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ProductDetailFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => context.read<ProductDetailBloc>().add(
                            ProductDetailLoadRequested(widget.productId),
                          ),
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is ProductDetailLoaded) {
            final product = state.product;
            final palette = context.appPalette;
            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  SizedBox(
                    height: 300,
                    child: PageView(
                      children: <Widget>[
                        Hero(
                          tag: 'product-hero-${product.id}',
                          child: CachedNetworkImage(
                            imageUrl: product.imageUrl,
                            fit: BoxFit.contain,
                            placeholder: (_, __) => Container(
                              color: palette.surface,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: palette.primary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          product.title,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          PriceFormatter.formatUsd(context, product.price),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: palette.primary),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.productRatingLabel(
                            product.ratingRate.toStringAsFixed(1),
                            product.ratingCount,
                          ),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.description,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 24),
                        FilledButton.icon(
                          key: _addToCartButtonKey,
                          onPressed: () =>
                              _handleAddToCart(context, product, l10n),
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: Text(l10n.addToCartLabel),
                        ),
                      ],
                    ),
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
