import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/core/network/token_storage.dart';
import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/datasources/local_auth_datasource.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/auth/domain/repositories/auth_repository.dart';

/// Concrete auth repository orchestrating remote & local layers.
@lazySingleton
class AuthRepositoryImpl implements AuthRepository {
  /// Creates repository with [AuthRemoteDatasource] + token dependencies.
  AuthRepositoryImpl(
    this._remote,
    this._local,
    this._tokens,
    this._talker,
  );

  final AuthRemoteDatasource _remote;
  final LocalAuthDatasource _local;
  final TokenStorage _tokens;
  final Talker _talker;

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
      await _tokens.setAccessToken(token);
      final user = UserEntity(
        id: 0,
        username: username,
        email: null,
      );
      await _local.cacheUser(user);
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
      await _tokens.clearAccessToken();
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
      if (!_tokens.hasToken) {
        return const Right<Failure, UserEntity?>(null);
      }
      final cached = _local.loadCachedUser();
      if (cached != null) {
        _talker.info('[ShopFlow][auth] session restored (${cached.username})');
        return Right<Failure, UserEntity?>(cached);
      }
      await _tokens.clearAccessToken();
      return const Right<Failure, UserEntity?>(null);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity?>(
        UnexpectedFailure(e.toString()),
      );
    }
  }
}
