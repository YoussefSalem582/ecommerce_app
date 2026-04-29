import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';

/// Immutable cart presentation states for badges + cart screen.
sealed class CartState extends Equatable {
  /// Shared props baseline.
  const CartState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first successful Hive read completes.
final class CartInitial extends CartState {
  /// Placeholder prior to loading transitions.
  const CartInitial();
}

/// Full-screen shimmer / awaiting persistence IO.
final class CartLoading extends CartState {
  /// Spinner visible while touching Hive.
  const CartLoading();
}

/// Successful Hive hydration with badge totals.
final class CartLoaded extends CartState {
  /// Rows sorted by insertion order as persisted.
  const CartLoaded(this.lines);

  /// Persisted SKU snapshots with quantities.
  final List<CartLineEntity> lines;

  /// Sum of all quantities for badge animations.
  int get totalQuantity =>
      lines.fold<int>(0, (int acc, CartLineEntity l) => acc + l.quantity);

  /// Pre-tax subtotal for checkout summaries.
  double get subtotal =>
      lines.fold<double>(0, (double acc, CartLineEntity l) => acc + l.lineTotal);

  @override
  List<Object?> get props => <Object?>[lines];
}

/// Recoverable persistence failure with localized messaging.
final class CartFailure extends CartState {
  /// Failure surface for snackbars / retry buttons.
  const CartFailure(this.message);

  /// Either repository copy or generic fallback text.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
