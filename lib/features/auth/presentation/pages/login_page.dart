import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/core/router/app_routes.dart';
import 'package:shop_flow/core/theme/app_spacing.dart';
import 'package:shop_flow/core/utils/app_breakpoints.dart';
import 'package:shop_flow/core/widgets/brand_badge.dart';
import 'package:shop_flow/core/widgets/google_sign_in_button.dart';
import 'package:shop_flow/core/widgets/gradient_button.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';
import 'package:shop_flow/features/auth/presentation/utils/auth_error_messages.dart';

/// Email/password sign-in against Fake Store `/auth/login`.
class LoginPage extends StatefulWidget {
  /// Creates the login screen.
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _username = TextEditingController(
    text: kDebugMode ? 'mor_2314' : '',
  );

  final TextEditingController _password = TextEditingController(
    text: kDebugMode ? '83r5^_' : '',
  );

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }
    context.read<AuthBloc>().add(
          AuthLoginRequested(
            username: _username.text.trim(),
            password: _password.text,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.loginTitle)),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state case AuthCredentialFailure(:final message)) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  authCredentialFailureSnackBarMessage(l10n, message),
                ),
              ),
            );
          }
        },
        builder: (BuildContext context, AuthState state) {
          final bool loading = state is AuthLoading;

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
                        child: BrandBadge(icon: Icons.lock_rounded),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      TextFormField(
                        controller: _username,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          labelText: l10n.usernameLabel,
                        ),
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
                        decoration: InputDecoration(
                          labelText: l10n.passwordLabel,
                        ),
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
                      const SizedBox(height: AppSpacing.xl),
                      AppGradientButton(
                        key: TestKeys.loginSubmitButton,
                        label: l10n.loginButton,
                        loading: loading,
                        onPressed: loading ? null : () => _submit(context),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      TextButton(
                        onPressed: loading
                            ? null
                            : () => context.push(AppRoutes.register),
                        child: Text(l10n.createAccountLink),
                      ),
                      const SizedBox(height: 8),
                      GoogleSignInButton(
                        key: TestKeys.googleSignInButton,
                        onPressed: loading
                            ? null
                            : () => context
                                .read<AuthBloc>()
                                .add(const AuthGoogleSignInRequested()),
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
