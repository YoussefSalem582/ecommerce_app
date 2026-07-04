import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/brand_badge.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/auth/presentation/utils/auth_error_messages.dart';

/// Registration screen targeting Fake Store `POST /users`.
class RegisterPage extends StatefulWidget {
  /// Creates register UI.
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();

  bool _emailValid(String value) {
    final v = value.trim();
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v);
  }

  @override
  void dispose() {
    _email.dispose();
    _username.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    context.read<AuthBloc>().add(
          AuthRegisterRequested(
            email: _email.text.trim(),
            username: _username.text.trim(),
            password: _password.text,
            firstName: _firstName.text.trim(),
            lastName: _lastName.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registerTitle)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is AuthCredentialFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authCredentialFailureSnackBarMessage(l10n, state.message),
                ),
              ),
            );
          }
          if (state is AuthRegistrationSucceeded) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.registerSuccessSnackbar)),
            );
            context.go(AppRoutes.login);
          }
        },
        builder: (BuildContext context, AuthState state) {
          final loading = state is AuthLoading;

          return AbsorbPointer(
            absorbing: loading,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final form = Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      const Align(
                        child: BrandBadge(icon: Icons.person_add_alt_1_rounded),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            InputDecoration(labelText: l10n.emailLabel),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          if (!_emailValid(value)) {
                            return l10n.invalidEmailHint;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _username,
                        decoration:
                            InputDecoration(labelText: l10n.usernameLabel),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _password,
                        obscureText: true,
                        decoration:
                            InputDecoration(labelText: l10n.passwordLabel),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return l10n.fieldRequired;
                          }
                          if (value.length < 3) {
                            return l10n.passwordTooShort;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _firstName,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            InputDecoration(labelText: l10n.firstNameLabel),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _lastName,
                        textCapitalization: TextCapitalization.words,
                        decoration:
                            InputDecoration(labelText: l10n.lastNameLabel),
                        validator: (String? value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.fieldRequired;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppGradientButton(
                        key: TestKeys.registerSubmitButton,
                        label: l10n.registerButton,
                        loading: loading,
                        onPressed: loading ? null : () => _submit(context),
                      ),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () => context.go(AppRoutes.login),
                        child: Text(l10n.alreadyHaveAccountLink),
                      ),
                    ],
                  ),
                );

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: constraints.maxWidth >= AppBreakpoints.mobile
                            ? 480
                            : double.infinity,
                      ),
                      child: form,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
