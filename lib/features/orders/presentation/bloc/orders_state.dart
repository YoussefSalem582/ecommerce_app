import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';

/// Orders list presentation states.
sealed class OrdersState extends Equatable {
  /// Baseline props.
  const OrdersState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first successful fetch.
final class OrdersInitial extends OrdersState {
  /// Placeholder constructor.
  const OrdersInitial();
}

/// Hive IO pending.
final class OrdersLoading extends OrdersState {
  /// Spinner visible.
  const OrdersLoading();
}

/// Journal rows ready for ListView.
final class OrdersLoaded extends OrdersState {
  /// Newest-first immutable snapshot.
  const OrdersLoaded(this.orders);

  /// Persisted purchase headers.
  final List<OrderEntity> orders;

  @override
  List<Object?> get props => <Object?>[orders];
}

/// Recoverable read failure.
final class OrdersFailure extends OrdersState {
  /// Snackbar / retry surface.
  const OrdersFailure(this.message);

  /// Failure detail text.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
