import 'package:flutter/material.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_category_chips.dart';
import 'package:shop_flow/features/home/presentation/widgets/catalog_clear_filters_chip.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';

/// Builds filter slivers (clear chip + category chips) for the catalog.
abstract final class CatalogFiltersSection {
  /// Returns slivers for active filters and category chips when [loaded] is set.
  static List<Widget> buildSlivers({
    required ProductListLoaded? loaded,
    required VoidCallback onClearFilters,
    required ValueChanged<String?> onCategorySelected,
  }) {
    if (loaded == null) {
      return const <Widget>[];
    }

    final List<Widget> slivers = <Widget>[];

    if (loaded.hasActiveFilters && loaded.products.isNotEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: CatalogClearFiltersChip(onPressed: onClearFilters),
        ),
      );
    }

    if (loaded.categories.isNotEmpty) {
      slivers.add(
        SliverToBoxAdapter(
          child: CatalogCategoryChips(
            categories: loaded.categories,
            selectedCategory: loaded.selectedCategory,
            onCategorySelected: onCategorySelected,
          ),
        ),
      );
    }

    return slivers;
  }
}
