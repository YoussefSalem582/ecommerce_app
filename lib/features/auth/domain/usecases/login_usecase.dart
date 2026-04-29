import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Executes username/password login via [AuthRepository].
@injectable
class LoginUseCase {
  /// Wraps repository login for presentation injection.
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  /// Delegates to remote login + persistence pipeline.
  Future<Either<Failure, UserEntity>> call({
    required String username,
    required String password,
  }) {
    return _repository.login(username: username, password: password);
  }
}
