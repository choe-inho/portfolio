import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import 'app_footer.dart';
import 'nav_bar.dart';

/// Shared page chrome: the animated Ethereal Glass mesh backdrop, a
/// cursor-following spotlight glow, the floating nav, scrollable content,
/// and the footer.
class PageScaffold extends StatefulWidget {
  const PageScaffold({
    super.key,
    required this.currentPath,
    required this.children,
    this.showFooter = true,
  });

  final String currentPath;
  final List<Widget> children;
  final bool showFooter;

  @override
  State<PageScaffold> createState() => _PageScaffoldState();
}

class _PageScaffoldState extends State<PageScaffold> {
  Offset? _pointer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: MouseRegion(
        opaque: false,
        onHover: (event) => setState(() => _pointer = event.localPosition),
        onExit: (_) => setState(() => _pointer = null),
        child: Stack(
          children: [
            const _AnimatedMeshBackdrop(),
            if (_pointer != null) _CursorGlow(position: _pointer!),
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 110),
                  ...widget.children,
                  if (widget.showFooter) const AppFooter(),
                ],
              ),
            ),
            AppNavBar(currentPath: widget.currentPath),
          ],
        ),
      ),
    );
  }
}

/// Soft radial glow that follows the pointer, fixed to the viewport (not the
/// scroll content) — the "cursor tracking" spotlight effect.
class _CursorGlow extends StatelessWidget {
  const _CursorGlow({required this.position});

  final Offset position;
  static const double _size = 480;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Positioned(
        left: position.dx - _size / 2,
        top: position.dy - _size / 2,
        child: Container(
          width: _size,
          height: _size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                AppColors.emerald.withValues(alpha: 0.14),
                AppColors.emerald.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Continuously drifting/pulsing mesh-gradient orbs — replaces the legacy
/// static backdrop with real motion, per the "much louder animation" brief.
class _AnimatedMeshBackdrop extends StatefulWidget {
  const _AnimatedMeshBackdrop();

  @override
  State<_AnimatedMeshBackdrop> createState() => _AnimatedMeshBackdropState();
}

class _AnimatedMeshBackdropState extends State<_AnimatedMeshBackdrop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 20),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: const BoxDecoration(color: AppColors.background),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final t = _controller.value * 2 * math.pi;
            return Stack(
              children: [
                _orb(
                  color: AppColors.purple,
                  baseSize: 380,
                  top: -140 + math.sin(t) * 50,
                  left: -80 + math.cos(t * 0.8) * 40,
                  pulse: 0.85 + math.sin(t) * 0.15,
                ),
                _orb(
                  color: AppColors.blue,
                  baseSize: 440,
                  top: 60 + math.cos(t * 0.7 + 1) * 60,
                  right: -160 + math.sin(t * 0.9) * 40,
                  pulse: 0.85 + math.sin(t + 2) * 0.15,
                ),
                _orb(
                  color: AppColors.emerald,
                  baseSize: 400,
                  bottom: -180 + math.sin(t * 0.6 + 2) * 55,
                  left: 40 + math.cos(t * 0.5) * 50,
                  pulse: 0.85 + math.sin(t + 4) * 0.15,
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _orb({
    required Color color,
    required double baseSize,
    required double pulse,
    double? top,
    double? left,
    double? right,
    double? bottom,
  }) {
    final size = baseSize * pulse;
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withValues(alpha: 0.22),
                color.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
