import 'package:equatable/equatable.dart';

/// Authentication events handled by [AuthBloc].
sealed class AuthEvent extends Equatable {
  /// Creates constant auth event base.
  const AuthEvent();

  @override
  List<Object?> get props => <Object?>[];
}

/// Restores JWT + cached profile on startup.
final class AuthSessionRequested extends AuthEvent {
  /// Attempts silent session restoration.
  const AuthSessionRequested();
}

/// Credentials login against Fake Store `/auth/login`.
final class AuthLoginRequested extends AuthEvent {
  /// Username field payload.
  const AuthLoginRequested({
    required this.username,
    required this.password,
  });

  /// Username credential.
  final String username;

  /// Password credential.
  final String password;

  @override
  List<Object?> get props => <Object?>[username, password];

  @override
  String toString() =>
      'AuthLoginRequested(username: $username, password: ***)';
}

/// Registration payload (`POST /users`).
final class AuthRegisterRequested extends AuthEvent {
  /// Collects registration fields.
  const AuthRegisterRequested({
    required this.email,
    required this.username,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  /// Email address.
  final String email;

  /// Unique username handle.
  final String username;

  /// Password credential.
  final String password;

  /// Given name input.
  final String firstName;

  /// Family name input.
  final String lastName;

  @override
  List<Object?> get props =>
      <Object?>[email, username, password, firstName, lastName];

  @override
  String toString() => 'AuthRegisterRequested('
      'email: $email, username: $username, password: ***, '
      'firstName: $firstName, lastName: $lastName)';
}

/// Clears secure credentials + cached profile.
final class AuthLogoutRequested extends AuthEvent {
  /// Logs out current session.
  const AuthLogoutRequested();
}

/// Google Sign-In showcase stub.
final class AuthGoogleSignInRequested extends AuthEvent {
  /// Triggers Google OAuth stub flow.
  const AuthGoogleSignInRequested();
}
