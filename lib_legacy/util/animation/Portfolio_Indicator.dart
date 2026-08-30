import 'package:flutter/material.dart';
import 'package:portfolio/util/config/App_Constants.dart';

/// 포트폴리오 전용 커스텀 로딩 인디케이터
///
/// 사용 가능한 스타일:
/// - IndicatorStyle.emeraldPulse: 에메랄드 펄스 효과
/// - IndicatorStyle.orbitingDots: 궤도 회전 도트
/// - IndicatorStyle.waveDots: 웨이브 도트
/// - IndicatorStyle.codingAnimation: 코딩 애니메이션
/// - IndicatorStyle.gradientSpinner: 그라데이션 스피너
/// - IndicatorStyle.bouncingBalls: 바운싱 볼
class PortfolioLoadingIndicator extends StatelessWidget {
  final IndicatorStyle style;
  final double? size;
  final Color? color;

  const PortfolioLoadingIndicator({
    super.key,
    this.style = IndicatorStyle.emeraldPulse,
    this.size,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final indicatorSize = size ?? constants.defaultIndicatorSize(context);

    switch (style) {
      case IndicatorStyle.emeraldPulse:
        return EmeraldPulseIndicator(size: indicatorSize, color: color);
      case IndicatorStyle.orbitingDots:
        return OrbitingDotsIndicator(size: indicatorSize, color: color);
      case IndicatorStyle.waveDots:
        return WaveDotsIndicator(size: indicatorSize, color: color);
      case IndicatorStyle.codingAnimation:
        return CodingAnimationIndicator(size: indicatorSize, color: color);
      case IndicatorStyle.gradientSpinner:
        return GradientSpinnerIndicator(size: indicatorSize, color: color);
      case IndicatorStyle.bouncingBalls:
        return BouncingBallsIndicator(size: indicatorSize, color: color);
    }
  }
}

enum IndicatorStyle {
  emeraldPulse,
  orbitingDots,
  waveDots,
  codingAnimation,
  gradientSpinner,
  bouncingBalls,
}

/// 1. 에메랄드 펄스 인디케이터 (추천! 브랜드 컬러와 잘 어울림)
/// 동심원이 펄스처럼 퍼져나가는 효과
class EmeraldPulseIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const EmeraldPulseIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<EmeraldPulseIndicator> createState() => _EmeraldPulseIndicatorState();
}

class _EmeraldPulseIndicatorState extends State<EmeraldPulseIndicator>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      3,
          (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 2000),
      )..repeat(),
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controllers[index],
          curve: Interval(
            index * 0.2,
            1.0,
            curve: Curves.easeOut,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _animations[index],
            builder: (context, child) {
              return Transform.scale(
                scale: _animations[index].value,
                child: Opacity(
                  opacity: 1.0 - _animations[index].value,
                  child: Container(
                    width: widget.size,
                    height: widget.size,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color,
                        width: 3,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// 2. 궤도 회전 도트 인디케이터 (추천! 모던하고 우아함)
/// 3개의 도트가 원 궤도를 따라 회전
class OrbitingDotsIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const OrbitingDotsIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<OrbitingDotsIndicator> createState() => _OrbitingDotsIndicatorState();
}

class _OrbitingDotsIndicatorState extends State<OrbitingDotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(3, (index) {
              final angle = (_controller.value * 2 * 3.14159) + (index * 2 * 3.14159 / 3);
              final radius = widget.size / 3;

              return Transform.translate(
                offset: Offset(
                  radius * cos(angle),
                  radius * sin(angle),
                ),
                child: Container(
                  width: widget.size / 6,
                  height: widget.size / 6,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.5),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  double cos(double angle) => angle.toString().contains('-')
      ? -angle.abs()
      : angle.abs();

  double sin(double angle) => angle;
}

/// 3. 웨이브 도트 인디케이터 (귀엽고 친근한 느낌)
/// 5개의 도트가 웨이브처럼 상하로 움직임
class WaveDotsIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const WaveDotsIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<WaveDotsIndicator> createState() => _WaveDotsIndicatorState();
}

class _WaveDotsIndicatorState extends State<WaveDotsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final value = (((_controller.value + (index * 0.2)) % 1.0) * 2 - 1).abs();

              return Transform.translate(
                offset: Offset(0, -widget.size / 4 * value),
                child: Container(
                  width: widget.size / 8,
                  height: widget.size / 8,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.6 + (0.4 * value)),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

/// 4. 코딩 애니메이션 인디케이터 (개발자스러운 느낌)
/// < / > 심볼이 회전하며 깜빡임
class CodingAnimationIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const CodingAnimationIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<CodingAnimationIndicator> createState() => _CodingAnimationIndicatorState();
}

class _CodingAnimationIndicatorState extends State<CodingAnimationIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _opacityController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();

    _opacityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _opacityController]),
        builder: (context, child) {
          return Opacity(
            opacity: 0.5 + (_opacityController.value * 0.5),
            child: Transform.rotate(
              angle: _rotationController.value * 2 * 3.14159,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // <
                  Positioned(
                    left: 0,
                    child: Text(
                      '<',
                      style: TextStyle(
                        fontSize: widget.size / 2,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  // /
                  Text(
                    '/',
                    style: TextStyle(
                      fontSize: widget.size / 2,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  // >
                  Positioned(
                    right: 0,
                    child: Text(
                      '>',
                      style: TextStyle(
                        fontSize: widget.size / 2,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 5. 그라데이션 스피너 (고급스러운 느낌)
/// 그라데이션이 있는 원형 스피너
class GradientSpinnerIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const GradientSpinnerIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<GradientSpinnerIndicator> createState() => _GradientSpinnerIndicatorState();
}

class _GradientSpinnerIndicatorState extends State<GradientSpinnerIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * 3.14159,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: SweepGradient(
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                    color.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.3, 0.6, 1.0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 6. 바운싱 볼 인디케이터 (활동적인 느낌)
/// 3개의 볼이 번갈아가며 위아래로 바운스
class BouncingBallsIndicator extends StatefulWidget {
  final double size;
  final Color? color;

  const BouncingBallsIndicator({
    super.key,
    required this.size,
    this.color,
  });

  @override
  State<BouncingBallsIndicator> createState() => _BouncingBallsIndicatorState();
}

class _BouncingBallsIndicatorState extends State<BouncingBallsIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = widget.color ?? theme.colorScheme.primary;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(3, (index) {
          return AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final delay = index * 0.2;
              final value = ((_controller.value - delay) % 1.0).clamp(0.0, 1.0);
              final bounce = (1 - (value * 2 - 1).abs());

              return Transform.translate(
                offset: Offset(0, -widget.size / 3 * bounce),
                child: Container(
                  width: widget.size / 5,
                  height: widget.size / 5,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.3),
                        blurRadius: 4 + (bounce * 4),
                        offset: Offset(0, 2 + (bounce * 2)),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}