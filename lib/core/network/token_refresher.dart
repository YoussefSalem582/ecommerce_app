import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/auth/domain/usecases/refresh_token_usecase.dart';

/// Attempts JWT refresh when Dio receives HTTP 401.
@lazySingleton
class TokenRefresher {
  /// Creates refresher with [RefreshTokenUseCase].
  TokenRefresher(this._refreshToken);

  final RefreshTokenUseCase _refreshToken;

  /// Returns true when a new access token was persisted.
  Future<bool> tryRefresh() async {
    final result = await _refreshToken.call();
    return result.isRight();
  }
}
