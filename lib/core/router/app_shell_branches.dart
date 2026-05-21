import 'package:shop_flow/core/router/app_routes.dart';

/// Indices for [StatefulShellRoute] branches — must match [AppRouter] order.
abstract final class AppShellBranches {
  /// Home / catalog tab.
  static const int home = 0;

  /// Cart tab.
  static const int cart = 1;

  /// Categories browse tab.
  static const int categories = 2;

  /// Orders tab.
  static const int orders = 3;

  /// Profile tab.
  static const int profile = 4;

  /// Number of shell branches (keep in sync with [paths]).
  static const int length = 5;

  /// Branch paths in tab order (for [GoRouter.go] fallback).
  static const List<String> paths = <String>[
    AppRoutes.home,
    AppRoutes.cart,
    AppRoutes.categories,
    AppRoutes.orders,
    AppRoutes.profile,
  ];
}
