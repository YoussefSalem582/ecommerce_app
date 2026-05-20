import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart';

/// Persists profile field edits locally.
@injectable
class UpdateProfileUseCase {
  /// Creates use case with [ProfileRepository].
  UpdateProfileUseCase(this._repository);

  final ProfileRepository _repository;

  /// Updates first/last name and email in local cache.
  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String firstName,
    required String lastName,
  }) =>
      _repository.updateProfile(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
}
