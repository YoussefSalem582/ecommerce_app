import 'package:dio/dio.dart';

import 'package:shop_flow/core/network/token_storage.dart';

/// Attaches `Authorization: Bearer` when an access token exists.
class AuthInterceptor extends Interceptor {
  /// Creates an interceptor using [tokenStorage].
  AuthInterceptor(this._tokenStorage);

  final TokenStorage _tokenStorage;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStorage.accessToken;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
