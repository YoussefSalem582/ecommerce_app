import 'package:equatable/equatable.dart';

/// Single-order drill-down events.
sealed class OrderDetailEvent extends Equatable {
  /// Baseline.
  const OrderDetailEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Requests Hive lookup by opaque id string.
final class OrderDetailLoadRequested extends OrderDetailEvent {
  /// Ledger primary key from GoRouter param.
  const OrderDetailLoadRequested(this.orderId);

  /// Hive JSON id segment.
  final String orderId;

  @override
  List<Object?> get props => <Object?>[orderId];
}
