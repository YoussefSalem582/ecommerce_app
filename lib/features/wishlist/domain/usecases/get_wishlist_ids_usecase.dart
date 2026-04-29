import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Hydrates wishlist ids for cubit startup states.
@injectable
class GetWishlistIdsUseCase {
  /// Reads repository snapshot for presentation bootstrap.
  GetWishlistIdsUseCase(this._repository);

  final WishlistRepository _repository;

  /// Returns persisted SKU ids for UI chips/hearts.
  Future<Either<Failure, Set<int>>> call() {
    return _repository.getIds();
  }
}
