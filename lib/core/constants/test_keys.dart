import 'package:flutter/material.dart';

/// Stable [ValueKey] names for integration and widget tests.
abstract final class TestKeys {
  /// Google Sign-In showcase button on login screen.
  static const googleSignInButton = ValueKey<String>('google_sign_in_button');

  /// Email login submit on login screen.
  static const loginSubmitButton = ValueKey<String>('login_submit_button');

  /// Register submit on registration screen.
  static const registerSubmitButton = ValueKey<String>('register_submit_button');

  /// Catalog search field on home screen.
  static const catalogSearchField = ValueKey<String>('catalog_search_field');

  /// First product card on home catalog grid.
  static const firstProductCard = ValueKey<String>('first_product_card');

  /// First product card on wishlist page grid.
  static const firstWishlistCard = ValueKey<String>('first_wishlist_card');

  /// Wishlist toggle on product detail app bar.
  static const wishlistToggleButton =
      ValueKey<String>('wishlist_toggle_button');

  /// Shell navigation tabs (mobile bottom bar / rail / drawer).
  static const homeNavTab = ValueKey<String>('home_nav_tab');

  /// Add-to-cart button on product detail (GlobalKey for layout + tests).
  static final addToCartButton = GlobalKey(debugLabel: 'add_to_cart_button');

  /// Cart icon on product detail app bar (pushes cart route).
  static final pdpCartButton = GlobalKey(debugLabel: 'pdp_cart_button');

  /// Cart tab in shell navigation (mobile bottom bar).
  static const cartNavTab = ValueKey<String>('cart_nav_tab');

  /// Orders tab in shell navigation.
  static const ordersNavTab = ValueKey<String>('orders_nav_tab');

  /// Profile tab in shell navigation.
  static const profileNavTab = ValueKey<String>('profile_nav_tab');

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

  /// First order tile on orders list.
  static const firstOrderTile = ValueKey<String>('first_order_tile');

  /// Settings gear on profile app bar.
  static const profileSettingsButton =
      ValueKey<String>('profile_settings_button');

  /// Edit profile CTA on profile page.
  static const editProfileButton = ValueKey<String>('edit_profile_button');

  /// Save profile on edit profile form.
  static const saveProfileButton = ValueKey<String>('save_profile_button');

  /// Dark theme radio on settings page.
  static const settingsThemeDark = ValueKey<String>('settings_theme_dark');

  /// Arabic locale radio on settings page.
  static const settingsLanguageArabic =
      ValueKey<String>('settings_language_arabic');
}
