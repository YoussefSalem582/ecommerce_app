import 'package:dio/dio.dart';

import 'package:shop_flow/core/error/exceptions.dart';
import 'package:shop_flow/core/network/dio_client.dart';
import 'package:shop_flow/core/network/dio_user_message.dart';
import 'package:shop_flow/features/products/data/datasources/products_remote_datasource.dart';
import 'package:shop_flow/features/products/data/models/product_model.dart';

/// Fake Store catalog REST datasource (`/products`, `/products/categories`).
class RemoteProductsDatasource implements ProductsRemoteDatasource {
  /// REST client backed by shared [Dio] configuration.
  RemoteProductsDatasource(this._dioClient);

  final DioClient _dioClient;

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final response = await _dioClient.dio.get<List<dynamic>>('/products');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty products payload');
      }
      return data
          .map((dynamic e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  @override
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    try {
      final encoded = Uri.encodeComponent(category);
      final response = await _dioClient.dio
          .get<List<dynamic>>('/products/category/$encoded');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty category payload');
      }
      return data
          .map((dynamic e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  @override
  Future<ProductModel> fetchProductById(int id) async {
    try {
      final response =
          await _dioClient.dio.get<Map<String, dynamic>>('/products/$id');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty product payload');
      }
      return ProductModel.fromJson(data);
    } on DioException catch (e) {
      throw _mapDio(e);
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final response =
          await _dioClient.dio.get<List<dynamic>>('/products/categories');
      final data = response.data;
      if (data == null) {
        throw const ServerException('Empty categories payload');
      }
      return data.map((dynamic e) => e.toString()).toList();
    } on DioException catch (e) {
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
