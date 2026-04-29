import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_flow/app/shop_flow_app.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDir;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    hiveDir = await Directory.systemTemp.createTemp('shop_flow_hive_test');
    Hive.init(hiveDir.path);
    await dotenv.load(fileName: 'assets/env/default.env');
    await configureDependencies();
    getIt<AuthBloc>().add(const AuthSessionRequested());
  });

  tearDownAll(() async {
    await Hive.close();
    await GetIt.instance.reset();
    if (hiveDir.existsSync()) {
      hiveDir.deleteSync(recursive: true);
    }
  });

  testWidgets('ShopFlow renders root MaterialApp', (WidgetTester tester) async {
    await tester.pumpWidget(const ShopFlowApp());
    await tester.pump();
    await tester.pump(const Duration(seconds: 2));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
