import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'dart:math' as math;

/// Econoding Hero 이미지 (애니메이션 포함)
class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late AnimationController _glowController;

  late Animation<double> _floatAnimation;
  late Animation<double> _rotateAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Float Animation (위아래로 떠다니는 효과)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Rotate Animation (부드러운 회전)
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_rotateController);

    // Pulse Animation (크기 변화)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    // Glow Animation (빛나는 효과)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.3,
      end: 0.6,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _rotateController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 250.r,
      tablet: 300.r,
      web: 400.r,
    );

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _rotateController,
          _pulseController,
          _glowController,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Transform.scale(
              scale: _pulseAnimation.value,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Glow effect (배경 빛)
                  Container(
                    width: imageSize * 1.2,
                    height: imageSize * 1.2,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(
                            alpha: _glowAnimation.value,
                          ),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                      ],
                    ),
                  ),

                  // Main container
                  Container(
                    width: imageSize,
                    height: imageSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          theme.colorScheme.primaryContainer,
                          theme.colorScheme.secondaryContainer,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 40,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: _rotateAnimation.value * 2 * 3.14159,
                        child: Image.asset(
                          'assets/icon/icon.png',
                          width: imageSize * 0.6,
                          height: imageSize * 0.6,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Orbiting particles (선택적 장식)
                  ..._buildOrbitingParticles(imageSize, theme),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// 궤도를 도는 파티클들 생성
  List<Widget> _buildOrbitingParticles(double imageSize, ThemeData theme) {
    return List.generate(3, (index) {
      final angle = (index / 3) * 2 * math.pi + (_rotateAnimation.value * 2 * math.pi);
      final radius = imageSize * 0.6;

      return Positioned(
        left: radius * (1 + 0.8 * math.cos(angle)),
        top: radius * (1 + 0.8 * math.sin(angle)),
        child: Container(
          width: 12.r,
          height: 12.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: theme.colorScheme.primary.withValues(alpha: 0.6),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.4),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      );
    });
  }
}

/// 심플 버전 (애니메이션 없음)
class EconodingHeroImageSimple extends StatelessWidget {
  const EconodingHeroImageSimple({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 250.r,
      tablet: 300.r,
      web: 400.r,
    );

    return Center(
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 40,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/icon/icon.png',
            width: imageSize * 0.6,
            height: imageSize * 0.6,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

/// 호버 인터랙션 버전 (웹용)
class HeroImageInteractive extends StatefulWidget {
  const HeroImageInteractive({super.key});

  @override
  State<HeroImageInteractive> createState() =>
      _HeroImageInteractiveState();
}

class _HeroImageInteractiveState
    extends State<HeroImageInteractive>
    with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  bool _isHovered = false;

  @override
  void initState() {
    super.initState();

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 0.1,
    ).animate(CurvedAnimation(
      parent: _hoverController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _hoverController.forward();
    } else {
      _hoverController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 250.r,
      tablet: 300.r,
      web: 400.r,
    );

    return Center(
      child: MouseRegion(
        onEnter: (_) => _onHoverChanged(true),
        onExit: (_) => _onHoverChanged(false),
        cursor: SystemMouseCursors.click,
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  width: imageSize,
                  height: imageSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        theme.colorScheme.primaryContainer,
                        theme.colorScheme.secondaryContainer,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.primary.withValues(
                          alpha: _isHovered ? 0.5 : 0.3,
                        ),
                        blurRadius: _isHovered ? 60 : 40,
                        offset: Offset(0, _isHovered ? 15 : 10),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Image.asset(
                      'assets/icon/icon.png',
                      width: imageSize * 0.6,
                      height: imageSize * 0.6,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}