import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Clears Hive cart payload once Stripe / demo checkout succeeds.
@injectable
class ClearCartUseCase {
  /// Repository-only dependency.
  ClearCartUseCase(this._repository);

  final CartRepository _repository;

  /// Drops all persisted SKU rows.
  Future<Either<Failure, Unit>> call() {
    return _repository.clearAll();
  }
}
