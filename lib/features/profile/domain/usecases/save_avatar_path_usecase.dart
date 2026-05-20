import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart';

/// Saves avatar path after image picker selection.
@injectable
class SaveAvatarPathUseCase {
  /// Creates use case with [ProfileRepository].
  SaveAvatarPathUseCase(this._repository);

  final ProfileRepository _repository;

  /// Persists avatar path locally.
  Future<Either<Failure, String>> call(String path) =>
      _repository.saveAvatarPath(path);
}
