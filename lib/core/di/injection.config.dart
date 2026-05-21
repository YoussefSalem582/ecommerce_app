// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:hive_flutter/hive_flutter.dart' as _i986;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;
import 'package:shop_flow/core/config/app_config.dart' as _i910;
import 'package:shop_flow/core/di/register_module.dart' as _i465;
import 'package:shop_flow/core/l10n/language_cubit.dart' as _i615;
import 'package:shop_flow/core/network/connectivity_cubit.dart' as _i1045;
import 'package:shop_flow/core/network/dio_client.dart' as _i475;
import 'package:shop_flow/core/network/token_refresher.dart' as _i543;
import 'package:shop_flow/core/network/token_storage.dart' as _i671;
import 'package:shop_flow/core/preferences/currency_cubit.dart' as _i206;
import 'package:shop_flow/core/preferences/notification_prefs_cubit.dart'
    as _i71;
import 'package:shop_flow/core/router/app_router.dart' as _i305;
import 'package:shop_flow/core/router/auth_refresh_notifier.dart' as _i70;
import 'package:shop_flow/core/theme/theme_cubit.dart' as _i714;
import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i475;
import 'package:shop_flow/features/auth/data/datasources/google_auth_datasource.dart'
    as _i891;
import 'package:shop_flow/features/auth/data/datasources/local_auth_datasource.dart'
    as _i389;
import 'package:shop_flow/features/auth/data/datasources/showcase_google_auth_datasource.dart'
    as _i505;
import 'package:shop_flow/features/auth/data/repositories/auth_repository_impl.dart'
    as _i320;
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart'
    as _i285;
import 'package:shop_flow/features/auth/domain/usecases/change_password_usecase.dart'
    as _i62;
import 'package:shop_flow/features/auth/domain/usecases/google_sign_in_usecase.dart'
    as _i369;
import 'package:shop_flow/features/auth/domain/usecases/login_usecase.dart'
    as _i626;
import 'package:shop_flow/features/auth/domain/usecases/logout_usecase.dart'
    as _i89;
import 'package:shop_flow/features/auth/domain/usecases/refresh_token_usecase.dart'
    as _i297;
import 'package:shop_flow/features/auth/domain/usecases/register_usecase.dart'
    as _i229;
import 'package:shop_flow/features/auth/domain/usecases/restore_session_usecase.dart'
    as _i968;
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart'
    as _i430;
import 'package:shop_flow/features/cart/data/datasources/local_cart_datasource.dart'
    as _i888;
import 'package:shop_flow/features/cart/data/repositories/cart_repository_impl.dart'
    as _i154;
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart'
    as _i32;
import 'package:shop_flow/features/cart/domain/usecases/add_or_increment_cart_usecase.dart'
    as _i73;
import 'package:shop_flow/features/cart/domain/usecases/clear_cart_usecase.dart'
    as _i56;
import 'package:shop_flow/features/cart/domain/usecases/get_cart_lines_usecase.dart'
    as _i828;
import 'package:shop_flow/features/cart/domain/usecases/remove_cart_line_usecase.dart'
    as _i207;
import 'package:shop_flow/features/cart/domain/usecases/set_cart_quantity_usecase.dart'
    as _i1057;
import 'package:shop_flow/features/cart/domain/usecases/sync_cart_usecase.dart'
    as _i706;
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart'
    as _i480;
import 'package:shop_flow/features/checkout/data/stripe_checkout_gateway.dart'
    as _i3;
import 'package:shop_flow/features/checkout/domain/checkout_payment_gateway.dart'
    as _i341;
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_bloc.dart'
    as _i514;
import 'package:shop_flow/features/orders/data/datasources/local_orders_datasource.dart'
    as _i688;
import 'package:shop_flow/features/orders/data/repositories/orders_repository_impl.dart'
    as _i1005;
import 'package:shop_flow/features/orders/domain/repositories/orders_repository.dart'
    as _i32;
import 'package:shop_flow/features/orders/domain/usecases/create_order_entity_usecase.dart'
    as _i824;
import 'package:shop_flow/features/orders/domain/usecases/get_order_by_id_usecase.dart'
    as _i848;
import 'package:shop_flow/features/orders/domain/usecases/get_orders_usecase.dart'
    as _i129;
import 'package:shop_flow/features/orders/domain/usecases/save_order_usecase.dart'
    as _i935;
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_bloc.dart'
    as _i982;
import 'package:shop_flow/features/orders/presentation/bloc/orders_bloc.dart'
    as _i13;
