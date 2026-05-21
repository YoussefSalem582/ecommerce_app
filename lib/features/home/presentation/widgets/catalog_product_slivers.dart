import 'package:flutter/material.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/product_grid_shimmer.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_clear_filters_chip.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';

/// Product catalog content as slivers (loading, error, empty, grid, list).
abstract final class CatalogProductSlivers {
  /// Builds slivers for the current [listState] at [contentWidth].
  static List<Widget> build({
    required BuildContext context,
    required ProductListState listState,
    required double contentWidth,
    required VoidCallback onRetry,
    required ValueChanged<int> onProductTap,
    VoidCallback? onClearFilters,
  }) {
    final int cols = ProductGridShimmer.columnsForWidth(contentWidth);

    if (listState is ProductListInitial || listState is ProductListLoading) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: ProductGridShimmer(crossAxisCount: cols),
        ),
      ];
    }

    if (listState is ProductListFailure) {
      return <Widget>[
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppErrorView(
            message: listState.message,
            onRetry: onRetry,
          ),
        ),
      ];
    }

    if (listState is ProductListLoaded) {
      final List<ProductEntity> products = listState.products;
      final AppLocalizations l10n = AppLocalizations.of(context);

      if (products.isEmpty) {
        return <Widget>[
          SliverFillRemaining(
            hasScrollBody: false,
            child: AppEmptyView(
              icon: Icons.inventory_2_outlined,
              title: l10n.catalogEmpty,
              body: l10n.catalogEmptyBody,
              action: listState.hasActiveFilters && onClearFilters != null
                  ? CatalogClearFiltersChip(onPressed: onClearFilters)
                  : null,
            ),
          ),
        ];
      }

      final EdgeInsets padding = const EdgeInsets.symmetric(
        horizontal: HomeSpacing.horizontal,
      );

      if (listState.viewMode == ProductListViewMode.list) {
        return <Widget>[
          SliverPadding(
            padding: padding,
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  final ProductEntity product = products[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: ProductCard(
                      key: index == 0 ? TestKeys.firstProductCard : null,
                      product: product,
                      onTap: () => onProductTap(product.id),
                    ),
                  );
                },
                childCount: products.length,
              ),
            ),
          ),
        ];
      }

      return <Widget>[
        SliverPadding(
          padding: padding,
          sliver: SliverGrid(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.72,
            ),
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final ProductEntity product = products[index];
                return ProductCard(
                  key: index == 0 ? TestKeys.firstProductCard : null,
                  product: product,
                  onTap: () => onProductTap(product.id),
                );
              },
              childCount: products.length,
            ),
          ),
        ),
      ];
    }

    return const <Widget>[];
  }
}
