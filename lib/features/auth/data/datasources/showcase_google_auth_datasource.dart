import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/features/auth/data/datasources/google_auth_datasource.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Showcase Google Sign-In returning a fixed demo profile.
@LazySingleton(as: GoogleAuthDatasource)
class ShowcaseGoogleAuthDatasource implements GoogleAuthDatasource {
  /// Creates stub datasource with Talker logging.
  ShowcaseGoogleAuthDatasource(this._talker);

  final Talker _talker;

  @override
  Future<UserEntity> signIn() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _talker.info('[ShopFlow][auth] Google Sign-In showcase stub');
    return const UserEntity(
      id: 9001,
      username: 'google_demo',
      email: 'demo@gmail.com',
      firstName: 'Google',
      lastName: 'Shopper',
    );
  }
}
