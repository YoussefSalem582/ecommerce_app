import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';

/// PDP-equivalent for persisted receipts.
sealed class OrderDetailState extends Equatable {
  /// Baseline.
  const OrderDetailState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before route hydration completes.
final class OrderDetailInitial extends OrderDetailState {
  /// Placeholder.
  const OrderDetailInitial();
}

/// Spinner during Hive read.
final class OrderDetailLoading extends OrderDetailState {
  /// Blocking indicator.
  const OrderDetailLoading();
}

/// Successfully matched ledger row.
final class OrderDetailLoaded extends OrderDetailState {
  /// Receipt aggregate for timeline UI.
  const OrderDetailLoaded(this.order);

  /// Parsed Hive projection.
  final OrderEntity order;

  @override
  List<Object?> get props => <Object?>[order];
}

/// Missing row or cache corruption messaging.
final class OrderDetailFailure extends OrderDetailState {
  /// Retry affordance copy.
  const OrderDetailFailure(this.message);

  /// Failure detail text.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
