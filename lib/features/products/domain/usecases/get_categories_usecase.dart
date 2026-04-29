import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';

/// Loads taxonomy labels for catalog chips.
@injectable
class GetCategoriesUseCase {
  /// Delegates to repository hybrid remote/cache logic.
  GetCategoriesUseCase(this._repository);

  final ProductsRepository _repository;

  /// Returns sorted category labels for filtering UI.
  Future<Either<Failure, List<String>>> call() => _repository.getCategories();
}
