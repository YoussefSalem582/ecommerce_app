import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Hive serializer for wishlisted SKU identifiers.
@lazySingleton
class LocalWishlistDatasource {
  /// Inject dedicated wishlist bucket from DI module.
  LocalWishlistDatasource(@Named('wishlist') this._box);

  final Box<String> _box;

  static const String _idsKey = 'wishlist_ids_json_v1';

  /// Reads sorted unique ids from disk.
  Future<Set<int>> readIds() async {
    final raw = _box.get(_idsKey);
    if (raw == null || raw.isEmpty) {
      return <int>{};
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((dynamic e) => e as int).toSet();
  }

  /// Writes ids back as stable JSON array ordering.
  Future<void> writeIds(Set<int> ids) async {
    final sorted = ids.toList()..sort();
    await _box.put(_idsKey, jsonEncode(sorted));
  }
}
