import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Executes Fake Store registration (`POST /users`).
@injectable
class RegisterUseCase {
  /// Wraps repository registration.
  RegisterUseCase(this._repository);

  final AuthRepository _repository;

  /// Delegates registration with profile fields.
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) {
    return _repository.register(
      email: email,
      username: username,
      password: password,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
