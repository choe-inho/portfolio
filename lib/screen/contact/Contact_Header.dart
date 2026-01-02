import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/theme/App_Colors.dart';

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
            child: _HeaderTitle(),
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
            child: _HeaderTitle(),
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

/// 헤더 타이틀
class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      'Contact',
      textAlign: TextAlign.center,
      style: theme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.success,
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

    return Text(
      '연락하기',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        fontWeight: FontWeight.w500,
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

    return Text(
      '언제든지 편하게 연락주세요!\n함께 멋진 프로젝트를 만들어가요',
      textAlign: TextAlign.center,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
        height: 1.5,
      ),
    );
  }
}