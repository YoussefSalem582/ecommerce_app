// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'شوب فلو';

  @override
  String get splashLoading => 'جاري التحميل…';

  @override
  String get homeTitle => 'الرئيسية';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get offlineBannerTitle => 'أنت غير متصل';

  @override
  String get offlineBannerBody => 'عرض المحتوى المخزن مؤقتاً حيثما أمكن.';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeSystem => 'النظام';

  @override
  String get debugLogs => 'سجلات التصحيح';

  @override
  String get loginTitle => 'تسجيل الدخول';

  @override
  String get registerTitle => 'إنشاء حساب';

  @override
  String get usernameLabel => 'اسم المستخدم';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get firstNameLabel => 'الاسم الأول';

  @override
  String get lastNameLabel => 'اسم العائلة';

  @override
  String get loginButton => 'دخول';

  @override
  String get registerButton => 'تسجيل';

  @override
  String get createAccountLink => 'إنشاء حساب';

  @override
  String get alreadyHaveAccountLink => 'لديك حساب؟ سجّل الدخول';

  @override
  String get fieldRequired => 'هذا الحقل مطلوب';

  @override
  String get passwordTooShort => 'استخدم 3 أحرف على الأقل';

  @override
  String get invalidEmailHint => 'أدخل بريداً إلكترونياً صالحاً';

  @override
  String get logoutButton => 'خروج';

  @override
  String welcomeUser(String username) {
    return 'مرحباً، $username';
  }

  @override
  String get registerSuccessSnackbar =>
      'تم إنشاء الحساب. سجّل الدخول باسم المستخدم.';

  @override
  String get authErrorNetworkUnreachable =>
      'تعذّر الوصول إلى الخادم. تحقّق من اتصالك وحاول مرة أخرى.';

  @override
  String get signInWithGoogleComingSoon =>
      'سيتم ربط تسجيل الدخول عبر جوجل في الإصدارات الإنتاجية.';

  @override
  String get googleSignInButton => 'المتابعة مع جوجل';

  @override
  String get catalogSearchHint => 'ابحث عن منتجات';

  @override
  String get catalogAllCategories => 'الكل';

  @override
  String get catalogEmpty => 'لا توجد منتجات مطابقة للفلاتر.';

  @override
  String get catalogEmptyBody =>
      'جرّب تعديل البحث أو مسح الفلاتر لعرض المزيد من المنتجات.';

  @override
  String get productDetailLoadingTitle => 'المنتج';

  @override
  String productRatingLabel(String rating, int count) {
    return '$rating • $count تقييم';
  }

  @override
  String get addToCartLabel => 'أضف إلى السلة';

  @override
  String get addToCartSuccess => 'تمت الإضافة إلى السلة';

  @override
  String get pageNotFoundTitle => 'الصفحة غير موجودة';

  @override
  String get pageNotFoundBody => 'هذا المسار غير موجود.';

  @override
  String get cartTitle => 'السلة';

  @override
  String get cartEmptyTitle => 'سلتك فارغة';

  @override
  String get cartEmptyBody =>
      'تصفح المنتجات واضغط «أضف إلى السلة» على أي منتج.';

  @override
  String get cartSubtotalLabel => 'المجموع الفرعي';

  @override
  String get cartCheckoutLabel => 'إتمام الشراء';

  @override
  String cartQuantityA11y(int quantity) {
    return 'الكمية $quantity';
  }

  @override
  String get wishlistToggleTooltip => 'قائمة الرغبات';

  @override
  String get wishlistTitle => 'قائمة الرغبات';

  @override
  String get wishlistEmptyTitle => 'قائمة رغباتك فارغة';

  @override
  String get wishlistEmptyBody => 'اضغط على القلب على أي منتج لحفظه هنا.';

  @override
  String get cartTooltip => 'السلة';

  @override
  String cartBadgeA11y(int count) {
    return '$count عناصر في السلة';
  }

  @override
  String get checkoutTitle => 'إتمام الشراء';

  @override
  String get checkoutPayButton => 'ادفع الآن';

  @override
  String get checkoutOrderSummarySection => 'ملخص الطلب';

  @override
  String get checkoutShippingSection => 'عنوان الشحن';

  @override
  String get checkoutFullNameLabel => 'الاسم الكامل';

  @override
  String get checkoutStreetLabel => 'عنوان الشارع';

  @override
  String get checkoutCityLabel => 'المدينة';

  @override
  String get checkoutPostalLabel => 'الرمز البريدي';

  @override
  String get checkoutCountryLabel => 'الدولة';

  @override
  String get checkoutStripeSheetHint =>
      'ستظهر نافذة دفع Stripe. استخدم بطاقة اختبار في وضع التجربة.';

  @override
  String get checkoutProcessingHint => 'جاري معالجة الدفع…';

  @override
  String get checkoutCartEmpty => 'سلتك فارغة. أضف منتجات قبل إتمام الشراء.';

  @override
  String get ordersTitle => 'الطلبات';

  @override
  String get ordersEmptyTitle => 'لا توجد طلبات بعد';

  @override
  String get ordersEmptyBody =>
      'أكمل الشراء لعرض الإيصالات هنا — تُخزَّن محلياً في Hive.';

  @override
  String get ordersOrderIdLabel => 'طلب';

  @override
  String get orderDetailTitle => 'تفاصيل الطلب';

  @override
  String get orderTimelineTitle => 'الحالة';

  @override
  String get orderStatusPending => 'تم استلام الدفع';

  @override
  String get orderStatusProcessing => 'قيد المعالجة';

  @override
  String get orderStatusShipped => 'تم الشحن';

  @override
  String get orderStatusDelivered => 'تم التسليم';

  @override
  String get orderSuccessTitle => 'شكراً لك!';

  @override
  String orderSuccessSubtitle(String orderId) {
    return 'تم حفظ طلبك $orderId.';
  }

  @override
  String get orderContinueShopping => 'متابعة التسوق';

  @override
  String get ordersTooltip => 'الطلبات';

  @override
  String get profileTitle => 'الملف الشخصي';

  @override
  String get editProfileTitle => 'تعديل الملف';

  @override
  String get changeAvatar => 'تغيير الصورة';

  @override
  String get saveProfile => 'حفظ الملف';

  @override
  String get profileUpdated => 'تم تحديث الملف';

  @override
  String get settingsThemeSection => 'المظهر';

  @override
  String get settingsLanguageSection => 'اللغة';

  @override
  String get debugLogsHint => 'هزّ الجهاز أو اضغط لفتح سجل Talker';

  @override
  String get catalogGridView => 'عرض شبكي';

  @override
  String get catalogListView => 'عرض قائمة';

  @override
  String get onboardingSkip => 'تخطي';

  @override
  String get onboardingNext => 'التالي';

  @override
  String get onboardingGetStarted => 'ابدأ';

  @override
  String get onboardingSlide1Title => 'تسوق بدون اتصال';

  @override
  String get onboardingSlide1Body =>
      'تصفح المنتجات المخزنة حتى عند انقطاع الاتصال. Hive يحافظ على توفر الكatalog.';

  @override
  String get onboardingSlide2Title => 'ادفع عبر Stripe';

  @override
  String get onboardingSlide2Body =>
      'عند ضبط مفاتيح Stripe، يفتح الدفع Payment Sheet ببطاقات اختبار. وإلا يكتمل الدفع محلياً في وضع العرض التوضيحي.';

  @override
  String get onboardingSlide3Title => 'عربي وإنجليزي';

  @override
  String get onboardingSlide3Body =>
      'بدّل اللغة فوراً مع دعم RTL كامل — دون إعادة تشغيل التطبيق.';

  @override
  String get googleSignInSuccess => 'تم تسجيل الدخول عبر جوجل (عرض توضيحي)';

  @override
  String get catalogSearchA11y => 'البحث عن المنتجات';

  @override
  String get decreaseQuantityA11y => 'تقليل الكمية';

  @override
  String get increaseQuantityA11y => 'زيادة الكمية';

  @override
  String get swipeToDeleteA11y => 'اسحب لليسار لإزالة العنصر من السلة';

  @override
  String get cartItemRemovedSnackbar => 'تمت إزالة العنصر من السلة';

  @override
  String get cartUndoRemove => 'تراجع';

  @override
  String get addToWishlistA11y => 'إضافة إلى المفضلة';

  @override
  String get removeFromWishlistA11y => 'إزالة من المفضلة';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج؟';

  @override
  String get logoutConfirmBody =>
      'ستحتاج لتسجيل الدخول مجدداً للوصول إلى سلتك وطلباتك.';

  @override
  String get logoutConfirmButton => 'تسجيل الخروج';

  @override
  String get cancelButton => 'إلغاء';

  @override
  String get copyOrderId => 'نسخ رقم الطلب';

  @override
  String get orderIdCopied => 'تم نسخ رقم الطلب';

  @override
  String onboardingPageIndicator(int current, int total) {
    return 'الصفحة $current من $total';
  }

  @override
  String get demoModeBannerTitle => 'وضع العرض التوضيحي';

  @override
  String get demoModeBannerBody =>
      'لا توجد رسوم حقيقية — تُحفظ الطلبات محلياً في هذا العرض.';

  @override
  String get settingsEnvironmentSection => 'البيئة';

  @override
  String settingsEnvironmentAppEnv(String env) {
    return 'بيئة التطبيق: $env';
  }

  @override
  String get settingsEnvironmentStripeOn => 'Stripe Payment Sheet مفعّل';

  @override
  String get settingsEnvironmentStripeOff =>
      'Stripe غير مضبوط — دفع تجريبي فقط';

  @override
  String get navHomeA11y => 'تبويب الرئيسية';

  @override
  String get navCartA11y => 'تبويب السلة';

  @override
  String get navCategoriesA11y => 'تبويب الفئات';

  @override
  String get navOrdersA11y => 'تبويب الطلبات';

  @override
  String get navProfileA11y => 'تبويب الملف الشخصي';

  @override
  String get categoriesTitle => 'الفئات';

  @override
  String get catalogSortLabel => 'ترتيب';

  @override
  String get catalogSortPriceAsc => 'السعر: من الأقل للأعلى';

  @override
  String get catalogSortPriceDesc => 'السعر: من الأعلى للأقل';

  @override
  String get catalogSortRatingDesc => 'الأعلى تقييماً';

  @override
  String get catalogSortTitleAsc => 'الاسم: أ–ي';

  @override
  String get catalogFilterTitle => 'تصفية';

  @override
  String get catalogFilterPriceLabel => 'نطاق السعر';

  @override
  String catalogFilterRatingLabel(String rating) {
    return 'الحد الأدنى للتقييم: $rating';
  }

  @override
  String get catalogFilterApply => 'تطبيق التصفية';

  @override
  String get catalogClearFilters => 'مسح التصفية';

  @override
  String get catalogBrowseCategories => 'تصفح الفئات';

  @override
  String get recentlyViewedTitle => 'شوهد مؤخراً';

  @override
  String get relatedProductsTitle => 'منتجات ذات صلة';

  @override
  String get productReviewsTitle => 'مراجعات العملاء';

  @override
  String productReviewsCount(int count) {
    return '$count مراجعة';
  }

  @override
  String get productShareTooltip => 'مشاركة المنتج';

  @override
  String productShareMessage(String title, String url) {
    return 'اطّلع على $title في ShopFlow: $url';
  }

  @override
  String get productShareFailed => 'تعذّر فتح نافذة المشاركة';

  @override
  String get checkoutPromoLabel => 'رمز الخصم';

  @override
  String get checkoutPromoHint => 'SAVE10 أو WELCOME5';

  @override
  String get checkoutPromoApply => 'تطبيق';

  @override
  String get checkoutPromoClear => 'إزالة';

  @override
  String get checkoutPromoInvalid => 'رمز خصم غير صالح';

  @override
  String checkoutPromoMinSubtotal(String amount) {
    return 'الحد الأدنى للطلب $amount USD لهذا الرمز';
  }

  @override
  String checkoutPromoApplied(String label) {
    return 'تم تطبيق الخصم: $label';
  }

  @override
  String get checkoutDiscountLabel => 'الخصم';

  @override
  String get checkoutTotalLabel => 'الإجمالي';

  @override
  String get checkoutSavedAddressLabel => 'استخدام عنوان محفوظ';

  @override
  String get checkoutSaveAddressLabel => 'حفظ هذا العنوان للمرة القادمة';

  @override
  String get addressesTitle => 'العناوين المحفوظة';

  @override
  String get addressesEmptyTitle => 'لا توجد عناوين محفوظة';

  @override
  String get addressesEmptyBody => 'أضف عنوان شحن لتسريع الدفع.';

  @override
  String get addAddressTitle => 'إضافة عنوان';

  @override
  String get editAddressTitle => 'تعديل العنوان';

  @override
  String get addressDefaultLabel => 'العنوان الافتراضي';

  @override
  String get addressSaved => 'تم حفظ العنوان';

  @override
  String get settingsCurrencySection => 'العملة';

  @override
  String get settingsNotificationsSection => 'الإشعارات';

  @override
  String get settingsOrderUpdatesLabel => 'تحديثات الطلب';

  @override
  String get settingsOrderUpdatesHint =>
      'عرض تجريبي فقط — لا إشعارات push في النسخة التجريبية';

  @override
  String get currencyUsd => 'دولار أمريكي (USD)';

  @override
  String get currencyEur => 'يورو (EUR)';

  @override
  String get currencySar => 'ريال سعودي (SAR)';

  @override
  String get changePasswordTitle => 'تغيير كلمة المرور';

  @override
  String get changePasswordHint =>
      'نموذج تجريبي — لا يُرسل إلى الخادم في وضع العرض.';

  @override
  String get changePasswordCurrentLabel => 'كلمة المرور الحالية';

  @override
  String get changePasswordNewLabel => 'كلمة المرور الجديدة';

  @override
  String get changePasswordConfirmLabel => 'تأكيد كلمة المرور الجديدة';

  @override
  String get changePasswordSubmit => 'تحديث كلمة المرور';

  @override
  String get changePasswordSuccess => 'تم تحديث كلمة المرور (عرض تجريبي)';

  @override
  String get changePasswordCurrentInvalid => 'أدخل كلمة المرور الحالية';

  @override
  String get changePasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get orderUpdateNotificationDemo =>
      'إشعارات تحديث الطلب مفعّلة (عرض تجريبي — لا push)';

  @override
  String get homeBannerSaleTitle => 'تخفيضات الموسم الكبرى';

  @override
  String get homeBannerSaleSubtitle => 'خصم حتى 50% على أفضل المنتجات';

  @override
  String get homeBannerShippingTitle => 'شحن سريع مجاني';

  @override
  String get homeBannerShippingSubtitle => 'على كل طلب فوق 50\$';

  @override
  String get homeBannerFreshTitle => 'وصل حديثًا';

  @override
  String get homeBannerFreshSubtitle => 'منتجات جديدة كل أسبوع';

  @override
  String get homeBannerCta => 'تسوّق الآن';

  @override
  String get homeBannerCarouselA11y => 'عروض ترويجية متنقلة';
}
