import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/orders/domain/entities/order_line_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

/// High-level fulfillment phase displayed in history timelines.
enum OrderStatus {
  /// Payment captured — awaiting warehouse prep.
  pending,

  /// Pick/pack stage for demo templates.
  processing,

  /// Handed to carrier (mock).
  shipped,

  /// Delivered / closed happy-path state.
  delivered,
}

/// Hive-backed customer order aggregate (Fake Store has no orders API).
class OrderEntity extends Equatable {
  /// Creates immutable purchase snapshot.
  const OrderEntity({
    required this.id,
    required this.createdAt,
    required this.status,
    required this.lines,
    required this.shipping,
    required this.total,
  });

  /// Stable string id (timestamp-based for offline demos).
  final String id;

  /// Local creation instant.
  final DateTime createdAt;

  /// Timeline stage for UI chips.
  final OrderStatus status;

  /// Line items copied from the cart at checkout.
  final List<OrderLineEntity> lines;

  /// Delivery instructions captured on checkout form.
  final ShippingAddressEntity shipping;

  /// Grand total in USD.
  final double total;

  @override
  List<Object?> get props =>
      <Object?>[id, createdAt, status, lines, shipping, total];
}
