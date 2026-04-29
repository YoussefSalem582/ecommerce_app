import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/router/auth_refresh_notifier.dart';
import 'package:shop_flow/core/widgets/debug_logs_page.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/auth/presentation/pages/login_page.dart';
import 'package:shop_flow/features/auth/presentation/pages/register_page.dart';
import 'package:shop_flow/features/cart/presentation/pages/cart_page.dart';
import 'package:shop_flow/features/checkout/presentation/pages/checkout_page.dart';
import 'package:shop_flow/features/home/presentation/pages/home_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/order_detail_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/order_success_page.dart';
import 'package:shop_flow/features/orders/presentation/pages/orders_page.dart';
import 'package:shop_flow/features/products/presentation/pages/product_detail_page.dart';
import 'package:shop_flow/features/splash/presentation/pages/splash_page.dart';

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
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (BuildContext context, GoRouterState state) =>
            const CartPage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (BuildContext context, GoRouterState state) =>
            const CheckoutPage(),
      ),
      GoRoute(
        path: AppRoutes.orders,
        name: 'orders',
        builder: (BuildContext context, GoRouterState state) =>
            const OrdersPage(),
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

    if (authState is AuthInitial || authState is AuthLoading) {
      return null;
    }

    final loggedIn = authState is AuthAuthenticated;

    const publicRoutes = <String>{
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.debugLogs,
    };

    if (!loggedIn && !publicRoutes.contains(location)) {
      return AppRoutes.login;
    }

    if (loggedIn &&
        (location == AppRoutes.login || location == AppRoutes.register)) {
      return AppRoutes.home;
    }

    return null;
  }
}
