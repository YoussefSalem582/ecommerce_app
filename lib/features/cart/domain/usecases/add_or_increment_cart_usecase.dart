import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Adds a catalog snapshot into the cart or increments quantity on duplicates.
@injectable
class AddOrIncrementCartUseCase {
  /// Constructor receives lazy repository binding.
  AddOrIncrementCartUseCase(this._repository);

  final CartRepository _repository;

  /// Materializes [product] into Hive-backed rows.
  Future<Either<Failure, List<CartLineEntity>>> call(
    ProductEntity product, {
    int quantityDelta = 1,
  }) {
    return _repository.addOrIncrement(
      productId: product.id,
      title: product.title,
      imageUrl: product.imageUrl,
      unitPrice: product.price,
      quantityDelta: quantityDelta,
    );
  }
}
