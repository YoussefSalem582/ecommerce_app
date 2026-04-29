import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/network/connectivity_cubit.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/usecases/add_or_increment_cart_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/get_cart_lines_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/remove_cart_line_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/set_cart_quantity_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/sync_cart_usecase.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_state.dart';

/// Coordinates Hive cart IO, badges, and connectivity-driven sync hooks.
@lazySingleton
class CartBloc extends Bloc<CartEvent, CartState> {
  /// Wires use cases + connectivity listener for Phase 4 milestones.
  CartBloc(
    this._getLines,
    this._addOrIncrement,
    this._removeLine,
    this._setQuantity,
    this._syncCart,
    this._clearCart,
    this._connectivity,
    this._talker,
  ) : super(const CartInitial()) {
    on<CartStarted>(_onStarted);
    on<CartRefreshRequested>(_onRefresh);
    on<CartProductAdded>(_onProductAdded);
    on<CartLineRemoved>(_onLineRemoved);
    on<CartQuantityChanged>(_onQuantityChanged);
    on<CartSyncRequested>(_onSyncRequested);
    on<CartClearRequested>(_onClearRequested);

    _connectivitySub = _connectivity.stream.listen((ConnectivityStatus status) {
      if (status == ConnectivityStatus.online) {
        add(const CartSyncRequested());
      }
    });
  }

  final GetCartLinesUseCase _getLines;
  final AddOrIncrementCartUseCase _addOrIncrement;
  final RemoveCartLineUseCase _removeLine;
  final SetCartQuantityUseCase _setQuantity;
  final SyncCartUseCase _syncCart;
  final ClearCartUseCase _clearCart;
  final ConnectivityCubit _connectivity;
  final Talker _talker;

  StreamSubscription<ConnectivityStatus>? _connectivitySub;

  Future<void> _onStarted(
    CartStarted event,
    Emitter<CartState> emit,
  ) async {
    emit(const CartLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    CartRefreshRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await _getLines();
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (lines) => emit(CartLoaded(lines)),
    );
  }

  Future<void> _load(Emitter<CartState> emit) async {
    final result = await _getLines();
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (lines) => emit(CartLoaded(lines)),
    );
  }

  Future<void> _onProductAdded(
    CartProductAdded event,
    Emitter<CartState> emit,
  ) async {
    final result = await _addOrIncrement(
      event.product,
      quantityDelta: event.quantityDelta,
    );
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (lines) {
        _talker.info('[ShopFlow][cart] added SKU ${event.product.id}');
        emit(CartLoaded(lines));
      },
    );
  }

  Future<void> _onLineRemoved(
    CartLineRemoved event,
    Emitter<CartState> emit,
  ) async {
    final result = await _removeLine(event.productId);
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (lines) => emit(CartLoaded(lines)),
    );
  }

  Future<void> _onQuantityChanged(
    CartQuantityChanged event,
    Emitter<CartState> emit,
  ) async {
    final result = await _setQuantity(event.productId, event.quantity);
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (lines) => emit(CartLoaded(lines)),
    );
  }

  Future<void> _onSyncRequested(
    CartSyncRequested event,
    Emitter<CartState> emit,
  ) async {
    await _syncCart();
  }

  Future<void> _onClearRequested(
    CartClearRequested event,
    Emitter<CartState> emit,
  ) async {
    final result = await _clearCart();
    result.fold(
      (failure) => emit(CartFailure(failure.message)),
      (_) => emit(const CartLoaded(<CartLineEntity>[])),
    );
  }

  @override
  Future<void> close() async {
    await _connectivitySub?.cancel();
    return super.close();
  }
}
