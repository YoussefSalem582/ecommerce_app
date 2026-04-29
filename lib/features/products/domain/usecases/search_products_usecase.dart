import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';

/// Applies substring filtering via repository search plumbing.
@injectable
class SearchProductsUseCase {
  /// Performs query-aware catalog reads.
  SearchProductsUseCase(this._repository);

  final ProductsRepository _repository;

  /// Returns rows matching [query] scoped by optional [category].
  Future<Either<Failure, List<ProductEntity>>> call({
    required String query,
    String? category,
  }) {
    return _repository.getProducts(
      category: category,
      searchQuery: query,
    );
  }
}
