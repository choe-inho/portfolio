import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class AboutMeHeader extends StatelessWidget {
  const AboutMeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileHeader();
      } else {
        return _DesktopHeader();
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
            theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
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
            theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
            theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2),
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
      'About Me',
      textAlign: TextAlign.center,
      style: theme.textTheme.displayMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.primary,
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
      '저에 대해 소개합니다',
      textAlign: TextAlign.center,
      style: theme.textTheme.titleLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}