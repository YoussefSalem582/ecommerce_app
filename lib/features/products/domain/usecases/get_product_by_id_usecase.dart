import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';

/// Loads PDP payload by numeric identifier.
@injectable
class GetProductByIdUseCase {
  /// Uses repository remote-first + Hive fallback.
  GetProductByIdUseCase(this._repository);

  final ProductsRepository _repository;

  /// Resolves a SKU snapshot for detail screens.
  Future<Either<Failure, ProductEntity>> call(int id) {
    return _repository.getProductById(id);
  }
}
