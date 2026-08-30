import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

/// high-end-visual-design skill: never use linear/ease-in-out — everything
/// moves on a custom spring-like cubic-bezier.
class AppMotion {
  AppMotion._();

  static const Curve spring = Cubic(0.32, 0.72, 0, 1);
  static const Duration fast = Duration(milliseconds: 250);
  static const Duration normal = Duration(milliseconds: 500);
  static const Duration slow = Duration(milliseconds: 800);
}

/// Fades + slides content in shortly after it mounts.
///
/// This is a deliberately lightweight stand-in for the skill's
/// IntersectionObserver scroll-reveal: every page here is a handful of
/// short, single-viewport sections rather than a long feed, so a staggered
/// mount animation reads the same to a visitor without pulling in a
/// viewport-visibility package.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn> {
  bool _visible = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1 : 0,
      duration: AppMotion.slow,
      curve: AppMotion.spring,
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.14),
        duration: AppMotion.slow,
        curve: AppMotion.spring,
        child: AnimatedScale(
          scale: _visible ? 1 : 0.9,
          duration: AppMotion.slow,
          curve: AppMotion.spring,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Scales on hover/press to simulate the skill's "magnetic button" physics.
class MagneticTap extends StatefulWidget {
  const MagneticTap({super.key, required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  State<MagneticTap> createState() => _MagneticTapState();
}

class _MagneticTapState extends State<MagneticTap> {
  bool _hovering = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _pressed ? 0.97 : (_hovering ? 1.02 : 1.0);
    return MouseRegion(
      cursor: widget.onTap == null
          ? MouseCursor.defer
          : SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: scale,
          duration: AppMotion.fast,
          curve: AppMotion.spring,
          child: widget.child,
        ),
      ),
    );
  }
}

/// Pointer-reactive 3D tilt + lift, for a much more "alive" hover feel on
/// bento/glass cards. No-ops gracefully on touch devices (hover never fires).
class TiltCard extends StatefulWidget {
  const TiltCard({super.key, required this.child, this.maxTiltDegrees = 10});

  final Widget child;
  final double maxTiltDegrees;

  @override
  State<TiltCard> createState() => _TiltCardState();
}

class _TiltCardState extends State<TiltCard> {
  double _rotateX = 0;
  double _rotateY = 0;
  double _scale = 1;

  void _onHover(PointerHoverEvent event, Size size) {
    if (size.width == 0 || size.height == 0) return;
    final dx = (event.localPosition.dx / size.width) - 0.5;
    final dy = (event.localPosition.dy / size.height) - 0.5;
    final maxRad = widget.maxTiltDegrees * math.pi / 180;
    setState(() {
      _rotateY = dx * maxRad * 2;
      _rotateX = -dy * maxRad * 2;
      _scale = 1.035;
    });
  }

  void _reset() {
    setState(() {
      _rotateX = 0;
      _rotateY = 0;
      _scale = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return MouseRegion(
          onHover: (event) => _onHover(event, size),
          onExit: (_) => _reset(),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.spring,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0018)
              ..rotateX(_rotateX)
              ..rotateY(_rotateY)
              ..scaleByDouble(_scale, _scale, _scale, 1),
            child: widget.child,
          ),
        );
      },
    );
  }
}
