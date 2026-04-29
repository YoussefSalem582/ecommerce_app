import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/domain/repositories/cart_repository.dart';

/// Loads persisted Hive cart rows for UI badges and checkout drafts.
@injectable
class GetCartLinesUseCase {
  /// Reads via abstract repository for Clean Architecture boundaries.
  GetCartLinesUseCase(this._repository);

  final CartRepository _repository;

  /// Returns SKU rows or cache failures for snackbars.
  Future<Either<Failure, List<CartLineEntity>>> call() {
    return _repository.getLines();
  }
}
