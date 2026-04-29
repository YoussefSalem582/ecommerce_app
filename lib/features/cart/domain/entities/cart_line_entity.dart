import 'package:equatable/equatable.dart';

/// Single persisted checkout row (local-first Hive snapshot).
class CartLineEntity extends Equatable {
  /// Creates an immutable cart line.
  const CartLineEntity({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.unitPrice,
    required this.quantity,
  });

  /// Product identifier from Fake Store.
  final int productId;

  /// Title copied at add-to-cart time for offline labels.
  final String title;

  /// Cached thumbnail URL for list rendering.
  final String imageUrl;

  /// Unit price in USD when the line was added.
  final double unitPrice;

  /// Number of units in the bag.
  final int quantity;

  /// Line total (price × quantity).
  double get lineTotal => unitPrice * quantity;

  @override
  List<Object?> get props =>
      <Object?>[productId, title, imageUrl, unitPrice, quantity];
}
