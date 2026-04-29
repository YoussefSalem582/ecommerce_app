import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';

/// Persists wishlisted product identifiers locally (Hive JSON).
abstract class WishlistRepository {
  /// Snapshot of favorited SKU ids.
  Future<Either<Failure, Set<int>>> getIds();

  /// Inserts or removes [productId] depending on prior membership.
  Future<Either<Failure, Set<int>>> toggle(int productId);
}
