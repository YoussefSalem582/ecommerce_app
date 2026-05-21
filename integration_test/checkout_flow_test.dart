import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shop_flow/app/shop_flow_app.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';

import '../test/support/app_test_bootstrap.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await bootstrapShopFlowTests();
    GetIt.instance<AuthBloc>().add(const AuthSessionRequested());
  });

  tearDownAll(() async {
    await tearDownShopFlowTests();
  });

  testWidgets('demo checkout flow from sign-in to order success', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ShopFlowApp());
    await tester.pumpAndSettle(const Duration(seconds: 10));

    if (find.byKey(TestKeys.googleSignInButton).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(TestKeys.googleSignInButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    expect(find.byKey(TestKeys.firstProductCard), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.firstProductCard), warnIfMissed: false);
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(TestKeys.addToCartButton), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.addToCartButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(TestKeys.pdpCartButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.pumpAndSettle(const Duration(seconds: 3));
    expect(find.byKey(TestKeys.cartCheckoutButton), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.cartCheckoutButton));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    await tester.enterText(
      find.byKey(TestKeys.checkoutFullName),
      'Jane Doe',
    );
    await tester.enterText(
      find.byKey(TestKeys.checkoutStreet),
      '123 Main St',
    );
    await tester.enterText(find.byKey(TestKeys.checkoutCity), 'Springfield');
    await tester.enterText(find.byKey(TestKeys.checkoutPostal), '62701');
    await tester.enterText(find.byKey(TestKeys.checkoutCountry), 'US');

    await tester.tap(find.byKey(TestKeys.checkoutPayButton));

    Finder successTitle = find.text('Thank you!');
    for (int i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (successTitle.evaluate().isNotEmpty) {
        break;
      }
    }

    expect(successTitle, findsOneWidget);
  });
}
