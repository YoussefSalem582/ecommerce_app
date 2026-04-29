import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Clears credentials from secure stores.
@injectable
class LogoutUseCase {
  /// Wraps repository logout.
  LogoutUseCase(this._repository);

  final AuthRepository _repository;

  /// Delegates logout side-effects.
  Future<Either<Failure, Unit>> call() => _repository.logout();
}
