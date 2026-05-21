import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_flow/app/shop_flow_app.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/constants/test_keys.dart';

/// Pumps frames until [finder] matches or [maxSteps] is exhausted.
Future<void> pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  Duration step = const Duration(milliseconds: 100),
  int maxSteps = 80,
}) async {
  for (var i = 0; i < maxSteps; i++) {
    await tester.pump(step);
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
}

/// Launches [ShopFlowApp] and waits for splash routing to settle.
Future<void> launchShopFlowApp(WidgetTester tester) async {
  await tester.pumpWidget(const ShopFlowApp());
  await pumpUntilFound(
    tester,
    find.byKey(TestKeys.loginSubmitButton)
        .or(find.byKey(TestKeys.googleSignInButton))
        .or(find.byKey(TestKeys.firstProductCard)),
  );
}

/// Signs in via Google showcase button or prefilled email credentials.
Future<void> signInDemoUser(WidgetTester tester) async {
  if (find.byKey(TestKeys.firstProductCard).evaluate().isNotEmpty) {
    return;
  }

  if (find.byKey(TestKeys.googleSignInButton).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(TestKeys.googleSignInButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.firstProductCard));
    return;
  }

  expect(find.byKey(TestKeys.loginSubmitButton), findsOneWidget);
  await tester.tap(find.byKey(TestKeys.loginSubmitButton));
  await pumpUntilFound(tester, find.byKey(TestKeys.firstProductCard));
}

/// Opens PDP from home and adds the first catalog item to cart.
Future<void> addFirstProductToCart(WidgetTester tester) async {
  expect(find.byKey(TestKeys.firstProductCard), findsOneWidget);
  await tester.tap(find.byKey(TestKeys.firstProductCard), warnIfMissed: false);
  await pumpUntilFound(tester, find.byKey(TestKeys.addToCartButton));

  await tester.tap(find.byKey(TestKeys.addToCartButton));
  await tester.pump(const Duration(milliseconds: 400));
}

/// Navigates to cart via bottom-nav tab (preferred) or PDP cart icon fallback.
Future<void> openCart(WidgetTester tester) async {
  if (find.byKey(TestKeys.cartNavTab).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(TestKeys.cartNavTab));
    await pumpUntilFound(tester, find.byKey(TestKeys.cartCheckoutButton));
    return;
  }

  if (find.byKey(TestKeys.pdpCartButton).evaluate().isNotEmpty) {
    await tester.tap(find.byKey(TestKeys.pdpCartButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.cartCheckoutButton));
  }
}

/// Fills shipping fields on checkout.
Future<void> fillCheckoutForm(WidgetTester tester) async {
  await tester.enterText(find.byKey(TestKeys.checkoutFullName), 'Jane Doe');
  await tester.enterText(find.byKey(TestKeys.checkoutStreet), '123 Main St');
  await tester.enterText(find.byKey(TestKeys.checkoutCity), 'Springfield');
  await tester.enterText(find.byKey(TestKeys.checkoutPostal), '62701');
  await tester.enterText(find.byKey(TestKeys.checkoutCountry), 'US');
}

/// Submits checkout and waits for order success screen.
Future<void> completeCheckout(WidgetTester tester) async {
  expect(find.byKey(TestKeys.checkoutPayButton), findsOneWidget);
  await fillCheckoutForm(tester);
  await tester.tap(find.byKey(TestKeys.checkoutPayButton));

  final bool hasStripe = GetIt.instance<AppConfig>().stripePublishableKey !=
          null &&
      GetIt.instance<AppConfig>().stripePaymentIntentClientSecret != null;

  if (hasStripe) {
    // Payment Sheet is platform UI — allow extra time when keys are configured.
    await pumpUntilFound(
      tester,
      find.byKey(TestKeys.orderSuccessTitle),
      maxSteps: 120,
    );
  } else {
    await pumpUntilFound(tester, find.byKey(TestKeys.orderSuccessTitle));
  }

  expect(find.byKey(TestKeys.orderSuccessTitle), findsOneWidget);
}

/// Taps a shell navigation tab by [TestKeys] value key.
Future<void> tapNavTab(WidgetTester tester, Key tabKey) async {
  await tester.tap(find.byKey(tabKey));
  await tester.pump(const Duration(milliseconds: 300));
}
