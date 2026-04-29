import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart';

/// Loads descending Hive journal for authenticated shoppers.
@injectable
class GetOrdersUseCase {
  /// Reads repository ledger surface.
  GetOrdersUseCase(this._repository);

  final OrdersRepository _repository;

  /// Returns cached rows newest-first.
  Future<Either<Failure, List<OrderEntity>>> call() {
    return _repository.getOrders();
  }
}
