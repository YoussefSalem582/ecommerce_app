import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/products/domain/entities/product_entity.dart';
import 'package:shop_flow/features/products/domain/usecases/get_categories_usecase.dart';
import 'package:shop_flow/features/products/domain/usecases/get_products_usecase.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_event.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_state.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_list_view_mode.dart';
import 'package:shop_flow/features/products/presentation/bloc/product_sort_option.dart';

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
    on<ProductListSortChanged>(_onSortChanged);
    on<ProductListPriceRangeChanged>(_onPriceRangeChanged);
    on<ProductListMinRatingChanged>(_onMinRatingChanged);
    on<ProductListFiltersCleared>(_onFiltersCleared);
  }

  final GetProductsUseCase _getProducts;
  final GetCategoriesUseCase _getCategories;

  String? _categoryFilter;
  String _searchQuery = '';
  int _loadGeneration = 0;
  ProductListViewMode _viewMode = ProductListViewMode.grid;
  ProductSortOption _sortOption = ProductSortOption.ratingDesc;
  double? _minPrice;
  double? _maxPrice;
  double _minRating = 0;
  List<ProductEntity> _rawProducts = <ProductEntity>[];
  List<String> _categories = <String>[];
  double _catalogMinPrice = 0;
  double _catalogMaxPrice = 0;

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
    _emitLoaded(emit);
  }

  void _onSortChanged(
    ProductListSortChanged event,
    Emitter<ProductListState> emit,
  ) {
    _sortOption = event.sortOption;
    _emitLoaded(emit);
  }

  void _onPriceRangeChanged(
    ProductListPriceRangeChanged event,
    Emitter<ProductListState> emit,
  ) {
    _minPrice = event.minPrice;
    _maxPrice = event.maxPrice;
    _emitLoaded(emit);
  }

  void _onMinRatingChanged(
    ProductListMinRatingChanged event,
    Emitter<ProductListState> emit,
  ) {
    _minRating = event.minRating;
    _emitLoaded(emit);
  }

  void _onFiltersCleared(
    ProductListFiltersCleared event,
    Emitter<ProductListState> emit,
  ) {
    _minPrice = null;
    _maxPrice = null;
    _minRating = 0;
    _emitLoaded(emit);
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
      (products) {
        _rawProducts = products;
        _categories = categories;
        if (products.isNotEmpty) {
          _catalogMinPrice =
              products.map((ProductEntity p) => p.price).reduce(
                    (double a, double b) => a < b ? a : b,
                  );
          _catalogMaxPrice =
              products.map((ProductEntity p) => p.price).reduce(
                    (double a, double b) => a > b ? a : b,
                  );
        } else {
          _catalogMinPrice = 0;
          _catalogMaxPrice = 0;
        }
        _emitLoaded(emit);
      },
    );
  }

  void _emitLoaded(Emitter<ProductListState> emit) {
    if (_rawProducts.isEmpty && state is! ProductListFailure) {
      emit(
        ProductListLoaded(
          products: <ProductEntity>[],
          categories: _categories,
          selectedCategory: _categoryFilter,
          searchQuery: _searchQuery,
          viewMode: _viewMode,
          sortOption: _sortOption,
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          minRating: _minRating,
          catalogMinPrice: _catalogMinPrice,
          catalogMaxPrice: _catalogMaxPrice,
        ),
      );
      return;
    }

    final filtered = _applySortAndFilter(_rawProducts);
    emit(
      ProductListLoaded(
        products: filtered,
        categories: _categories,
        selectedCategory: _categoryFilter,
        searchQuery: _searchQuery,
        viewMode: _viewMode,
        sortOption: _sortOption,
        minPrice: _minPrice,
        maxPrice: _maxPrice,
        minRating: _minRating,
        catalogMinPrice: _catalogMinPrice,
        catalogMaxPrice: _catalogMaxPrice,
      ),
    );
  }

  List<ProductEntity> _applySortAndFilter(List<ProductEntity> products) {
    final double effectiveMin = _minPrice ?? _catalogMinPrice;
    final double effectiveMax = _maxPrice ?? _catalogMaxPrice;

    var result = products.where((ProductEntity p) {
      if (p.price < effectiveMin || p.price > effectiveMax) {
        return false;
      }
      if (_minRating > 0 && p.ratingRate < _minRating) {
        return false;
      }
      return true;
    }).toList();

    switch (_sortOption) {
      case ProductSortOption.priceAsc:
        result.sort((ProductEntity a, ProductEntity b) =>
            a.price.compareTo(b.price));
      case ProductSortOption.priceDesc:
        result.sort((ProductEntity a, ProductEntity b) =>
            b.price.compareTo(a.price));
      case ProductSortOption.ratingDesc:
        result.sort((ProductEntity a, ProductEntity b) =>
            b.ratingRate.compareTo(a.ratingRate));
      case ProductSortOption.titleAsc:
        result.sort(
          (ProductEntity a, ProductEntity b) =>
              a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }

    return result;
  }
}
