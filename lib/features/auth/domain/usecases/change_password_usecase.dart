import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';

/// Showcase password change — local validation only (no Fake Store endpoint).
@injectable
class ChangePasswordUseCase {
  /// Returns success after UI-level validation passes.
  Future<Either<Failure, Unit>> call() async {
    return const Right(unit);
  }
}
