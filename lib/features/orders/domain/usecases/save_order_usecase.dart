import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart';

/// Persists completed checkout aggregates into Hive ledger.
@injectable
class SaveOrderUseCase {
  /// Constructor binds repository port.
  SaveOrderUseCase(this._repository);

  final OrdersRepository _repository;

  /// Appends [order] JSON history row.
  Future<Either<Failure, Unit>> call(OrderEntity order) {
    return _repository.saveOrder(order);
  }
}
