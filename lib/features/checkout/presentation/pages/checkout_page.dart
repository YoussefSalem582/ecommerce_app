import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/config/app_config.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/core/widgets/offline_banner.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/checkout/domain/showcase_promo.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_cubit.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_state.dart';

/// Address capture + payment trigger for Phase 5 checkout shell.
class CheckoutPage extends StatefulWidget {
  /// Creates authenticated checkout host route.
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  final TextEditingController _streetCtrl = TextEditingController();
  final TextEditingController _cityCtrl = TextEditingController();
  final TextEditingController _postalCtrl = TextEditingController();
  final TextEditingController _countryCtrl = TextEditingController();
  final TextEditingController _promoCtrl = TextEditingController();
  bool _saveAddress = false;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<CheckoutBloc>().add(const CheckoutStarted());
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _streetCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    _countryCtrl.dispose();
    _promoCtrl.dispose();
    super.dispose();
  }

  void _fillAddress(SavedAddressEntity address) {
    setState(() {
      _nameCtrl.text = address.fullName;
      _streetCtrl.text = address.street;
      _cityCtrl.text = address.city;
      _postalCtrl.text = address.postalCode;
      _countryCtrl.text = address.country;
      _selectedAddressId = address.id;
    });
  }

  void _applyPromo(AppLocalizations l10n, double subtotal) {
    final promo = ShowcasePromoCatalog.find(_promoCtrl.text);
    if (promo == null) {
      context.read<CheckoutBloc>().add(
            CheckoutPromoRejected(l10n.checkoutPromoInvalid),
          );
      return;
    }
    final discount = promo.discountFor(subtotal);
    if (discount <= 0) {
      context.read<CheckoutBloc>().add(
            CheckoutPromoRejected(
              l10n.checkoutPromoMinSubtotal(
                promo.minSubtotal.toStringAsFixed(0),
              ),
            ),
          );
      return;
    }
    context.read<CheckoutBloc>().add(
          CheckoutPromoApplied(
            code: promo.code,
            discountAmount: discount,
            message: l10n.checkoutPromoApplied(promo.label),
          ),
        );
  }

  void _submit(AppLocalizations l10n) {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final ShippingAddressEntity address = ShippingAddressEntity(
      fullName: _nameCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      postalCode: _postalCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
    );
    context.read<CheckoutBloc>().add(
          CheckoutPaySubmitted(address, saveAddress: _saveAddress),
        );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (CheckoutState previous, CheckoutState current) {
            return switch (current) {
              CheckoutReady(:final lastError) when lastError != null =>
                previous is! CheckoutReady ||
                    previous.lastError != current.lastError,
              _ => false,
            };
          },
          listener: (BuildContext context, CheckoutState state) {
            if (state case CheckoutReady(:final lastError)
                when lastError != null) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(lastError)),
              );
            }
          },
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (_, CheckoutState current) =>
              current is CheckoutSuccess,
          listener: (BuildContext context, CheckoutState state) {
            if (state case CheckoutSuccess(:final orderId)) {
              context.read<CartBloc>().add(const CartRefreshRequested());
              context.go(AppRoutes.orderSuccess(orderId));
            }
          },
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (_, CheckoutState current) =>
              current is CheckoutCartEmpty,
          listener: (BuildContext context, CheckoutState state) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.checkoutCartEmpty)),
            );
            context.pop();
          },
        ),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text(l10n.checkoutTitle)),
        body: OfflineBanner(
          child: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (BuildContext context, CheckoutState state) {
            return switch (state) {
              CheckoutInitial() || CheckoutLoading() =>
                const AppLoadingView(),
              CheckoutFailure(:final message) => AppErrorView(
                  message: message,
                  onRetry: () => context
                      .read<CheckoutBloc>()
                      .add(const CheckoutStarted()),
                ),
              CheckoutReady(
                :final lines,
                :final subtotal,
                :final stripeEnabled,
                :final submitting,
                :final discountAmount,
                :final totalAfterDiscount,
                :final promoMessage,
                :final promoCode,
              ) =>
                AbsorbPointer(
                  absorbing: submitting,
                  child: Stack(
                    children: <Widget>[
                      LayoutBuilder(
                        builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                        ) {
                          final bool wide =
                              constraints.maxWidth >= AppBreakpoints.tablet;
                          final bool rowFields =
                              constraints.maxWidth >= AppBreakpoints.mobile;

                          final Widget summary = _OrderSummarySection(
                            l10n: l10n,
                            palette: palette,
                            lines: lines,
                            subtotal: subtotal,
                            discountAmount: discountAmount,
                            totalAfterDiscount: totalAfterDiscount,
                            promoMessage: promoMessage,
                            promoCode: promoCode,
                            stripeEnabled: stripeEnabled,
                            promoController: _promoCtrl,
                            onApplyPromo: () => _applyPromo(l10n, subtotal),
                            onClearPromo: () {
                              _promoCtrl.clear();
                              context
                                  .read<CheckoutBloc>()
                                  .add(const CheckoutPromoCleared());
                            },
                          );
                          final Widget form = _ShippingFormSection(
                            formKey: _formKey,
                            l10n: l10n,
                            nameCtrl: _nameCtrl,
                            streetCtrl: _streetCtrl,
                            cityCtrl: _cityCtrl,
                            postalCtrl: _postalCtrl,
                            countryCtrl: _countryCtrl,
                            rowFields: rowFields,
                            onSubmit: () => _submit(l10n),
                            submitting: submitting,
                            showDemoBanner: getIt<AppConfig>().isDemoEnv &&
                                !stripeEnabled,
                            saveAddress: _saveAddress,
                            onSaveAddressChanged: (bool value) {
                              setState(() => _saveAddress = value);
                            },
                            selectedAddressId: _selectedAddressId,
                            onAddressSelected: _fillAddress,
                          );

                          if (!wide) {
                            return SingleChildScrollView(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[summary, form],
                              ),
                            );
                          }

                          return Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 1200),
                              child: SingleChildScrollView(
                                padding: const EdgeInsets.all(24),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Expanded(flex: 2, child: summary),
                                    const SizedBox(width: 32),
                                    Expanded(flex: 3, child: form),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      if (submitting)
                        ColoredBox(
                          color: Colors.black26,
                          child: Center(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    const CircularProgressIndicator(),
                                    const SizedBox(height: 16),
                                    Text(l10n.checkoutProcessingHint),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              CheckoutSuccess() || CheckoutCartEmpty() =>
                const SizedBox.shrink(),
            };
          },
        ),
        ),
      ),
    );
  }
}

