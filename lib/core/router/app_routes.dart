/// Typed route paths for [GoRouter] (`ShopFlow`).
abstract final class AppRoutes {
  /// Splash / bootstrap route.
  static const splash = '/splash';

  /// Primary catalog shell home.
  static const home = '/home';

  /// Profile tab inside authenticated shell.
  static const profile = '/profile';

  /// Theme, locale, and debug preferences.
  static const settings = '/settings';

  /// First-run carousel (shown once).
  static const onboarding = '/onboarding';

  /// Edit profile form (full-screen over shell).
  static const editProfile = '/edit-profile';

  /// PDP pattern `/product/:id`.
  static const productPath = '/product';

  /// Deep-link helper for PDP routes.
  static String product(int id) => '$productPath/$id';

  /// Email/password sign-in.
  static const login = '/login';

  /// Fake Store compatible registration form.
  static const register = '/register';

  /// Developer Talker log screen (debug only).
  static const debugLogs = '/debug-logs';

  /// Shopping bag review route.
  static const cart = '/cart';

  /// Address + payment orchestration.
  static const checkout = '/checkout';

  /// Offline order journal.
  static const orders = '/orders';

  /// Order receipt (`/order/:orderId`).
  static const orderPath = '/order';

  /// Deep link helper for receipt timeline route.
  static String order(String orderId) => '$orderPath/$orderId';

  /// Thank-you route prefix (`/order-success/:orderId`).
  static const orderSuccessPath = '/order-success';

  /// Explicit success deep link builder.
  static String orderSuccess(String orderId) =>
      '$orderSuccessPath/$orderId';
}
