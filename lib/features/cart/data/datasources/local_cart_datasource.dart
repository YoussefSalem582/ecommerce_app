import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/cart/data/models/cart_line_model.dart';

/// Hive-backed serializer for cart rows (`cart_items` box).
@lazySingleton
class LocalCartDatasource {
  /// Opens named cart storage bucket injected via DI.
  LocalCartDatasource(@Named('cartItems') this._box);

  /// Hive box storing JSON payloads keyed below.
  final Box<String> _box;

  static const String _linesKey = 'cart_lines_json_v1';

  /// Reads persisted rows (empty when unset).
  Future<List<CartLineModel>> readLines() async {
    final raw = _box.get(_linesKey);
    if (raw == null || raw.isEmpty) {
      return <CartLineModel>[];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (dynamic e) => CartLineModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  /// Persists the entire cart snapshot atomically.
  Future<void> writeLines(List<CartLineModel> lines) async {
    final encoded =
        jsonEncode(lines.map((CartLineModel e) => e.toJson()).toList());
    await _box.put(_linesKey, encoded);
  }
}
