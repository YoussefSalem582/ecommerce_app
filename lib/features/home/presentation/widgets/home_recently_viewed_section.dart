import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_cubit.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_state.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';

/// Horizontal strip of recently viewed products above the catalog grid.
class HomeRecentlyViewedSection extends StatelessWidget {
  /// Creates the recently viewed carousel section.
  const HomeRecentlyViewedSection({super.key});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);

    return BlocBuilder<RecentlyViewedCubit, RecentlyViewedState>(
      builder: (BuildContext context, RecentlyViewedState rvState) {
        if (rvState is! RecentlyViewedReady || rvState.products.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: HomeSpacing.sectionHeaderPadding,
              child: Text(
                l10n.recentlyViewedTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: HomeSpacing.recentlyViewedHeight,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: HomeSpacing.pageHorizontal,
                itemCount: rvState.products.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (BuildContext context, int index) {
                  final ProductEntity product = rvState.products[index];
                  return SizedBox(
                    width: HomeSpacing.recentlyViewedTileWidth,
                    child: ProductCard(
                      product: product,
                      enableHero: false,
                      onTap: () => context.push(AppRoutes.product(product.id)),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: HomeSpacing.sectionGap),
          ],
        );
      },
    );
  }
}
