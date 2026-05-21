import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_bloc.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_event.dart';
import 'package:shop_flow/features/wishlist/presentation/bloc/wishlist_page_state.dart';

import '../../support/app_test_bootstrap.dart';

void main() {
  setUpAll(() async {
    await bootstrapShopFlowTests();
  });

  tearDownAll(() async {
    await tearDownShopFlowTests();
  });

  test('WishlistPageBloc emits empty when no favorites saved', () async {
    final WishlistPageBloc bloc = GetIt.instance<WishlistPageBloc>();
    bloc.add(const WishlistPageStarted());

    final WishlistPageState state = await bloc.stream.firstWhere(
      (WishlistPageState s) =>
          s is WishlistPageEmpty ||
          s is WishlistPageLoaded ||
          s is WishlistPageFailure,
    );

    expect(state, isA<WishlistPageEmpty>());
    await bloc.close();
  });
}
