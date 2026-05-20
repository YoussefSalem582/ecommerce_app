import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Profile screen states.
sealed class ProfileState extends Equatable {
  /// Creates profile state base.
  const ProfileState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Before first load completes.
final class ProfileInitial extends ProfileState {
  /// Placeholder state.
  const ProfileInitial();
}

/// Spinner visible.
final class ProfileLoading extends ProfileState {
  /// Loading indicator state.
  const ProfileLoading();
}

/// Profile data ready.
final class ProfileLoaded extends ProfileState {
  /// Successful profile emission.
  const ProfileLoaded({
    required this.user,
    this.avatarPath,
  });

  /// Cached user entity.
  final UserEntity user;

  /// Local avatar filesystem path.
  final String? avatarPath;

  @override
  List<Object?> get props => <Object?>[user, avatarPath];
}

/// Recoverable failure.
final class ProfileFailure extends ProfileState {
  /// Failure with message.
  const ProfileFailure(this.message);

  /// Human-readable detail.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}
