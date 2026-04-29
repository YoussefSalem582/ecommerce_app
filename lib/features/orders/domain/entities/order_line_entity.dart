import 'package:equatable/equatable.dart';

/// Single SKU snapshot frozen at purchase time (offline history).
class OrderLineEntity extends Equatable {
  /// Creates immutable order row.
  const OrderLineEntity({
    required this.productId,
    required this.title,
    required this.unitPrice,
    required this.quantity,
  });

  /// Catalog identifier at checkout.
  final int productId;

  /// Human-readable label.
  final String title;

  /// Locked USD unit amount.
  final double unitPrice;

  /// Purchased quantity.
  final int quantity;

  /// Row total (unit × qty).
  double get lineTotal => unitPrice * quantity;

  @override
  List<Object?> get props =>
      <Object?>[productId, title, unitPrice, quantity];
}
