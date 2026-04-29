import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// PDP states emitted by [ProductDetailBloc].
sealed class ProductDetailState extends Equatable {
  /// Shared equality baseline.
  const ProductDetailState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Awaiting first emission for routed SKU.
final class ProductDetailInitial extends ProductDetailState {
  /// Placeholder before loading begins.
  const ProductDetailInitial();
}

/// PDP spinner / shimmer replacement.
final class ProductDetailLoading extends ProductDetailState {
  /// Loading indicator state.
  const ProductDetailLoading();
}

/// PDP presentation model ready.
final class ProductDetailLoaded extends ProductDetailState {
  /// Successful PDP emission.
  const ProductDetailLoaded(this.product);

  /// Hydrated catalog entity.
  final ProductEntity product;

  @override
  List<Object?> get props => <Object?>[product];
}

/// Recoverable PDP failure (network + empty cache).
final class ProductDetailFailure extends ProductDetailState {
  /// Failure detail for UI messaging.
  const ProductDetailFailure(this.message);

  /// Failure description text.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
