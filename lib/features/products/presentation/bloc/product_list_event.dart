import 'package:equatable/equatable.dart';

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