class _OrderSummarySection extends StatelessWidget {
  const _OrderSummarySection({
    required this.l10n,
    required this.palette,
    required this.lines,
    required this.subtotal,
    required this.discountAmount,
    required this.totalAfterDiscount,
    required this.promoMessage,
    required this.promoCode,
    required this.stripeEnabled,
    required this.promoController,
    required this.onApplyPromo,
    required this.onClearPromo,
  });

  final AppLocalizations l10n;
  final AppPalette palette;
  final List<CartLineEntity> lines;
  final double subtotal;
  final double discountAmount;
  final double totalAfterDiscount;
  final String? promoMessage;
  final String? promoCode;
  final bool stripeEnabled;
  final TextEditingController promoController;
  final VoidCallback onApplyPromo;
  final VoidCallback onClearPromo;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Text(
          l10n.checkoutOrderSummarySection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                key: TestKeys.checkoutPromoField,
                controller: promoController,
                decoration: InputDecoration(
                  labelText: l10n.checkoutPromoLabel,
                  hintText: l10n.checkoutPromoHint,
                ),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.tonal(
              key: TestKeys.checkoutPromoApplyButton,
              onPressed: onApplyPromo,
              child: Text(l10n.checkoutPromoApply),
            ),
          ],
        ),
        if (promoMessage != null) ...<Widget>[
          const SizedBox(height: 4),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  promoMessage!,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: promoCode != null
                            ? palette.primary
                            : Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
              if (promoCode != null)
                TextButton(
                  onPressed: onClearPromo,
                  child: Text(l10n.checkoutPromoClear),
                ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: lines
                .map(
                  (CartLineEntity l) => ListTile(
                    title: Text(
                      l.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${l.quantity} × ${PriceFormatter.formatUsd(context, l.unitPrice)}',
                    ),
                    trailing: Text(
                      PriceFormatter.formatUsd(context, l.lineTotal),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                '${l10n.cartSubtotalLabel}: ${PriceFormatter.formatUsd(context, subtotal)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              if (discountAmount > 0)
                Text(
                  '${l10n.checkoutDiscountLabel}: -${PriceFormatter.formatUsd(context, discountAmount)}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: palette.accent,
                      ),
                ),
              Text(
                '${l10n.checkoutTotalLabel}: ${PriceFormatter.formatUsd(context, totalAfterDiscount)}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: palette.primary),
              ),
            ],
          ),
        ),
        if (stripeEnabled)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              l10n.checkoutStripeSheetHint,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }
}

