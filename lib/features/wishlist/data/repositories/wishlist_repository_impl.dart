import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/core/error/failures.dart';
import 'package:shop_flow/features/wishlist/data/datasources/local_wishlist_datasource.dart';
import 'package:shop_flow/features/wishlist/domain/repositories/wishlist_repository.dart';

/// Local-only wishlist persistence for offline showroom demos.
@lazySingleton
class WishlistRepositoryImpl implements WishlistRepository {
  /// Constructor wires datasource + structured logging.
  WishlistRepositoryImpl(this._local, this._talker);

  final LocalWishlistDatasource _local;
  final Talker _talker;

  @override
  Future<Either<Failure, Set<int>>> getIds() async {
    try {
      final ids = await _local.readIds();
      return Right<Failure, Set<int>>(ids);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, Set<int>>(
        CacheFailure('Could not read wishlist'),
      );
    }
  }

  @override
  Future<Either<Failure, Set<int>>> toggle(int productId) async {
    try {
      final ids = await _local.readIds();
      if (ids.contains(productId)) {
        ids.remove(productId);
      } else {
        ids.add(productId);
      }
      await _local.writeIds(ids);
      _talker.info('[ShopFlow][wishlist] toggle → ${ids.length} ids cached');
      return Right<Failure, Set<int>>(ids);
    } on Object catch (e, st) {
      _talker.handle(e, st);
      return const Left<Failure, Set<int>>(
        CacheFailure('Could not update wishlist'),
      );
    }
  }
}
