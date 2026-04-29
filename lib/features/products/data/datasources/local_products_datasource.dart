import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/products/data/models/product_model.dart';

/// Persists last successful full-catalog fetch as JSON in Hive.
@lazySingleton
class LocalProductsDatasource {
  /// Hive box holding serialized catalog snapshots.
  LocalProductsDatasource(@Named('productsCache') this._box);

  final Box<String> _box;

  static const String _catalogKey = 'catalog_json_v1';

  /// Writes raw catalog JSON array string.
  Future<void> saveCatalogJson(String json) async {
    await _box.put(_catalogKey, json);
  }

  /// Reads catalog JSON if previously hydrated.
  String? readCatalogJson() => _box.get(_catalogKey);

  /// Parses cached catalog models when offline.
  List<ProductModel> readCachedProducts() {
    final raw = readCatalogJson();
    if (raw == null || raw.isEmpty) {
      return <ProductModel>[];
    }
    try {
      return ProductModel.listFromJsonString(raw);
    } on Object {
      return <ProductModel>[];
    }
  }
}
