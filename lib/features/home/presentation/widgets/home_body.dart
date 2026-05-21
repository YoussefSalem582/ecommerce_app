import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_category_chips.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_clear_filters_chip.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_product_viewport.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_search_bar.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_recently_viewed_section.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';

/// Scrollable catalog body — search, recently viewed, filters, and grid.
class HomeBody extends StatelessWidget {
  /// Creates the home catalog body.
  const HomeBody({
    required this.listState,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.onProductTap,
    required this.onShowFilterSheet,
    super.key,
  });

  /// Current product list BLoC state.
  final ProductListState listState;

  /// Search field controller owned by the parent page.
  final TextEditingController searchController;

  /// Invoked when the user submits a search query.
  final VoidCallback onSearchSubmitted;

  /// Invoked when a product tile is tapped.
  final ValueChanged<int> onProductTap;

  /// Opens the filter bottom sheet (includes sort).
  final void Function(ProductListLoaded loaded) onShowFilterSheet;

  void _clearFilters(BuildContext context) {
    context.read<ProductListBloc>().add(const ProductListFiltersCleared());
  }

  Future<void> _refresh(BuildContext context) async {
    final ProductListBloc bloc = context.read<ProductListBloc>();
    bloc.add(const ProductListRefreshRequested());
    await bloc.stream.firstWhere(
      (ProductListState s) => s is ProductListLoaded || s is ProductListFailure,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool wide = constraints.maxWidth >= AppBreakpoints.tablet;

        final Widget content = Column(
          children: <Widget>[
            CatalogSearchBar(
              controller: searchController,
              onSubmitted: onSearchSubmitted,
              listState: listState,
              onShowFilterSheet: onShowFilterSheet,
            ),
            const SizedBox(height: HomeSpacing.sectionGap),
            const HomeRecentlyViewedSection(),
            if (listState is ProductListLoaded &&
                (listState as ProductListLoaded).hasActiveFilters &&
                (listState as ProductListLoaded).products.isNotEmpty)
              CatalogClearFiltersChip(onPressed: () => _clearFilters(context)),
            if (listState is ProductListLoaded &&
                (listState as ProductListLoaded).categories.isNotEmpty)
              CatalogCategoryChips(
                categories: (listState as ProductListLoaded).categories,
                selectedCategory:
                    (listState as ProductListLoaded).selectedCategory,
                onCategorySelected: (String? category) {
                  context.read<ProductListBloc>().add(
                    ProductListCategorySelected(category),
                  );
                },
              ),
            Expanded(
              child: CatalogProductViewport(
                listState: listState,
                onRetry: () => context.read<ProductListBloc>().add(
                  const ProductListStarted(),
                ),
                onRefresh: () => _refresh(context),
                onProductTap: onProductTap,
                onClearFilters:
                    listState is ProductListLoaded &&
                        (listState as ProductListLoaded).hasActiveFilters
                    ? () => _clearFilters(context)
                    : null,
              ),
            ),
          ],
        );

        if (!wide) {
          return content;
        }

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: HomeSpacing.maxContentWidth,
            ),
            child: content,
          ),
        );
      },
    );
  }
}
