import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shop_flow/app/shop_flow_app.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/network/token_storage.dart';
import 'package:talker/talker.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';

/// ShopFlow entry — initializes Hive, env, DI, logging, and Stripe keys.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await dotenv.load(fileName: 'assets/env/default.env');

  // Optional gitignored override at project root (never commit secrets).
  await dotenv.load(fileName: '.env', mergeWith: dotenv.env, isOptional: true);

  await configureDependencies();

  await getIt<TokenStorage>().hydrate();

  final talker = getIt<Talker>();
  final appEnv = getIt<AppConfig>().appEnv;
  talker.info(
    '[ShopFlow] APP_ENV=$appEnv '
    '(raw=${dotenv.env['APP_ENV'] ?? 'unset'}, demo=${getIt<AppConfig>().isDemoEnv})',
  );
  Bloc.observer = TalkerBlocObserver(talker: talker);

  final stripeKey = getIt<AppConfig>().stripePublishableKey;
  if (stripeKey != null && stripeKey.isNotEmpty) {
    Stripe.publishableKey = stripeKey;
  }

  FlutterError.onError = (FlutterErrorDetails details) {
    talker.handle(details.exception, details.stack ?? StackTrace.empty);
  };

  runApp(const ShopFlowApp());
}
