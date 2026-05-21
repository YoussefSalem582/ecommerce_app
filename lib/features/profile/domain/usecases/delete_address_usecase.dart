import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/domain/repositories/addresses_repository.dart';

/// Deletes a saved address by id.
@injectable
class DeleteAddressUseCase {
  /// Delegates to repository.
  DeleteAddressUseCase(this._repository);

  final AddressesRepository _repository;

  /// Removes address and returns updated list.
  Future<Either<Failure, List<SavedAddressEntity>>> call(String id) {
    return _repository.deleteAddress(id);
  }
}
