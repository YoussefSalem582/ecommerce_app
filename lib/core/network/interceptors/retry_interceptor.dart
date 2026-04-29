import 'package:dio/dio.dart';

/// Retries failed idempotent requests with exponential backoff.
class RetryInterceptor extends Interceptor {
  /// Creates a retry interceptor bound to [dio].
  RetryInterceptor(this._dio, {this.maxRetries = 3});

  final Dio _dio;
  final int maxRetries;

  static const _retryCountKey = 'shop_flow_retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final attempt = (options.extra[_retryCountKey] as int?) ?? 0;

    if (!_shouldRetry(err) || attempt >= maxRetries) {
      handler.next(err);
      return;
    }

    options.extra[_retryCountKey] = attempt + 1;
    final delayMs = 200 * (1 << attempt);
    await Future<void>.delayed(Duration(milliseconds: delayMs));

    try {
      final response = await _dio.fetch<Object?>(options);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    }
  }

  bool _shouldRetry(DioException err) {
    final m = err.type;
    if (m == DioExceptionType.connectionError &&
        (_isLikelyDnsFailure(err) || _isConnectionReset(err))) {
      return false;
    }
    return m == DioExceptionType.connectionTimeout ||
        m == DioExceptionType.sendTimeout ||
        m == DioExceptionType.receiveTimeout ||
        m == DioExceptionType.connectionError ||
        (err.response?.statusCode != null && err.response!.statusCode! >= 500);
  }

  /// DNS / unknown-host failures rarely recover within backoff; skip retries.
  bool _isLikelyDnsFailure(DioException err) {
    final msg = '${err.message ?? ''} ${err.error ?? ''}'.toLowerCase();
    return msg.contains('failed host lookup') ||
        msg.contains('unknown host') ||
        msg.contains('no address associated') ||
        msg.contains('temporary failure in name resolution');
  }

  /// Peer RST often persists across immediate retries; avoid log/snackbar spam.
  bool _isConnectionReset(DioException err) {
    final msg = '${err.message ?? ''} ${err.error ?? ''}'.toLowerCase();
    return msg.contains('connection reset');
  }
}
