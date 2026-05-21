import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';

/// Contract for saved shipping address persistence.
abstract class AddressesRepository {
  /// Returns all saved addresses.
  Future<Either<Failure, List<SavedAddressEntity>>> getAddresses();

  /// Upserts an address (generates id when empty).
  Future<Either<Failure, List<SavedAddressEntity>>> saveAddress(
    SavedAddressEntity address,
  );

  /// Removes address by [id].
  Future<Either<Failure, List<SavedAddressEntity>>> deleteAddress(String id);
}
