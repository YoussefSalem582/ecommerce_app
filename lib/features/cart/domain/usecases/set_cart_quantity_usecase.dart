import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Updates quantity or deletes row when quantity reaches zero.
@injectable
class SetCartQuantityUseCase {
  /// Supplies persistence orchestration.
  SetCartQuantityUseCase(this._repository);

  final CartRepository _repository;

  /// Persists new quantity for [productId].
  Future<Either<Failure, List<CartLineEntity>>> call(
    int productId,
    int quantity,
  ) {
    return _repository.setQuantity(productId, quantity);
  }
}
