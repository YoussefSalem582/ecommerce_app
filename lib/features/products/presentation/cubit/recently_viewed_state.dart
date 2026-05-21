import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/products/domain/entities/product_entity.dart';

/// Recently viewed strip states for home catalog.
sealed class RecentlyViewedState extends Equatable {
  /// Shared equality baseline.
  const RecentlyViewedState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first Hive read completes.
final class RecentlyViewedInitial extends RecentlyViewedState {
  /// Placeholder prior to hydration.
  const RecentlyViewedInitial();
}

/// Resolving product rows for stored ids.
final class RecentlyViewedLoading extends RecentlyViewedState {
  /// Spinner state while fetching PDP rows.
  const RecentlyViewedLoading();
}

/// MRU products ready for horizontal list rendering.
final class RecentlyViewedReady extends RecentlyViewedState {
  /// Hydrated catalog rows in MRU order.
  const RecentlyViewedReady(this.products);

  /// Resolved product entities (may be shorter than stored ids).
  final List<ProductEntity> products;

  @override
  List<Object?> get props => <Object?>[products];
}
