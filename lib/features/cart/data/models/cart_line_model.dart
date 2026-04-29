import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';

/// JSON-friendly cart row stored inside Hive `Box<String>`.
class CartLineModel {
  /// Parses from decoded JSON map.
  CartLineModel({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  /// Builds from domain entity for persistence.
  factory CartLineModel.fromEntity(CartLineEntity entity) => CartLineModel(
        productId: entity.productId,
        title: entity.title,
        imageUrl: entity.imageUrl,
        unitPrice: entity.unitPrice,
        quantity: entity.quantity,
      );

  /// Parses Fake Store–agnostic serialized payload.
  factory CartLineModel.fromJson(Map<String, dynamic> json) => CartLineModel(
        productId: (json['productId'] as num).toInt(),
        title: json['title'] as String,
        imageUrl: json['imageUrl'] as String,
        unitPrice: (json['unitPrice'] as num).toDouble(),
        quantity: (json['quantity'] as num).toInt(),
      );

  /// Stable identifier used as merge key.
  final int productId;

  /// Human-readable label cached offline.
  final String title;

  /// HTTPS image reference.
  final String imageUrl;

  /// Unit amount in USD.
  final double unitPrice;

  /// Count of units for this SKU.
  final int quantity;

  /// Converts into Hive-storable JSON map.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'productId': productId,
        'title': title,
        'imageUrl': imageUrl,
        'unitPrice': unitPrice,
        'quantity': quantity,
      };

  /// Maps into pure domain entity.
  CartLineEntity toEntity() => CartLineEntity(
        productId: productId,
        title: title,
        imageUrl: imageUrl,
        unitPrice: unitPrice,
        quantity: quantity,
      );
}
