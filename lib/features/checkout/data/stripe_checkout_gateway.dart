import 'package:dartz/dartz.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/checkout/domain/checkout_payment_gateway.dart';

/// Stripe Payment Sheet bridge for portfolio reviewers with backend secrets.
@lazySingleton
class StripeCheckoutGateway implements CheckoutPaymentGateway {
  /// Injects Talker for declarative payment breadcrumbs.
  StripeCheckoutGateway(this._talker);

  final Talker _talker;

  @override
  Future<Either<Failure, Unit>> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
        ),
      );
      await Stripe.instance.presentPaymentSheet();
      return const Right<Failure, Unit>(unit);
    } on StripeException catch (e, st) {
      _talker.handle(e, st);
      final String msg = e.error.localizedMessage ?? e.toString();
      return Left<Failure, Unit>(ServerFailure(msg));
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return Left<Failure, Unit>(UnexpectedFailure(e.toString()));
    }
  }
}
