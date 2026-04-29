import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Flips membership for a SKU inside Hive-backed wishlist JSON.
@injectable
class ToggleWishlistUseCase {
  /// Supplies persistence abstraction.
  ToggleWishlistUseCase(this._repository);

  final WishlistRepository _repository;

  /// Persists toggle result set for optimistic cubit emissions.
  Future<Either<Failure, Set<int>>> call(int productId) {
    return _repository.toggle(productId);
  }
}
