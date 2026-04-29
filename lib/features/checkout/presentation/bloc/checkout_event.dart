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
  const CheckoutPaySubmitted(this.address);

  /// Snapshot passed into order ledger JSON.
  final ShippingAddressEntity address;

  @override
  List<Object?> get props => <Object?>[address];
}
