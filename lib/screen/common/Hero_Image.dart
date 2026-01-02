import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/About_Me_Controller.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Indicator.dart';

/// Hero 섹션 프로필 이미지
/// AboutMeController에서 프로필 이미지를 가져와 표시합니다.
/// HTTP 415 에러 해결: URL 검증 및 대체 로딩 방식
class HeroImage extends StatefulWidget {
  const HeroImage({super.key});

  @override
  State<HeroImage> createState() => _HeroImageState();
}

class _HeroImageState extends State<HeroImage> with TickerProviderStateMixin {
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
      mobile: 200.r,
      tablet: 280.r,
      web: 350.r,
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
                  size: imageSize * 1.2,
                  glowOpacity: _glowAnimation.value,
                ),

                // 프로필 이미지
                _ProfileImage(
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
            blurRadius: 60,
            spreadRadius: 10,
          ),
        ],
      ),
    );
  }
}

/// 프로필 이미지 Widget
class _ProfileImage extends StatelessWidget {
  final double size;

  const _ProfileImage({
    required this.size,
  });

  /// Firebase Storage URL 검증 및 수정
  String _sanitizeImageUrl(String url) {
    // 이미 올바른 형식이면 그대로 반환
    if (url.contains('firebasestorage.googleapis.com') && url.contains('alt=media')) {
      debugPrint('✅ [Hero Image] 올바른 URL 형식: $url');
      return url;
    }

    // URL이 Firebase Storage URL인지 확인
    if (url.contains('firebasestorage.googleapis.com')) {
      // alt=media 파라미터가 없으면 추가
      if (!url.contains('alt=media')) {
        final separator = url.contains('?') ? '&' : '?';
        final sanitizedUrl = '$url${separator}alt=media';
        debugPrint('🔧 [Hero Image] URL 수정: $sanitizedUrl');
        return sanitizedUrl;
      }
    }

    debugPrint('⚠️ [Hero Image] 알 수 없는 URL 형식: $url');
    return url;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // AboutMeController에서 프로필 이미지 가져오기
    return GetBuilder<AboutMeController>(
      init: AboutMeController(),
      builder: (controller) {
        // 데이터 로딩 중이거나 없는 경우
        if (!controller.aboutMeFetching.value || controller.aboutMe == null) {
          return _PlaceholderImage(size: size);
        }

        final originalUrl = controller.aboutMe!.profileImage;
        final sanitizedUrl = _sanitizeImageUrl(originalUrl);

        debugPrint('📸 [Hero Image] 프로필 이미지 로드 시작');
        debugPrint('🔗 [Hero Image] Original URL: $originalUrl');
        debugPrint('🔗 [Hero Image] Sanitized URL: $sanitizedUrl');

        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              width: 4,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.2),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: Image.network(
              sanitizedUrl,
              fit: BoxFit.cover,
              // HTTP 헤더 설정 없음 (브라우저 기본값 사용)
              errorBuilder: (context, error, stackTrace) {
                debugPrint('❌ [Hero Image] 이미지 로드 실패');
                debugPrint('❌ [Hero Image] Error: $error');
                debugPrint('❌ [Hero Image] StackTrace: $stackTrace');
                return _ErrorPlaceholder(size: size);
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  debugPrint('✅ [Hero Image] 이미지 로드 완료');
                  return child;
                }

                final progress = loadingProgress.cumulativeBytesLoaded /
                    (loadingProgress.expectedTotalBytes ?? 1);
                debugPrint('⏳ [Hero Image] 로딩 중: ${(progress * 100).toStringAsFixed(0)}%');

                return _LoadingPlaceholder(
                  size: size,
                  progress: progress,
                );
              },
            ),
          ),
        );
      },
    );
  }
}

/// 로딩 중 Placeholder (진행률 표시)
class _LoadingPlaceholder extends StatelessWidget {
  final double size;
  final double progress;

  const _LoadingPlaceholder({
    required this.size,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 진행률 표시
          SizedBox(
            width: size * 0.5,
            height: size * 0.5,
            child: CircularProgressIndicator(
              value: progress,
              color: theme.colorScheme.primary,
              strokeWidth: 3,
            ),
          ),
          // 퍼센트 텍스트
          Text(
            '${(progress * 100).toInt()}%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// 에러 발생 시 Placeholder
class _ErrorPlaceholder extends StatelessWidget {
  final double size;

  const _ErrorPlaceholder({
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
        color: theme.colorScheme.errorContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: size * 0.4,
            color: theme.colorScheme.error,
          ),
          SizedBox(height: 8),
          Text(
            '이미지 로드 실패',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }
}

/// 데이터 로드 전 Placeholder
class _PlaceholderImage extends StatelessWidget {
  final double size;

  const _PlaceholderImage({
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
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 4,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.3,
          height: size * 0.3,
          child: PortfolioLoadingIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}