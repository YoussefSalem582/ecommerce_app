import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';

/// Fetches catalog rows with optional category + substring filters.
@injectable
class GetProductsUseCase {
  /// Uses repository offline-first pipeline.
  GetProductsUseCase(this._repository);

  final ProductsRepository _repository;

  /// Loads SKU rows for listing grids.
  Future<Either<Failure, List<ProductEntity>>> call({
    String? category,
    String? searchQuery,
  }) {
    return _repository.getProducts(
      category: category,
      searchQuery: searchQuery,
    );
  }
}
