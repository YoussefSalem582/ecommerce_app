import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Compact catalog tile with Hero flight into PDP.
class ProductCard extends StatelessWidget {
  /// Renders grid card content for [product].
  const ProductCard({
    required this.product,
    required this.onTap,
    super.key,
  });

  /// SKU entity backing the tile.
  final ProductEntity product;

  /// Invoked when user selects the tile.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final disableAnimations =
        kIsWeb || MediaQuery.of(context).disableAnimations;

    Widget card = Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool gridTile = constraints.maxHeight.isFinite;
              return Stack(
                clipBehavior: Clip.none,
                children: <Widget>[
                  gridTile
                      ? _GridProductBody(product: product, palette: palette)
                      : _ListProductBody(product: product, palette: palette),
                  Positioned(
                    top: -4,
                    right: -4,
                    child: _WishlistButton(productId: product.id),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    if (!disableAnimations) {
      card = card
          .animate()
          .fadeIn(duration: 220.ms)
          .slideY(begin: 0.04, duration: 220.ms);
    }

    return card;
  }
}

class _GridProductBody extends StatelessWidget {
  const _GridProductBody({
    required this.product,
    required this.palette,
  });

  final ProductEntity product;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _ProductImage(product: product, palette: palette),
        ),
        const SizedBox(height: 10),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                PriceFormatter.formatUsd(context, product.price),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: palette.accent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                product.ratingRate.toStringAsFixed(1),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: palette.accent),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          l10n.productRatingLabel(
            product.ratingRate.toStringAsFixed(1),
            product.ratingCount,
          ),
          style: Theme.of(context).textTheme.labelSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ListProductBody extends StatelessWidget {
  const _ListProductBody({
    required this.product,
    required this.palette,
  });

  final ProductEntity product;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 88,
          height: 88,
          child: _ProductImage(product: product, palette: palette),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                product.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 6),
              Text(
                PriceFormatter.formatUsd(context, product.price),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w700,
                    ),
              ),
              Text(
                l10n.productRatingLabel(
                  product.ratingRate.toStringAsFixed(1),
                  product.ratingCount,
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.product,
    required this.palette,
  });

  final ProductEntity product;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'product-hero-${product.id}',
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CachedNetworkImage(
          imageUrl: product.imageUrl,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          placeholder: (_, __) => Container(
            color: palette.surface,
            alignment: Alignment.center,
            child: CircularProgressIndicator(
              color: palette.primary,
              strokeWidth: 2,
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            color: palette.surface,
            alignment: Alignment.center,
            child: Icon(
              Icons.image_not_supported_outlined,
              color: palette.error,
            ),
          ),
        ),
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Material(
      color: Colors.transparent,
      child: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (BuildContext context, WishlistState wl) {
          final bool isFav = wl is WishlistReady && wl.contains(productId);
          return Semantics(
            label: isFav
                ? l10n.removeFromWishlistA11y
                : l10n.addToWishlistA11y,
            button: true,
            child: IconButton.filledTonal(
              tooltip: isFav
                  ? l10n.removeFromWishlistA11y
                  : l10n.addToWishlistA11y,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(width: 36, height: 36),
              iconSize: 20,
              onPressed: () =>
                  context.read<WishlistCubit>().toggleId(productId),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            ),
          );
        },
      ),
    );
  }
}
