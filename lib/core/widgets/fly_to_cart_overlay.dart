import 'dart:ui' show lerpDouble;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Overlay flight animating a thumbnail toward the cart badge anchor.
///
/// Disabled automatically when [MediaQuery.disableAnimations] is true.
abstract final class FlyToCartOverlay {
  /// Inserts a dismissible overlay entry that lerps [startRect] → [endRect].
  static void show(
    BuildContext context, {
    required Rect startRect,
    required Rect endRect,
    required String imageUrl,
  }) {
    if (MediaQuery.of(context).disableAnimations) {
      return;
    }
    final OverlayState? overlay = Overlay.maybeOf(context);
    if (overlay == null) {
      return;
    }
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (BuildContext ctx) => _FlyingThumbnail(
        startRect: startRect,
        endRect: endRect,
        imageUrl: imageUrl,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }
}

class _FlyingThumbnail extends StatefulWidget {
  const _FlyingThumbnail({
    required this.startRect,
    required this.endRect,
    required this.imageUrl,
    required this.onDone,
  });

  final Rect startRect;
  final Rect endRect;
  final String imageUrl;
  final VoidCallback onDone;

  @override
  State<_FlyingThumbnail> createState() => _FlyingThumbnailState();
}

class _FlyingThumbnailState extends State<_FlyingThumbnail>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 420),
  );

  late final Animation<double> _t = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInCubic,
  );

  @override
  void initState() {
    super.initState();
    _controller.forward().whenComplete(widget.onDone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SizedBox.expand(
        child: AnimatedBuilder(
          animation: _t,
          builder: (BuildContext context, Widget? child) {
            final double k = _t.value;
            final Rect r = Rect.lerp(widget.startRect, widget.endRect, k)!;
            final double side =
                lerpDouble(widget.startRect.shortestSide * 0.35,
                        widget.endRect.shortestSide * 0.85, k) ??
                    widget.startRect.shortestSide * 0.35;
            final double cx = r.center.dx - side / 2;
            final double cy = r.center.dy - side / 2;
            return Stack(
              children: <Widget>[
                Positioned(
                  left: cx,
                  top: cy,
                  width: side,
                  height: side,
                  child: Opacity(
                    opacity: 1 - (k * 0.35),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: widget.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
