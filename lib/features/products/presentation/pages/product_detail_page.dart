import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/core/widgets/fly_to_cart_overlay.dart';
import 'package:shop_flow/core/widgets/offline_banner.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_state.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_cubit.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_reviews_section.dart';
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

  Future<void> _shareProduct(ProductEntity product, AppLocalizations l10n) async {
    final String message = l10n.productShareMessage(
      product.title,
      'shopflow://product/${product.id}',
    );
    try {
      await Share.share(message);
    } on Exception {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.productShareFailed)),
      );
    }
  }

  void _onProductLoaded(ProductEntity product) {
    context.read<RecentlyViewedCubit>().recordView(product.id);
  }

  void _handleAddToCart(
    BuildContext context,
    ProductEntity product,
    AppLocalizations l10n,
  ) {
    final BuildContext? btnCtx = TestKeys.addToCartButton.currentContext;
    final BuildContext? cartCtx = TestKeys.pdpCartButton.currentContext;
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
            return switch (state) {
              ProductDetailLoaded(:final product) => Text(
                  product.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              _ => Text(l10n.productDetailLoadingTitle),
            };
          },
        ),
        actions: <Widget>[
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (BuildContext context, ProductDetailState detailState) {
              if (detailState case ProductDetailLoaded(:final product)) {
                return IconButton(
                  key: TestKeys.productShareButton,
                  tooltip: l10n.productShareTooltip,
                  icon: const Icon(Icons.share_outlined),
                  onPressed: () => _shareProduct(product, l10n),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocBuilder<ProductDetailBloc, ProductDetailState>(
            builder: (BuildContext context, ProductDetailState detailState) {
              if (detailState case ProductDetailLoaded(:final product)) {
              return BlocBuilder<WishlistCubit, WishlistState>(
                builder: (BuildContext context, WishlistState wl) {
                  final bool isFav = switch (wl) {
                    WishlistReady ready => ready.contains(product.id),
                    _ => false,
                  };
                  return Semantics(
                    label: isFav
                        ? l10n.removeFromWishlistA11y
                        : l10n.addToWishlistA11y,
                    button: true,
                    child: IconButton(
                      key: TestKeys.wishlistToggleButton,
                      tooltip: isFav
                          ? l10n.removeFromWishlistA11y
                          : l10n.addToWishlistA11y,
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                      ),
                      onPressed: () =>
                          context.read<WishlistCubit>().toggleId(product.id),
                    ),
                  );
                },
              );
              }
              return const SizedBox.shrink();
            },
          ),
          BlocSelector<CartBloc, CartState, int>(
            selector: (CartState s) => switch (s) {
              CartLoaded(:final totalQuantity) => totalQuantity,
              _ => 0,
            },
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
                  key: TestKeys.pdpCartButton,
                  tooltip: l10n.cartTooltip,
                  icon: const Icon(Icons.shopping_cart_outlined),
                  onPressed: () => context.push(AppRoutes.cart),
                ),
              );
            },
          ),
        ],
      ),
      body: OfflineBanner(
        child: BlocConsumer<ProductDetailBloc, ProductDetailState>(
          listenWhen: (ProductDetailState prev, ProductDetailState curr) =>
              curr is ProductDetailLoaded && prev is! ProductDetailLoaded,
          listener: (BuildContext context, ProductDetailState state) {
            if (state case ProductDetailLoaded(:final product)) {
              _onProductLoaded(product);
            }
          },
          builder: (BuildContext context, ProductDetailState state) {
            return switch (state) {
              ProductDetailInitial() || ProductDetailLoading() =>
                const AppLoadingView(),
              ProductDetailFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context.read<ProductDetailBloc>().add(
                        ProductDetailLoadRequested(widget.productId),
                      ),
                ),
              ProductDetailLoaded(
                :final product,
                :final relatedProducts,
              ) =>
                _ProductDetailLoadedBody(
                  product: product,
                  relatedProducts: relatedProducts,
                  l10n: l10n,
                  onAddToCart: () => _handleAddToCart(context, product, l10n),
                ),
            };
          },
        ),
      ),
    );
  }
}

class _ProductDetailLoadedBody extends StatelessWidget {
  const _ProductDetailLoadedBody({
    required this.product,
    required this.relatedProducts,
    required this.l10n,
    required this.onAddToCart,
  });

  final ProductEntity product;
  final List<ProductEntity> relatedProducts;
  final AppLocalizations l10n;
  final VoidCallback onAddToCart;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    return SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    SizedBox(
                      height: 300,
                      child: Hero(
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
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: palette.accent.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              l10n.productRatingLabel(
                                product.ratingRate.toStringAsFixed(1),
                                product.ratingCount,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(color: palette.accent),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            product.description,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 24),
                          ProductReviewsSection(product: product),
                          if (relatedProducts.isNotEmpty) ...<Widget>[
                            const SizedBox(height: 24),
                            Text(
                              l10n.relatedProductsTitle,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 220,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: relatedProducts.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (BuildContext context, int index) {
                                  final ProductEntity related =
                                      relatedProducts[index];
                                  return SizedBox(
                                    width: 160,
                                    child: ProductCard(
                                      product: related,
                                      enableHero: false,
                                      onTap: () => context.push(
                                        AppRoutes.product(related.id),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                          const SizedBox(height: 24),
                          FilledButton.icon(
                            key: TestKeys.addToCartButton,
                            onPressed: onAddToCart,
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
}
