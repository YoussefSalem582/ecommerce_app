import 'package:equatable/equatable.dart';

/// Immutable shipping snapshot persisted with each [OrderEntity].
class ShippingAddressEntity extends Equatable {
  /// Creates checkout delivery payload.
  const ShippingAddressEntity({
    required this.fullName,
    required this.street,
    required this.city,
    required this.postalCode,
    required this.country,
  });

  /// Recipient display name.
  final String fullName;

  /// Street + number line.
  final String street;

  /// City / region label.
  final String city;

  /// Postal or ZIP code.
  final String postalCode;

  /// ISO country name as entered by shopper.
  final String country;

  @override
  List<Object?> get props =>
      <Object?>[fullName, street, city, postalCode, country];
}
