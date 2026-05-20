import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:shop_flow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';

/// Drives catalog filters, search, and offline-aware reload cycles.
@lazySingleton
class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  /// Loads taxonomy + SKU slices via use cases only.
  ProductListBloc(
    this._getProducts,
    this._getCategories,
  ) : super(const ProductListInitial()) {
    on<ProductListStarted>(_onStarted);
    on<ProductListRefreshRequested>(_onRefresh);
    on<ProductListCategorySelected>(_onCategory);
    on<ProductListSearchSubmitted>(_onSearch);
    on<ProductListViewModeToggled>(_onViewModeToggled);
  }

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  String? _categoryFilter;
  String _searchQuery = '';
  int _loadGeneration = 0;
  ProductListViewMode _viewMode = ProductListViewMode.grid;

  Future<void> _onStarted(
    ProductListStarted event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading(++_loadGeneration));
    await _loadCatalog(emit);
  }

  Future<void> _onRefresh(
    ProductListRefreshRequested event,
    Emitter<ProductListState> emit,
  ) async {
    emit(ProductListLoading(++_loadGeneration));
    await _loadCatalog(emit);
  }

  Future<void> _onCategory(
    ProductListCategorySelected event,
    Emitter<ProductListState> emit,
  ) async {
    _categoryFilter = event.category;
    emit(ProductListLoading(++_loadGeneration));
    await _loadCatalog(emit);
  }

  Future<void> _onSearch(
    ProductListSearchSubmitted event,
    Emitter<ProductListState> emit,
  ) async {
    _searchQuery = event.query;
    emit(ProductListLoading(++_loadGeneration));
    await _loadCatalog(emit);
  }

  void _onViewModeToggled(
    ProductListViewModeToggled event,
    Emitter<ProductListState> emit,
  ) {
    _viewMode = _viewMode == ProductListViewMode.grid
        ? ProductListViewMode.list
        : ProductListViewMode.grid;
    final current = state;
    if (current is ProductListLoaded) {
      emit(
        ProductListLoaded(
          products: current.products,
          categories: current.categories,
          selectedCategory: current.selectedCategory,
          searchQuery: current.searchQuery,
          viewMode: _viewMode,
        ),
      );
    }
  }

  Future<void> _loadCatalog(Emitter<ProductListState> emit) async {
    final categoriesResult = await _getCategories.call();
    final productsResult = await _getProducts.call(
      category: _categoryFilter,
      searchQuery: _searchQuery.trim().isEmpty ? null : _searchQuery.trim(),
    );

    final categories = categoriesResult.fold(
      (failure) {
        final fromProducts = productsResult.fold(
          (Failure _) => <String>[],
          (List<ProductEntity> list) {
            final labels = list.map((ProductEntity p) => p.category).toSet();
            return labels.toList()..sort();
          },
        );
        return fromProducts;
      },
      (list) => list,
    );

    productsResult.fold(
      (failure) => emit(ProductListFailure(failure.message)),
      (products) => emit(
        ProductListLoaded(
          products: products,
          categories: categories,
          selectedCategory: _categoryFilter,
          searchQuery: _searchQuery,
          viewMode: _viewMode,
        ),
      ),
    );
  }
}
