import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

import 'package:shop_flow/features/auth/domain/usecases/google_sign_in_usecase.dart';
import 'package:shop_flow/features/auth/domain/usecases/login_usecase.dart';
import 'package:shop_flow/features/auth/domain/usecases/logout_usecase.dart';
import 'package:shop_flow/features/auth/domain/usecases/register_usecase.dart';
import 'package:shop_flow/features/auth/domain/usecases/restore_session_usecase.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_event.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';

/// Global authentication coordinator (restore/login/register/logout).
@lazySingleton
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  /// Wires use cases + Talker logging context.
  AuthBloc(
    this._restoreSession,
    this._login,
    this._register,
    this._logout,
    this._googleSignIn,
    this._talker,
  ) : super(const AuthInitial()) {
    on<AuthSessionRequested>(_onSessionRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
  }

  final RestoreSessionUseCase _restoreSession;
  final LoginUseCase _login;
  final RegisterUseCase _register;
  final LogoutUseCase _logout;
  final GoogleSignInUseCase _googleSignIn;
  final Talker _talker;

  Future<void> _onSessionRequested(
    AuthSessionRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _restoreSession.call();
    result.fold(
      (failure) {
        _talker.info(
          '[ShopFlow][auth] session restore failed: ${failure.message}',
        );
        emit(const AuthUnauthenticated());
      },
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _login.call(
      username: event.username,
      password: event.password,
    );
    result.fold(
      (failure) => emit(AuthCredentialFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _register.call(
      email: event.email,
      username: event.username,
      password: event.password,
      firstName: event.firstName,
      lastName: event.lastName,
    );
    result.fold(
      (failure) => emit(AuthCredentialFailure(failure.message)),
      (user) => emit(AuthRegistrationSucceeded(user.username)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _logout.call();
    result.fold(
      (failure) => emit(AuthCredentialFailure(failure.message)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _googleSignIn.call();
    result.fold(
      (failure) => emit(AuthCredentialFailure(failure.message)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }
}
