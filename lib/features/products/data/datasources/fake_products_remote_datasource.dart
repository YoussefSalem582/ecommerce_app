import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/features/products/data/datasources/products_remote_datasource.dart';
import 'package:shop_flow/features/products/data/models/product_model.dart';
import 'package:talker/talker.dart';

/// Offline-friendly catalog when `APP_ENV=demo` or Fake Store is unreachable.
class FakeProductsRemoteDatasource implements ProductsRemoteDatasource {
  /// Creates in-memory demo catalog.
  FakeProductsRemoteDatasource(this._talker);

  final Talker _talker;

  static List<ProductModel> get _catalog => <ProductModel>[
        ProductModel(
          id: 1,
          title: 'Fjallraven Backpack',
          price: 109.95,
          description:
              'Your perfect pack for everyday use and walks in the forest.',
          category: "men's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow1/200/200',
          ratingRate: 3.9,
          ratingCount: 120,
        ),
        ProductModel(
          id: 2,
          title: 'Slim Fit T-Shirt',
          price: 22.3,
          description: 'Premium cotton slim-fit tee for casual wear.',
          category: "men's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow2/200/200',
          ratingRate: 4.1,
          ratingCount: 259,
        ),
        ProductModel(
          id: 3,
          title: 'Mens Cotton Jacket',
          price: 55.99,
          description: 'Lightweight jacket suitable for spring and autumn.',
          category: "men's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow3/200/200',
          ratingRate: 4.7,
          ratingCount: 500,
        ),
        ProductModel(
          id: 4,
          title: 'Gold Micropave Ring',
          price: 695,
          description: 'Satisfaction guaranteed — crafted with precision.',
          category: 'jewelery',
          imageUrl: 'https://picsum.photos/seed/shopflow4/200/200',
          ratingRate: 3.9,
          ratingCount: 70,
        ),
        ProductModel(
          id: 5,
          title: 'Solid Gold Petite Ring',
          price: 168,
          description: 'Elegant petite ring for everyday elegance.',
          category: 'jewelery',
          imageUrl: 'https://picsum.photos/seed/shopflow5/200/200',
          ratingRate: 4.6,
          ratingCount: 400,
        ),
        ProductModel(
          id: 6,
          title: 'White Gold Princess Ring',
          price: 9.99,
          description: 'Classic princess-cut design in white gold finish.',
          category: 'jewelery',
          imageUrl: 'https://picsum.photos/seed/shopflow6/200/200',
          ratingRate: 3.5,
          ratingCount: 10,
        ),
        ProductModel(
          id: 7,
          title: 'WD 2TB External Drive',
          price: 64,
          description: 'USB 3.0 portable storage with fast transfer speeds.',
          category: 'electronics',
          imageUrl: 'https://picsum.photos/seed/shopflow7/200/200',
          ratingRate: 3.3,
          ratingCount: 203,
        ),
        ProductModel(
          id: 8,
          title: 'SanDisk SSD PLUS 1TB',
          price: 109,
          description: 'Boost your laptop performance with reliable SSD storage.',
          category: 'electronics',
          imageUrl: 'https://picsum.photos/seed/shopflow8/200/200',
          ratingRate: 2.9,
          ratingCount: 470,
        ),
        ProductModel(
          id: 9,
          title: 'Samsung Monitor 49"',
          price: 999.99,
          description: 'Ultra-wide curved monitor for productivity and gaming.',
          category: 'electronics',
          imageUrl: 'https://picsum.photos/seed/shopflow9/200/200',
          ratingRate: 2.2,
          ratingCount: 140,
        ),
        ProductModel(
          id: 10,
          title: 'Rain Jacket Women Plus',
          price: 56.99,
          description: 'Water-resistant shell with breathable lining.',
          category: "women's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow10/200/200',
          ratingRate: 3.8,
          ratingCount: 679,
        ),
        ProductModel(
          id: 11,
          title: "MBJ Women's Short Sleeve",
          price: 12.99,
          description: 'Lightweight short sleeve top for warm weather.',
          category: "women's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow11/200/200',
          ratingRate: 4.7,
          ratingCount: 130,
        ),
        ProductModel(
          id: 12,
          title: "Opna Women's Moisture",
          price: 7.95,
          description: 'Moisture-wicking fabric keeps you cool and dry.',
          category: "women's clothing",
          imageUrl: 'https://picsum.photos/seed/shopflow12/200/200',
          ratingRate: 4.5,
          ratingCount: 146,
        ),
      ];

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    _talker.info(
      '[ShopFlow][products][demo] catalog (${_catalog.length} SKUs)',
    );
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<ProductModel>.from(_catalog);
  }

  @override
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    final filtered = _catalog
        .where((ProductModel p) => p.category == category)
        .toList();
    _talker.info(
      '[ShopFlow][products][demo] category "$category" (${filtered.length})',
    );
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return filtered;
  }

  @override
  Future<ProductModel> fetchProductById(int id) async {
    for (final ProductModel p in _catalog) {
      if (p.id == id) {
        _talker.info('[ShopFlow][products][demo] product $id');
        return p;
      }
    }
    throw ServerException('Demo product $id not found');
  }

  @override
  Future<List<String>> fetchCategories() async {
    final categories = _catalog.map((ProductModel p) => p.category).toSet();
    final sorted = categories.toList()..sort();
    _talker.info(
      '[ShopFlow][products][demo] categories (${sorted.length})',
    );
    return sorted;
  }
}
