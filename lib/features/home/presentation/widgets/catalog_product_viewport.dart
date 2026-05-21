import 'package:flutter/material.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/product_grid_shimmer.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_clear_filters_chip.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/products/presentation/widgets/product_card_widget.dart';

/// Catalog product area — loading, error, empty, grid/list with pull-to-refresh.
class CatalogProductViewport extends StatelessWidget {
  /// Creates the expandable catalog content region.
  const CatalogProductViewport({
    required this.listState,
    required this.onRetry,
    required this.onRefresh,
    required this.onProductTap,
    this.onClearFilters,
    super.key,
  });

  /// Current product list BLoC state.
  final ProductListState listState;

  /// Invoked to reload after a failure.
  final VoidCallback onRetry;

  /// Invoked for pull-to-refresh; should await completion.
  final Future<void> Function() onRefresh;

  /// Invoked when a product tile is tapped.
  final ValueChanged<int> onProductTap;

  /// Optional callback to clear filters (shown in empty state when active).
  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints gridConstraints) {
        final int cols = ProductGridShimmer.columnsForWidth(
          gridConstraints.maxWidth,
        );

        if (listState is ProductListInitial ||
            listState is ProductListLoading) {
          return ProductGridShimmer(crossAxisCount: cols);
        }

        if (listState is ProductListFailure) {
          return AppErrorView(
            message: (listState as ProductListFailure).message,
            onRetry: onRetry,
          );
        }

        if (listState is ProductListLoaded) {
          final ProductListLoaded loaded = listState as ProductListLoaded;
          final List<ProductEntity> products = loaded.products;

          if (products.isEmpty) {
            return AppEmptyView(
              icon: Icons.inventory_2_outlined,
              title: l10n.catalogEmpty,
              body: l10n.catalogEmptyBody,
              action: loaded.hasActiveFilters && onClearFilters != null
                  ? CatalogClearFiltersChip(onPressed: onClearFilters!)
                  : null,
            );
          }

          return RefreshIndicator(
            color: palette.primary,
            onRefresh: onRefresh,
            child: loaded.viewMode == ProductListViewMode.list
                ? ListView.builder(
                    padding: const EdgeInsets.all(HomeSpacing.horizontal),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
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
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(HomeSpacing.horizontal),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.72,
                    ),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ProductEntity product = products[index];
                      return ProductCard(
                        key: index == 0 ? TestKeys.firstProductCard : null,
                        product: product,
                        onTap: () => onProductTap(product.id),
                      );
                    },
                  ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
