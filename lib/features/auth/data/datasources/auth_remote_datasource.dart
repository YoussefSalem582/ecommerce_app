import 'package:shop_flow/features/auth/data/models/user_model.dart';

/// Remote login/register contract (Fake Store HTTP or demo implementation).
abstract class AuthRemoteDatasource {
  /// Returns a bearer token string after successful credential validation.
  Future<String> login({
    required String username,
    required String password,
  });

  /// Creates or simulates a user account and returns the profile payload.
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  });
}
