import 'package:equatable/equatable.dart';


/// Edit profile form events.
sealed class EditProfileEvent extends Equatable {
  /// Creates edit profile event base.
  const EditProfileEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Prefills form from cached profile.
final class EditProfileStarted extends EditProfileEvent {
  /// Loads current profile into form.
  const EditProfileStarted();
}

/// Submits validated form fields.
final class EditProfileSubmitted extends EditProfileEvent {
  /// Form payload.
  const EditProfileSubmitted({
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  /// Email field.
  final String email;

  /// First name field.
  final String firstName;

  /// Last name field.
  final String lastName;

  @override
  List<Object?> get props => <Object?>[email, firstName, lastName];
}

/// Picks avatar from gallery via image picker.
final class EditProfileAvatarPicked extends EditProfileEvent {
  /// Local file path from picker.
  const EditProfileAvatarPicked(this.path);

  /// Filesystem path.
  final String path;

  @override
  List<Object?> get props => <Object?>[path];
}
