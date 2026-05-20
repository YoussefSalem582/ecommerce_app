import 'dart:convert';

import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Fake Store–shaped user payload for JSON encode/decode.
class UserModel extends UserEntity {
  /// Builds the model from REST JSON maps.
  UserModel({
    required super.id,
    required super.username,
    super.email,
    super.firstName,
    super.lastName,
  });

  /// Parses Fake Store user JSON (`GET /users/:id`, `POST /users`).
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    Map<String, dynamic>? nameMap;
    if (name is Map<String, dynamic>) {
      nameMap = name;
    }
    return UserModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      username: json['username'] as String? ?? '',
      email: json['email'] as String?,
      firstName: nameMap?['firstname'] as String?,
      lastName: nameMap?['lastname'] as String?,
    );
  }

  /// Encodes profile fields for SharedPreferences persistence.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'username': username,
        'email': email,
        'firstname': firstName,
        'lastname': lastName,
      };

  /// Restores [UserEntity] from persisted JSON string.
  static UserEntity fromStorage(String raw) {
    final map = jsonDecode(raw) as Map<String, dynamic>;
    return UserModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      username: map['username'] as String? ?? '',
      email: map['email'] as String?,
      firstName: map['firstname'] as String?,
      lastName: map['lastname'] as String?,
    );
  }

  /// Converts model into domain entity for repositories.
  UserEntity toEntity() => UserEntity(
        id: id,
        username: username,
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

  /// Builds model from domain entity for local persistence.
  factory UserModel.fromEntity(UserEntity entity) => UserModel(
        id: entity.id,
        username: entity.username,
        email: entity.email,
        firstName: entity.firstName,
        lastName: entity.lastName,
      );
}
