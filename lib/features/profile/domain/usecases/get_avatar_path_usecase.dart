import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart';

/// Reads persisted avatar path from local storage.
@injectable
class GetAvatarPathUseCase {
  /// Creates use case with [ProfileRepository].
  GetAvatarPathUseCase(this._repository);

  final ProfileRepository _repository;

  /// Returns filesystem path or null.
  Future<Either<Failure, String?>> call() => _repository.getAvatarPath();
}
