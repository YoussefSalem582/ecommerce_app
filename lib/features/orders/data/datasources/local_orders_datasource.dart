import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/orders/data/models/order_model.dart';

/// Hive-backed order ledger (`orders_cache` box).
@lazySingleton
class LocalOrdersDatasource {
  /// Injects typed JSON bucket from DI module.
  LocalOrdersDatasource(@Named('ordersCache') this._box);

  final Box<String> _box;

  static const String _ordersKey = 'orders_json_v1';

  /// Reads full ledger (newest first).
  Future<List<OrderModel>> readAll() async {
    final raw = _box.get(_ordersKey);
    if (raw == null || raw.isEmpty) {
      return <OrderModel>[];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    final list = decoded
        .map(
          (dynamic e) => OrderModel.fromJson(e as Map<String, dynamic>),
        )
        .toList()
      ..sort((OrderModel a, OrderModel b) =>
          b.createdAtMs.compareTo(a.createdAtMs));
    return list;
  }

  /// Prepends [order] while preserving descending chronology.
  Future<void> prepend(OrderModel order) async {
    final current = await readAll();
    final next = <OrderModel>[order, ...current];
    await writeAll(next);
  }

  /// Writes entire ledger snapshot.
  Future<void> writeAll(List<OrderModel> orders) async {
    final encoded =
        jsonEncode(orders.map((OrderModel e) => e.toJson()).toList());
    await _box.put(_ordersKey, encoded);
  }
}
