import 'package:dio/dio.dart';

import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/network/token_refresher.dart';
import 'package:shop_flow/core/network/token_storage.dart';

/// Attaches `Authorization: Bearer` when an access token exists.
class AuthInterceptor extends Interceptor {
  /// Creates an interceptor using [tokenStorage].
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.accessTokenSync;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

/// Retries once after refreshing JWT on HTTP 401 responses.
class TokenRefreshInterceptor extends QueuedInterceptor {
  /// Creates refresh interceptor.
  TokenRefreshInterceptor(this._dio, this._tokenStorage);

  final Dio _dio;
  final TokenStorage _tokenStorage;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    final retried = err.requestOptions.extra['retried'] == true;
    if (retried) {
      handler.next(err);
      return;
    }

    final refreshed = await getIt<TokenRefresher>().tryRefresh();
    if (!refreshed) {
      handler.next(err);
      return;
    }

    final token = _tokenStorage.accessTokenSync;
    final options = err.requestOptions;
    options.extra['retried'] = true;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    try {
      final response = await _dio.fetch<dynamic>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }
}
