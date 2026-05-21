import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/domain/usecases/delete_address_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/get_addresses_usecase.dart';
import 'package:shop_flow/features/profile/domain/usecases/save_address_usecase.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_state.dart';

/// Manages saved shipping addresses for profile + checkout.
@lazySingleton
class AddressesCubit extends Cubit<AddressesState> {
  /// Hydrates on construction.
  AddressesCubit(this._getAddresses, this._saveAddress, this._deleteAddress)
      : super(const AddressesInitial()) {
    Future<void>.microtask(load);
  }

  final GetAddressesUseCase _getAddresses;
  final SaveAddressUseCase _saveAddress;
  final DeleteAddressUseCase _deleteAddress;

  /// Reloads address list from Hive.
  Future<void> load() async {
    emit(const AddressesLoading());
    final result = await _getAddresses();
    result.fold(
      (failure) => emit(AddressesFailure(failure.message)),
      (list) => emit(AddressesReady(list)),
    );
  }

  /// Upserts an address row.
  Future<bool> save(SavedAddressEntity address) async {
    final result = await _saveAddress(address);
    return result.fold(
      (failure) {
        emit(AddressesFailure(failure.message));
        return false;
      },
      (list) {
        emit(AddressesReady(list));
        return true;
      },
    );
  }

  /// Deletes address by id.
  Future<void> delete(String id) async {
    final result = await _deleteAddress(id);
    result.fold(
      (failure) => emit(AddressesFailure(failure.message)),
      (list) => emit(AddressesReady(list)),
    );
  }
}
