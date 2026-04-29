import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:injectable/injectable.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/network/interceptors/auth_interceptor.dart';
import 'package:shop_flow/core/network/interceptors/retry_interceptor.dart';
import 'package:shop_flow/core/network/token_storage.dart';
import 'package:talker/talker.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';

/// Mimics mobile Chrome so TLS/CDN paths align with the emulator browser.
const _kShopFlowMobileBrowserUa =
    'Mozilla/5.0 (Linux; Android 13; Mobile) '
    'AppleWebKit/537.36 (KHTML, like Gecko) '
    'Chrome/120.0.0.0 Mobile Safari/537.36';

/// Avoid logging bodies that include passwords.
///
/// Talker prints request payload data verbatim otherwise.
bool _dioRequestSafeToLog(RequestOptions options) {
  final path = options.uri.path.toLowerCase();
  if (path.contains('/auth/login')) {
    return false;
  }
  if (options.method == 'POST' &&
      path.endsWith('/users') &&
      options.data is Map<dynamic, dynamic>) {
    final map = options.data! as Map<dynamic, dynamic>;
    if (map.containsKey('password')) {
      return false;
    }
  }
  return true;
}

/// Configured [Dio] instance shared application-wide.
@lazySingleton
class DioClient {
  /// Builds the HTTP client with interceptors.
  DioClient(this._talker, this._config, this._tokenStorage) {
    final dio = Dio(
      BaseOptions(
        baseUrl: _config.apiBaseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        // Avoid reusing sockets some emulators/CDNs close aggressively (RST).
        persistentConnection: false,
        headers: <String, dynamic>{
          Headers.acceptHeader: 'application/json',
          Headers.contentTypeHeader: 'application/json',
          if (!kIsWeb) 'User-Agent': _kShopFlowMobileBrowserUa,
          if (!kIsWeb) 'Connection': 'close',
        },
      ),
    );

    dio.interceptors.addAll(<Interceptor>[
      AuthInterceptor(_tokenStorage),
      TalkerDioLogger(
        talker: _talker,
        settings: const TalkerDioLoggerSettings(
          requestFilter: _dioRequestSafeToLog,
        ),
      ),
      RetryInterceptor(dio),
    ]);

    _dio = dio;
  }

  final Talker _talker;
  final AppConfig _config;
  final TokenStorage _tokenStorage;

  late final Dio _dio;

  /// Root Dio instance — inject this instead of constructing manually.
  Dio get dio => _dio;
}
