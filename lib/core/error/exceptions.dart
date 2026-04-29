/// Exception thrown when the remote API returns an error payload or status.
class ServerException implements Exception {
  /// Creates a server exception with [message].
  const ServerException(this.message);

  /// Diagnostic message.
  final String message;

  @override
  String toString() => 'ServerException: $message';
}

/// Exception thrown when reading or writing local cache fails.
class CacheException implements Exception {
  /// Creates a cache exception with [message].
  const CacheException(this.message);

  /// Diagnostic message.
  final String message;

  @override
  String toString() => 'CacheException: $message';
}
