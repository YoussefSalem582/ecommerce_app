import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import 'package:shop_flow/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:shop_flow/features/auth/presentation/bloc/auth_state.dart';

/// Notifies [GoRouter] when [AuthBloc] emits new navigation-sensitive states.
@lazySingleton
class AuthRefreshNotifier extends ChangeNotifier {
  /// Subscribes to auth stream for redirect recomputation.
  AuthRefreshNotifier(this._bloc) {
    _subscription = _bloc.stream.listen((AuthState _) => notifyListeners());
  }

  final AuthBloc _bloc;

  StreamSubscription<AuthState>? _subscription;

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }
}
