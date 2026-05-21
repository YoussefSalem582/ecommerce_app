import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

/// Hive-backed recently viewed SKU id list (max 10, MRU order).
@lazySingleton
class LocalRecentlyViewedDatasource {
  /// Opens dedicated recently viewed bucket from DI.
  LocalRecentlyViewedDatasource(@Named('recentlyViewed') this._box);

  final Box<String> _box;

  static const String _idsKey = 'recently_viewed_ids_v1';
  static const int maxEntries = 10;

  /// Reads MRU-ordered product ids from disk.
  Future<List<int>> readIds() async {
    final raw = _box.get(_idsKey);
    if (raw == null || raw.isEmpty) {
      return <int>[];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((dynamic e) => e as int).toList();
  }

  /// Prepends [productId], dedupes, trims to [maxEntries], persists.
  Future<List<int>> recordView(int productId) async {
    final current = await readIds();
    final updated = <int>[productId, ...current.where((int id) => id != productId)];
    if (updated.length > maxEntries) {
      updated.removeRange(maxEntries, updated.length);
    }
    await _box.put(_idsKey, jsonEncode(updated));
    return updated;
  }
}
