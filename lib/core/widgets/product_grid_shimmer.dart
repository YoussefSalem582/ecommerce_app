import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:shop_flow/core/theme/app_radius.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';

/// Skeleton placeholders matching responsive catalog tile geometry.
class ProductGridShimmer extends StatelessWidget {
  /// Builds shimmer placeholders for [crossAxisCount] columns.
  const ProductGridShimmer({
    required this.crossAxisCount,
    super.key,
  });

  /// Grid column count implied by [LayoutBuilder] constraints.
  final int crossAxisCount;

  static int columnsForWidth(double width) {
    if (width >= AppBreakpoints.desktop) {
      return 4;
    }
    if (width >= AppBreakpoints.tablet) {
      return 3;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.appPalette;
    final disable =
        kIsWeb || MediaQuery.of(context).disableAnimations;
    final borderColor = palette.muted.withValues(alpha: 0.18);
    final blockColor = palette.muted.withValues(alpha: 0.14);

    Widget tile() {
      final box = Container(
        decoration: BoxDecoration(
          color: disable ? palette.surfaceElevated : null,
          borderRadius: AppRadius.brLg,
          border: Border.all(color: borderColor),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: blockColor,
                  borderRadius: AppRadius.brMd,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Container(
              height: 14,
              width: double.infinity,
              decoration: BoxDecoration(
                color: blockColor,
                borderRadius: AppRadius.brXs,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Container(
              height: 14,
              width: 80,
              decoration: BoxDecoration(
                color: blockColor,
                borderRadius: AppRadius.brXs,
              ),
            ),
          ],
        ),
      );

      if (disable) {
        return box;
      }

      return Shimmer.fromColors(
        baseColor: palette.muted.withValues(alpha: 0.12),
        highlightColor: palette.primary.withValues(alpha: 0.18),
        child: box,
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.72,
      ),
      itemCount: crossAxisCount * 4,
      itemBuilder: (BuildContext context, int _) => tile(),
    );
  }
}
