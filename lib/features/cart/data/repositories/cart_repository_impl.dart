import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/data/datasources/local_cart_datasource.dart';
import 'package:shop_flow/features/cart/data/models/cart_line_model.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Hive-only cart repository with Talker hooks for portfolio reviewers.
@lazySingleton
class CartRepositoryImpl implements CartRepository {
  /// Injects serializer + logger dependencies.
  CartRepositoryImpl(this._local, this._talker);

  final LocalCartDatasource _local;
  final Talker _talker;

  Future<Either<Failure, List<CartLineEntity>>> _afterWrite(
    Future<List<CartLineModel>> Function(List<CartLineModel> draft) mutate,
  ) async {
    try {
      final current = await _local.readLines();
      final next = await mutate(current);
      await _local.writeLines(next);
      _talker.info('[ShopFlow][cart] persisted ${next.length} SKU rows');
      return Right<Failure, List<CartLineEntity>>(
        next.map((CartLineModel m) => m.toEntity()).toList(),
      );
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, List<CartLineEntity>>(
        CacheFailure('Could not update cart'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CartLineEntity>>> getLines() async {
    try {
      final models = await _local.readLines();
      return Right<Failure, List<CartLineEntity>>(
        models.map((CartLineModel m) => m.toEntity()).toList(),
      );
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, List<CartLineEntity>>(
        CacheFailure('Could not read cart'),
      );
    }
  }

  @override
  Future<Either<Failure, List<CartLineEntity>>> addOrIncrement({
    required int productId,
    required String title,
    required String imageUrl,
    required double unitPrice,
    int quantityDelta = 1,
  }) {
    return _afterWrite((List<CartLineModel> rows) async {
      final idx = rows.indexWhere((CartLineModel r) => r.productId == productId);
      if (idx >= 0) {
        final prev = rows[idx];
        rows[idx] = CartLineModel(
          productId: prev.productId,
          title: prev.title,
          imageUrl: prev.imageUrl,
          unitPrice: prev.unitPrice,
          quantity: prev.quantity + quantityDelta,
        );
        return rows;
      }
      rows.add(
        CartLineModel(
          productId: productId,
          title: title,
          imageUrl: imageUrl,
          unitPrice: unitPrice,
          quantity: quantityDelta,
        ),
      );
      return rows;
    });
  }

  @override
  Future<Either<Failure, List<CartLineEntity>>> removeLine(int productId) {
    return _afterWrite((List<CartLineModel> rows) async {
      rows.removeWhere((CartLineModel r) => r.productId == productId);
      return rows;
    });
  }

  @override
  Future<Either<Failure, List<CartLineEntity>>> setQuantity(
    int productId,
    int quantity,
  ) {
    if (quantity <= 0) {
      return removeLine(productId);
    }
    return _afterWrite((List<CartLineModel> rows) async {
      final idx = rows.indexWhere((CartLineModel r) => r.productId == productId);
      if (idx < 0) {
        return rows;
      }
      final prev = rows[idx];
      rows[idx] = CartLineModel(
        productId: prev.productId,
        title: prev.title,
        imageUrl: prev.imageUrl,
        unitPrice: prev.unitPrice,
        quantity: quantity,
      );
      return rows;
    });
  }

  @override
  Future<Either<Failure, Unit>> syncPending() async {
    _talker.info(
      '[ShopFlow][cart] syncPending — remote cart API not used (Fake Store)',
    );
    return const Right<Failure, Unit>(unit);
  }

  @override
  Future<Either<Failure, Unit>> clearAll() async {
    try {
      await _local.writeLines(<CartLineModel>[]);
      _talker.info('[ShopFlow][cart] cleared after checkout');
      return const Right<Failure, Unit>(unit);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, Unit>(
        CacheFailure('Could not clear cart'),
      );
    }
  }
}
