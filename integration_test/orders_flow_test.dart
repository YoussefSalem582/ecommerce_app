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

  testWidgets('checkout creates order visible in orders list', (
    WidgetTester tester,
  ) async {
    await launchShopFlowApp(tester);
    await signInDemoUser(tester);

    await addFirstProductToCart(tester);
    await openCart(tester);

    await tester.tap(find.byKey(TestKeys.cartCheckoutButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.checkoutPayButton));
    await completeCheckout(tester);

    await tapNavTab(tester, TestKeys.ordersNavTab);
    await pumpUntilFound(tester, find.byKey(TestKeys.firstOrderTile));

    expect(find.byKey(TestKeys.firstOrderTile), findsOneWidget);
    await tester.tap(find.byKey(TestKeys.firstOrderTile));
    await tester.pump(const Duration(milliseconds: 500));
  });
}
