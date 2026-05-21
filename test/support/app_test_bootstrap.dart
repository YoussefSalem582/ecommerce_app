import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/network/token_storage.dart';

/// Options for widget and integration test bootstrapping.
class TestBootstrapOptions {
  /// Creates bootstrap configuration.
  const TestBootstrapOptions({
    this.skipOnboarding = true,
    this.locale,
    this.appEnv,
  });

  /// When true, onboarding is marked complete in SharedPreferences.
  final bool skipOnboarding;

  /// Optional locale override applied after DI (e.g. `Locale('ar')`).
  final Locale? locale;

  /// Optional `APP_ENV` override merged into dotenv before DI.
  final String? appEnv;
}

/// Boots Hive, env, and GetIt for widget/integration tests.
Future<void> bootstrapShopFlowTests({
  TestBootstrapOptions options = const TestBootstrapOptions(),
}) async {
  final Map<String, Object> prefs = <String, Object>{};
  if (options.skipOnboarding) {
    prefs[StorageKeys.onboardingComplete] = true;
  }
  SharedPreferences.setMockInitialValues(prefs);
  FlutterSecureStorage.setMockInitialValues(<String, String>{});
  final Directory hiveDir =
      await Directory.systemTemp.createTemp('shop_flow_hive_test');
  Hive.init(hiveDir.path);
  await dotenv.load(fileName: 'assets/env/default.env');
  if (options.appEnv != null) {
    dotenv.env['APP_ENV'] = options.appEnv!;
  }
  await configureDependencies();
  await getIt<TokenStorage>().hydrate();
}

/// Tears down Hive boxes and GetIt after a test suite.
Future<void> tearDownShopFlowTests() async {
  await Hive.close();
  await GetIt.instance.reset();
}
