import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/model/About_Me.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class AboutMeStrengthSection extends StatelessWidget {
  final AboutMe aboutMe;

  const AboutMeStrengthSection({
    super.key,
    required this.aboutMe,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.3),
      ),
      child: Column(
        children: [
          // 섹션 타이틀
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: _SectionTitle(),
          ),

          SizedBox(height: constants.spacingXL),

          // 강점 카드 리스트 (모바일도 그리드로 변경)
          SlideInAnimation(
            delay: const Duration(milliseconds: 500),
            child: _StrengthCardList(
              strengthText: aboutMe.strength,
            ),
          ),
        ],
      ),
    );
  }
}

/// 섹션 타이틀
class _SectionTitle extends StatelessWidget {
  const _SectionTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.award,
              size: constants.iconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '나의 강점',
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
        SizedBox(height: constants.spacingS),
        Text(
          '제가 가진 핵심 역량입니다',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 강점 카드 리스트
class _StrengthCardList extends StatelessWidget {
  final String strengthText;

  const _StrengthCardList({required this.strengthText});

  // 강점 텍스트를 파싱하여 리스트로 변환
  List<Map<String, String>> _parseStrengths(String text) {
    // 예시: "협업 능력|팀워크|소통" 형태로 저장되어 있다고 가정
    // 또는 줄바꿈으로 구분된 텍스트
    final strengths = <Map<String, String>>[];

    // 여기서는 줄바꿈으로 구분된다고 가정
    final lines = text.split('\n');

    final icons = [
      LucideIcons.users,
      LucideIcons.target,
      LucideIcons.zap,
      LucideIcons.heart,
      LucideIcons.lightbulb,
      LucideIcons.shield,
    ];

    for (int i = 0; i < lines.length && i < 6; i++) {
      final line = lines[i].trim();
      if (line.isNotEmpty) {
        // "|"로 구분하여 제목과 설명 분리 (선택적)
        final parts = line.split('|');
        strengths.add({
          'title': parts[0].trim(),
          'description': parts.length > 1 ? parts[1].trim() : '',
          'icon': icons[i % icons.length].toString(),
        });
      }
    }

    return strengths;
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final constants = AppConstants.of(context);
    final strengths = _parseStrengths(strengthText);

    return Obx(() {
      // 모바일, 태블릿, 웹 모두 그리드로 표시
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: appController.responsive(
            mobile: 3, // 모바일: 3열 (1줄에 3개씩, 총 2줄로 6개 표시)
            tablet: 2,  // 태블릿: 2열
            web: 3,     // 웹: 3열
          ),
          crossAxisSpacing: appController.responsive(
            mobile: constants.spacingS,  // 모바일: 작은 간격
            tablet: constants.spacingL,
            web: constants.spacingL,
          ),
          mainAxisSpacing: appController.responsive(
            mobile: constants.spacingS,  // 모바일: 작은 간격
            tablet: constants.spacingL,
            web: constants.spacingL,
          ),
          childAspectRatio: appController.responsive(
            mobile: 0.75, // 모바일: 세로로 더 긴 비율 (설명 텍스트 포함)
            tablet: 1.3,
            web: 1.3,
          ),
        ),
        itemCount: strengths.length,
        itemBuilder: (context, index) {
          final strength = strengths[index];
          return FadeInAnimation(
            delay: Duration(milliseconds: 600 + (index * 100)),
            child: _StrengthCard(
              title: strength['title']!,
              description: strength['description']!,
              index: index,
            ),
          );
        },
      );
    });
  }
}

/// 강점 카드
class _StrengthCard extends StatefulWidget {
  final String title;
  final String description;
  final int index;

  const _StrengthCard({
    required this.title,
    required this.description,
    required this.index,
  });

  @override
  State<_StrengthCard> createState() => _StrengthCardState();
}

class _StrengthCardState extends State<_StrengthCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // 카드별 아이콘 (순환)
  static const List<IconData> _icons = [
    LucideIcons.users,
    LucideIcons.target,
    LucideIcons.zap,
    LucideIcons.heart,
    LucideIcons.lightbulb,
    LucideIcons.shield,
  ];

  // 카드별 색상 (순환)
  static List<Color> _getColors(BuildContext context) {
    final theme = Theme.of(context);
    return [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
      theme.colorScheme.error,
      const Color(0xFF10B981), // 에메랄드
      const Color(0xFF8B5CF6), // 퍼플
    ];
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHoverChanged(bool isHovered) {
    setState(() => _isHovered = isHovered);
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();
    final icon = _icons[widget.index % _icons.length];
    final colors = _getColors(context);
    final color = colors[widget.index % colors.length];

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          padding: EdgeInsets.all(
            appController.responsive(
              mobile: constants.spacingS,  // 모바일: 작은 패딩
              tablet: constants.spacingL,
              web: constants.spacingL,
            ),
          ),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              constants.largeBorderRadius(context),
            ),
            border: Border.all(
              color: _isHovered
                  ? color.withValues(alpha: 0.5)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 아이콘
              _CardIcon(
                icon: icon,
                color: color,
                isHovered: _isHovered,
              ),

              SizedBox(height: appController.responsive(
                mobile: constants.spacingXS,  // 모바일: 작은 간격
                tablet: constants.spacingM,
                web: constants.spacingM,
              )),

              // 타이틀
              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: appController.responsive(
                  mobile: 2,  // 모바일: 최대 2줄
                  tablet: 1,
                  web: 1,
                ),
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: appController.responsive(
                    mobile: 12.sp,  // 모바일: 작은 폰트
                    tablet: 18.sp,
                    web: 22.sp,
                  ),
                  color: theme.colorScheme.onSurface,
                ),
              ),

              // 설명이 있을 경우 (모든 디바이스에서 표시)
              if (widget.description.isNotEmpty) ...[
                SizedBox(height: appController.responsive(
                  mobile: constants.spacingXS,
                  tablet: constants.spacingS,
                  web: constants.spacingS,
                )),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  maxLines: appController.responsive(
                    mobile: 2,  // 모바일: 2줄
                    tablet: 2,
                    web: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: appController.responsive(
                      mobile: 10.sp,  // 모바일: 작은 폰트
                      tablet: 14.sp,
                      web: 14.sp,
                    ),
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// 카드 아이콘
class _CardIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final bool isHovered;

  const _CardIcon({
    required this.icon,
    required this.color,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return AnimatedContainer(
      duration: constants.fastAnimation,
      width: appController.responsive(
        mobile: 40.r,  // 모바일: 작은 아이콘 컨테이너
        tablet: 64.r,
        web: 64.r,
      ),
      height: appController.responsive(
        mobile: 40.r,
        tablet: 64.r,
        web: 64.r,
      ),
      decoration: BoxDecoration(
        color: isHovered
            ? color.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: appController.responsive(
            mobile: 20.r,  // 모바일: 작은 아이콘
            tablet: 32.r,
            web: 32.r,
          ),
          color: color,
        ),
      ),
    );
  }
}