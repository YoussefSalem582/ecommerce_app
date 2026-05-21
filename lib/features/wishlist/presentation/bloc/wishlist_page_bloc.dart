import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:shop_flow/features/wishlist/domain/usecases/get_wishlist_ids_usecase.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_event.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_state.dart';

/// Loads favorited SKU rows by intersecting Hive ids with catalog data.
@injectable
class WishlistPageBloc extends Bloc<WishlistPageEvent, WishlistPageState> {
  /// Resolves wishlist ids against offline-first catalog use case.
  WishlistPageBloc(this._getIds, this._getProducts)
      : super(const WishlistPageInitial()) {
    on<WishlistPageStarted>(_onStarted);
    on<WishlistPageRefreshRequested>(_onRefresh);
  }

  final GetWishlistIdsUseCase _getIds;
  final GetProductsUseCase _getProducts;

  Future<void> _onStarted(
    WishlistPageStarted event,
    Emitter<WishlistPageState> emit,
  ) async {
    emit(const WishlistPageLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    WishlistPageRefreshRequested event,
    Emitter<WishlistPageState> emit,
  ) async {
    emit(const WishlistPageLoading());
    await _load(emit);
  }

  Future<void> _load(Emitter<WishlistPageState> emit) async {
    final idsResult = await _getIds();
    final ids = idsResult.fold(
      (failure) {
        emit(WishlistPageFailure(failure.message));
        return null;
      },
      (Set<int> set) => set,
    );
    if (ids == null) {
      return;
    }

    if (ids.isEmpty) {
      emit(const WishlistPageEmpty());
      return;
    }

    final productsResult = await _getProducts();
    productsResult.fold(
      (failure) => emit(WishlistPageFailure(failure.message)),
      (List<ProductEntity> all) {
        final filtered = all.where((ProductEntity p) => ids.contains(p.id)).toList();
        if (filtered.isEmpty) {
          emit(const WishlistPageEmpty());
        } else {
          emit(WishlistPageLoaded(products: filtered));
        }
      },
    );
  }
}
