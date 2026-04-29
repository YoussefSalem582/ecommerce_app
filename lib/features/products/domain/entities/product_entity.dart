import 'package:equatable/equatable.dart';

/// Catalog item surfaced from Fake Store–compatible APIs.
class ProductEntity extends Equatable {
  /// Creates an immutable product snapshot.
  const ProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.imageUrl,
    required this.ratingRate,
    required this.ratingCount,
  });

  /// Stable identifier used for PDP routing and caching.
  final int id;

  /// Short catalog title.
  final String title;

  /// Unit price in USD (Fake Store convention).
  final double price;

  /// Long marketing copy / specs text.
  final String description;

  /// Taxonomy bucket label from the remote API.
  final String category;

  /// HTTPS image URL for grid / gallery tiles.
  final String imageUrl;

  /// Aggregate star rating average.
  final double ratingRate;

  /// Number of ratings contributing to [ratingRate].
  final int ratingCount;

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        price,
        description,
        category,
        imageUrl,
        ratingRate,
        ratingCount,
      ];
}
