import 'package:equatable/equatable.dart';

/// Base failure returned by repositories and use cases (`Either` left side).
abstract class Failure extends Equatable {
  /// Creates a failure with a human-readable explanation.
  const Failure(this.message);

  /// User-facing or loggable description.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// Failure originating from remote APIs or transport.
class ServerFailure extends Failure {
  /// Creates a server-side failure.
  const ServerFailure(super.message);
}

/// Failure originating from local cache / Hive / preferences.
class CacheFailure extends Failure {
  /// Creates a cache failure.
  const CacheFailure(super.message);
}

/// Failure when there is no usable network connection.
class NetworkFailure extends Failure {
  /// Creates a network failure.
  const NetworkFailure(super.message);
}

/// Unexpected failures not mapped to a specific category.
class UnexpectedFailure extends Failure {
  /// Creates an unexpected failure.
  const UnexpectedFailure(super.message);
}
