import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Google Sign-In contract (showcase stub — swap for real OAuth).
abstract class GoogleAuthDatasource {
  /// Returns demo Google user profile for showcase builds.
  Future<UserEntity> signIn();
}
