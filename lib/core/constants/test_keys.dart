import 'package:flutter/material.dart';

/// Stable [ValueKey] names for integration and widget tests.
abstract final class TestKeys {
  /// Google Sign-In showcase button on login screen.
  static const googleSignInButton = ValueKey<String>('google_sign_in_button');

  /// First product card on home catalog grid.
  static const firstProductCard = ValueKey<String>('first_product_card');

  /// Add-to-cart button on product detail (GlobalKey for layout + tests).
  static final addToCartButton = GlobalKey(debugLabel: 'add_to_cart_button');

  /// Cart icon on product detail app bar (pushes cart route).
  static final pdpCartButton = GlobalKey(debugLabel: 'pdp_cart_button');

  /// Cart tab in shell navigation (mobile bottom bar).
  static const cartNavTab = ValueKey<String>('cart_nav_tab');

  /// Checkout CTA on cart page.
  static const cartCheckoutButton = ValueKey<String>('cart_checkout_button');

  /// Shipping form fields on checkout page.
  static const checkoutFullName = ValueKey<String>('checkout_full_name');
  static const checkoutStreet = ValueKey<String>('checkout_street');
  static const checkoutCity = ValueKey<String>('checkout_city');
  static const checkoutPostal = ValueKey<String>('checkout_postal');
  static const checkoutCountry = ValueKey<String>('checkout_country');
  static const checkoutPayButton = ValueKey<String>('checkout_pay_button');

  /// Order success headline (integration / widget tests).
  static const orderSuccessTitle = ValueKey<String>('order_success_title');
}
