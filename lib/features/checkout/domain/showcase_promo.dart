/// Showcase promo code definitions for checkout demo.
class ShowcasePromo {
  /// Creates promo metadata.
  const ShowcasePromo({
    required this.code,
    required this.label,
    this.percentOff,
    this.fixedOff,
    this.minSubtotal = 0,
  }) : assert(
          percentOff != null || fixedOff != null,
          'Promo must define percentOff or fixedOff',
        );

  /// Uppercase coupon code shoppers enter.
  final String code;

  /// Human-readable label for success messaging.
  final String label;

  /// Percentage discount (0–100).
  final double? percentOff;

  /// Fixed USD discount.
  final double? fixedOff;

  /// Minimum subtotal required to apply.
  final double minSubtotal;

  /// Computes discount amount capped at [subtotal].
  double discountFor(double subtotal) {
    if (subtotal < minSubtotal) {
      return 0;
    }
    if (percentOff != null) {
      return (subtotal * percentOff! / 100).clamp(0, subtotal);
    }
    return (fixedOff ?? 0).clamp(0, subtotal);
  }
}

/// Known showcase coupons — extend for consumer projects.
abstract final class ShowcasePromoCatalog {
  static const List<ShowcasePromo> all = <ShowcasePromo>[
    ShowcasePromo(
      code: 'SAVE10',
      label: '10% off',
      percentOff: 10,
    ),
    ShowcasePromo(
      code: 'WELCOME5',
      label: r'$5 off',
      fixedOff: 5,
      minSubtotal: 20,
    ),
  ];

  /// Resolves promo by case-insensitive code match.
  static ShowcasePromo? find(String rawCode) {
    final normalized = rawCode.trim().toUpperCase();
    for (final ShowcasePromo promo in all) {
      if (promo.code == normalized) {
        return promo;
      }
    }
    return null;
  }
}
