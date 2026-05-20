import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/core/network/token_storage.dart';
import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/datasources/google_auth_datasource.dart';
import 'package:shop_flow/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Concrete auth repository orchestrating remote & local layers.
@lazySingleton
class AuthRepositoryImpl implements AuthRepository {
  /// Creates repository with auth datasources + token dependencies.
  AuthRepositoryImpl(
    this._remote,
    this._google,
    this._local,
    this._tokens,
    this._talker,
  );

  final AuthRemoteDatasource _remote;
  final GoogleAuthDatasource _google;
  final LocalAuthDatasource _local;
  final TokenStorage _tokens;
  final Talker _talker;

  Future<void> _persistSession({
    required String accessToken,
    required String refreshToken,
    required UserEntity user,
  }) async {
    await _tokens.setAccessToken(accessToken);
    await _tokens.setRefreshToken(refreshToken);
    await _local.cacheUser(user);
  }

  String _mockRefreshToken(String username) => 'refresh_$username';

  String _mockAccessToken(String username) =>
      'access.$username.${DateTime.now().millisecondsSinceEpoch}';

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final token = await _remote.login(
        username: username,
        password: password,
      );
      final user = UserEntity(
        id: 0,
        username: username,
        email: null,
      );
      await _persistSession(
        accessToken: token,
        refreshToken: _mockRefreshToken(username),
        user: user,
      );
      _talker.info('[ShopFlow][auth] login success ($username)');
      return Right<Failure, UserEntity>(user);
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(ServerFailure(e.message));
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final model = await _remote.register(
        email: email,
        username: username,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      final entity = model.toEntity();
      await _local.cacheUser(entity);
      _talker.info('[ShopFlow][auth] register success (${entity.username})');
      return Right<Failure, UserEntity>(entity);
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(ServerFailure(e.message));
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, Unit>> logout() async {
    try {
      await _tokens.clearAll();
      await _local.clearCachedUser();
      _talker.info('[ShopFlow][auth] logout');
      return const Right<Failure, Unit>(unit);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, Unit>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> restoreSession() async {
    try {
      if (!await _tokens.hasToken) {
        return const Right<Failure, UserEntity?>(null);
      }
      final cached = _local.loadCachedUser();
      if (cached != null) {
        _talker.info('[ShopFlow][auth] session restored (${cached.username})');
        return Right<Failure, UserEntity?>(cached);
      }
      await _tokens.clearAll();
      return const Right<Failure, UserEntity?>(null);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity?>(
        UnexpectedFailure(e.toString()),
      );
    }
  }

  @override
  Future<Either<Failure, String>> refreshAccessToken() async {
    try {
      final refresh = await _tokens.refreshToken;
      if (refresh == null || refresh.isEmpty) {
        return const Left<Failure, String>(
          CacheFailure('No refresh token available'),
        );
      }
      final newToken = await _remote.refreshAccessToken(refreshToken: refresh);
      await _tokens.setAccessToken(newToken);
      _talker.info('[ShopFlow][auth] access token refreshed');
      return Right<Failure, String>(newToken);
    } on ServerException catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, String>(ServerFailure(e.message));
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, String>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final user = await _google.signIn();
      await _persistSession(
        accessToken: _mockAccessToken(user.username),
        refreshToken: _mockRefreshToken(user.username),
        user: user,
      );
      _talker.info('[ShopFlow][auth] Google sign-in success (${user.username})');
      return Right<Failure, UserEntity>(user);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(UnexpectedFailure(e.toString()));
    }
  }
}
