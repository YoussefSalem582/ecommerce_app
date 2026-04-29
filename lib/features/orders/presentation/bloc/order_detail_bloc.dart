import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/orders/domain/usecases/get_order_by_id_usecase.dart';
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_event.dart';
import 'package:shop_flow/features/orders/presentation/bloc/order_detail_state.dart';

/// Route-scoped receipt viewer — register as factory via `@injectable`.
@injectable
class OrderDetailBloc extends Bloc<OrderDetailEvent, OrderDetailState> {
  /// Hydrates one Hive snapshot by opaque id.
  OrderDetailBloc(this._getById) : super(const OrderDetailInitial()) {
    on<OrderDetailLoadRequested>(_onLoad);
  }

  final GetOrderByIdUseCase _getById;

  Future<void> _onLoad(
    OrderDetailLoadRequested event,
    Emitter<OrderDetailState> emit,
  ) async {
    emit(const OrderDetailLoading());
    final result = await _getById(event.orderId);
    result.fold(
      (failure) => emit(OrderDetailFailure(failure.message)),
      (order) {
        if (order == null) {
          emit(const OrderDetailFailure('Order not found'));
        } else {
          emit(OrderDetailLoaded(order));
        }
      },
    );
  }
}
