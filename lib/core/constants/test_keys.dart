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

  /// Categories tab in shell navigation (after cart).
  static const categoriesNavTab = ValueKey<String>('categories_nav_tab');

  /// Alias for [categoriesNavTab] (legacy home bottom bar key).
  static const categoriesBrowseButton = categoriesNavTab;

  /// Sort section inside the catalog filter bottom sheet.
  static const catalogSortButton = ValueKey<String>('catalog_sort_button');

  /// Filter button beside the home catalog search field.
  static const catalogFilterButton = ValueKey<String>('catalog_filter_button');

  /// Clear filters chip on home catalog.
  static const catalogClearFiltersChip =
      ValueKey<String>('catalog_clear_filters_chip');

  /// Price range slider in catalog filter sheet.
  static const catalogPriceRangeSlider =
      ValueKey<String>('catalog_price_range_slider');

  /// Rating slider in catalog filter sheet.
  static const catalogRatingSlider =
      ValueKey<String>('catalog_rating_slider');

  /// Apply filters button in catalog filter sheet.
  static const catalogFilterApplyButton =
      ValueKey<String>('catalog_filter_apply_button');

  /// First category card on categories page.
  static const firstCategoryCard = ValueKey<String>('first_category_card');

  /// Share button on product detail app bar.
  static const productShareButton = ValueKey<String>('product_share_button');

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

  /// Promo code field on checkout page.
  static const checkoutPromoField = ValueKey<String>('checkout_promo_field');

  /// Apply promo button on checkout page.
  static const checkoutPromoApplyButton =
      ValueKey<String>('checkout_promo_apply_button');

  /// Saved address dropdown on checkout page.
  static const checkoutSavedAddressDropdown =
      ValueKey<String>('checkout_saved_address_dropdown');

  /// Save address checkbox on checkout page.
  static const checkoutSaveAddressCheckbox =
      ValueKey<String>('checkout_save_address_checkbox');

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

  /// Change password CTA on profile page.
  static const changePasswordButton =
      ValueKey<String>('change_password_button');

  /// Save profile on edit profile form.
  static const saveProfileButton = ValueKey<String>('save_profile_button');

  /// Dark theme radio on settings page.
  static const settingsThemeDark = ValueKey<String>('settings_theme_dark');

  /// Arabic locale radio on settings page.
  static const settingsLanguageArabic =
      ValueKey<String>('settings_language_arabic');

  /// EUR currency radio on settings page.
  static const settingsCurrencyEur = ValueKey<String>('settings_currency_eur');

  /// Order notifications toggle on settings page.
  static const settingsOrderNotifications =
      ValueKey<String>('settings_order_notifications');

  /// Add address FAB on addresses page.
  static const addAddressFab = ValueKey<String>('add_address_fab');

  /// First address tile on addresses page.
  static const firstAddressTile = ValueKey<String>('first_address_tile');

  /// Address form fields on add address page.
  static const addressFullName = ValueKey<String>('address_full_name');
  static const addressStreet = ValueKey<String>('address_street');
  static const addressCity = ValueKey<String>('address_city');
  static const addressPostal = ValueKey<String>('address_postal');
  static const addressCountry = ValueKey<String>('address_country');
  static const saveAddressButton = ValueKey<String>('save_address_button');

  /// Change password form fields.
  static const changePasswordCurrent =
      ValueKey<String>('change_password_current');
  static const changePasswordNew = ValueKey<String>('change_password_new');
  static const changePasswordConfirm =
      ValueKey<String>('change_password_confirm');
  static const changePasswordSubmit =
      ValueKey<String>('change_password_submit');
}
