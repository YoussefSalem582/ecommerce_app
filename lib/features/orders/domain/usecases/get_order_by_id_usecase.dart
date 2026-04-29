import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart';

/// PDP-style drill-down for timeline rendering.
@injectable
class GetOrderByIdUseCase {
  /// Supplies lookup abstraction.
  GetOrderByIdUseCase(this._repository);

  final OrdersRepository _repository;

  /// Returns single journal hit when present.
  Future<Either<Failure, OrderEntity?>> call(String id) {
    return _repository.getOrderById(id);
  }
}
