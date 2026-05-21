import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';

/// Catalog list events consumed by [ProductListBloc].
sealed class ProductListEvent extends Equatable {
  /// Common base for diff-friendly equality.
  const ProductListEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Cold-start / retry fetch for grid + chips.
final class ProductListStarted extends ProductListEvent {
  /// Requests categories + SKUs.
  const ProductListStarted();
}

/// Pull-to-refresh gesture on catalog scaffold.
final class ProductListRefreshRequested extends ProductListEvent {
  /// Silent reload preserving filters.
  const ProductListRefreshRequested();
}

/// Category chip selection (`null` means “all”).
final class ProductListCategorySelected extends ProductListEvent {
  /// Creates category filter event.
  const ProductListCategorySelected(this.category);

  /// Selected taxonomy label or `null` for full catalog.
  final String? category;

  @override
  List<Object?> get props => <Object?>[category];
}

/// Search field submission (Enter / icon).
final class ProductListSearchSubmitted extends ProductListEvent {
  /// Stores plain-text query state on bloc.
  const ProductListSearchSubmitted(this.query);

  /// User-entered substring filter.
  final String query;

  @override
  List<Object?> get props => <Object?>[query];
}

/// Toggles grid vs list layout on catalog.
final class ProductListViewModeToggled extends ProductListEvent {
  /// Switches between grid and list presentation.
  const ProductListViewModeToggled();
}

/// Client-side sort option changed (applied after fetch).
final class ProductListSortChanged extends ProductListEvent {
  /// Updates sort reducer on bloc.
  const ProductListSortChanged(this.sortOption);

  /// Selected sort strategy.
  final ProductSortOption sortOption;

  @override
  List<Object?> get props => <Object?>[sortOption];
}

/// Price range filter changed (`null` bounds mean unbounded).
final class ProductListPriceRangeChanged extends ProductListEvent {
  /// Updates min/max USD filter.
  const ProductListPriceRangeChanged({
    required this.minPrice,
    required this.maxPrice,
  });

  /// Lower bound inclusive (`null` → catalog min).
  final double? minPrice;

  /// Upper bound inclusive (`null` → catalog max).
  final double? maxPrice;

  @override
  List<Object?> get props => <Object?>[minPrice, maxPrice];
}

/// Minimum aggregate rating filter (0 = no filter).
final class ProductListMinRatingChanged extends ProductListEvent {
  /// Sets star threshold filter.
  const ProductListMinRatingChanged(this.minRating);

  /// Minimum rating average inclusive.
  final double minRating;

  @override
  List<Object?> get props => <Object?>[minRating];
}

/// Clears price/rating filters while preserving category + search.
final class ProductListFiltersCleared extends ProductListEvent {
  /// Resets client-side filter state.
  const ProductListFiltersCleared();
}
