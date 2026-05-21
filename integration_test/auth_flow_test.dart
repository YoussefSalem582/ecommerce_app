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

  testWidgets('email login reaches home catalog', (WidgetTester tester) async {
    await launchShopFlowApp(tester);

    if (find.byKey(TestKeys.googleSignInButton).evaluate().isNotEmpty) {
      await tester.tap(find.byKey(TestKeys.googleSignInButton));
      await pumpUntilFound(tester, find.byKey(TestKeys.firstProductCard));
    } else {
      expect(find.byKey(TestKeys.loginSubmitButton), findsOneWidget);
      await tester.tap(find.byKey(TestKeys.loginSubmitButton));
      await pumpUntilFound(tester, find.byKey(TestKeys.firstProductCard));
    }

    expect(find.byKey(TestKeys.firstProductCard), findsOneWidget);
    expect(find.byKey(TestKeys.homeNavTab), findsOneWidget);
  });
}
