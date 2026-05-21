import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';

/// Listing states emitted by [ProductListBloc].
sealed class ProductListState extends Equatable {
  /// Shared equality baseline.
  const ProductListState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first successful fetch completes.
final class ProductListInitial extends ProductListState {
  /// Placeholder prior to loading transition.
  const ProductListInitial();
}

/// Grid shimmer / spinner visible.
final class ProductListLoading extends ProductListState {
  /// Loading indicator state (distinct per emission so refresh rebuilds).
  const ProductListLoading(this.generation);

  /// Monotonic counter so duplicate [ProductListLoading] emissions differ.
  final int generation;

  @override
  List<Object?> get props => <Object?>[generation];
}

/// Catalog payload ready for rendering.
final class ProductListLoaded extends ProductListState {
  /// Successful catalog emission.
  const ProductListLoaded({
    required this.products,
    required this.categories,
    required this.selectedCategory,
    required this.searchQuery,
    this.viewMode = ProductListViewMode.grid,
    this.sortOption = ProductSortOption.ratingDesc,
    this.minPrice,
    this.maxPrice,
    this.minRating = 0,
    required this.catalogMinPrice,
    required this.catalogMaxPrice,
  });

  /// Visible SKU rows after filters.
  final List<ProductEntity> products;

  /// Chip labels from remote or Hive-derived fallback.
  final List<String> categories;

  /// Active chip (`null` → all products).
  final String? selectedCategory;

  /// Latest submitted search query string.
  final String searchQuery;

  /// Grid or list presentation mode.
  final ProductListViewMode viewMode;

  /// Active client-side sort option.
  final ProductSortOption sortOption;

  /// Active minimum price filter (`null` → catalog min).
  final double? minPrice;

  /// Active maximum price filter (`null` → catalog max).
  final double? maxPrice;

  /// Minimum rating filter (0 = disabled).
  final double minRating;

  /// Unfiltered catalog minimum price for slider bounds.
  final double catalogMinPrice;

  /// Unfiltered catalog maximum price for slider bounds.
  final double catalogMaxPrice;

  /// Whether any client-side filter is active.
  bool get hasActiveFilters =>
      minRating > 0 ||
      (minPrice != null && minPrice! > catalogMinPrice) ||
      (maxPrice != null && maxPrice! < catalogMaxPrice);

  @override
  List<Object?> get props => <Object?>[
        products,
        categories,
        selectedCategory,
        searchQuery,
        viewMode,
        sortOption,
        minPrice,
        maxPrice,
        minRating,
        catalogMinPrice,
        catalogMaxPrice,
      ];
}

/// Recoverable failure surface with messaging for snackbars.
final class ProductListFailure extends ProductListState {
  /// Failure with localized / API detail text.
  const ProductListFailure(this.message);

  /// Human-readable failure detail.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
