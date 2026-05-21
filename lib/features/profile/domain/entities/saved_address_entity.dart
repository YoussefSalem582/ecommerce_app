import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

/// Persisted shipping address with stable local id.
class SavedAddressEntity extends Equatable {
  /// Creates saved address row.
  const SavedAddressEntity({
    required this.id,
    required this.fullName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
    this.isDefault = false,
  });

  /// Local uuid string.
  final String id;

  /// Recipient display name.
  final String fullName;

  /// Street + number line.
  final String street;

  /// City / region label.
  final String city;

  /// Postal or ZIP code.
  final String postalCode;

  /// Country name as entered.
  final String country;

  /// Whether this row is the default checkout selection.
  final bool isDefault;

  /// Maps to checkout shipping snapshot.
  ShippingAddressEntity toShipping() {
    return ShippingAddressEntity(
      fullName: fullName,
      street: street,
      city: city,
      postalCode: postalCode,
      country: country,
    );
  }

  SavedAddressEntity copyWith({
    String? id,
    String? fullName,
    String? street,
    String? city,
    String? postalCode,
    String? country,
    bool? isDefault,
  }) {
    return SavedAddressEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      street: street ?? this.street,
      city: city ?? this.city,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'street': street,
      'city': city,
      'postalCode': postalCode,
      'country': country,
      'isDefault': isDefault,
    };
  }

  factory SavedAddressEntity.fromJson(Map<String, dynamic> json) {
    return SavedAddressEntity(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      street: json['street'] as String,
      city: json['city'] as String,
      postalCode: json['postalCode'] as String,
      country: json['country'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props =>
      <Object?>[id, fullName, street, city, postalCode, country, isDefault];
}
