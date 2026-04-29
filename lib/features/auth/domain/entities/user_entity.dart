import 'package:equatable/equatable.dart';

/// Signed-in customer snapshot shared across presentation & domain layers.
class UserEntity extends Equatable {
  /// Creates a lightweight profile entity.
  const UserEntity({
    required this.id,
    required this.username,
    this.email,
    this.firstName,
    this.lastName,
  });

  /// Fake Store numeric identifier (or `0` when unknown until sync).
  final int id;

  /// Unique username credential / handle.
  final String username;

  /// Email address when known.
  final String? email;

  /// Given name fragment from Fake Store profile payload.
  final String? firstName;

  /// Family name fragment from Fake Store profile payload.
  final String? lastName;

  @override
  List<Object?> get props => <Object?>[
        id,
        username,
        email,
        firstName,
        lastName,
      ];
}
