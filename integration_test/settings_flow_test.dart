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

  testWidgets('profile settings theme and locale toggle', (
    WidgetTester tester,
  ) async {
    await launchShopFlowApp(tester);
    await signInDemoUser(tester);

    await tapNavTab(tester, TestKeys.profileNavTab);
    await pumpUntilFound(tester, find.byKey(TestKeys.profileSettingsButton));

    await tester.tap(find.byKey(TestKeys.profileSettingsButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.settingsThemeDark));

    await tester.tap(find.byKey(TestKeys.settingsThemeDark));
    await tester.pump(const Duration(milliseconds: 300));

    await tester.tap(find.byKey(TestKeys.settingsLanguageArabic));
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(TestKeys.settingsLanguageArabic), findsOneWidget);
  });

  testWidgets('edit profile saves display name', (WidgetTester tester) async {
    await launchShopFlowApp(tester);
    await signInDemoUser(tester);

    await tapNavTab(tester, TestKeys.profileNavTab);
    await pumpUntilFound(tester, find.byKey(TestKeys.editProfileButton));

    await tester.tap(find.byKey(TestKeys.editProfileButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.saveProfileButton));

    await tester.enterText(find.byType(TextFormField).at(1), 'Showcase');

    await tester.tap(find.byKey(TestKeys.saveProfileButton));
    await pumpUntilFound(tester, find.byKey(TestKeys.editProfileButton));
  });
}
