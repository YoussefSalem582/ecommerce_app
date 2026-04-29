import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';

/// Local-first cart persistence with optional remote sync hooks.
abstract class CartRepository {
  /// Reads all persisted rows from Hive.
  Future<Either<Failure, List<CartLineEntity>>> getLines();

  /// Adds a SKU or increments quantity when [productId] already exists.
  Future<Either<Failure, List<CartLineEntity>>> addOrIncrement({
    required int productId,
    required String title,
    required String imageUrl,
    required double unitPrice,
    int quantityDelta = 1,
  });

  /// Drops a SKU entirely from the cart payload.
  Future<Either<Failure, List<CartLineEntity>>> removeLine(int productId);

  /// Sets quantity for [productId]; removes the row when [quantity] ≤ 0.
  Future<Either<Failure, List<CartLineEntity>>> setQuantity(
    int productId,
    int quantity,
  );

  /// Placeholder sync called when connectivity returns (Fake Store has no cart API).
  Future<Either<Failure, Unit>> syncPending();

  /// Removes every SKU row after successful checkout.
  Future<Either<Failure, Unit>> clearAll();
}
