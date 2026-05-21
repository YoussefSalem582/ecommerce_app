import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Listing states for [WishlistPageBloc].
sealed class WishlistPageState extends Equatable {
  /// Shared equality baseline.
  const WishlistPageState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first successful fetch completes.
final class WishlistPageInitial extends WishlistPageState {
  /// Placeholder prior to loading transition.
  const WishlistPageInitial();
}

/// Grid shimmer / spinner visible.
final class WishlistPageLoading extends WishlistPageState {
  /// Loading indicator state.
  const WishlistPageLoading();
}

/// Favorited products ready for rendering.
final class WishlistPageLoaded extends WishlistPageState {
  /// Successful wishlist catalog emission.
  const WishlistPageLoaded({required this.products});

  /// SKU rows matching persisted wishlist ids.
  final List<ProductEntity> products;

  @override
  List<Object?> get props => <Object?>[products];
}

/// No favorited products after filtering.
final class WishlistPageEmpty extends WishlistPageState {
  /// Empty wishlist surface.
  const WishlistPageEmpty();
}

/// Recoverable failure with messaging for retry UI.
final class WishlistPageFailure extends WishlistPageState {
  /// Failure with localized / API detail text.
  const WishlistPageFailure(this.message);

  /// Human-readable failure detail.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
