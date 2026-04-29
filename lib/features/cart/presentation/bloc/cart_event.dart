import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Mutations requested by cart surfaces (sheet, PDP, connectivity hooks).
sealed class CartEvent extends Equatable {
  /// Shared equality baseline for reducer routing.
  const CartEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Hydrates Hive snapshot on screen entry.
final class CartStarted extends CartEvent {
  /// Bootstrap load event.
  const CartStarted();
}

/// Silent reload after returning from checkout placeholders.
final class CartRefreshRequested extends CartEvent {
  /// Pull-to-refresh hook on cart list.
  const CartRefreshRequested();
}

/// Adds SKU payload from catalog context menus.
final class CartProductAdded extends CartEvent {
  /// Captures catalog snapshot at tap time.
  const CartProductAdded(this.product, {this.quantityDelta = 1});

  /// Source catalog entity with pricing metadata.
  final ProductEntity product;

  /// Increment amount when bulk adding future bundles.
  final int quantityDelta;

  @override
  List<Object?> get props => <Object?>[product, quantityDelta];
}

/// Deletes one persisted row after swipe dismissal.
final class CartLineRemoved extends CartEvent {
  /// Targets SKU primary key.
  const CartLineRemoved(this.productId);

  /// Fake Store–compatible identifier.
  final int productId;

  @override
  List<Object?> get props => <Object?>[productId];
}

/// Updates numeric stepper selections on cart rows.
final class CartQuantityChanged extends CartEvent {
  /// Applies merged quantity from UI controls.
  const CartQuantityChanged(this.productId, this.quantity);

  /// SKU identifier for Hive merge logic.
  final int productId;

  /// Absolute quantity post-stepper adjustment.
  final int quantity;

  @override
  List<Object?> get props => <Object?>[productId, quantity];
}

/// Fired when connectivity returns online — logs sync placeholder.
final class CartSyncRequested extends CartEvent {
  /// Connectivity-driven hook.
  const CartSyncRequested();
}

/// Clears every Hive row after checkout confirmation.
final class CartClearRequested extends CartEvent {
  /// Post-payment housekeeping.
  const CartClearRequested();
}
