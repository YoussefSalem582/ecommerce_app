import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/data/datasources/local_addresses_datasource.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/addresses_repository.dart';

/// Hive-backed saved address repository.
@LazySingleton(as: AddressesRepository)
class AddressesRepositoryImpl implements AddressesRepository {
  /// Injects local JSON datasource.
  AddressesRepositoryImpl(this._local);

  final LocalAddressesDatasource _local;

  @override
  Future<Either<Failure, List<SavedAddressEntity>>> getAddresses() async {
    try {
      final list = await _local.readAll();
      return Right(list);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedAddressEntity>>> saveAddress(
    SavedAddressEntity address,
  ) async {
    try {
      final current = await _local.readAll();
      final id = address.id.isEmpty
          ? 'addr_${DateTime.now().millisecondsSinceEpoch}'
          : address.id;
      var updated = address.copyWith(id: id);

      if (updated.isDefault) {
        for (var i = 0; i < current.length; i++) {
          current[i] = current[i].copyWith(isDefault: false);
        }
      }

      final index = current.indexWhere((SavedAddressEntity a) => a.id == id);
      if (index >= 0) {
        current[index] = updated;
      } else {
        if (current.isEmpty) {
          updated = updated.copyWith(isDefault: true);
        }
        current.add(updated);
      }

      await _local.writeAll(current);
      return Right(current);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedAddressEntity>>> deleteAddress(
    String id,
  ) async {
    try {
      final current = await _local.readAll();
      current.removeWhere((SavedAddressEntity a) => a.id == id);
      if (current.isNotEmpty && !current.any((SavedAddressEntity a) => a.isDefault)) {
        current[0] = current.first.copyWith(isDefault: true);
      }
      await _local.writeAll(current);
      return Right(current);
    } on Exception catch (e) {
      return Left(UnexpectedFailure(e.toString()));
    }
  }
}
