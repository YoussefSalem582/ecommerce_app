import 'package:flutter/material.dart';
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

  testWidgets('catalog to cart flow in demo mode', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopFlowApp());
    await tester.pumpAndSettle(const Duration(seconds: 10));

    if (find.byKey(TestKeys.googleSignInButton).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(TestKeys.googleSignInButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    expect(find.byKey(TestKeys.firstProductCard), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.firstProductCard));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.byKey(TestKeys.addToCartButton), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.addToCartButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(TestKeys.cartNavTab));
    await tester.pumpAndSettle(const Duration(seconds: 3));

    expect(find.byKey(TestKeys.cartCheckoutButton), findsOneWidget);
  });

  testWidgets('wishlist route shows empty state', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopFlowApp());
    await tester.pumpAndSettle(const Duration(seconds: 10));

    if (find.byKey(TestKeys.googleSignInButton).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(TestKeys.googleSignInButton));
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    await tester.tap(find.byIcon(Icons.favorite_outline_rounded));
    await tester.pumpAndSettle(const Duration(seconds: 5));

    expect(find.text('Your wishlist is empty'), findsOneWidget);
  });
}
