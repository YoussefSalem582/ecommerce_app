import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
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
    this.enableHero = true,
    super.key,
  });

  /// SKU entity backing the tile.
  final ProductEntity product;

  /// Invoked when user selects the tile.
  final VoidCallback onTap;

  /// When false, image is not wrapped in [Hero] (use for duplicate tiles on one screen).
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final disableAnimations =
        kIsWeb || MediaQuery.of(context).disableAnimations;

    Widget card = Semantics(
      label: product.title,
      button: true,
      child: _PressableCard(
        onTap: onTap,
        enableScale: !disableAnimations,
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm),
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final bool gridTile = constraints.maxHeight.isFinite;
                return Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    gridTile
                        ? _GridProductBody(
                            product: product,
                            palette: palette,
                            enableHero: enableHero,
                          )
                        : _ListProductBody(
                            product: product,
                            palette: palette,
                            enableHero: enableHero,
                          ),
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

/// Wraps a tappable card with a springy press-down scale.
class _PressableCard extends StatefulWidget {
  const _PressableCard({
    required this.child,
    required this.onTap,
    required this.enableScale,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool enableScale;

  @override
  State<_PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<_PressableCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enableScale || _pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.97 : 1,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  const _RatingPill({required this.rating, required this.palette});

  final double rating;
  final AppPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 3),
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.star_rounded, size: 13, color: palette.onAccent),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: palette.onAccent,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ],
      ),
    );
  }
}

class _GridProductBody extends StatelessWidget {
  const _GridProductBody({
    required this.product,
    required this.palette,
    required this.enableHero,
  });

  final ProductEntity product;
  final AppPalette palette;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: _ProductImage(
            product: product,
            palette: palette,
            enableHero: enableHero,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          product.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                PriceFormatter.formatUsd(context, product.price),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: palette.primary,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ),
            _RatingPill(rating: product.ratingRate, palette: palette),
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
    required this.enableHero,
  });

  final ProductEntity product;
  final AppPalette palette;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 92,
          height: 92,
          child: _ProductImage(
            product: product,
            palette: palette,
            enableHero: enableHero,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
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
              const SizedBox(height: AppSpacing.xs),
              Row(
                children: <Widget>[
                  Text(
                    PriceFormatter.formatUsd(context, product.price),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: palette.primary,
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  _RatingPill(rating: product.ratingRate, palette: palette),
                ],
              ),
              const SizedBox(height: 2),
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
    required this.enableHero,
  });

  final ProductEntity product;
  final AppPalette palette;
  final bool enableHero;

  @override
  Widget build(BuildContext context) {
    final Widget image = ClipRRect(
      borderRadius: AppRadius.brMd,
      child: CachedNetworkImage(
        imageUrl: product.imageUrl,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholder: (_, __) => Container(
          color: palette.muted.withValues(alpha: 0.12),
          alignment: Alignment.center,
          child: CircularProgressIndicator(
            color: palette.primary,
            strokeWidth: 2,
          ),
        ),
        errorWidget: (_, __, ___) => Container(
          color: palette.muted.withValues(alpha: 0.12),
          alignment: Alignment.center,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: palette.error,
          ),
        ),
      ),
    );

    if (!enableHero) {
      return image;
    }

    return Hero(
      tag: 'product-hero-${product.id}',
      child: image,
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.productId});

  final int productId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

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
              style: IconButton.styleFrom(
                backgroundColor: palette.surfaceElevated.withValues(alpha: 0.92),
                foregroundColor: isFav ? palette.secondary : palette.onSurface,
              ),
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
