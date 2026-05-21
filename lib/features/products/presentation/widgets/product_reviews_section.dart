import 'package:flutter/material.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/entities/product_review_entity.dart';

/// Showcase reviews list with aggregate rating from catalog entity.
class ProductReviewsSection extends StatelessWidget {
  /// Builds mock review rows for [product].
  const ProductReviewsSection({required this.product, super.key});

  /// PDP product with aggregate rating fields.
  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = context.appPalette;
    final reviews = MockReviewGenerator.forProduct(
      productId: product.id,
      ratingRate: product.ratingRate,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          l10n.productReviewsTitle,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Icon(Icons.star_rounded, color: palette.accent, size: 28),
            const SizedBox(width: 8),
            Text(
              product.ratingRate.toStringAsFixed(1),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(width: 8),
            Text(
              l10n.productReviewsCount(product.ratingCount),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...reviews.map(
          (ProductReviewEntity review) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(review.author),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: List<Widget>.generate(5, (int i) {
                      return Icon(
                        i < review.rating.round()
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        size: 16,
                        color: palette.accent,
                      );
                    }),
                  ),
                  const SizedBox(height: 4),
                  Text(review.body),
                  const SizedBox(height: 4),
                  Text(
                    review.date,
                    style: Theme.of(context).textTheme.labelSmall,
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
