import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Edit profile form states.
sealed class EditProfileState extends Equatable {
  /// Creates edit profile state base.
  const EditProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before form is prefilled.
final class EditProfileInitial extends EditProfileState {
  /// Placeholder state.
  const EditProfileInitial();
}

/// Loading profile or saving changes.
final class EditProfileLoading extends EditProfileState {
  /// Spinner state.
  const EditProfileLoading();
}

/// Form ready for editing.
final class EditProfileReady extends EditProfileState {
  /// Prefilled form state.
  const EditProfileReady({
    required this.user,
    this.avatarPath,
  });

  /// Current user snapshot.
  final UserEntity user;

  /// Optional avatar path.
  final String? avatarPath;

  @override
  List<Object?> get props => <Object?>[user, avatarPath];
}

/// Save succeeded — navigate back.
final class EditProfileSaved extends EditProfileState {
  /// Updated user entity.
  const EditProfileSaved(this.user);

  /// Saved profile.
  final UserEntity user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Recoverable failure.
final class EditProfileFailure extends EditProfileState {
  /// Failure message.
  const EditProfileFailure(this.message);

  /// Human-readable detail.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
