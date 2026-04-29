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
  String get productDetailLoadingTitle => 'المنتج';

  @override
  String productRatingLabel(String rating, int count) {
    return '$rating • $count تقييم';
  }

  @override
  String get addToCartLabel => 'أضف إلى السلة';

  @override
  String get addToCartComingSoon => 'مزامنة السلة في المرحلة القادمة.';

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
  String get cartCheckoutComingSoon =>
      'الدفع عبر Stripe سيصل في المرحلة الخامسة.';

  @override
  String cartQuantityA11y(int quantity) {
    return 'الكمية $quantity';
  }

  @override
  String get wishlistToggleTooltip => 'قائمة الرغبات';

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
}
