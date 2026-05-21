import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';

import '../test/support/app_test_bootstrap.dart';
import 'support/flow_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await bootstrapShopFlowTests();
    GetIt.instance<AuthBloc>().add(const AuthSessionRequested());
  });

  tearDownAll(() async {
    await tearDownShopFlowTests();
  });

  testWidgets('search catalog, open PDP, toggle wishlist', (
    WidgetTester tester,
  ) async {
    await launchShopFlowApp(tester);
    await signInDemoUser(tester);

    expect(find.byKey(TestKeys.catalogSearchField), findsOneWidget);
    await tester.enterText(find.byKey(TestKeys.catalogSearchField), 'jacket');
    await tester.tap(find.byIcon(Icons.search_rounded).last);
    await pumpUntilFound(tester, find.byKey(TestKeys.firstProductCard));

    await tester.tap(find.byKey(TestKeys.firstProductCard), warnIfMissed: false);
    await pumpUntilFound(tester, find.byKey(TestKeys.wishlistToggleButton));

    await tester.tap(find.byKey(TestKeys.wishlistToggleButton));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(TestKeys.wishlistToggleButton), findsOneWidget);
  });
}
