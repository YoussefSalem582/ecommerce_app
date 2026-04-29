import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/usecases/clear_cart_usecase.dart';
import 'package:shop_flow/features/cart/domain/usecases/get_cart_lines_usecase.dart';
import 'package:shop_flow/features/checkout/domain/checkout_payment_gateway.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:shop_flow/features/orders/domain/entities/order_entity.dart';
import 'package:shop_flow/features/orders/domain/usecases/create_order_entity_usecase.dart';
import 'package:shop_flow/features/orders/domain/usecases/save_order_usecase.dart';

/// Stripe-aware checkout coordinator with Hive fallback demo path.
@lazySingleton
class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  /// Injects cart readers, order writers, and optional Stripe gateway.
  CheckoutBloc(
    this._getCartLines,
    this._createOrder,
    this._saveOrder,
    this._clearCart,
    this._paymentGateway,
    this._config,
    this._talker,
  ) : super(const CheckoutInitial()) {
    on<CheckoutStarted>(_onStarted);
    on<CheckoutPaySubmitted>(_onPaySubmitted);
  }

  final GetCartLinesUseCase _getCartLines;
  final CreateOrderEntityUseCase _createOrder;
  final SaveOrderUseCase _saveOrder;
  final ClearCartUseCase _clearCart;
  final CheckoutPaymentGateway _paymentGateway;
  final AppConfig _config;
  final Talker _talker;

  Future<void> _onStarted(
    CheckoutStarted event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(const CheckoutLoading());
    final result = await _getCartLines();
    result.fold(
      (failure) => emit(CheckoutFailure(failure.message)),
      (lines) {
        if (lines.isEmpty) {
          emit(const CheckoutCartEmpty());
          return;
        }
        final double subtotal = lines.fold<double>(
          0,
          (double a, CartLineEntity l) => a + l.lineTotal,
        );
        final bool stripe = _config.stripePublishableKey != null &&
            _config.stripePublishableKey!.isNotEmpty &&
            _config.stripePaymentIntentClientSecret != null &&
            _config.stripePaymentIntentClientSecret!.isNotEmpty;
        emit(
          CheckoutReady(
            lines: lines,
            subtotal: subtotal,
            stripeEnabled: stripe,
          ),
        );
      },
    );
  }

  Future<void> _onPaySubmitted(
    CheckoutPaySubmitted event,
    Emitter<CheckoutState> emit,
  ) async {
    final CheckoutState current = state;
    if (current is! CheckoutReady) {
      return;
    }
    emit(current.copyWith(submitting: true, clearError: true));
    final OrderEntity order = _createOrder(
      cartLines: current.lines,
      shipping: event.address,
    );

    final bool stripe = current.stripeEnabled;
    if (stripe) {
      final secret = _config.stripePaymentIntentClientSecret!;
      final payResult = await _paymentGateway.presentPaymentSheet(
        clientSecret: secret,
        merchantDisplayName: 'ShopFlow',
      );
      final failed = payResult.fold<bool>(
        (failure) {
          emit(
            current.copyWith(
              submitting: false,
              lastError: failure.message,
            ),
          );
          return true;
        },
        (_) => false,
      );
      if (failed) {
        return;
      }
    } else {
      _talker.info(
        '[ShopFlow][checkout] demo checkout — configure Stripe secrets for Payment Sheet',
      );
    }

    final saveResult = await _saveOrder(order);
    final saveFailed = saveResult.fold<bool>(
      (failure) {
        emit(
          current.copyWith(
            submitting: false,
            lastError: failure.message,
          ),
        );
        return true;
      },
      (_) => false,
    );
    if (saveFailed) {
      return;
    }

    final clearResult = await _clearCart();
    clearResult.fold(
      (failure) {
        _talker.warning(
          '[ShopFlow][checkout] order saved but cart clear failed: '
          '${failure.message}',
        );
        emit(CheckoutSuccess(order.id));
      },
      (_) => emit(CheckoutSuccess(order.id)),
    );
  }
}
