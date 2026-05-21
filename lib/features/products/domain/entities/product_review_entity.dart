import 'package:equatable/equatable.dart';

/// Deterministic mock review row for PDP showcase section.
class ProductReviewEntity extends Equatable {
  /// Creates immutable review snapshot.
  const ProductReviewEntity({
    required this.author,
    required this.rating,
    required this.body,
    required this.date,
  });

  /// Display name for reviewer.
  final String author;

  /// Star rating 1–5.
  final double rating;

  /// Review body copy.
  final String body;

  /// Relative review date label.
  final String date;

  @override
  List<Object?> get props => <Object?>[author, rating, body, date];
}

/// Generates stable mock reviews from product id + aggregate rating.
abstract final class MockReviewGenerator {
  static const List<String> _authors = <String>[
    'Alex M.',
    'Samira K.',
    'Jordan P.',
    'Casey L.',
    'Riley T.',
  ];

  static const List<String> _bodies = <String>[
    'Great quality for the price. Would buy again.',
    'Exactly as described. Fast delivery in demo mode.',
    'Solid build and comfortable to use daily.',
    'Good value showcase product — happy with purchase.',
    'Nice design. Works well for everyday use.',
  ];

  /// Returns 2–4 mock reviews seeded by [productId].
  static List<ProductReviewEntity> forProduct({
    required int productId,
    required double ratingRate,
  }) {
    final count = 2 + (productId % 3);
    return List<ProductReviewEntity>.generate(count, (int index) {
      final seed = productId + index * 7;
      final author = _authors[seed % _authors.length];
      final body = _bodies[(seed + 2) % _bodies.length];
      final rating = (ratingRate + (index - 1) * 0.3).clamp(1.0, 5.0);
      final daysAgo = 3 + (seed % 28);
      return ProductReviewEntity(
        author: author,
        rating: rating,
        body: body,
        date: '${daysAgo}d ago',
      );
    });
  }
}