import 'package:shop_flow/features/products/data/datasources/local_products_datasource.dart'
    as _i185;
import 'package:shop_flow/features/products/data/datasources/local_recently_viewed_datasource.dart'
    as _i455;
import 'package:shop_flow/features/products/data/datasources/products_remote_datasource.dart'
    as _i437;
import 'package:shop_flow/features/products/data/repositories/products_repository_impl.dart'
    as _i851;
import 'package:shop_flow/features/products/domain/repositories/products_repository.dart'
    as _i823;
import 'package:shop_flow/features/products/domain/usecases/get_categories_usecase.dart'
    as _i873;
import 'package:shop_flow/features/products/domain/usecases/get_product_by_id_usecase.dart'
    as _i961;
import 'package:shop_flow/features/products/domain/usecases/get_products_usecase.dart'
    as _i438;
import 'package:shop_flow/features/products/domain/usecases/search_products_usecase.dart'
    as _i55;
import 'package:shop_flow/features/products/presentation/bloc/product_detail_bloc.dart'
    as _i814;
import 'package:shop_flow/features/products/presentation/bloc/product_list_bloc.dart'
    as _i428;
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_cubit.dart'
    as _i244;
import 'package:shop_flow/features/profile/data/datasources/local_addresses_datasource.dart'
    as _i97;
import 'package:shop_flow/features/profile/data/datasources/local_profile_datasource.dart'
    as _i197;
import 'package:shop_flow/features/profile/data/repositories/addresses_repository_impl.dart'
    as _i128;
import 'package:shop_flow/features/profile/data/repositories/profile_repository_impl.dart'
    as _i925;
import 'package:shop_flow/features/profile/domain/repositories/addresses_repository.dart'
    as _i938;
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart'
    as _i151;
import 'package:shop_flow/features/profile/domain/usecases/delete_address_usecase.dart'
    as _i130;
import 'package:shop_flow/features/profile/domain/usecases/get_addresses_usecase.dart'
    as _i537;
import 'package:shop_flow/features/profile/domain/usecases/get_avatar_path_usecase.dart'
    as _i111;
import 'package:shop_flow/features/profile/domain/usecases/get_profile_usecase.dart'
    as _i220;
import 'package:shop_flow/features/profile/domain/usecases/save_address_usecase.dart'
    as _i291;
import 'package:shop_flow/features/profile/domain/usecases/save_avatar_path_usecase.dart'
    as _i81;
import 'package:shop_flow/features/profile/domain/usecases/update_profile_usecase.dart'
    as _i827;
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_bloc.dart'
    as _i1060;
import 'package:shop_flow/features/profile/presentation/bloc/profile_bloc.dart'
    as _i827;
import 'package:shop_flow/features/profile/presentation/cubit/addresses_cubit.dart'
    as _i360;
import 'package:shop_flow/features/wishlist/data/datasources/local_wishlist_datasource.dart'
    as _i1027;
import 'package:shop_flow/features/wishlist/data/repositories/wishlist_repository_impl.dart'
    as _i1038;
import 'package:shop_flow/features/wishlist/domain/repositories/wishlist_repository.dart'
    as _i535;
import 'package:shop_flow/features/wishlist/domain/usecases/get_wishlist_ids_usecase.dart'
    as _i1048;
import 'package:shop_flow/features/wishlist/domain/usecases/toggle_wishlist_usecase.dart'
    as _i192;
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_bloc.dart'
    as _i27;
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_cubit.dart'
    as _i866;
