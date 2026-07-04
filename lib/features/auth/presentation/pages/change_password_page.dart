import 'package:flutter/material.dart';
import 'package:shop_flow/core/di/injection.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';
import 'package:shop_flow/features/auth/domain/usecases/change_password_usecase.dart';

/// Showcase change-password form with local validation only.
class ChangePasswordPage extends StatefulWidget {
  /// Creates change password route.
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    setState(() => _submitting = true);
    final result = await getIt<ChangePasswordUseCase>().call();
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(failure.message)),
        );
      },
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.changePasswordSuccess)),
        );
        Navigator.of(context).pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.changePasswordTitle)),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: <Widget>[
            Text(
              l10n.changePasswordHint,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: TestKeys.changePasswordCurrent,
              controller: _currentCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.changePasswordCurrentLabel,
              ),
              validator: (String? v) {
                if (v == null || v.trim().length < 3) {
                  return l10n.changePasswordCurrentInvalid;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.changePasswordNew,
              controller: _newCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.changePasswordNewLabel,
              ),
              validator: (String? v) {
                if (v == null || v.length < 3) {
                  return l10n.passwordTooShort;
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              key: TestKeys.changePasswordConfirm,
              controller: _confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: l10n.changePasswordConfirmLabel,
              ),
              validator: (String? v) {
                if (v != _newCtrl.text) {
                  return l10n.changePasswordMismatch;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            AppGradientButton(
              key: TestKeys.changePasswordSubmit,
              label: l10n.changePasswordSubmit,
              loading: _submitting,
              onPressed: _submitting ? null : () => _submit(l10n),
            ),
          ],
        ),
      ),
    );
  }
}
