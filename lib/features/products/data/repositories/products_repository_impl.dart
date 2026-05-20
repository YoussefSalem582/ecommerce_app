import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/data/datasources/local_products_datasource.dart';
import 'package:shop_flow/features/products/data/datasources/products_remote_datasource.dart';
import 'package:shop_flow/features/products/data/models/product_model.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';

/// Offline-first catalog repository (Hive stale-while-error).
@lazySingleton
class ProductsRepositoryImpl implements ProductsRepository {
  /// Coordinates remote API + Hive persistence.
  ProductsRepositoryImpl(
    this._remote,
    this._local,
    this._talker,
  );

  final ProductsRemoteDatasource _remote;
  final LocalProductsDatasource _local;
  final Talker _talker;

  List<ProductModel> _applySearch(List<ProductModel> input, String? query) {
    final q = query?.trim().toLowerCase();
    if (q == null || q.isEmpty) {
      return input;
    }
    return input
        .where(
          (ProductModel p) =>
              p.title.toLowerCase().contains(q) ||
              p.description.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  Future<Either<Failure, List<ProductEntity>>> getProducts({
    String? category,
    String? searchQuery,
  }) async {
    try {
      late List<ProductModel> models;
      if (category != null && category.isNotEmpty) {
        models = await _remote.fetchProductsByCategory(category);
      } else {
        models = await _remote.fetchAllProducts();
        final encoded = jsonEncode(
          models.map((ProductModel m) => m.toJson()).toList(),
        );
        await _local.saveCatalogJson(encoded);
        _talker.info('[ShopFlow][products] cached ${models.length} SKUs');
      }
      final visible = _applySearch(models, searchQuery);
      return Right<Failure, List<ProductEntity>>(
        visible.map((ProductModel m) => m.toEntity()).toList(),
      );
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      return _serveCached(
        category: category,
        searchQuery: searchQuery,
        errorHint: e.message,
      );
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return _serveCached(
        category: category,
        searchQuery: searchQuery,
        errorHint: e.toString(),
      );
    }
  }

  Either<Failure, List<ProductEntity>> _serveCached({
    String? category,
    String? searchQuery,
    required String errorHint,
  }) {
    final cached = _local.readCachedProducts();
    if (cached.isEmpty) {
      return Left<Failure, List<ProductEntity>>(NetworkFailure(errorHint));
    }
    var models = cached;
    if (category != null && category.isNotEmpty) {
      models =
          models.where((ProductModel p) => p.category == category).toList();
    }
    models = _applySearch(models, searchQuery);
    _talker.info(
      '[ShopFlow][products] offline catalog served (${models.length} items)',
    );
    return Right<Failure, List<ProductEntity>>(
      models.map((ProductModel m) => m.toEntity()).toList(),
    );
  }

  @override
  Future<Either<Failure, ProductEntity>> getProductById(int id) async {
    try {
      final model = await _remote.fetchProductById(id);
      return Right<Failure, ProductEntity>(model.toEntity());
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      final cached = _local.readCachedProducts();
      for (final ProductModel p in cached) {
        if (p.id == id) {
          _talker.info('[ShopFlow][products] product $id from Hive');
          return Right<Failure, ProductEntity>(p.toEntity());
        }
      }
      return Left<Failure, ProductEntity>(NetworkFailure(e.message));
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, ProductEntity>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> getCategories() async {
    try {
      final list = await _remote.fetchCategories();
      return Right<Failure, List<String>>(list);
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      final cached = _local.readCachedProducts();
      if (cached.isEmpty) {
        return Left<Failure, List<String>>(NetworkFailure(e.message));
      }
      final categories = <String>{};
      for (final ProductModel p in cached) {
        if (p.category.isNotEmpty) {
          categories.add(p.category);
        }
      }
      final sorted = categories.toList()..sort();
      _talker.info(
        '[ShopFlow][products] categories from Hive (${sorted.length})',
      );
      return Right<Failure, List<String>>(sorted);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, List<String>>(UnexpectedFailure(e.toString()));
    }
  }
}
