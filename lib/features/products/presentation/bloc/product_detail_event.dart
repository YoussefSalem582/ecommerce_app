import 'package:equatable/equatable.dart';

/// PDP events consumed by [ProductDetailBloc].
sealed class ProductDetailEvent extends Equatable {
  /// Shared equality baseline.
  const ProductDetailEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Hydrates PDP via numeric route argument.
final class ProductDetailLoadRequested extends ProductDetailEvent {
  /// Targets Fake Store primary key.
  const ProductDetailLoadRequested(this.productId);

  /// SKU identifier parsed from deep links.
  final int productId;

  @override
  List<Object?> get props => <Object?>[productId];
}
