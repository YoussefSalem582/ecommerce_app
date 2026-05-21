import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';

/// Hive JSON store for saved shipping addresses.
@lazySingleton
class LocalAddressesDatasource {
  /// Opens addresses bucket from DI.
  LocalAddressesDatasource(@Named('addresses') this._box);

  final Box<String> _box;

  static const String _listKey = 'saved_addresses_v1';

  /// Reads all saved addresses.
  Future<List<SavedAddressEntity>> readAll() async {
    final raw = _box.get(_listKey);
    if (raw == null || raw.isEmpty) {
      return <SavedAddressEntity>[];
    }
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (dynamic e) =>
              SavedAddressEntity.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  /// Persists full address list.
  Future<void> writeAll(List<SavedAddressEntity> addresses) async {
    final encoded = jsonEncode(addresses.map((SavedAddressEntity a) => a.toJson()).toList());
    await _box.put(_listKey, encoded);
  }
}
