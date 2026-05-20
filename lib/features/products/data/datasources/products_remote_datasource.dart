import 'package:shop_flow/features/products/data/models/product_model.dart';

/// Remote catalog contract (Fake Store HTTP or offline demo catalog).
abstract class ProductsRemoteDatasource {
  /// Returns all products.
  Future<List<ProductModel>> fetchAllProducts();

  /// Returns products filtered by category label.
  Future<List<ProductModel>> fetchProductsByCategory(String category);

  /// Returns a single product by id.
  Future<ProductModel> fetchProductById(int id);

  /// Returns distinct category labels.
  Future<List<String>> fetchCategories();
}
