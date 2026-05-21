import 'package:flutter/material.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_search_bar.dart';
import 'package:shop_flow/features/home/presentation/widgets/home_spacing.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';

/// Pinned [SliverPersistentHeader] hosting the catalog search row.
class CatalogPinnedHeader extends StatelessWidget {
  /// Creates a pinned search + filter header sliver.
  const CatalogPinnedHeader({
    required this.searchController,
    required this.onSearchSubmitted,
    required this.listState,
    required this.onShowFilterSheet,
    super.key,
  });

  /// Search field controller owned by the parent page.
  final TextEditingController searchController;

  /// Invoked when the user submits a search query.
  final VoidCallback onSearchSubmitted;

  /// Current product list BLoC state.
  final ProductListState listState;

  /// Opens the filter bottom sheet when catalog is loaded.
  final void Function(ProductListLoaded loaded) onShowFilterSheet;

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _CatalogPinnedHeaderDelegate(
        child: Material(
          color: Theme.of(context).colorScheme.surface,
          child: CatalogSearchBar(
            controller: searchController,
            onSubmitted: onSearchSubmitted,
            listState: listState,
            onShowFilterSheet: onShowFilterSheet,
          ),
        ),
      ),
    );
  }
}

class _CatalogPinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  _CatalogPinnedHeaderDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => HomeSpacing.pinnedSearchHeight;

  @override
  double get maxExtent => HomeSpacing.pinnedSearchHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox(
      height: HomeSpacing.pinnedSearchHeight,
      child: child,
    );
  }

  @override
  bool shouldRebuild(covariant _CatalogPinnedHeaderDelegate oldDelegate) {
    return oldDelegate.child != child;
  }
}
