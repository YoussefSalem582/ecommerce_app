import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/pages/login_page.dart';

import '../support/app_test_bootstrap.dart';
import '../support/golden_harness.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    await bootstrapShopFlowTests();
    GetIt.instance<AuthBloc>().add(const AuthLogoutRequested());
  });

  tearDownAll(() async {
    await tearDownShopFlowTests();
  });

  Future<void> pumpLogin(
    WidgetTester tester, {
    required Size size,
    ThemeMode themeMode = ThemeMode.light,
  }) async {
    final AuthBloc authBloc = GetIt.instance<AuthBloc>();
    await pumpGolden(
      tester,
      wrapGoldenApp(
        themeMode: themeMode,
        child: withBlocProvider(authBloc, const LoginPage()),
      ),
      surfaceSize: size,
    );
  }

  testWidgets('login mobile light golden', (WidgetTester tester) async {
    await pumpLogin(tester, size: const Size(390, 844));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_mobile_light.png'),
    );
  });

  testWidgets('login tablet light golden', (WidgetTester tester) async {
    await pumpLogin(tester, size: const Size(800, 1280));
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_tablet_light.png'),
    );
  });

  testWidgets('login mobile dark golden', (WidgetTester tester) async {
    await pumpLogin(
      tester,
      size: const Size(390, 844),
      themeMode: ThemeMode.dark,
    );
    await expectLater(
      find.byType(Scaffold),
      matchesGoldenFile('goldens/login_mobile_dark.png'),
    );
  });
}
