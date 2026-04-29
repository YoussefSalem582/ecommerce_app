import 'package:equatable/equatable.dart';

/// Orders journal events for authenticated history tab.
sealed class OrdersEvent extends Equatable {
  /// Shared equality baseline.
  const OrdersEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Loads Hive ledger on tab entry / pull refresh.
final class OrdersStarted extends OrdersEvent {
  /// Bootstrap fetch.
  const OrdersStarted();
}

/// Silent reload preserving scroll offset optional MVP skip full reload.
final class OrdersRefreshRequested extends OrdersEvent {
  /// Pull-to-refresh hook.
  const OrdersRefreshRequested();
}
