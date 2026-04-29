import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/orders/domain/usecases/get_orders_usecase.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_event.dart';
import 'package:shop_flow/features/orders/presentation/bloc/orders_state.dart';

/// Offline-first orders journal for Phase 5 portfolio reviewers.
@lazySingleton
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  /// Hydrates ledger via use case only.
  OrdersBloc(this._getOrders) : super(const OrdersInitial()) {
    on<OrdersStarted>(_onStarted);
    on<OrdersRefreshRequested>(_onRefresh);
  }

  final GetOrdersUseCase _getOrders;

  Future<void> _onStarted(
    OrdersStarted event,
    Emitter<OrdersState> emit,
  ) async {
    emit(const OrdersLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    OrdersRefreshRequested event,
    Emitter<OrdersState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<OrdersState> emit) async {
    final result = await _getOrders();
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (orders) => emit(OrdersLoaded(orders)),
    );
  }
}
