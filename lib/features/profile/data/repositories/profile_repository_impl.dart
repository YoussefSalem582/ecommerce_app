import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';
import 'package:shop_flow/features/profile/data/datasources/local_profile_datasource.dart';
import 'package:shop_flow/features/profile/domain/repositories/profile_repository.dart';

/// Local-first profile repository for showcase builds.
@LazySingleton(as: ProfileRepository)
class ProfileRepositoryImpl implements ProfileRepository {
  /// Creates repository with local datasource + Talker.
  ProfileRepositoryImpl(this._local, this._talker);

  final LocalProfileDatasource _local;
  final Talker _talker;

  @override
  Future<Either<Failure, UserEntity>> getProfile() async {
    try {
      final user = _local.loadProfile();
      if (user == null) {
        return const Left<Failure, UserEntity>(
          CacheFailure('No cached profile'),
        );
      }
      return Right<Failure, UserEntity>(user);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> updateProfile({
    required String email,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final user = await _local.updateProfile(
        email: email,
        firstName: firstName,
        lastName: lastName,
      );
      _talker.info('[ShopFlow][profile] updated (${user.username})');
      return Right<Failure, UserEntity>(user);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, UserEntity>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String?>> getAvatarPath() async {
    try {
      return Right<Failure, String?>(_local.loadAvatarPath());
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, String?>(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> saveAvatarPath(String path) async {
    try {
      await _local.saveAvatarPath(path);
      _talker.info('[ShopFlow][profile] avatar saved');
      return Right<Failure, String>(path);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, String>(UnexpectedFailure(e.toString()));
    }
  }
}
