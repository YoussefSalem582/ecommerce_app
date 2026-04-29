import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

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
  });

  /// Visible SKU rows after filters.
  final List<ProductEntity> products;

  /// Chip labels from remote or Hive-derived fallback.
  final List<String> categories;

  /// Active chip (`null` → all products).
  final String? selectedCategory;

  /// Latest submitted search query string.
  final String searchQuery;

  @override
  List<Object?> get props =>
      <Object?>[products, categories, selectedCategory, searchQuery];
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