import 'package:talker/talker.dart' as _i993;
import 'package:talker_flutter/talker_flutter.dart' as _i207;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i62.ChangePasswordUseCase>(() => _i62.ChangePasswordUseCase());
    gh.factory<_i824.CreateOrderEntityUseCase>(
      () => _i824.CreateOrderEntityUseCase(),
    );
    gh.singleton<_i910.AppConfig>(() => _i910.AppConfig());
    gh.singleton<_i207.Talker>(() => registerModule.talker());
    gh.lazySingleton<_i895.Connectivity>(() => registerModule.connectivity());
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage(),
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.ordersCache,
      instanceName: 'ordersCache',
      preResolve: true,
    );
    gh.factory<_i73.AddOrIncrementCartUseCase>(
      () => _i73.AddOrIncrementCartUseCase(gh<_i32.CartRepository>()),
    );
    gh.factory<_i56.ClearCartUseCase>(
      () => _i56.ClearCartUseCase(gh<_i32.CartRepository>()),
    );
    gh.factory<_i828.GetCartLinesUseCase>(
      () => _i828.GetCartLinesUseCase(gh<_i32.CartRepository>()),
    );
    gh.factory<_i207.RemoveCartLineUseCase>(
      () => _i207.RemoveCartLineUseCase(gh<_i32.CartRepository>()),
    );
    gh.factory<_i1057.SetCartQuantityUseCase>(
      () => _i1057.SetCartQuantityUseCase(gh<_i32.CartRepository>()),
    );
    gh.factory<_i706.SyncCartUseCase>(
      () => _i706.SyncCartUseCase(gh<_i32.CartRepository>()),
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.addresses,
      instanceName: 'addresses',
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.recentlyViewed,
      instanceName: 'recentlyViewed',
      preResolve: true,
    );
    gh.lazySingleton<_i97.LocalAddressesDatasource>(
      () => _i97.LocalAddressesDatasource(
        gh<_i986.Box<String>>(instanceName: 'addresses'),
      ),
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.wishlist,
      instanceName: 'wishlist',
      preResolve: true,
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.cartItems,
      instanceName: 'cartItems',
      preResolve: true,
    );
    gh.lazySingleton<_i3.StripeCheckoutGateway>(
      () => _i3.StripeCheckoutGateway(gh<_i993.Talker>()),
    );
    gh.lazySingleton<_i615.LanguageCubit>(
      () => _i615.LanguageCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i206.CurrencyCubit>(
      () => _i206.CurrencyCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i71.NotificationPrefsCubit>(
      () => _i71.NotificationPrefsCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i714.ThemeCubit>(
      () => _i714.ThemeCubit(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i389.LocalAuthDatasource>(
      () => _i389.LocalAuthDatasource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i891.GoogleAuthDatasource>(
      () => _i505.ShowcaseGoogleAuthDatasource(gh<_i993.Talker>()),
    );
    gh.lazySingleton<_i455.LocalRecentlyViewedDatasource>(
      () => _i455.LocalRecentlyViewedDatasource(
        gh<_i986.Box<String>>(instanceName: 'recentlyViewed'),
      ),
    );
    await gh.factoryAsync<_i986.Box<String>>(
      () => registerModule.productsCache,
      instanceName: 'productsCache',
      preResolve: true,
    );
    gh.factory<_i369.GoogleSignInUseCase>(
      () => _i369.GoogleSignInUseCase(gh<_i285.AuthRepository>()),
    );
    gh.factory<_i626.LoginUseCase>(
      () => _i626.LoginUseCase(gh<_i285.AuthRepository>()),
    );
    gh.factory<_i89.LogoutUseCase>(
      () => _i89.LogoutUseCase(gh<_i285.AuthRepository>()),
    );
    gh.factory<_i297.RefreshTokenUseCase>(
      () => _i297.RefreshTokenUseCase(gh<_i285.AuthRepository>()),
    );
    gh.factory<_i229.RegisterUseCase>(
      () => _i229.RegisterUseCase(gh<_i285.AuthRepository>()),
    );
    gh.factory<_i968.RestoreSessionUseCase>(
      () => _i968.RestoreSessionUseCase(gh<_i285.AuthRepository>()),
    );
    gh.lazySingleton<_i430.AuthBloc>(
      () => _i430.AuthBloc(
        gh<_i968.RestoreSessionUseCase>(),
        gh<_i626.LoginUseCase>(),
        gh<_i229.RegisterUseCase>(),
        gh<_i89.LogoutUseCase>(),
        gh<_i369.GoogleSignInUseCase>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.factory<_i1048.GetWishlistIdsUseCase>(
      () => _i1048.GetWishlistIdsUseCase(gh<_i535.WishlistRepository>()),
    );
    gh.factory<_i192.ToggleWishlistUseCase>(
      () => _i192.ToggleWishlistUseCase(gh<_i535.WishlistRepository>()),
    );
    gh.lazySingleton<_i671.TokenStorage>(
      () => _i671.TokenStorage(gh<_i558.FlutterSecureStorage>()),
    );
    gh.factory<_i873.GetCategoriesUseCase>(
      () => _i873.GetCategoriesUseCase(gh<_i823.ProductsRepository>()),
    );
    gh.factory<_i961.GetProductByIdUseCase>(
      () => _i961.GetProductByIdUseCase(gh<_i823.ProductsRepository>()),
    );
    gh.factory<_i438.GetProductsUseCase>(
      () => _i438.GetProductsUseCase(gh<_i823.ProductsRepository>()),
    );
    gh.factory<_i55.SearchProductsUseCase>(
      () => _i55.SearchProductsUseCase(gh<_i823.ProductsRepository>()),
    );
    gh.lazySingleton<_i688.LocalOrdersDatasource>(
      () => _i688.LocalOrdersDatasource(
        gh<_i986.Box<String>>(instanceName: 'ordersCache'),
      ),
    );
    gh.lazySingleton<_i938.AddressesRepository>(
      () => _i128.AddressesRepositoryImpl(gh<_i97.LocalAddressesDatasource>()),
    );
    gh.lazySingleton<_i866.WishlistCubit>(
      () => _i866.WishlistCubit(
        gh<_i1048.GetWishlistIdsUseCase>(),
        gh<_i192.ToggleWishlistUseCase>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i244.RecentlyViewedCubit>(
      () => _i244.RecentlyViewedCubit(
        gh<_i455.LocalRecentlyViewedDatasource>(),
        gh<_i961.GetProductByIdUseCase>(),
      ),
    );
    gh.factory<_i848.GetOrderByIdUseCase>(
      () => _i848.GetOrderByIdUseCase(gh<_i32.OrdersRepository>()),
    );
    gh.factory<_i129.GetOrdersUseCase>(
      () => _i129.GetOrdersUseCase(gh<_i32.OrdersRepository>()),
    );
    gh.factory<_i935.SaveOrderUseCase>(
      () => _i935.SaveOrderUseCase(gh<_i32.OrdersRepository>()),
    );
    gh.lazySingleton<_i1045.ConnectivityCubit>(
      () => _i1045.ConnectivityCubit(
        gh<_i895.Connectivity>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i70.AuthRefreshNotifier>(
      () => _i70.AuthRefreshNotifier(gh<_i430.AuthBloc>()),
    );
    gh.lazySingleton<_i814.ProductDetailBloc>(
      () => _i814.ProductDetailBloc(
        gh<_i961.GetProductByIdUseCase>(),
        gh<_i438.GetProductsUseCase>(),
      ),
    );
    gh.lazySingleton<_i888.LocalCartDatasource>(
      () => _i888.LocalCartDatasource(
        gh<_i986.Box<String>>(instanceName: 'cartItems'),
      ),
    );
    gh.lazySingleton<_i185.LocalProductsDatasource>(
      () => _i185.LocalProductsDatasource(
        gh<_i986.Box<String>>(instanceName: 'productsCache'),
      ),
    );
    gh.lazySingleton<_i428.ProductListBloc>(
      () => _i428.ProductListBloc(
        gh<_i438.GetProductsUseCase>(),
        gh<_i873.GetCategoriesUseCase>(),
      ),
    );
    gh.lazySingleton<_i305.AppRouter>(
      () =>
          _i305.AppRouter(gh<_i430.AuthBloc>(), gh<_i70.AuthRefreshNotifier>()),
    );
    gh.lazySingleton<_i1005.OrdersRepositoryImpl>(
      () => _i1005.OrdersRepositoryImpl(
        gh<_i688.LocalOrdersDatasource>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i197.LocalProfileDatasource>(
      () => _i197.LocalProfileDatasource(
        gh<_i389.LocalAuthDatasource>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i1027.LocalWishlistDatasource>(
      () => _i1027.LocalWishlistDatasource(
        gh<_i986.Box<String>>(instanceName: 'wishlist'),
      ),
    );
    gh.lazySingleton<_i543.TokenRefresher>(
      () => _i543.TokenRefresher(gh<_i297.RefreshTokenUseCase>()),
    );
    gh.lazySingleton<_i480.CartBloc>(
      () => _i480.CartBloc(
        gh<_i828.GetCartLinesUseCase>(),
        gh<_i73.AddOrIncrementCartUseCase>(),
        gh<_i207.RemoveCartLineUseCase>(),
        gh<_i1057.SetCartQuantityUseCase>(),
        gh<_i706.SyncCartUseCase>(),
        gh<_i56.ClearCartUseCase>(),
        gh<_i1045.ConnectivityCubit>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i475.DioClient>(
      () => _i475.DioClient(
        gh<_i993.Talker>(),
        gh<_i910.AppConfig>(),
        gh<_i671.TokenStorage>(),
      ),
    );
    gh.lazySingleton<_i1038.WishlistRepositoryImpl>(
      () => _i1038.WishlistRepositoryImpl(
        gh<_i1027.LocalWishlistDatasource>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.factory<_i27.WishlistPageBloc>(
      () => _i27.WishlistPageBloc(
        gh<_i1048.GetWishlistIdsUseCase>(),
        gh<_i438.GetProductsUseCase>(),
      ),
    );
    gh.factory<_i130.DeleteAddressUseCase>(
      () => _i130.DeleteAddressUseCase(gh<_i938.AddressesRepository>()),
    );
    gh.factory<_i537.GetAddressesUseCase>(
      () => _i537.GetAddressesUseCase(gh<_i938.AddressesRepository>()),
    );
    gh.factory<_i291.SaveAddressUseCase>(
      () => _i291.SaveAddressUseCase(gh<_i938.AddressesRepository>()),
    );
    gh.lazySingleton<_i13.OrdersBloc>(
      () => _i13.OrdersBloc(gh<_i129.GetOrdersUseCase>()),
    );
    gh.factory<_i982.OrderDetailBloc>(
      () => _i982.OrderDetailBloc(gh<_i848.GetOrderByIdUseCase>()),
    );
    gh.lazySingleton<_i151.ProfileRepository>(
      () => _i925.ProfileRepositoryImpl(
        gh<_i197.LocalProfileDatasource>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i514.CheckoutBloc>(
      () => _i514.CheckoutBloc(
        gh<_i828.GetCartLinesUseCase>(),
        gh<_i824.CreateOrderEntityUseCase>(),
        gh<_i935.SaveOrderUseCase>(),
        gh<_i56.ClearCartUseCase>(),
        gh<_i341.CheckoutPaymentGateway>(),
        gh<_i291.SaveAddressUseCase>(),
        gh<_i910.AppConfig>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i154.CartRepositoryImpl>(
      () => _i154.CartRepositoryImpl(
        gh<_i888.LocalCartDatasource>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.lazySingleton<_i475.AuthRemoteDatasource>(
      () => registerModule.authRemoteDatasource(
        gh<_i910.AppConfig>(),
        gh<_i207.Talker>(),
        gh<_i475.DioClient>(),
      ),
    );
    gh.lazySingleton<_i437.ProductsRemoteDatasource>(
      () => registerModule.productsRemoteDatasource(
        gh<_i910.AppConfig>(),
        gh<_i207.Talker>(),
        gh<_i475.DioClient>(),
      ),
    );
    gh.lazySingleton<_i360.AddressesCubit>(
      () => _i360.AddressesCubit(
        gh<_i537.GetAddressesUseCase>(),
        gh<_i291.SaveAddressUseCase>(),
        gh<_i130.DeleteAddressUseCase>(),
      ),
    );
    gh.lazySingleton<_i851.ProductsRepositoryImpl>(
      () => _i851.ProductsRepositoryImpl(
        gh<_i437.ProductsRemoteDatasource>(),
        gh<_i185.LocalProductsDatasource>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.factory<_i111.GetAvatarPathUseCase>(
      () => _i111.GetAvatarPathUseCase(gh<_i151.ProfileRepository>()),
    );
    gh.factory<_i220.GetProfileUseCase>(
      () => _i220.GetProfileUseCase(gh<_i151.ProfileRepository>()),
    );
    gh.factory<_i81.SaveAvatarPathUseCase>(
      () => _i81.SaveAvatarPathUseCase(gh<_i151.ProfileRepository>()),
    );
    gh.factory<_i827.UpdateProfileUseCase>(
      () => _i827.UpdateProfileUseCase(gh<_i151.ProfileRepository>()),
    );
    gh.factory<_i1060.EditProfileBloc>(
      () => _i1060.EditProfileBloc(
        gh<_i220.GetProfileUseCase>(),
        gh<_i827.UpdateProfileUseCase>(),
        gh<_i111.GetAvatarPathUseCase>(),
        gh<_i81.SaveAvatarPathUseCase>(),
      ),
    );
    gh.lazySingleton<_i320.AuthRepositoryImpl>(
      () => _i320.AuthRepositoryImpl(
        gh<_i475.AuthRemoteDatasource>(),
        gh<_i891.GoogleAuthDatasource>(),
        gh<_i389.LocalAuthDatasource>(),
        gh<_i671.TokenStorage>(),
        gh<_i993.Talker>(),
      ),
    );
    gh.factory<_i827.ProfileBloc>(
      () => _i827.ProfileBloc(
        gh<_i220.GetProfileUseCase>(),
        gh<_i111.GetAvatarPathUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i465.RegisterModule {}
