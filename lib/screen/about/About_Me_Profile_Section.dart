import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/model/About_Me.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../util/animation/Portfolio_Indicator.dart';

class AboutMeProfileSection extends StatelessWidget {
  final AboutMe aboutMe;

  const AboutMeProfileSection({
    super.key,
    required this.aboutMe,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileProfileSection(aboutMe: aboutMe);
      } else {
        return _DesktopProfileSection(aboutMe: aboutMe);
      }
    });
  }
}

/// 데스크톱/태블릿 프로필 섹션
class _DesktopProfileSection extends StatelessWidget {
  final AboutMe aboutMe;

  const _DesktopProfileSection({required this.aboutMe});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: SlideInAnimation(
        delay: const Duration(milliseconds: 400),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽: 프로필 이미지
            Expanded(
              flex: 2,
              child: _ProfileImage(
                imageUrl: aboutMe.profileImage,
              ),
            ),

            SizedBox(width: constants.spacingXXL),

            // 오른쪽: 프로필 정보
            Expanded(
              flex: 3,
              child: _ProfileInfo(aboutMe: aboutMe),
            ),
          ],
        ),
      ),
    );
  }
}

/// 모바일 프로필 섹션
class _MobileProfileSection extends StatelessWidget {
  final AboutMe aboutMe;

  const _MobileProfileSection({required this.aboutMe});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.largePadding(context)),
      child: SlideInAnimation(
        delay: const Duration(milliseconds: 400),
        child: Column(
          children: [
            // 프로필 이미지
            _ProfileImage(
              imageUrl: aboutMe.profileImage,
            ),

            SizedBox(height: constants.spacingXL),

            // 프로필 정보
            _ProfileInfo(aboutMe: aboutMe),
          ],
        ),
      ),
    );
  }
}

/// 프로필 이미지
class _ProfileImage extends StatefulWidget {
  final String imageUrl;

  const _ProfileImage({required this.imageUrl});

  @override
  State<_ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<_ProfileImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    final imageSize = appController.responsive(
      mobile: 200.r,
      tablet: 280.r,
      web: 350.r,
    );

    return Center(
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: imageSize,
          height: imageSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.3),
                blurRadius: 40,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: widget.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => _ImagePlaceholder(),
              errorWidget: (context, url, error) => _ImageError(),
            ),
          ),
        ),
      ),
    );
  }
}

/// 이미지 로딩 플레이스홀더 - Coding Animation 인디케이터 사용
class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Center(
        child: PortfolioLoadingIndicator(
          style: IndicatorStyle.codingAnimation,
          size: constants.smallIndicatorSize(context),
        ),
      ),
    );
  }
}

/// 이미지 에러
class _ImageError extends StatelessWidget {
  const _ImageError();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: theme.colorScheme.surfaceVariant,
      child: Icon(
        LucideIcons.user,
        size: 80.r,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// 프로필 정보
class _ProfileInfo extends StatelessWidget {
  final AboutMe aboutMe;

  const _ProfileInfo({required this.aboutMe});

  int _calculateAge(DateTime birthDay) {
    final now = DateTime.now();
    int age = now.year - birthDay.year;
    if (now.month < birthDay.month ||
        (now.month == birthDay.month && now.day < birthDay.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final age = _calculateAge(aboutMe.birthDay);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 이름
        FadeInAnimation(
          delay: const Duration(milliseconds: 600),
          child: Text(
            aboutMe.name,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),

        SizedBox(height: constants.spacingM),

        // 나이 정보
        FadeInAnimation(
          delay: const Duration(milliseconds: 700),
          child: _InfoRow(
            icon: LucideIcons.cake,
            label: '나이',
            value: '$age세',
          ),
        ),

        SizedBox(height: constants.spacingS),

        // 생년월일
        FadeInAnimation(
          delay: const Duration(milliseconds: 750),
          child: _InfoRow(
            icon: LucideIcons.calendar,
            label: '생년월일',
            value: '${aboutMe.birthDay.year}.${aboutMe.birthDay.month.toString().padLeft(2, '0')}.${aboutMe.birthDay.day.toString().padLeft(2, '0')}',
          ),
        ),

        SizedBox(height: constants.spacingXL),

        // 구분선
        Divider(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),

        SizedBox(height: constants.spacingXL),

        // 자기소개 타이틀
        FadeInAnimation(
          delay: const Duration(milliseconds: 800),
          child: Row(
            children: [
              Icon(
                LucideIcons.messageSquare,
                size: constants.iconSize(context),
                color: theme.colorScheme.primary,
              ),
              SizedBox(width: constants.spacingS),
              Text(
                '자기소개',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: constants.spacingM),

        // 자기소개 내용
        FadeInAnimation(
          delay: const Duration(milliseconds: 900),
          child: Container(
            padding: EdgeInsets.all(constants.spacingL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(
                constants.borderRadius(context),
              ),
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Text(
              aboutMe.produce,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.7,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 정보 행
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Row(
      children: [
        // 아이콘
        Container(
          width: 36.r,
          height: 36.r,
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(
              constants.smallBorderRadius(context),
            ),
          ),
          child: Icon(
            icon,
            size: 18.r,
            color: theme.colorScheme.primary,
          ),
        ),

        SizedBox(width: constants.spacingM),

        // 라벨과 값
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
            ),
            Text(
              value,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ],
    );
  }
}