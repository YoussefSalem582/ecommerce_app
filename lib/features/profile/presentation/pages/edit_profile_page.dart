import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_flow/core/constants/test_keys.dart';
import 'package:shop_flow/core/l10n/gen/app_localizations.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_bloc.dart';
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_event.dart';
import 'package:shop_flow/features/profile/presentation/bloc/edit_profile_state.dart';
import 'package:shop_flow/core/widgets/app_error_view.dart';
import 'package:shop_flow/core/widgets/app_loading_view.dart';
import 'package:shop_flow/features/profile/presentation/widgets/profile_avatar_widget.dart';

/// Form for editing locally cached profile fields and avatar.
class EditProfilePage extends StatefulWidget {
  /// Creates edit profile route.
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      context.read<EditProfileBloc>().add(const EditProfileStarted());
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickAvatar() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (file == null || !mounted) {
      return;
    }
    context
        .read<EditProfileBloc>()
        .add(EditProfileAvatarPicked(file.path));
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    context.read<EditProfileBloc>().add(
          EditProfileSubmitted(
            email: _emailController.text.trim(),
            firstName: _firstNameController.text.trim(),
            lastName: _lastNameController.text.trim(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.editProfileTitle)),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (BuildContext context, EditProfileState state) {
          if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
          if (state is EditProfileSaved) {
            context.read<AuthBloc>().add(const AuthSessionRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(l10n.profileUpdated)),
            );
            context.pop();
          }
          if (state is EditProfileReady &&
              _emailController.text.isEmpty &&
              _firstNameController.text.isEmpty) {
            _emailController.text = state.user.email ?? '';
            _firstNameController.text = state.user.firstName ?? '';
            _lastNameController.text = state.user.lastName ?? '';
          }
        },
        builder: (BuildContext context, EditProfileState state) {
          if (state is EditProfileLoading || state is EditProfileInitial) {
            return const AppLoadingView();
          }

          if (state is EditProfileFailure) {
            return AppErrorView(
              message: state.message,
              onRetry: () => context
                  .read<EditProfileBloc>()
                  .add(const EditProfileStarted()),
            );
          }

          if (state is! EditProfileReady) {
            return const SizedBox.shrink();
          }

          final formState = state;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: <Widget>[
                      ProfileAvatarWidget(
                        user: formState.user,
                        avatarPath: formState.avatarPath,
                        radius: 56,
                      ),
                      IconButton.filled(
                        tooltip: l10n.changeAvatar,
                        onPressed: _pickAvatar,
                        icon: const Icon(Icons.camera_alt_outlined),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: l10n.emailLabel),
                    keyboardType: TextInputType.emailAddress,
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.fieldRequired;
                      }
                      if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                          .hasMatch(value.trim())) {
                        return l10n.invalidEmailHint;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: l10n.firstNameLabel,
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
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: l10n.lastNameLabel),
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    key: TestKeys.saveProfileButton,
                    onPressed: state is EditProfileLoading ? null : _submit,
                    child: Text(l10n.saveProfile),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
