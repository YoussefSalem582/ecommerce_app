import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Reads persisted JWT + cached profile on cold start.
@injectable
class RestoreSessionUseCase {
  /// Wraps repository session restoration.
  RestoreSessionUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns cached user when token exists.
  Future<Either<Failure, UserEntity?>> call() => _repository.restoreSession();
}
