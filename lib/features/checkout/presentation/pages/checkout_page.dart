import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/theme_extensions.dart';
import 'package:shop_flow/core/utils/price_formatter.dart';
import 'package:shop_flow/features/cart/domain/entities/cart_line_entity.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:shop_flow/features/cart/presentation/bloc/cart_event.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_bloc.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_event.dart';
import 'package:shop_flow/features/checkout/presentation/bloc/checkout_state.dart';
import 'package:shop_flow/features/orders/domain/entities/shipping_address_entity.dart';

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
    super.dispose();
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
    context.read<CheckoutBloc>().add(CheckoutPaySubmitted(address));
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context);
    final palette = context.appPalette;

    return MultiBlocListener(
      listeners: <BlocListener<dynamic, dynamic>>[
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (CheckoutState previous, CheckoutState current) {
            if (current is! CheckoutReady || current.lastError == null) {
              return false;
            }
            if (previous is! CheckoutReady) {
              return true;
            }
            return previous.lastError != current.lastError;
          },
          listener: (BuildContext context, CheckoutState state) {
            final CheckoutReady s = state as CheckoutReady;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(s.lastError!)),
            );
          },
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listenWhen: (_, CheckoutState current) =>
              current is CheckoutSuccess,
          listener: (BuildContext context, CheckoutState state) {
            final CheckoutSuccess s = state as CheckoutSuccess;
            context.read<CartBloc>().add(const CartRefreshRequested());
            context.go(AppRoutes.orderSuccess(s.orderId));
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
        body: BlocBuilder<CheckoutBloc, CheckoutState>(
          builder: (BuildContext context, CheckoutState state) {
            if (state is CheckoutInitial || state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CheckoutFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(state.message, textAlign: TextAlign.center),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => context
                            .read<CheckoutBloc>()
                            .add(const CheckoutStarted()),
                        child: Text(l10n.retry),
                      ),
                    ],
                  ),
                ),
              );
            }
            if (state is CheckoutReady) {
              final bool submitting = state.submitting;
              return AbsorbPointer(
                absorbing: submitting,
                child: Stack(
                  children: <Widget>[
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Text(
                              l10n.checkoutOrderSummarySection,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Card(
                              child: Column(
                                children: state.lines
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
                                          PriceFormatter.formatUsd(
                                            context,
                                            l.lineTotal,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${l10n.cartSubtotalLabel}: ${PriceFormatter.formatUsd(context, state.subtotal)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(color: palette.primary),
                              ),
                            ),
                            if (state.stripeEnabled)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  l10n.checkoutStripeSheetHint,
                                  style:
                                      Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            const SizedBox(height: 24),
                            Text(
                              l10n.checkoutShippingSection,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _nameCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.checkoutFullNameLabel,
                              ),
                              validator: (String? v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? l10n.fieldRequired
                                      : null,
                            ),
                            TextFormField(
                              controller: _streetCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.checkoutStreetLabel,
                              ),
                              validator: (String? v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? l10n.fieldRequired
                                      : null,
                            ),
                            TextFormField(
                              controller: _cityCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.checkoutCityLabel,
                              ),
                              validator: (String? v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? l10n.fieldRequired
                                      : null,
                            ),
                            TextFormField(
                              controller: _postalCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.checkoutPostalLabel,
                              ),
                              validator: (String? v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? l10n.fieldRequired
                                      : null,
                            ),
                            TextFormField(
                              controller: _countryCtrl,
                              decoration: InputDecoration(
                                labelText: l10n.checkoutCountryLabel,
                              ),
                              validator: (String? v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? l10n.fieldRequired
                                      : null,
                            ),
                            const SizedBox(height: 24),
                            FilledButton(
                              onPressed:
                                  submitting ? null : () => _submit(l10n),
                              child: Text(l10n.checkoutPayButton),
                            ),
                          ],
                        ),
                      ),
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
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