class _ShippingFormSection extends StatelessWidget {
  const _ShippingFormSection({
    required this.formKey,
    required this.l10n,
    required this.nameCtrl,
    required this.streetCtrl,
    required this.cityCtrl,
    required this.postalCtrl,
    required this.countryCtrl,
    required this.rowFields,
    required this.onSubmit,
    required this.submitting,
    required this.showDemoBanner,
    required this.saveAddress,
    required this.onSaveAddressChanged,
    required this.selectedAddressId,
    required this.onAddressSelected,
  });

  final GlobalKey<FormState> formKey;
  final AppLocalizations l10n;
  final TextEditingController nameCtrl;
  final TextEditingController streetCtrl;
  final TextEditingController cityCtrl;
  final TextEditingController postalCtrl;
  final TextEditingController countryCtrl;
  final bool rowFields;
  final VoidCallback onSubmit;
  final bool submitting;
  final bool showDemoBanner;
  final bool saveAddress;
  final ValueChanged<bool> onSaveAddressChanged;
  final String? selectedAddressId;
  final ValueChanged<SavedAddressEntity> onAddressSelected;

  @override
  Widget build(BuildContext context) {
    final Widget cityField = TextFormField(
      key: TestKeys.checkoutCity,
      controller: cityCtrl,
      decoration: InputDecoration(labelText: l10n.checkoutCityLabel),
      validator: (String? v) =>
          (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
    );
    final Widget postalField = TextFormField(
      key: TestKeys.checkoutPostal,
      controller: postalCtrl,
      decoration: InputDecoration(labelText: l10n.checkoutPostalLabel),
      validator: (String? v) =>
          (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
    );

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (showDemoBanner) ...<Widget>[
            MaterialBanner(
              content: Text(l10n.demoModeBannerBody),
              leading: const Icon(Icons.info_outline),
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer
                  .withValues(alpha: 0.35),
              actions: <Widget>[
                Text(l10n.demoModeBannerTitle),
              ],
            ),
            const SizedBox(height: 16),
          ],
          const SizedBox(height: 24),
          Text(
            l10n.checkoutShippingSection,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          BlocBuilder<AddressesCubit, AddressesState>(
            builder: (BuildContext context, AddressesState addrState) {
              if (addrState is! AddressesReady || addrState.addresses.isEmpty) {
                return const SizedBox.shrink();
              }
              return Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 8),
                child: DropdownButtonFormField<String>(
                  key: TestKeys.checkoutSavedAddressDropdown,
                  value: selectedAddressId,
                  decoration: InputDecoration(
                    labelText: l10n.checkoutSavedAddressLabel,
                  ),
                  items: addrState.addresses
                      .map(
                        (SavedAddressEntity a) => DropdownMenuItem<String>(
                          value: a.id,
                          child: Text(
                            '${a.fullName} — ${a.city}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (String? id) {
                    if (id == null) {
                      return;
                    }
                    final SavedAddressEntity? match = addrState.addresses
                        .where((SavedAddressEntity a) => a.id == id)
                        .firstOrNull;
                    if (match != null) {
                      onAddressSelected(match);
                    }
                  },
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          TextFormField(
            key: TestKeys.checkoutFullName,
            controller: nameCtrl,
            decoration: InputDecoration(labelText: l10n.checkoutFullNameLabel),
            validator: (String? v) =>
                (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            key: TestKeys.checkoutStreet,
            controller: streetCtrl,
            decoration: InputDecoration(labelText: l10n.checkoutStreetLabel),
            validator: (String? v) =>
                (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          if (rowFields)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(child: cityField),
                const SizedBox(width: 16),
                Expanded(child: postalField),
              ],
            )
          else ...<Widget>[
            cityField,
            const SizedBox(height: 12),
            postalField,
          ],
          const SizedBox(height: 12),
          TextFormField(
            key: TestKeys.checkoutCountry,
            controller: countryCtrl,
            decoration: InputDecoration(labelText: l10n.checkoutCountryLabel),
            validator: (String? v) =>
                (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            key: TestKeys.checkoutSaveAddressCheckbox,
            value: saveAddress,
            onChanged: (bool? value) =>
                onSaveAddressChanged(value ?? false),
            title: Text(l10n.checkoutSaveAddressLabel),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 12),
          FilledButton(
            key: TestKeys.checkoutPayButton,
            onPressed: submitting ? null : onSubmit,
            child: Text(l10n.checkoutPayButton),
          ),
        ],
      ),
    );
  }
}
