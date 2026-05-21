import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shop_flow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_state.dart';

/// Loads Hero PDP payloads with Hive-aware fallback.
@lazySingleton
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  /// Hydrates PDP rows exclusively via use cases.
  ProductDetailBloc(this._getProductById, this._getProducts)
      : super(const ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onLoadRequested);
  }

  final GetProductByIdUseCase _getProductById;
  final GetProductsUseCase _getProducts;

  Future<void> _onLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());
    final result = await _getProductById.call(event.productId);
    await result.fold(
      (failure) async => emit(ProductDetailFailure(failure.message)),
      (product) async {
        final relatedResult = await _getProducts.call(category: product.category);
        final related = relatedResult.fold(
          (_) => <ProductEntity>[],
          (List<ProductEntity> list) {
            final filtered = list
                .where((ProductEntity p) => p.id != product.id)
                .toList()
              ..sort(
                (ProductEntity a, ProductEntity b) =>
                    b.ratingRate.compareTo(a.ratingRate),
              );
            return filtered;
          },
        );
        final topRelated = related.take(4).toList();
        emit(ProductDetailLoaded(product: product, relatedProducts: topRelated));
      },
    );
  }
}
