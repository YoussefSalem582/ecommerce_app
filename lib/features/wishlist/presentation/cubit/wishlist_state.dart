import 'package:equatable/equatable.dart';

/// Wishlist cubit states backing heart toggles on grids + PDP.
sealed class WishlistState extends Equatable {
  /// Equality baseline for Cubit transitions.
  const WishlistState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Prior to first Hive read.
final class WishlistInitial extends WishlistState {
  /// Default constructor before hydration.
  const WishlistInitial();
}

/// Loading spinner while parsing JSON ids.
final class WishlistLoading extends WishlistState {
  /// Placeholder while awaiting IO.
  const WishlistLoading();
}

/// Successfully hydrated SKU identifier bucket.
final class WishlistReady extends WishlistState {
  /// Sorted unique ids for deterministic equality.
  WishlistReady(Set<int> ids) : sortedIds = List<int>.from(ids)..sort();

  /// Stable ordering for `Equatable` + binary-friendly compares.
  final List<int> sortedIds;

  /// Fast membership helper for hearts.
  bool contains(int productId) => sortedIds.contains(productId);

  @override
  List<Object?> get props => <Object?>[sortedIds];
}

/// Recoverable Hive failures when toggling favorites.
final class WishlistFailure extends WishlistState {
  /// User-visible retry messaging source.
  const WishlistFailure(this.message);

  /// Failure detail propagated from repositories.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
