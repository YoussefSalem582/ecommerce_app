import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/products/data/datasources/local_recently_viewed_datasource.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/usecases/get_product_by_id_usecase.dart';
import 'package:shop_flow/features/products/presentation/cubit/recently_viewed_state.dart';

/// Tracks MRU product ids and hydrates lightweight catalog rows for home strip.
@lazySingleton
class RecentlyViewedCubit extends Cubit<RecentlyViewedState> {
  /// Loads persisted ids on construction.
  RecentlyViewedCubit(this._local, this._getProductById)
      : super(const RecentlyViewedInitial()) {
    Future<void>.microtask(load);
  }

  final LocalRecentlyViewedDatasource _local;
  final GetProductByIdUseCase _getProductById;

  /// Reads Hive ids and resolves product entities for UI.
  Future<void> load() async {
    emit(const RecentlyViewedLoading());
    final ids = await _local.readIds();
    final products = await _resolveProducts(ids);
    emit(RecentlyViewedReady(products));
  }

  /// Records a PDP visit and refreshes the home strip.
  Future<void> recordView(int productId) async {
    await _local.recordView(productId);
    await load();
  }

  Future<List<ProductEntity>> _resolveProducts(List<int> ids) async {
    final List<ProductEntity> products = <ProductEntity>[];
    for (final int id in ids) {
      final result = await _getProductById.call(id);
      result.fold(
        (_) {},
        (ProductEntity p) => products.add(p),
      );
    }
    return products;
  }
}
