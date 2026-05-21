import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/addresses_repository.dart';

/// Upserts a saved address row.
@injectable
class SaveAddressUseCase {
  /// Delegates to repository.
  SaveAddressUseCase(this._repository);

  final AddressesRepository _repository;

  /// Persists [address] and returns updated list.
  Future<Either<Failure, List<SavedAddressEntity>>> call(
    SavedAddressEntity address,
  ) {
    return _repository.saveAddress(address);
  }
}
