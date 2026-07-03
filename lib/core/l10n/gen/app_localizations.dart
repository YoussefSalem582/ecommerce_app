import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// Application title shown in task manager
  ///
  /// In en, this message translates to:
  /// **'ShopFlow'**
  String get appTitle;

  /// No description provided for @splashLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get splashLoading;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @offlineBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineBannerTitle;

  /// No description provided for @offlineBannerBody.
  ///
  /// In en, this message translates to:
  /// **'Showing cached content where available.'**
  String get offlineBannerBody;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @debugLogs.
  ///
  /// In en, this message translates to:
  /// **'Debug logs'**
  String get debugLogs;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginTitle;

  /// No description provided for @registerTitle.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get registerTitle;

  /// No description provided for @usernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @firstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get firstNameLabel;

  /// No description provided for @lastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get lastNameLabel;

  /// No description provided for @loginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get loginButton;

  /// No description provided for @registerButton.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get registerButton;

  /// No description provided for @createAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get createAccountLink;

  /// No description provided for @alreadyHaveAccountLink.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? Sign in'**
  String get alreadyHaveAccountLink;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Use at least 3 characters'**
  String get passwordTooShort;

  /// No description provided for @invalidEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address'**
  String get invalidEmailHint;

  /// No description provided for @logoutButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutButton;

  /// No description provided for @welcomeUser.
  ///
  /// In en, this message translates to:
  /// **'Welcome, {username}'**
  String welcomeUser(String username);

  /// No description provided for @registerSuccessSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Account created. Sign in with your username.'**
  String get registerSuccessSnackbar;

  /// No description provided for @authErrorNetworkUnreachable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t reach the server. Check your connection and try again.'**
  String get authErrorNetworkUnreachable;

  /// No description provided for @signInWithGoogleComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In will connect here for production builds.'**
  String get signInWithGoogleComingSoon;

  /// No description provided for @googleSignInButton.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get googleSignInButton;

  /// No description provided for @catalogSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get catalogSearchHint;

  /// No description provided for @catalogAllCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get catalogAllCategories;

  /// No description provided for @catalogEmpty.
  ///
  /// In en, this message translates to:
  /// **'No products match your filters.'**
  String get catalogEmpty;

  /// No description provided for @catalogEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or clearing filters to see more products.'**
  String get catalogEmptyBody;

  /// No description provided for @productDetailLoadingTitle.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get productDetailLoadingTitle;

  /// No description provided for @productRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'{rating} • {count} reviews'**
  String productRatingLabel(String rating, int count);

  /// No description provided for @addToCartLabel.
  ///
  /// In en, this message translates to:
  /// **'Add to cart'**
  String get addToCartLabel;

  /// No description provided for @addToCartSuccess.
  ///
  /// In en, this message translates to:
  /// **'Added to your cart'**
  String get addToCartSuccess;

  /// No description provided for @pageNotFoundTitle.
  ///
  /// In en, this message translates to:
  /// **'Page not found'**
  String get pageNotFoundTitle;

  /// No description provided for @pageNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'That route does not exist.'**
  String get pageNotFoundBody;

  /// No description provided for @cartTitle.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTitle;

  /// No description provided for @cartEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty'**
  String get cartEmptyTitle;

  /// No description provided for @cartEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Browse the catalog and tap add to cart on any product.'**
  String get cartEmptyBody;

  /// No description provided for @cartSubtotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get cartSubtotalLabel;

  /// No description provided for @cartCheckoutLabel.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get cartCheckoutLabel;

  /// No description provided for @cartQuantityA11y.
  ///
  /// In en, this message translates to:
  /// **'Quantity {quantity}'**
  String cartQuantityA11y(int quantity);

  /// No description provided for @wishlistToggleTooltip.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistToggleTooltip;

  /// No description provided for @wishlistTitle.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlistTitle;

  /// No description provided for @wishlistEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get wishlistEmptyTitle;

  /// No description provided for @wishlistEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Tap the heart on any product to save it here.'**
  String get wishlistEmptyBody;

  /// No description provided for @cartTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cartTooltip;

  /// No description provided for @cartBadgeA11y.
  ///
  /// In en, this message translates to:
  /// **'{count} items in cart'**
  String cartBadgeA11y(int count);

  /// No description provided for @checkoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkoutTitle;

  /// No description provided for @checkoutPayButton.
  ///
  /// In en, this message translates to:
  /// **'Pay now'**
  String get checkoutPayButton;

  /// No description provided for @checkoutOrderSummarySection.
  ///
  /// In en, this message translates to:
  /// **'Order summary'**
  String get checkoutOrderSummarySection;

  /// No description provided for @checkoutShippingSection.
  ///
  /// In en, this message translates to:
  /// **'Shipping address'**
  String get checkoutShippingSection;

  /// No description provided for @checkoutFullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get checkoutFullNameLabel;

  /// No description provided for @checkoutStreetLabel.
  ///
  /// In en, this message translates to:
  /// **'Street address'**
  String get checkoutStreetLabel;

  /// No description provided for @checkoutCityLabel.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get checkoutCityLabel;

  /// No description provided for @checkoutPostalLabel.
  ///
  /// In en, this message translates to:
  /// **'Postal code'**
  String get checkoutPostalLabel;

  /// No description provided for @checkoutCountryLabel.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get checkoutCountryLabel;

  /// No description provided for @checkoutStripeSheetHint.
  ///
  /// In en, this message translates to:
  /// **'Stripe Payment Sheet opens next. Use a test card in sandbox.'**
  String get checkoutStripeSheetHint;

  /// No description provided for @checkoutProcessingHint.
  ///
  /// In en, this message translates to:
  /// **'Processing payment…'**
  String get checkoutProcessingHint;

  /// No description provided for @checkoutCartEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your cart is empty. Add products before checkout.'**
  String get checkoutCartEmpty;

  /// No description provided for @ordersTitle.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTitle;

  /// No description provided for @ordersEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No orders yet'**
  String get ordersEmptyTitle;

  /// No description provided for @ordersEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Complete checkout to see receipts here — stored offline in Hive.'**
  String get ordersEmptyBody;

  /// No description provided for @ordersOrderIdLabel.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get ordersOrderIdLabel;

  /// No description provided for @orderDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Order details'**
  String get orderDetailTitle;

  /// No description provided for @orderTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get orderTimelineTitle;

  /// No description provided for @orderStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Payment received'**
  String get orderStatusPending;

  /// No description provided for @orderStatusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get orderStatusProcessing;

  /// No description provided for @orderStatusShipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get orderStatusShipped;

  /// No description provided for @orderStatusDelivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get orderStatusDelivered;

  /// No description provided for @orderSuccessTitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you!'**
  String get orderSuccessTitle;

  /// No description provided for @orderSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Your order {orderId} is saved.'**
  String orderSuccessSubtitle(String orderId);

  /// No description provided for @orderContinueShopping.
  ///
  /// In en, this message translates to:
  /// **'Continue shopping'**
  String get orderContinueShopping;

  /// No description provided for @ordersTooltip.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get ordersTooltip;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @changeAvatar.
  ///
  /// In en, this message translates to:
  /// **'Change photo'**
  String get changeAvatar;

  /// No description provided for @saveProfile.
  ///
  /// In en, this message translates to:
  /// **'Save profile'**
  String get saveProfile;

  /// No description provided for @profileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Profile updated'**
  String get profileUpdated;

  /// No description provided for @settingsThemeSection.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeSection;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @debugLogsHint.
  ///
  /// In en, this message translates to:
  /// **'Shake device or tap to open Talker console'**
  String get debugLogsHint;

  /// No description provided for @catalogGridView.
  ///
  /// In en, this message translates to:
  /// **'Grid view'**
  String get catalogGridView;

  /// No description provided for @catalogListView.
  ///
  /// In en, this message translates to:
  /// **'List view'**
  String get catalogListView;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSlide1Title.
  ///
  /// In en, this message translates to:
  /// **'Shop offline'**
  String get onboardingSlide1Title;

  /// No description provided for @onboardingSlide1Body.
  ///
  /// In en, this message translates to:
  /// **'Browse cached products even when your connection drops. Hive keeps the catalog available.'**
  String get onboardingSlide1Body;

  /// No description provided for @onboardingSlide2Title.
  ///
  /// In en, this message translates to:
  /// **'Pay with Stripe'**
  String get onboardingSlide2Title;

  /// No description provided for @onboardingSlide2Body.
  ///
  /// In en, this message translates to:
  /// **'When Stripe keys are configured, checkout opens Payment Sheet with sandbox test cards. Otherwise demo mode completes checkout locally.'**
  String get onboardingSlide2Body;

  /// No description provided for @onboardingSlide3Title.
  ///
  /// In en, this message translates to:
  /// **'Arabic & English'**
  String get onboardingSlide3Title;

  /// No description provided for @onboardingSlide3Body.
  ///
  /// In en, this message translates to:
  /// **'Switch language instantly with full RTL support — no app restart required.'**
  String get onboardingSlide3Body;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google (showcase stub)'**
  String get googleSignInSuccess;

  /// No description provided for @catalogSearchA11y.
  ///
  /// In en, this message translates to:
  /// **'Search products'**
  String get catalogSearchA11y;

  /// No description provided for @decreaseQuantityA11y.
  ///
  /// In en, this message translates to:
  /// **'Decrease quantity'**
  String get decreaseQuantityA11y;

  /// No description provided for @increaseQuantityA11y.
  ///
  /// In en, this message translates to:
  /// **'Increase quantity'**
  String get increaseQuantityA11y;

  /// No description provided for @swipeToDeleteA11y.
  ///
  /// In en, this message translates to:
  /// **'Swipe left to remove item from cart'**
  String get swipeToDeleteA11y;

  /// No description provided for @cartItemRemovedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Item removed from cart'**
  String get cartItemRemovedSnackbar;

  /// No description provided for @cartUndoRemove.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get cartUndoRemove;

  /// No description provided for @addToWishlistA11y.
  ///
  /// In en, this message translates to:
  /// **'Add to wishlist'**
  String get addToWishlistA11y;

  /// No description provided for @removeFromWishlistA11y.
  ///
  /// In en, this message translates to:
  /// **'Remove from wishlist'**
  String get removeFromWishlistA11y;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign out?'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to sign in again to access your cart and orders.'**
  String get logoutConfirmBody;

  /// No description provided for @logoutConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get logoutConfirmButton;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @copyOrderId.
  ///
  /// In en, this message translates to:
  /// **'Copy order ID'**
  String get copyOrderId;

  /// No description provided for @orderIdCopied.
  ///
  /// In en, this message translates to:
  /// **'Order ID copied'**
  String get orderIdCopied;

  /// No description provided for @onboardingPageIndicator.
  ///
  /// In en, this message translates to:
  /// **'Page {current} of {total}'**
  String onboardingPageIndicator(int current, int total);

  /// No description provided for @demoModeBannerTitle.
  ///
  /// In en, this message translates to:
  /// **'Demo mode'**
  String get demoModeBannerTitle;

  /// No description provided for @demoModeBannerBody.
  ///
  /// In en, this message translates to:
  /// **'No real charges — orders are saved locally in this showcase build.'**
  String get demoModeBannerBody;

  /// No description provided for @settingsEnvironmentSection.
  ///
  /// In en, this message translates to:
  /// **'Environment'**
  String get settingsEnvironmentSection;

  /// No description provided for @settingsEnvironmentAppEnv.
  ///
  /// In en, this message translates to:
  /// **'App environment: {env}'**
  String settingsEnvironmentAppEnv(String env);

  /// No description provided for @settingsEnvironmentStripeOn.
  ///
  /// In en, this message translates to:
  /// **'Stripe Payment Sheet enabled'**
  String get settingsEnvironmentStripeOn;

  /// No description provided for @settingsEnvironmentStripeOff.
  ///
  /// In en, this message translates to:
  /// **'Stripe not configured — demo checkout only'**
  String get settingsEnvironmentStripeOff;

  /// No description provided for @navHomeA11y.
  ///
  /// In en, this message translates to:
  /// **'Home tab'**
  String get navHomeA11y;

  /// No description provided for @navCartA11y.
  ///
  /// In en, this message translates to:
  /// **'Cart tab'**
  String get navCartA11y;

  /// No description provided for @navCategoriesA11y.
  ///
  /// In en, this message translates to:
  /// **'Categories tab'**
  String get navCategoriesA11y;

  /// No description provided for @navOrdersA11y.
  ///
  /// In en, this message translates to:
  /// **'Orders tab'**
  String get navOrdersA11y;

  /// No description provided for @navProfileA11y.
  ///
  /// In en, this message translates to:
  /// **'Profile tab'**
  String get navProfileA11y;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @catalogSortLabel.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get catalogSortLabel;

  /// No description provided for @catalogSortPriceAsc.
  ///
  /// In en, this message translates to:
  /// **'Price: low to high'**
  String get catalogSortPriceAsc;

  /// No description provided for @catalogSortPriceDesc.
  ///
  /// In en, this message translates to:
  /// **'Price: high to low'**
  String get catalogSortPriceDesc;

  /// No description provided for @catalogSortRatingDesc.
  ///
  /// In en, this message translates to:
  /// **'Top rated'**
  String get catalogSortRatingDesc;

  /// No description provided for @catalogSortTitleAsc.
  ///
  /// In en, this message translates to:
  /// **'Name: A–Z'**
  String get catalogSortTitleAsc;

  /// No description provided for @catalogFilterTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get catalogFilterTitle;

  /// No description provided for @catalogFilterPriceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price range'**
  String get catalogFilterPriceLabel;

  /// No description provided for @catalogFilterRatingLabel.
  ///
  /// In en, this message translates to:
  /// **'Minimum rating: {rating}'**
  String catalogFilterRatingLabel(String rating);

  /// No description provided for @catalogFilterApply.
  ///
  /// In en, this message translates to:
  /// **'Apply filters'**
  String get catalogFilterApply;

  /// No description provided for @catalogClearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear filters'**
  String get catalogClearFilters;

  /// No description provided for @catalogBrowseCategories.
  ///
  /// In en, this message translates to:
  /// **'Browse categories'**
  String get catalogBrowseCategories;

  /// No description provided for @recentlyViewedTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently viewed'**
  String get recentlyViewedTitle;

  /// No description provided for @relatedProductsTitle.
  ///
  /// In en, this message translates to:
  /// **'Related products'**
  String get relatedProductsTitle;

  /// No description provided for @productReviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Customer reviews'**
  String get productReviewsTitle;

  /// No description provided for @productReviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String productReviewsCount(int count);

  /// No description provided for @productShareTooltip.
  ///
  /// In en, this message translates to:
  /// **'Share product'**
  String get productShareTooltip;

  /// No description provided for @productShareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out {title} on ShopFlow: {url}'**
  String productShareMessage(String title, String url);

  /// No description provided for @productShareFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not open share sheet'**
  String get productShareFailed;

  /// No description provided for @checkoutPromoLabel.
  ///
  /// In en, this message translates to:
  /// **'Promo code'**
  String get checkoutPromoLabel;

  /// No description provided for @checkoutPromoHint.
  ///
  /// In en, this message translates to:
  /// **'SAVE10 or WELCOME5'**
  String get checkoutPromoHint;

  /// No description provided for @checkoutPromoApply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get checkoutPromoApply;

  /// No description provided for @checkoutPromoClear.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get checkoutPromoClear;

  /// No description provided for @checkoutPromoInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid promo code'**
  String get checkoutPromoInvalid;

  /// No description provided for @checkoutPromoMinSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Minimum order {amount} USD required for this code'**
  String checkoutPromoMinSubtotal(String amount);

  /// No description provided for @checkoutPromoApplied.
  ///
  /// In en, this message translates to:
  /// **'Promo applied: {label}'**
  String checkoutPromoApplied(String label);

  /// No description provided for @checkoutDiscountLabel.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get checkoutDiscountLabel;

  /// No description provided for @checkoutTotalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get checkoutTotalLabel;

  /// No description provided for @checkoutSavedAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Use saved address'**
  String get checkoutSavedAddressLabel;

  /// No description provided for @checkoutSaveAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Save this address for next time'**
  String get checkoutSaveAddressLabel;

  /// No description provided for @addressesTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved addresses'**
  String get addressesTitle;

  /// No description provided for @addressesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved addresses'**
  String get addressesEmptyTitle;

  /// No description provided for @addressesEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add a shipping address to speed up checkout.'**
  String get addressesEmptyBody;

  /// No description provided for @addAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Add address'**
  String get addAddressTitle;

  /// No description provided for @editAddressTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit address'**
  String get editAddressTitle;

  /// No description provided for @addressDefaultLabel.
  ///
  /// In en, this message translates to:
  /// **'Default address'**
  String get addressDefaultLabel;

  /// No description provided for @addressSaved.
  ///
  /// In en, this message translates to:
  /// **'Address saved'**
  String get addressSaved;

  /// No description provided for @settingsCurrencySection.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get settingsCurrencySection;

  /// No description provided for @settingsNotificationsSection.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsSection;

  /// No description provided for @settingsOrderUpdatesLabel.
  ///
  /// In en, this message translates to:
  /// **'Order updates'**
  String get settingsOrderUpdatesLabel;

  /// No description provided for @settingsOrderUpdatesHint.
  ///
  /// In en, this message translates to:
  /// **'Showcase only — no push delivery in demo builds'**
  String get settingsOrderUpdatesHint;

  /// No description provided for @currencyUsd.
  ///
  /// In en, this message translates to:
  /// **'US Dollar (USD)'**
  String get currencyUsd;

  /// No description provided for @currencyEur.
  ///
  /// In en, this message translates to:
  /// **'Euro (EUR)'**
  String get currencyEur;

  /// No description provided for @currencySar.
  ///
  /// In en, this message translates to:
  /// **'Saudi Riyal (SAR)'**
  String get currencySar;

  /// No description provided for @changePasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get changePasswordTitle;

  /// No description provided for @changePasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Showcase form — password is not sent to a server in demo mode.'**
  String get changePasswordHint;

  /// No description provided for @changePasswordCurrentLabel.
  ///
  /// In en, this message translates to:
  /// **'Current password'**
  String get changePasswordCurrentLabel;

  /// No description provided for @changePasswordNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New password'**
  String get changePasswordNewLabel;

  /// No description provided for @changePasswordConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get changePasswordConfirmLabel;

  /// No description provided for @changePasswordSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update password'**
  String get changePasswordSubmit;

  /// No description provided for @changePasswordSuccess.
  ///
  /// In en, this message translates to:
  /// **'Password updated (showcase)'**
  String get changePasswordSuccess;

  /// No description provided for @changePasswordCurrentInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter your current password'**
  String get changePasswordCurrentInvalid;

  /// No description provided for @changePasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get changePasswordMismatch;

  /// No description provided for @orderUpdateNotificationDemo.
  ///
  /// In en, this message translates to:
  /// **'Order update notifications are enabled (showcase — no push sent)'**
  String get orderUpdateNotificationDemo;

  /// No description provided for @homeBannerSaleTitle.
  ///
  /// In en, this message translates to:
  /// **'Mega Season Sale'**
  String get homeBannerSaleTitle;

  /// No description provided for @homeBannerSaleSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Up to 50% off top-rated picks'**
  String get homeBannerSaleSubtitle;

  /// No description provided for @homeBannerShippingTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Express Shipping'**
  String get homeBannerShippingTitle;

  /// No description provided for @homeBannerShippingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'On every order over \$50'**
  String get homeBannerShippingSubtitle;

  /// No description provided for @homeBannerFreshTitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh Arrivals'**
  String get homeBannerFreshTitle;

  /// No description provided for @homeBannerFreshSubtitle.
  ///
  /// In en, this message translates to:
  /// **'New drops added every week'**
  String get homeBannerFreshSubtitle;

  /// No description provided for @homeBannerCta.
  ///
  /// In en, this message translates to:
  /// **'Shop now'**
  String get homeBannerCta;

  /// No description provided for @homeBannerCarouselA11y.
  ///
  /// In en, this message translates to:
  /// **'Promotional offers carousel'**
  String get homeBannerCarouselA11y;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
