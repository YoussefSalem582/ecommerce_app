import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Local profile reads/writes for the signed-in shopper.
abstract class ProfileRepository {
  /// Returns cached profile or failure when none exists.
  Future<Either<Failure, UserEntity>> getProfile();

  /// Persists updated profile fields locally.
  Future<Either<Failure, UserEntity>> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  });

  /// Reads local avatar file path, if any.
  Future<Either<Failure, String?>> getAvatarPath();

  /// Saves avatar file path from image picker.
  Future<Either<Failure, String>> saveAvatarPath(String path);
}
