import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Remote + Hive-backed catalog access for ShopFlow.
abstract class ProductsRepository {
  /// Returns products for optional [category] plus optional [searchQuery] filter.
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
    String? searchQuery,
  });

  /// Returns a single SKU by primary key with stale-fallback from Hive catalog.
  Future<Either<Failure, ProductEntity>> getProductById(int id);

  /// Lists taxonomy labels for filter chips (best-effort from cache offline).
  Future<Either<Failure, List<String>>> getCategories();
}
