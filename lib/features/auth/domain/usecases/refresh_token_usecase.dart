import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Rotates JWT when Dio receives HTTP 401.
@injectable
class RefreshTokenUseCase {
  /// Creates use case with [AuthRepository].
  RefreshTokenUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns new access token on success.
  Future<Either<Failure, String>> call() => _repository.refreshAccessToken();
}
