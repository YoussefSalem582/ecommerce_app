import 'dart:convert';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// JSON DTO mirroring Fake Store product payloads.
class ProductModel {
  /// Parses REST JSON into a model instance.
  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.ratingRate,
    required this.ratingCount,
  });

  /// Primary key.
  final int id;

  /// Title field.
  final String title;

  /// Price field.
  final double price;

  /// Description body.
  final String description;

  /// Category slug label.
  final String category;

  /// Remote image URL.
  final String imageUrl;

  /// Average rating.
  final double ratingRate;

  /// Rating population count.
  final int ratingCount;

  /// Parses Fake Store JSON map.
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final rating = json['rating'];
    double rate = 0;
    int count = 0;
    if (rating is Map<String, dynamic>) {
      rate = (rating['rate'] as num?)?.toDouble() ?? 0;
      count = (rating['count'] as num?)?.toInt() ?? 0;
    }
    return ProductModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] as String? ?? '',
      category: json['category'] as String? ?? '',
      imageUrl: json['image'] as String? ?? '',
      ratingRate: rate,
      ratingCount: count,
    );
  }

  /// Serializes model for Hive persistence.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'image': imageUrl,
        'rating': <String, dynamic>{
          'rate': ratingRate,
          'count': ratingCount,
        },
      };

  /// Maps into domain entity for repository contracts.
  ProductEntity toEntity() => ProductEntity(
        id: id,
        title: title,
        price: price,
        description: description,
        category: category,
        imageUrl: imageUrl,
        ratingRate: ratingRate,
        ratingCount: ratingCount,
      );

  /// Decodes catalog JSON array into models.
  static List<ProductModel> listFromJsonString(String raw) {
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map(
          (dynamic e) => ProductModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
