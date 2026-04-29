import 'package:dartz/dartz.dart';

import 'package:shop_flow/core/error/failures.dart';

/// Presents Stripe Payment Sheet using platform SDK (data layer impl).
abstract class CheckoutPaymentGateway {
  /// Initializes + surfaces Stripe sheet for [clientSecret].
  Future<Either<Failure, Unit>> presentPaymentSheet({
    required String clientSecret,
    required String merchantDisplayName,
  });
}
