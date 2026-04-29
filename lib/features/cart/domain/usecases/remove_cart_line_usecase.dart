import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Deletes a SKU row (swipe-to-remove from cart screen).
@injectable
class RemoveCartLineUseCase {
  /// Repository-only dependency surface.
  RemoveCartLineUseCase(this._repository);

  final CartRepository _repository;

  /// Drops [productId] from persisted payload.
  Future<Either<Failure, List<CartLineEntity>>> call(int productId) {
    return _repository.removeLine(productId);
  }
}
