// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'ShopFlow';

  @override
  String get splashLoading => 'Loading…';

  @override
  String get homeTitle => 'Home';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get offlineBannerTitle => 'You are offline';

  @override
  String get offlineBannerBody => 'Showing cached content where available.';

  @override
  String get retry => 'Retry';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get debugLogs => 'Debug logs';

  @override
  String get loginTitle => 'Sign in';

  @override
  String get registerTitle => 'Create account';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get emailLabel => 'Email';

  @override
  String get firstNameLabel => 'First name';

  @override
  String get lastNameLabel => 'Last name';

  @override
  String get loginButton => 'Sign in';

  @override
  String get registerButton => 'Register';

  @override
  String get createAccountLink => 'Create an account';

  @override
  String get alreadyHaveAccountLink => 'Already have an account? Sign in';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get passwordTooShort => 'Use at least 3 characters';

  @override
  String get invalidEmailHint => 'Enter a valid email address';

  @override
  String get logoutButton => 'Sign out';

  @override
  String welcomeUser(String username) {
    return 'Welcome, $username';
  }

  @override
  String get registerSuccessSnackbar =>
      'Account created. Sign in with your username.';

  @override
  String get authErrorNetworkUnreachable =>
      'Couldn\'t reach the server. Check your connection and try again.';

  @override
  String get signInWithGoogleComingSoon =>
      'Google Sign-In will connect here for production builds.';

  @override
  String get googleSignInButton => 'Continue with Google';

  @override
  String get catalogSearchHint => 'Search products';

  @override
  String get catalogAllCategories => 'All';

  @override
  String get catalogEmpty => 'No products match your filters.';

  @override
  String get productDetailLoadingTitle => 'Product';

  @override
  String productRatingLabel(String rating, int count) {
    return '$rating • $count reviews';
  }

  @override
  String get addToCartLabel => 'Add to cart';

  @override
  String get addToCartComingSoon => 'Cart sync comes in the next milestone.';

  @override
  String get addToCartSuccess => 'Added to your cart';

  @override
  String get pageNotFoundTitle => 'Page not found';

  @override
  String get pageNotFoundBody => 'That route does not exist.';

  @override
  String get cartTitle => 'Cart';

  @override
  String get cartEmptyTitle => 'Your cart is empty';

  @override
  String get cartEmptyBody =>
      'Browse the catalog and tap add to cart on any product.';

  @override
  String get cartSubtotalLabel => 'Subtotal';

  @override
  String get cartCheckoutLabel => 'Checkout';

  @override
  String get cartCheckoutComingSoon =>
      'Checkout with Stripe arrives in Phase 5.';

  @override
  String cartQuantityA11y(int quantity) {
    return 'Quantity $quantity';
  }

  @override
  String get wishlistToggleTooltip => 'Wishlist';

  @override
  String get cartTooltip => 'Cart';

  @override
  String cartBadgeA11y(int count) {
    return '$count items in cart';
  }

  @override
  String get checkoutTitle => 'Checkout';

  @override
  String get checkoutPayButton => 'Pay now';

  @override
  String get checkoutOrderSummarySection => 'Order summary';

  @override
  String get checkoutShippingSection => 'Shipping address';

  @override
  String get checkoutFullNameLabel => 'Full name';

  @override
  String get checkoutStreetLabel => 'Street address';

  @override
  String get checkoutCityLabel => 'City';

  @override
  String get checkoutPostalLabel => 'Postal code';

  @override
  String get checkoutCountryLabel => 'Country';

  @override
  String get checkoutStripeSheetHint =>
      'Stripe Payment Sheet opens next. Use a test card in sandbox.';

  @override
  String get checkoutProcessingHint => 'Processing payment…';

  @override
  String get checkoutCartEmpty =>
      'Your cart is empty. Add products before checkout.';

  @override
  String get ordersTitle => 'Orders';

  @override
  String get ordersEmptyTitle => 'No orders yet';

  @override
  String get ordersEmptyBody =>
      'Complete checkout to see receipts here — stored offline in Hive.';

  @override
  String get ordersOrderIdLabel => 'Order';

  @override
  String get orderDetailTitle => 'Order details';

  @override
  String get orderTimelineTitle => 'Status';

  @override
  String get orderStatusPending => 'Payment received';

  @override
  String get orderStatusProcessing => 'Processing';

  @override
  String get orderStatusShipped => 'Shipped';

  @override
  String get orderStatusDelivered => 'Delivered';

  @override
  String get orderSuccessTitle => 'Thank you!';

  @override
  String orderSuccessSubtitle(String orderId) {
    return 'Your order $orderId is saved.';
  }

  @override
  String get orderContinueShopping => 'Continue shopping';

  @override
  String get ordersTooltip => 'Orders';

  @override
  String get profileTitle => 'Profile';

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get changeAvatar => 'Change photo';

  @override
  String get saveProfile => 'Save profile';

  @override
  String get profileUpdated => 'Profile updated';

  @override
  String get settingsThemeSection => 'Appearance';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get debugLogsHint => 'Shake device or tap to open Talker console';

  @override
  String get catalogGridView => 'Grid view';

  @override
  String get catalogListView => 'List view';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSlide1Title => 'Shop offline';

  @override
  String get onboardingSlide1Body =>
      'Browse cached products even when your connection drops. Hive keeps the catalog available.';

  @override
  String get onboardingSlide2Title => 'Pay with Stripe';

  @override
  String get onboardingSlide2Body =>
      'Checkout uses Stripe Payment Sheet with sandbox test cards for a real payment flow demo.';

  @override
  String get onboardingSlide3Title => 'Arabic & English';

  @override
  String get onboardingSlide3Body =>
      'Switch language instantly with full RTL support — no app restart required.';

  @override
  String get googleSignInSuccess => 'Signed in with Google (showcase stub)';

  @override
  String get catalogSearchA11y => 'Search products';

  @override
  String get decreaseQuantityA11y => 'Decrease quantity';

  @override
  String get increaseQuantityA11y => 'Increase quantity';

  @override
  String get swipeToDeleteA11y => 'Swipe left to remove item from cart';

  @override
  String get cartItemRemovedSnackbar => 'Item removed from cart';

  @override
  String get cartUndoRemove => 'Undo';

  @override
  String get addToWishlistA11y => 'Add to wishlist';

  @override
  String get removeFromWishlistA11y => 'Remove from wishlist';

  @override
  String get logoutConfirmTitle => 'Sign out?';

  @override
  String get logoutConfirmBody =>
      'You will need to sign in again to access your cart and orders.';

  @override
  String get logoutConfirmButton => 'Sign out';

  @override
  String get cancelButton => 'Cancel';

  @override
  String get copyOrderId => 'Copy order ID';

  @override
  String get orderIdCopied => 'Order ID copied';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'Page $current of $total';
  }
}
