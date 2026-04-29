import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/order_line_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

/// Builds immutable [OrderEntity] snapshots from live cart rows + address form.
@injectable
class CreateOrderEntityUseCase {

  /// Materializes a pending local order id + totals.
  OrderEntity call({
    required List<CartLineEntity> cartLines,
    required ShippingAddressEntity shipping,
  }) {
    final List<OrderLineEntity> lines = cartLines
        .map(
          (CartLineEntity l) => OrderLineEntity(
            productId: l.productId,
            title: l.title,
            unitPrice: l.unitPrice,
            quantity: l.quantity,
          ),
        )
        .toList();
    final double total =
        lines.fold<double>(0, (double a, OrderLineEntity l) => a + l.lineTotal);
    return OrderEntity(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      lines: lines,
      shipping: shipping,
      total: total,
    );
  }
}
