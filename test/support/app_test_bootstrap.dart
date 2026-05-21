import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/core/constants/storage_keys.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/network/token_storage.dart';

/// Boots Hive, env, and GetIt for widget/integration tests.
Future<void> bootstrapShopFlowTests() async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    StorageKeys.onboardingComplete: true,
  });
  FlutterSecureStorage.setMockInitialValues(<String, String>{});
  final Directory hiveDir =
      await Directory.systemTemp.createTemp('shop_flow_hive_test');
  Hive.init(hiveDir.path);
  await dotenv.load(fileName: 'assets/env/default.env');
  await configureDependencies();
  await getIt<TokenStorage>().hydrate();
}

/// Tears down Hive boxes and GetIt after a test suite.
Future<void> tearDownShopFlowTests() async {
  await Hive.close();
  await GetIt.instance.reset();
}
