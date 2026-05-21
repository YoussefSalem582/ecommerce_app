import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

/// Checkout interaction contract for address + payment orchestration.
sealed class CheckoutEvent extends Equatable {
  /// Shared baseline for reducers.
  const CheckoutEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Hydrates summary rows from Hive cart on route entry.
final class CheckoutStarted extends CheckoutEvent {
  /// Kickoff event when checkout route mounts.
  const CheckoutStarted();
}

/// Validates address then runs Stripe sheet (if configured) or demo payment.
final class CheckoutPaySubmitted extends CheckoutEvent {
  /// Shipping payload captured from form controllers.
  const CheckoutPaySubmitted(this.address, {this.saveAddress = false});

  /// Snapshot passed into order ledger JSON.
  final ShippingAddressEntity address;

  /// Whether to persist address to Hive address book.
  final bool saveAddress;

  @override
  List<Object?> get props => <Object?>[address, saveAddress];
}

/// Applies a validated showcase promo to checkout summary.
final class CheckoutPromoApplied extends CheckoutEvent {
  /// Confirmed promo application.
  const CheckoutPromoApplied({
    required this.code,
    required this.discountAmount,
    required this.message,
  });

  /// Uppercase promo code.
  final String code;

  /// Discount in USD.
  final double discountAmount;

  /// Localized success message.
  final String message;

  @override
  List<Object?> get props => <Object?>[code, discountAmount, message];
}

/// Reports invalid promo attempt with localized message.
final class CheckoutPromoRejected extends CheckoutEvent {
  /// Invalid promo feedback.
  const CheckoutPromoRejected(this.message);

  /// Localized error message.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Clears applied promo from checkout summary.
final class CheckoutPromoCleared extends CheckoutEvent {
  /// Removes discount state.
  const CheckoutPromoCleared();
}
