import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:portfolio/controller/About_Me_Controller.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Indicator.dart';

import '../../util/config/Font_Sizes.dart';

/// Hero 섹션 프로필 이미지
/// AboutMeController에서 프로필 이미지를 가져와 표시합니다.
/// - 무한 로딩 해결: Get.find로 기존 컨트롤러 사용
/// - 애니메이션 제거: 깔끔한 정적 이미지
/// - 사각형 디자인: borderRadius 적용
/// - 자연스러운 그림자
class HeroImage extends StatelessWidget {
  const HeroImage({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 350.r,
      tablet: 350.r,
      web: 350.r,
    );

    return Center(
      child: _ProfileImage(size: imageSize),
    );
  }
}

/// 프로필 이미지 Widget
class _ProfileImage extends StatefulWidget {
  final double size;

  const _ProfileImage({
    required this.size,
  });

  @override
  State<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage> {
  bool _hasLogged = false; // 로그 한 번만 찍기 위한 플래그

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // 🔥 중요: init 사용하지 않고 Get.find로 기존 컨트롤러 사용
    // AboutMeController는 AboutMePage에서 이미 초기화됨
    try {
      final controller = Get.find<AboutMeController>();

      return Obx(() {
        // 데이터 로딩 중이거나 없는 경우
        if (!controller.aboutMeFetching.value || controller.aboutMe == null) {
          if (!_hasLogged) {
            debugPrint('⏳ [Hero Image] 프로필 데이터 로딩 중...');
            _hasLogged = true;
          }
          return _PlaceholderImage(size: widget.size);
        }

        final profileImageUrl = controller.aboutMe!.profileImage;

        // 로그는 단 한 번만 출력
        if (!_hasLogged) {
          debugPrint('📸 [Hero Image] 프로필 이미지 로드 시작');
          debugPrint('🔗 [Hero Image] URL: $profileImageUrl');
          _hasLogged = true;
        }

        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r), // 둥근 사각형
            boxShadow: [
              // 자연스러운 그림자 (다층)
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 40,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 60,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.r),
            child: CachedNetworkImage(
              imageUrl: profileImageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) {
                return _LoadingPlaceholder(size: widget.size);
              },
              errorWidget: (context, url, error) {
                debugPrint('❌ [Hero Image] 이미지 로드 실패: $error');
                return _ErrorPlaceholder(size: widget.size);
              },
              // 로드 완료 시 로그 (한 번만)
              imageBuilder: (context, imageProvider) {
                if (!_hasLogged) {
                  debugPrint('✅ [Hero Image] 이미지 로드 완료');
                }
                return Image(
                  image: imageProvider,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
        );
      });
    } catch (e) {
      // AboutMeController가 아직 초기화되지 않은 경우
      debugPrint('⚠️ [Hero Image] AboutMeController를 찾을 수 없습니다: $e');
      return _PlaceholderImage(size: widget.size);
    }
  }
}

/// 로딩 중 Placeholder
class _LoadingPlaceholder extends StatelessWidget {
  final double size;

  const _LoadingPlaceholder({
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: theme.colorScheme.surfaceContainerHighest,
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.2,
          height: size * 0.2,
          child: PortfolioLoadingIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
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
    final fontSizes = FontSizes.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        color: theme.colorScheme.errorContainer,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: size * 0.3,
            color: theme.colorScheme.error,
          ),
          SizedBox(height: 8.h),
          Text(
            '이미지 로드 실패',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.w600,
              fontSize: fontSizes.bodySmall(context)
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
        borderRadius: BorderRadius.circular(16.r),
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.2,
          height: size * 0.2,
          child: PortfolioLoadingIndicator(
            color: theme.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}