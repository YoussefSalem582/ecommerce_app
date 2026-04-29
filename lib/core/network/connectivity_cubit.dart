import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:talker/talker.dart';

/// Online vs offline connectivity status derived from [Connectivity].
enum ConnectivityStatus {
  /// Device has a usable network path.
  online,

  /// No usable connection — prefer cached data paths.
  offline,
}

/// Maps connectivity stream events into [ConnectivityStatus].
@lazySingleton
class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  /// Subscribes to platform connectivity updates.
  ConnectivityCubit(this._connectivity, this._talker)
      : super(ConnectivityStatus.online) {
    _subscription = _connectivity.onConnectivityChanged.listen(_onChanged);
    unawaited(_emitInitial());
  }

  final Connectivity _connectivity;
  final Talker _talker;

  StreamSubscription<List<ConnectivityResult>>? _subscription;

  Future<void> _emitInitial() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _emit(results);
    } on Object catch (e, st) {
      _talker.handle(e, st);
    }
  }

  void _onChanged(List<ConnectivityResult> results) {
    _emit(results);
  }

  void _emit(List<ConnectivityResult> results) {
    final offline = results.isEmpty ||
        results.every((r) => r == ConnectivityResult.none);
    final next =
        offline ? ConnectivityStatus.offline : ConnectivityStatus.online;
    if (next != state) {
      _talker.info('[ShopFlow][core] connectivity → ${next.name}');
      emit(next);
    }
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
