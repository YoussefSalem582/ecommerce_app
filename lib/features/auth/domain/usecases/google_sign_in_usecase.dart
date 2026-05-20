import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Signs in with Google via showcase stub datasource.
@injectable
class GoogleSignInUseCase {
  /// Creates use case with [AuthRepository].
  GoogleSignInUseCase(this._repository);

  final AuthRepository _repository;

  /// Returns authenticated user on success.
  Future<Either<Failure, UserEntity>> call() =>
      _repository.signInWithGoogle();
}
