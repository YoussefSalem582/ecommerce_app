import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_detail_state.dart';

/// Loads Hero PDP payloads with Hive-aware fallback.
@lazySingleton
class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  /// Hydrates PDP rows exclusively via [GetProductByIdUseCase].
  ProductDetailBloc(this._getProductById)
      : super(const ProductDetailInitial()) {
    on<ProductDetailLoadRequested>(_onLoadRequested);
  }

  final GetProductByIdUseCase _getProductById;

  Future<void> _onLoadRequested(
    ProductDetailLoadRequested event,
    Emitter<ProductDetailState> emit,
  ) async {
    emit(const ProductDetailLoading());
    final result = await _getProductById.call(event.productId);
    result.fold(
      (failure) => emit(ProductDetailFailure(failure.message)),
      (product) => emit(ProductDetailLoaded(product)),
    );
  }
}
