import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart';

/// Loads cached profile for the profile screen.
@injectable
class GetProfileUseCase {
  /// Creates use case with [ProfileRepository].
  GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  /// Returns local profile snapshot.
  Future<Either<Failure, UserEntity>> call() => _repository.getProfile();
}
