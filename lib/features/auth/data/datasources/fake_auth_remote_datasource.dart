import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/models/user_model.dart';
import 'package:talker/talker.dart';

/// Offline-friendly auth when `APP_ENV` is `demo` (see core `AppConfig`).
///
/// Skips HTTP so reviewers can pass login/register when `fakestoreapi.com`
/// is unreachable from their network stack.
class FakeAuthRemoteDatasource implements AuthRemoteDatasource {
  /// Records demo-mode sign-ins for Talker traces.
  FakeAuthRemoteDatasource(this._talker);

  final Talker _talker;

  static const _demoJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.'
      'eyJzdWIiOiJzaG9wZmxvdy1kZW1vIn0.demo';

  @override
  Future<String> login({
    required String username,
    required String password,
  }) async {
    _talker.info('[ShopFlow][auth][demo] login (no network): $username');
    return _demoJwt;
  }

  @override
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _talker.info('[ShopFlow][auth][demo] register (no network): $username');
    final id = username.hashCode.abs() % 1000000;
    return UserModel(
      id: id == 0 ? 1 : id,
      username: username,
      email: email,
      firstName: firstName,
      lastName: lastName,
    );
  }
}
