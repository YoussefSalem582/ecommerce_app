import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/order_line_entity.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

/// JSON bridge for Hive `orders_cache` persistence.
class OrderModel {
  /// Parses ledger row map.
  OrderModel({
    required this.id,
    required this.createdAtMs,
    required this.statusName,
    required this.lines,
    required this.shipping,
    required this.total,
  });

  /// Hydrates from domain entity for writes.
  factory OrderModel.fromEntity(OrderEntity entity) => OrderModel(
        id: entity.id,
        createdAtMs: entity.createdAt.millisecondsSinceEpoch,
        statusName: entity.status.name,
        lines: entity.lines
            .map((OrderLineEntity e) => OrderLineModel.fromEntity(e))
            .toList(),
        shipping: ShippingAddressModel.fromEntity(entity.shipping),
        total: entity.total,
      );

  /// Parses dynamic JSON map from Hive.
  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: json['id'] as String,
        createdAtMs: (json['createdAtMs'] as num).toInt(),
        statusName: json['status'] as String,
        lines: (json['lines'] as List<dynamic>)
            .map(
              (dynamic e) =>
                  OrderLineModel.fromJson(e as Map<String, dynamic>),
            )
            .toList(),
        shipping: ShippingAddressModel.fromJson(
          json['shipping'] as Map<String, dynamic>,
        ),
        total: (json['total'] as num).toDouble(),
      );

  /// Opaque primary key.
  final String id;

  /// Epoch millis for [DateTime].
  final int createdAtMs;

  /// [OrderStatus.name] persisted token.
  final String statusName;

  /// Frozen SKU rows.
  final List<OrderLineModel> lines;

  /// Delivery payload.
  final ShippingAddressModel shipping;

  /// Grand total USD.
  final double total;

  /// Typed status enum for UI layers.
  OrderStatus get status {
    for (final OrderStatus s in OrderStatus.values) {
      if (s.name == statusName) {
        return s;
      }
    }
    return OrderStatus.pending;
  }

  /// Converts to JSON map for Hive encoding.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'createdAtMs': createdAtMs,
        'status': statusName,
        'lines': lines.map((OrderLineModel e) => e.toJson()).toList(),
        'shipping': shipping.toJson(),
        'total': total,
      };

  /// Domain projection for repositories.
  OrderEntity toEntity() => OrderEntity(
        id: id,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtMs),
        status: status,
        lines: lines.map((OrderLineModel m) => m.toEntity()).toList(),
        shipping: shipping.toEntity(),
        total: total,
      );
}

/// Serialized cart row frozen at checkout.
class OrderLineModel {
  /// Parses nested map.
  OrderLineModel({
    required this.productId,
    required this.title,
    required this.unitPrice,
    required this.quantity,
  });

  /// Copies entity fields.
  factory OrderLineModel.fromEntity(OrderLineEntity entity) => OrderLineModel(
        productId: entity.productId,
        title: entity.title,
        unitPrice: entity.unitPrice,
        quantity: entity.quantity,
      );

  /// Parses JSON map fragment.
  factory OrderLineModel.fromJson(Map<String, dynamic> json) => OrderLineModel(
        productId: (json['productId'] as num).toInt(),
        title: json['title'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
      );

  /// SKU identifier.
  final int productId;

  /// Title label.
  final String title;

  /// Unit USD amount.
  final double unitPrice;

  /// Quantity count.
  final int quantity;

  /// JSON serializer fragment.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'productId': productId,
        'title': title,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  /// Domain projection.
  OrderLineEntity toEntity() => OrderLineEntity(
        productId: productId,
        title: title,
        unitPrice: unitPrice,
        quantity: quantity,
      );
}

/// Shipping JSON companion type.
class ShippingAddressModel {
  /// Parses nested structure.
  ShippingAddressModel({
    required this.fullName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  /// Copies pure entity.
  factory ShippingAddressModel.fromEntity(ShippingAddressEntity entity) =>
      ShippingAddressModel(
        fullName: entity.fullName,
        street: entity.street,
        city: entity.city,
        postalCode: entity.postalCode,
        country: entity.country,
      );

  /// Parses JSON fragment.
  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) =>
      ShippingAddressModel(
        fullName: json['fullName'] as String,
        street: json['street'] as String,
        city: json['city'] as String,
        postalCode: json['postalCode'] as String,
        country: json['country'] as String,
      );

  /// Recipient name line.
  final String fullName;

  /// Street address line.
  final String street;

  /// City label.
  final String city;

  /// Postal code string.
  final String postalCode;

  /// Country label.
  final String country;

  /// JSON serializer fragment.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'fullName': fullName,
        'street': street,
        'city': city,
        'postalCode': postalCode,
        'country': country,
      };

  /// Pure entity projection.
  ShippingAddressEntity toEntity() => ShippingAddressEntity(
        fullName: fullName,
        street: street,
        city: city,
        postalCode: postalCode,
        country: country,
      );
}
