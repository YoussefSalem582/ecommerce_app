import 'package:flutter/material.dart';

import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';

/// Compact lime rating pill (star glyph + numeric rating) used on catalog
/// tiles and the product detail page.
class RatingBadge extends StatelessWidget {
  /// Creates a rating pill for [rating].
  const RatingBadge({
    required this.rating,
    this.dense = true,
    super.key,
  });

  /// Aggregate rating value (e.g. `4.3`).
  final double rating;

  /// When true renders the tighter catalog-tile size; false is the roomier
  /// PDP size.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final double iconSize = dense ? 13 : 16;
    final EdgeInsets padding = dense
        ? const EdgeInsets.symmetric(horizontal: 8, vertical: 3)
        : const EdgeInsets.symmetric(horizontal: 10, vertical: 5);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: palette.accent,
        borderRadius: AppRadius.brPill,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(Icons.star_rounded, size: iconSize, color: palette.onAccent),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: (dense
                    ? Theme.of(context).textTheme.labelSmall
                    : Theme.of(context).textTheme.labelLarge)
                ?.copyWith(
              color: palette.onAccent,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
