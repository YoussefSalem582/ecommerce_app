import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Authentication operations backed by remote APIs and local token storage.
abstract class AuthRepository {
  /// Attempts credentials login against the remote IdP.
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  /// Registers a user profile via Fake Store `POST /users`.
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  });

  /// Clears JWT + cached profile (logout).
  Future<Either<Failure, Unit>> logout();

  /// Restores session when a token + cached profile exist.
  Future<Either<Failure, UserEntity?>> restoreSession();
}
