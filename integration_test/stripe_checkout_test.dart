@Tags(<String>['stripe'])
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shop_flow/core/config/app_config.dart';
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

  testWidgets('stripe checkout skipped when publishable key absent', (
    WidgetTester tester,
  ) async {
    final AppConfig config = GetIt.instance<AppConfig>();
    if (config.stripePublishableKey != null &&
        config.stripePaymentIntentClientSecret != null) {
      // Live Stripe path requires manual Payment Sheet interaction on device.
      return;
    }

    await launchShopFlowApp(tester);
    await signInDemoUser(tester);
    await addFirstProductToCart(tester);
    await openCart(tester);

    await tester.tap(find.byKey(TestKeys.cartCheckoutButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.checkoutPayButton));

    expect(find.text(config.appEnv), findsNothing);
    await completeCheckout(tester);
  });
}
