import 'package:equatable/equatable.dart';

/// Events for the dedicated wishlist catalog page.
sealed class WishlistPageEvent extends Equatable {
  /// Shared equality baseline.
  const WishlistPageEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Initial hydration of favorited SKU rows.
final class WishlistPageStarted extends WishlistPageEvent {
  /// Triggers first load.
  const WishlistPageStarted();
}

/// Pull-to-refresh or cubit-driven reload.
final class WishlistPageRefreshRequested extends WishlistPageEvent {
  /// Re-fetches ids + catalog slice.
  const WishlistPageRefreshRequested();
}
