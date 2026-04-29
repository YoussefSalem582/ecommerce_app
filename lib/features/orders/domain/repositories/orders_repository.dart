import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';

/// Local-first order journal (`orders_cache` Hive box).
abstract class OrdersRepository {
  /// Chronological history (newest first).
  Future<Either<Failure, List<OrderEntity>>> getOrders();

  /// Lookup by opaque id string.
  Future<Either<Failure, OrderEntity?>> getOrderById(String id);

  /// Prepends [order] JSON into Hive ledger.
  Future<Either<Failure, Unit>> saveOrder(OrderEntity order);
}
