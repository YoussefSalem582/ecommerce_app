import 'package:dio/dio.dart';

import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/core/network/dio_client.dart';
import 'package:shop_flow/core/network/dio_user_message.dart';
import 'package:shop_flow/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shop_flow/features/auth/data/models/user_model.dart';

/// REST datasource targeting Fake Store auth & users endpoints.
class RemoteAuthDatasource implements AuthRemoteDatasource {
  /// Remote datasource backed by shared [Dio] client.
  RemoteAuthDatasource(this._dioClient);

  final DioClient _dioClient;

  /// Returns JWT string from `POST /auth/login`.
  Future<String> login({
    required String username,
    required String password,
  }) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dioClient.dio.post<Map<String, dynamic>>(
        '/auth/login',
        data: <String, dynamic>{
          'username': username,
          'password': password,
        },
      );
      final token = response.data?['token'] as String?;
      if (token == null || token.isEmpty) {
        throw const ServerException('Missing token in login response');
      }
      return token;
    } on DioException catch (e, _) {
      throw _mapDio(e);
    }
  }

  /// Creates a user via `POST /users` with Fake Store schema.
  Future<UserModel> register({
    required String email,
    required String username,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final Response<Map<String, dynamic>> response =
          await _dioClient.dio.post<Map<String, dynamic>>(
        '/users',
        data: <String, dynamic>{
          'email': email,
          'username': username,
          'password': password,
          'name': <String, dynamic>{
            'firstname': firstName,
            'lastname': lastName,
          },
          'address': <String, dynamic>{
            'city': 'Placeholder',
            'street': 'Demo street',
            'number': 1,
            'zipcode': '00000',
            'geolocation': <String, dynamic>{
              'lat': '0',
              'long': '0',
            },
          },
          'phone': '000-000-0000',
        },
      );
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty register response');
      }
      return UserModel.fromJson(data);
    } on DioException catch (e, _) {
      throw _mapDio(e);
    }
  }

  ServerException _mapDio(DioException e) {
    final status = e.response?.statusCode;
    final body = e.response?.data;
    final message = body is Map<String, dynamic>
        ? body['message']?.toString()
        : e.message;
    return ServerException(
      sanitizeDioUserFacingMessage(message ?? 'HTTP ${status ?? '–'}'),
    );
  }
}
