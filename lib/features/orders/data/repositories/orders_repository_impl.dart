import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/orders/data/datasources/local_orders_datasource.dart';
import 'package:shop_flow/features/orders/data/models/order_model.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart';

/// Offline-first journal — Fake Store has no purchase API.
@lazySingleton
class OrdersRepositoryImpl implements OrdersRepository {
  /// Combines serializer + Talker breadcrumbs.
  OrdersRepositoryImpl(this._local, this._talker);

  final LocalOrdersDatasource _local;
  final Talker _talker;

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final models = await _local.readAll();
      return Right<Failure, List<OrderEntity>>(
        models.map((OrderModel m) => m.toEntity()).toList(),
      );
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, List<OrderEntity>>(
        CacheFailure('Could not read orders'),
      );
    }
  }

  @override
  Future<Either<Failure, OrderEntity?>> getOrderById(String id) async {
    try {
      final models = await _local.readAll();
      OrderModel? hit;
      for (final OrderModel m in models) {
        if (m.id == id) {
          hit = m;
          break;
        }
      }
      return Right<Failure, OrderEntity?>(hit?.toEntity());
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, OrderEntity?>(
        CacheFailure('Could not read order'),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> saveOrder(OrderEntity order) async {
    try {
      await _local.prepend(OrderModel.fromEntity(order));
      _talker.info('[ShopFlow][orders] saved order ${order.id}');
      return const Right<Failure, Unit>(unit);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, Unit>(
        CacheFailure('Could not save order'),
      );
    }
  }
}
