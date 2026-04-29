import 'package:equatable/equatable.dart';

import 'package:shop_flow/features/auth/domain/entities/user_entity.dart';

/// Authentication states emitted by [AuthBloc].
sealed class AuthState extends Equatable {
  /// Creates auth state base.
  const AuthState();

  @override
  List<Object?> get props => <Object?>[];
}

/// Bootstrapping — session resolution has not completed yet.
final class AuthInitial extends AuthState {
  /// Initial placeholder state.
  const AuthInitial();
}

/// Long-running auth pipeline (restore/login/register/logout).
final class AuthLoading extends AuthState {
  /// Spinner-friendly intermediate state.
  const AuthLoading();
}

/// Authenticated user session available for guarded routes.
final class AuthAuthenticated extends AuthState {
  /// Signed-in profile snapshot.
  const AuthAuthenticated(this.user);

  /// Domain entity carried across tabs.
  final UserEntity user;

  @override
  List<Object?> get props => <Object?>[user];
}

/// Guest mode — user must sign in.
final class AuthUnauthenticated extends AuthState {
  /// User needs credentials or registration.
  const AuthUnauthenticated();
}

/// Wrong credentials / validation failure from Fake Store.
final class AuthCredentialFailure extends AuthState {
  /// Human-readable API message for UI snackbars.
  const AuthCredentialFailure(this.message);

  /// Failure detail text.
  final String message;

  @override
  List<Object?> get props => <Object?>[message];
}

/// Registration succeeded — UI should route to login screen.
final class AuthRegistrationSucceeded extends AuthState {
  /// Successful signup acknowledgement with username hint.
  const AuthRegistrationSucceeded(this.username);

  /// Registered username for localized messaging.
  final String username;

  @override
  List<Object?> get props => <Object?>[username];
}
