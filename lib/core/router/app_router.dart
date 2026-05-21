import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/router/app_shell.dart';
import 'package:shop_flow/core/router/auth_refresh_notifier.dart';
import 'package:shop_flow/core/widgets/debug_logs_page.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/auth/presentation/pages/change_password_page.dart';
import 'package:shop_flow/features/auth/presentation/pages/login_page.dart';
import 'package:shop_flow/features/auth/presentation/pages/register_page.dart';
import 'package:shop_flow/features/cart/presentation/pages/cart_page.dart';
import 'package:shop_flow/features/checkout/presentation/pages/checkout_page.dart';
import 'package:shop_flow/features/home/presentation/pages/home_page.dart';
import 'package:shop_flow/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/order_detail_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/order_success_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/orders_page.dart';
import 'package:shop_flow/features/products/presentation/pages/categories_page.dart';
import 'package:shop_flow/features/products/presentation/pages/product_detail_page.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/presentation/pages/add_address_page.dart';
import 'package:shop_flow/features/profile/presentation/pages/addresses_page.dart';
import 'package:shop_flow/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:shop_flow/features/profile/presentation/pages/profile_page.dart';
import 'package:shop_flow/features/profile/presentation/pages/settings_page.dart';
import 'package:shop_flow/features/splash/presentation/pages/splash_page.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_bloc.dart';
import 'package:shop_flow/features/wishlist/presentation/pages/wishlist_page.dart';

/// Application-wide GoRouter configuration with auth-aware redirects.
@lazySingleton
class AppRouter {
  /// Builds routing table for ShopFlow.
  AppRouter(this._authBloc, this._authRefreshNotifier);

  final AuthBloc _authBloc;
  final AuthRefreshNotifier _authRefreshNotifier;

  /// Config passed to [MaterialApp.router].
  late final GoRouter config = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _authRefreshNotifier,
    redirect: _redirect,
    errorBuilder: (BuildContext context, GoRouterState state) {
      final AppLocalizations l10n = AppLocalizations.of(context);
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pageNotFoundTitle)),
        body: Center(child: Text(l10n.pageNotFoundBody)),
      );
    },
    routes: <RouteBase>[
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        pageBuilder: (BuildContext context, GoRouterState state) {
          return CustomTransitionPage<void>(
            key: state.pageKey,
            child: const SplashPage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          );
        },
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (BuildContext context, GoRouterState state) =>
            const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (BuildContext context, GoRouterState state) =>
            const RegisterPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (
          BuildContext context,
          GoRouterState state,
          StatefulNavigationShell navigationShell,
        ) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: <StatefulShellBranch>[
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (BuildContext context, GoRouterState state) =>
                    const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.cart,
                name: 'cart',
                builder: (BuildContext context, GoRouterState state) =>
                    const CartPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.orders,
                name: 'orders',
                builder: (BuildContext context, GoRouterState state) =>
                    const OrdersPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: <RouteBase>[
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (BuildContext context, GoRouterState state) =>
                    const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.categories,
        name: 'categories',
        builder: (BuildContext context, GoRouterState state) =>
            const CategoriesPage(),
      ),
      GoRoute(
        path: AppRoutes.wishlist,
        name: 'wishlist',
        builder: (BuildContext context, GoRouterState state) {
          return BlocProvider<WishlistPageBloc>(
            create: (_) => getIt<WishlistPageBloc>(),
            child: const WishlistPage(),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (BuildContext context, GoRouterState state) =>
            const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        name: 'addresses',
        builder: (BuildContext context, GoRouterState state) =>
            const AddressesPage(),
      ),
      GoRoute(
        path: AppRoutes.addAddress,
        name: 'addAddress',
        builder: (BuildContext context, GoRouterState state) {
          final SavedAddressEntity? existing =
              state.extra as SavedAddressEntity?;
          return AddAddressPage(existing: existing);
        },
      ),
      GoRoute(
        path: AppRoutes.changePassword,
        name: 'changePassword',
        builder: (BuildContext context, GoRouterState state) =>
            const ChangePasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        name: 'editProfile',
        builder: (BuildContext context, GoRouterState state) =>
            const EditProfilePage(),
      ),
      GoRoute(
        path: '${AppRoutes.orderPath}/:orderId',
        name: 'orderDetail',
        builder: (BuildContext context, GoRouterState state) {
          final String orderId = state.pathParameters['orderId'] ?? '';
          return OrderDetailPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.orderSuccessPath}/:orderId',
        name: 'orderSuccess',
        builder: (BuildContext context, GoRouterState state) {
          final String orderId = state.pathParameters['orderId'] ?? '';
          return OrderSuccessPage(orderId: orderId);
        },
      ),
      GoRoute(
        path: '${AppRoutes.productPath}/:id',
        name: 'productDetail',
        builder: (BuildContext context, GoRouterState state) {
          final int id =
              int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: AppRoutes.debugLogs,
        name: 'debugLogs',
        builder: (BuildContext context, GoRouterState state) =>
            const DebugLogsPage(),
      ),
    ],
  );

  String? _redirect(BuildContext context, GoRouterState state) {
    final location = state.matchedLocation;
    final authState = _authBloc.state;

    final bool? loggedIn = switch (authState) {
      AuthAuthenticated() => true,
      AuthUnauthenticated() => false,
      AuthInitial() || AuthLoading() => null,
      _ => false,
    };

    if (loggedIn == null) {
      return null;
    }

    const publicRoutes = <String>{
      AppRoutes.splash,
      AppRoutes.onboarding,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.debugLogs,
    };

    if (!loggedIn && !publicRoutes.contains(location)) {
      return AppRoutes.login;
    }

    if (loggedIn &&
        (location == AppRoutes.login ||
            location == AppRoutes.register ||
            location == AppRoutes.onboarding)) {
      return AppRoutes.home;
    }

    return null;
  }
}
