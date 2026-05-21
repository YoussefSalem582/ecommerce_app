import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';

/// Checkout presentation states for summary + payment milestones.
sealed class CheckoutState extends Equatable {
  /// Equality baseline.
  const CheckoutState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Route entered before first cart read resolves.
final class CheckoutInitial extends CheckoutState {
  /// Spinner placeholder.
  const CheckoutInitial();
}

/// Pulling cart snapshot from Hive via use case.
final class CheckoutLoading extends CheckoutState {
  /// Full-screen blocking indicator.
  const CheckoutLoading();
}

/// Address form + pay CTA enabled with live totals.
final class CheckoutReady extends CheckoutState {
  /// Successful cart hydration for summary cards.
  const CheckoutReady({
    required this.lines,
    required this.subtotal,
    required this.stripeEnabled,
    this.submitting = false,
    this.lastError,
    this.promoCode,
    this.discountAmount = 0,
    this.promoMessage,
  });

  /// Rows mirrored from [CartLineEntity] cache.
  final List<CartLineEntity> lines;

  /// Sum of line totals in USD.
  final double subtotal;

  /// Whether Stripe Payment Sheet will run before persisting the order.
  final bool stripeEnabled;

  /// Locks form while Stripe / Hive writes run.
  final bool submitting;

  /// Surface sheet / persistence failures without losing cart snapshot.
  final String? lastError;

  /// Applied showcase promo code (uppercase) or null.
  final String? promoCode;

  /// Discount subtracted from [subtotal].
  final double discountAmount;

  /// Success or validation message for promo field.
  final String? promoMessage;

  /// Total after discount.
  double get totalAfterDiscount =>
      (subtotal - discountAmount).clamp(0, double.infinity);

  /// Returns a modified copy for reducer transitions.
  CheckoutReady copyWith({
    List<CartLineEntity>? lines,
    double? subtotal,
    bool? stripeEnabled,
    bool? submitting,
    String? lastError,
    bool clearError = false,
    String? promoCode,
    bool clearPromoCode = false,
    double? discountAmount,
    String? promoMessage,
    bool clearPromoMessage = false,
  }) {
    return CheckoutReady(
      lines: lines ?? this.lines,
      subtotal: subtotal ?? this.subtotal,
      stripeEnabled: stripeEnabled ?? this.stripeEnabled,
      submitting: submitting ?? this.submitting,
      lastError: clearError ? null : (lastError ?? this.lastError),
      promoCode: clearPromoCode ? null : (promoCode ?? this.promoCode),
      discountAmount: discountAmount ?? this.discountAmount,
      promoMessage:
          clearPromoMessage ? null : (promoMessage ?? this.promoMessage),
    );
  }

  @override
  List<Object?> get props => <Object?>[
        lines,
        subtotal,
        stripeEnabled,
        submitting,
        lastError,
        promoCode,
        discountAmount,
        promoMessage,
      ];
}

/// Order persisted + cart cleared — navigate to success route.
final class CheckoutSuccess extends CheckoutState {
  /// Ledger id for thank-you deep link.
  const CheckoutSuccess(this.orderId);

  /// Hive order primary key string.
  final String orderId;

  @override
  List<Object?> get props => <Object?>[orderId];
}

/// Recoverable bootstrap failure (cannot read cart lines).
final class CheckoutFailure extends CheckoutState {
  /// Human-readable retry messaging.
  const CheckoutFailure(this.message);

  /// Failure copy for snackbars.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Cart snapshot empty — route should pop back to bag screen.
final class CheckoutCartEmpty extends CheckoutState {
  /// Signals router/UI to return shopper to catalog replenishment.
  const CheckoutCartEmpty();
}
