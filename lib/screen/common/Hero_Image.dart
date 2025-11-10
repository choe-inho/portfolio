import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';

/// Hero 이미지 - 원형 배경만 제공 (내부 아이콘은 별도 추가)
class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;

  late Animation<double> _floatAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    // Float Animation (위아래로 부드럽게 떠다니는 효과)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(
      begin: -8,
      end: 8,
    ).animate(CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    ));

    // Glow Animation (빛나는 효과)
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(
      begin: 0.4,
      end: 0.7,
    ).animate(CurvedAnimation(
      parent: _glowController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 280.r,
      tablet: 350.r,
      web: 450.r,
    );

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([
          _floatController,
          _glowController,
        ]),
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatAnimation.value),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Glow effect (외부 빛)
                _GlowEffect(
                  size: imageSize * 1.3,
                  glowOpacity: _glowAnimation.value,
                ),

                // Main Circle Background (여기에 아이콘 추가)
                _CircleBackground(
                  size: imageSize,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Glow Effect Widget
class _GlowEffect extends StatelessWidget {
  final double size;
  final double glowOpacity;

  const _GlowEffect({
    required this.size,
    required this.glowOpacity,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(
              alpha: glowOpacity * 0.5,
            ),
            blurRadius: 80,
            spreadRadius: 30,
          ),
          BoxShadow(
            color: theme.colorScheme.tertiary.withValues(
              alpha: glowOpacity * 0.3,
            ),
            blurRadius: 60,
            spreadRadius: 20,
          ),
        ],
      ),
    );
  }
}

/// Circle Background - 원형 배경만 (내부에 아이콘 추가 가능)
class _CircleBackground extends StatelessWidget {
  final double size;

  const _CircleBackground({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            theme.colorScheme.primary.withValues(alpha: 0.9),
            theme.colorScheme.primary.withValues(alpha: 0.7),
            theme.colorScheme.tertiary.withValues(alpha: 0.8),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      // 여기에 아이콘 추가
      child: Center(
        child: Image.asset(
          'assets/icon/icon_only_logo.png', // 원하는 아이콘 경로로 변경
          width: size * 0.55,
          height: size * 0.55,
          fit: BoxFit.contain,
          color: const Color(0xfffafafa),
        ),
      ),
    );
  }
}