import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/network/dio_client.dart';
import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/datasources/fake_auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:shop_flow/features/products/data/datasources/fake_products_remote_datasource.dart';
import 'package:shop_flow/features/products/data/datasources/products_remote_datasource.dart';
import 'package:shop_flow/features/products/data/datasources/remote_products_datasource.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Third-party bindings required during dependency injection setup.
@module
abstract class RegisterModule {
  /// Shared Talker logger instance used across BLoC, Dio, and manual logs.
  @singleton
  Talker talker() => TalkerFlutter.init();

  /// Platform connectivity probe used by connectivity cubit.
  @lazySingleton
  Connectivity connectivity() => Connectivity();

  /// Secure storage for JWT credentials.
  @lazySingleton
  FlutterSecureStorage secureStorage() => const FlutterSecureStorage();

  /// Application preferences (theme, locale, feature flags).
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  /// Serialized product list JSON cache (offline-first).
  @preResolve
  @Named('productsCache')
  Future<Box<String>> get productsCache =>
      Hive.openBox<String>('products_cache');

  /// Wishlist SKU ids JSON bucket.
  @preResolve
  @Named('wishlist')
  Future<Box<String>> get wishlist => Hive.openBox<String>('wishlist');

  /// Cart payload cache — local-first checkout draft.
  @preResolve
  @Named('cartItems')
  Future<Box<String>> get cartItems => Hive.openBox<String>('cart_items');

  /// Orders list cache for offline history rendering.
  @preResolve
  @Named('ordersCache')
  Future<Box<String>> get ordersCache =>
      Hive.openBox<String>('orders_cache');

  /// Fake Store HTTP unless `APP_ENV=demo`, then in-memory fake datasource.
  @lazySingleton
  AuthRemoteDatasource authRemoteDatasource(
    AppConfig config,
    Talker talker,
    DioClient dioClient,
  ) {
    if (config.isDemoEnv) {
      return FakeAuthRemoteDatasource(talker);
    }
    return RemoteAuthDatasource(dioClient);
  }

  /// Fake Store HTTP unless `APP_ENV=demo`, then in-memory demo catalog.
  @lazySingleton
  ProductsRemoteDatasource productsRemoteDatasource(
    AppConfig config,
    Talker talker,
    DioClient dioClient,
  ) {
    if (config.isDemoEnv) {
      return FakeProductsRemoteDatasource(talker);
    }
    return RemoteProductsDatasource(dioClient);
  }
}
