import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';
import 'package:shop_flow/features/profile/domain/entities/saved_address_entity.dart';
import 'package:shop_flow/features/profile/presentation/cubit/addresses_cubit.dart';

/// Form to add or edit a saved shipping address.
class AddAddressPage extends StatefulWidget {
  /// Creates add/edit address route ([existing] for edit mode).
  const AddAddressPage({this.existing, super.key});

  /// Address being edited, if any.
  final SavedAddressEntity? existing;

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _streetCtrl;
  late final TextEditingController _cityCtrl;
  late final TextEditingController _postalCtrl;
  late final TextEditingController _countryCtrl;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final SavedAddressEntity? existing = widget.existing;
    _nameCtrl = TextEditingController(text: existing?.fullName ?? '');
    _streetCtrl = TextEditingController(text: existing?.street ?? '');
    _cityCtrl = TextEditingController(text: existing?.city ?? '');
    _postalCtrl = TextEditingController(text: existing?.postalCode ?? '');
    _countryCtrl = TextEditingController(text: existing?.country ?? '');
    _isDefault = existing?.isDefault ?? false;
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

  Future<void> _save(AppLocalizations l10n) async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    final SavedAddressEntity address = SavedAddressEntity(
      id: widget.existing?.id ?? '',
      fullName: _nameCtrl.text.trim(),
      street: _streetCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      postalCode: _postalCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
      isDefault: _isDefault,
    );
    final bool ok = await context.read<AddressesCubit>().save(address);
    if (ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.addressSaved)),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bool editing = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(editing ? l10n.editAddressTitle : l10n.addAddressTitle),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              key: TestKeys.addressFullName,
              controller: _nameCtrl,
              decoration: InputDecoration(labelText: l10n.checkoutFullNameLabel),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.addressStreet,
              controller: _streetCtrl,
              decoration: InputDecoration(labelText: l10n.checkoutStreetLabel),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.addressCity,
              controller: _cityCtrl,
              decoration: InputDecoration(labelText: l10n.checkoutCityLabel),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.addressPostal,
              controller: _postalCtrl,
              decoration: InputDecoration(labelText: l10n.checkoutPostalLabel),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.addressCountry,
              controller: _countryCtrl,
              decoration: InputDecoration(labelText: l10n.checkoutCountryLabel),
              validator: (String? v) =>
                  (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null,
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: _isDefault,
              onChanged: (bool value) => setState(() => _isDefault = value),
              title: Text(l10n.addressDefaultLabel),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppGradientButton(
              key: TestKeys.saveAddressButton,
              label: l10n.saveProfile,
              onPressed: () => _save(l10n),
            ),
          ],
        ),
      ),
    );
  }
}
