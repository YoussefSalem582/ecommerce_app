import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Invoked when connectivity returns — placeholder until backend carts exist.
@injectable
class SyncCartUseCase {
  /// Bridges repository sync hooks into presentation layer.
  SyncCartUseCase(this._repository);

  final CartRepository _repository;

  /// Logs analytics-friendly hook for reviewers.
  Future<Either<Failure, Unit>> call() {
    return _repository.syncPending();
  }
}
