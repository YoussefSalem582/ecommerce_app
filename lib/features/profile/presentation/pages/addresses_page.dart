import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/widgets/app_empty_view.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_cubit.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_state.dart';

/// Lists saved shipping addresses with add/edit/delete actions.
class AddressesPage extends StatelessWidget {
  /// Creates addresses management route.
  const AddressesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.addressesTitle)),
      floatingActionButton: FloatingActionButton.extended(
        key: TestKeys.addAddressFab,
        onPressed: () => context.push(AppRoutes.addAddress),
        icon: const Icon(Icons.add),
        label: Text(l10n.addAddressTitle),
      ),
      body: BlocBuilder<AddressesCubit, AddressesState>(
        builder: (BuildContext context, AddressesState state) {
          return switch (state) {
            AddressesInitial() || AddressesLoading() => const AppLoadingView(),
            AddressesFailure(:final message) => AppErrorView(
                message: message,
                onRetry: () => context.read<AddressesCubit>().load(),
              ),
            AddressesReady(:final addresses) when addresses.isEmpty =>
              AppEmptyView(
                icon: Icons.location_on_outlined,
                title: l10n.addressesEmptyTitle,
                body: l10n.addressesEmptyBody,
              ),
            AddressesReady(:final addresses) => ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (BuildContext context, int index) {
                  final SavedAddressEntity address = addresses[index];
                  return Card(
                    key: index == 0 ? TestKeys.firstAddressTile : null,
                    child: ListTile(
                      leading: Icon(
                        address.isDefault
                            ? Icons.home_rounded
                            : Icons.location_on_outlined,
                      ),
                      title: Text(address.fullName),
                      subtitle: Text(
                        '${address.street}, ${address.city}, ${address.country}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            context.read<AddressesCubit>().delete(address.id),
                      ),
                      onTap: () => context.push(
                        AppRoutes.addAddress,
                        extra: address,
                      ),
                    ),
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
