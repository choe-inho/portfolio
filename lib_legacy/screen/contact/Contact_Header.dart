import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/route/App_Routes.dart';
import 'package:portfolio/util/theme/App_Colors.dart';

import '../../controller/Admin_Contoller.dart';
import '../../util/config/Font_Sizes.dart';

class ContactHeader extends StatelessWidget {
  const ContactHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return const _MobileHeader();
      } else {
        return const _DesktopHeader();
      }
    });
  }
}

/// 데스크톱/태블릿 헤더
class _DesktopHeader extends StatelessWidget {
  const _DesktopHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL * 1.5,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.successContainer.withValues(alpha: 0.3),
            theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          FadeInAnimation(
            duration: const Duration(milliseconds: 800),
            child: _HeaderTitle(), // ⭐ 숨겨진 제스처 포함
          ),
          SizedBox(height: constants.spacingM),
          SlideInAnimation(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 800),
            child: _HeaderSubtitle(),
          ),
          SizedBox(height: constants.spacingL),
          SlideInAnimation(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 800),
            child: _HeaderDescription(),
          ),
        ],
      ),
    );
  }
}

/// 모바일 헤더
class _MobileHeader extends StatelessWidget {
  const _MobileHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.largePadding(context)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            theme.colorScheme.successContainer.withValues(alpha: 0.3),
            theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          FadeInAnimation(
            duration: const Duration(milliseconds: 800),
            child: _HeaderTitle(), // ⭐ 숨겨진 제스처 포함
          ),
          SizedBox(height: constants.spacingS),
          SlideInAnimation(
            delay: const Duration(milliseconds: 200),
            duration: const Duration(milliseconds: 800),
            child: _HeaderSubtitle(),
          ),
          SizedBox(height: constants.spacingM),
          SlideInAnimation(
            delay: const Duration(milliseconds: 400),
            duration: const Duration(milliseconds: 800),
            child: _HeaderDescription(),
          ),
        ],
      ),
    );
  }
}

/// 헤더 타이틀 (숨겨진 제스처 포함)
class _HeaderTitle extends StatefulWidget {
  const _HeaderTitle();

  @override
  State<_HeaderTitle> createState() => _HeaderTitleState();
}

class _HeaderTitleState extends State<_HeaderTitle> {
  int _tapCount = 0;
  DateTime? _lastTapTime;

  void _handleTap() {
    final now = DateTime.now();

    // 2초 이내에 탭한 경우만 카운트
    if (_lastTapTime != null &&
        now.difference(_lastTapTime!) < const Duration(seconds: 2)) {
      _tapCount++;
      debugPrint('🔍 [Contact Header] 탭 카운트: $_tapCount');
    } else {
      _tapCount = 1;
      debugPrint('🔍 [Contact Header] 탭 카운트 초기화');
    }

    _lastTapTime = now;

    // 5번 탭하면 관리자 페이지 접근 시도
    if (_tapCount == 5) {
      debugPrint('🚀 [Contact Header] 5번 탭 감지 - 관리자 페이지 접근 시도');
      _navigateToAdmin();
      _tapCount = 0;
    }
  }

  void _navigateToAdmin() {
    try {
      final adminController = Get.find<AdminController>();
      final theme = Theme.of(context);

      if (adminController.isLoggedIn.value && adminController.isAdmin.value) {
        // 관리자: 페이지 이동
        debugPrint('✅ [Contact Header] 관리자 권한 확인 - 이동');
        Get.toNamed(AppRoutes.contactAdmin);

        // 성공 피드백
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(LucideIcons.check, color: Colors.white),
                const SizedBox(width: 8),
                const Text('관리자 페이지로 이동합니다'),
              ],
            ),
            backgroundColor: theme.colorScheme.success,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        // 권한 없음
        debugPrint('❌ [Contact Header] 관리자 권한 없음');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(LucideIcons.lock, color: Colors.white),
                const SizedBox(width: 8),
                const Text('관리자 권한이 필요합니다'),
              ],
            ),
            backgroundColor: theme.colorScheme.error,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ [Contact Header] 에러 발생: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizes = FontSizes.of(context);
    
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.opaque,
      child: Text(
        'Contact',
        textAlign: TextAlign.center,
        style: theme.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: theme.colorScheme.success,
          fontSize: fontSizes.displayMedium(context)
        ),
      ),
    );
  }
}

/// 헤더 서브타이틀
class _HeaderSubtitle extends StatelessWidget {
  const _HeaderSubtitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizes = FontSizes.of(context);
    
    return Text(
      '연락하기',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        fontWeight: FontWeight.w500,
        fontSize: fontSizes.titleLarge(context)
      ),
    );
  }
}

/// 헤더 설명
class _HeaderDescription extends StatelessWidget {
  const _HeaderDescription();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fontSizes = FontSizes.of(context);
    
    return Text(
      '언제든지 편하게 연락주세요!\n함께 멋진 프로젝트를 만들어가요',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        height: 1.5,
        fontSize: fontSizes.bodyLarge(context)
      ),
    );
  }
}