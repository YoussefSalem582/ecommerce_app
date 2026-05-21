import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/addresses_repository.dart';

/// Loads saved addresses from Hive.
@injectable
class GetAddressesUseCase {
  /// Delegates to repository.
  GetAddressesUseCase(this._repository);

  final AddressesRepository _repository;

  /// Returns address rows.
  Future<Either<Failure, List<SavedAddressEntity>>> call() {
    return _repository.getAddresses();
  }
}
