import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';

/// Saved addresses cubit states.
sealed class AddressesState extends Equatable {
  /// Shared equality baseline.
  const AddressesState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first load.
final class AddressesInitial extends AddressesState {
  /// Placeholder state.
  const AddressesInitial();
}

/// Loading addresses from Hive.
final class AddressesLoading extends AddressesState {
  /// Spinner state.
  const AddressesLoading();
}

/// Addresses ready for list UI.
final class AddressesReady extends AddressesState {
  /// Hydrated address rows.
  const AddressesReady(this.addresses);

  /// Saved shipping rows.
  final List<SavedAddressEntity> addresses;

  @override
  List<Object?> get props => <Object?>[addresses];
}

/// Recoverable failure.
final class AddressesFailure extends AddressesState {
  /// Error message.
  const AddressesFailure(this.message);

  /// Human-readable detail.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
