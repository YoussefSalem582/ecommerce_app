import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/di/injection.config.dart';
import 'package:shop_flow/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';
import 'package:shop_flow/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';
import 'package:shop_flow/features/checkout/data/stripe_checkout_gateway.dart';
import 'package:shop_flow/features/checkout/domain/checkout_payment_gateway.dart';
import 'package:shop_flow/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart';
import 'package:shop_flow/features/products/data/repositories/products_repository_impl.dart';
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart';
import 'package:shop_flow/features/wishlist/data/repositories/wishlist_repository_impl.dart';
import 'package:shop_flow/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Global service locator for ShopFlow (Injectable + GetIt).
final GetIt getIt = GetIt.instance;

/// Registers all `@injectable` types — call once after `Hive`/`dotenv` init.
@InjectableInit()
Future<void> configureDependencies() async {
  await getIt.init();
  if (!getIt.isRegistered<AuthRepository>()) {
    getIt.registerLazySingleton<AuthRepository>(
      () => getIt<AuthRepositoryImpl>(),
    );
  }
  if (!getIt.isRegistered<ProductsRepository>()) {
    getIt.registerLazySingleton<ProductsRepository>(
      () => getIt<ProductsRepositoryImpl>(),
    );
  }
  if (!getIt.isRegistered<CartRepository>()) {
    getIt.registerLazySingleton<CartRepository>(
      () => getIt<CartRepositoryImpl>(),
    );
  }
  if (!getIt.isRegistered<WishlistRepository>()) {
    getIt.registerLazySingleton<WishlistRepository>(
      () => getIt<WishlistRepositoryImpl>(),
    );
  }
  if (!getIt.isRegistered<OrdersRepository>()) {
    getIt.registerLazySingleton<OrdersRepository>(
      () => getIt<OrdersRepositoryImpl>(),
    );
  }
  if (!getIt.isRegistered<CheckoutPaymentGateway>()) {
    getIt.registerLazySingleton<CheckoutPaymentGateway>(
      () => getIt<StripeCheckoutGateway>(),
    );
  }
}
