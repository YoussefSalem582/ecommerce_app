import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

/// Opens debug tooling when the device is shaken (debug builds only).
class ShakeDebugListener extends StatefulWidget {
  /// Creates a shake listener wrapping [child].
  const ShakeDebugListener({
    required this.child,
    required this.onShake,
    super.key,
  });

  /// Widget tree below the listener.
  final Widget child;

  /// Callback fired once per shake debounce window.
  final VoidCallback onShake;

  @override
  State<ShakeDebugListener> createState() => _ShakeDebugListenerState();
}

class _ShakeDebugListenerState extends State<ShakeDebugListener> {
  StreamSubscription<UserAccelerometerEvent>? _subscription;
  DateTime? _lastShakeAt;
  double _lastMagnitude = 0;

  static const _shakeThreshold = 18.0;
  static const _debounce = Duration(milliseconds: 1200);

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      return;
    }
    _subscription = userAccelerometerEventStream().listen(_onAccelerometer);
  }

  void _onAccelerometer(UserAccelerometerEvent event) {
    if (!mounted) {
      return;
    }
    if (MediaQuery.of(context).disableAnimations) {
      return;
    }

    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    final delta = (magnitude - _lastMagnitude).abs();
    _lastMagnitude = magnitude;

    if (delta < _shakeThreshold) {
      return;
    }

    final now = DateTime.now();
    if (_lastShakeAt != null && now.difference(_lastShakeAt!) < _debounce) {
      return;
    }
    _lastShakeAt = now;
    widget.onShake();
  }

  @override
  void dispose() {
    unawaited(_subscription?.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
