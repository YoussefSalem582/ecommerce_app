import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/features/wishlist/domain/usecases/get_wishlist_ids_usecase.dart';
import 'package:shop_flow/features/wishlist/domain/usecases/toggle_wishlist_usecase.dart';
import 'package:shop_flow/features/wishlist/presentation/cubit/wishlist_state.dart';

/// Persists wishlist hearts locally with optimistic Cubit updates.
@lazySingleton
class WishlistCubit extends Cubit<WishlistState> {
  /// Hydrates asynchronously via microtask to avoid constructor awaits.
  WishlistCubit(this._getIds, this._toggle, this._talker)
      : super(const WishlistInitial()) {
    Future<void>.microtask(load);
  }

  final GetWishlistIdsUseCase _getIds;
  final ToggleWishlistUseCase _toggle;
  final Talker _talker;

  /// Reads Hive JSON snapshot into ready state.
  Future<void> load() async {
    emit(const WishlistLoading());
    final result = await _getIds();
    result.fold(
      (failure) => emit(WishlistFailure(failure.message)),
      (ids) => emit(WishlistReady(ids)),
    );
  }

  /// Flips SKU membership and emits sorted ids for UI diffing.
  Future<void> toggleId(int productId) async {
    final WishlistState previous = state;
    final result = await _toggle(productId);
    result.fold(
      (failure) {
        _talker.warning(
          '[ShopFlow][wishlist] toggle failed: ${failure.message}',
        );
        if (previous is WishlistReady) {
          emit(previous);
        } else {
          emit(WishlistFailure(failure.message));
        }
      },
      (ids) => emit(WishlistReady(ids)),
    );
  }

  /// Convenience helper for hearts without pattern matching in widgets.
  bool contains(int productId) {
    final WishlistState s = state;
    return s is WishlistReady && s.contains(productId);
  }
}
