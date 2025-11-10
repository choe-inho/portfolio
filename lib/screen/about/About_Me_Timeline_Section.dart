import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class AboutMeTimelineSection extends StatelessWidget {
  const AboutMeTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: Column(
        children: [
          // 섹션 타이틀
          FadeInAnimation(
            delay: const Duration(milliseconds: 300),
            child: _SectionTitle(),
          ),

          SizedBox(height: constants.spacingXL),

          // 타임라인
          _Timeline(),
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
              LucideIcons.clock,
              size: constants.iconSize(context),
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '경력 & 학력',
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
          '제가 걸어온 길입니다',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 타임라인
class _Timeline extends StatelessWidget {
  const _Timeline();

  // TODO: 실제 데이터는 Firestore에서 가져올 예정
  static final List<Map<String, dynamic>> _timelineData = [
    {
      'type': 'education', // education or career
      'title': '울산대학교',
      'subtitle': '컴퓨터정보통신공학부',
      'period': '2019.03 - 2025.02',
      'description': '컴퓨터과학 전공, 학점 4.0/4.5',
      'icon': LucideIcons.graduationCap,
    },
    {
      'type': 'career',
      'title': '프리랜서 개발자',
      'subtitle': 'Flutter 앱 개발',
      'period': '2023.01 - 2024.12',
      'description': 'Flutter를 활용한 크로스플랫폼 앱 개발',
      'icon': LucideIcons.briefcase,
    },
    {
      'type': 'career',
      'title': '스타트업 A',
      'subtitle': 'Flutter 개발자',
      'period': '2024.01 - 현재',
      'description': '사내 앱 서비스 개발 및 유지보수',
      'icon': LucideIcons.building,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileTimeline(data: _timelineData);
      } else {
        return _DesktopTimeline(data: _timelineData);
      }
    });
  }
}

/// 데스크톱 타임라인
class _DesktopTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _DesktopTimeline({required this.data});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Column(
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return SlideInAnimation(
          delay: Duration(milliseconds: 500 + (index * 150)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index < data.length - 1 ? constants.spacingXL : 0,
            ),
            child: _TimelineItem(
              type: item['type'],
              title: item['title'],
              subtitle: item['subtitle'],
              period: item['period'],
              description: item['description'],
              icon: item['icon'],
              isLast: index == data.length - 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 모바일 타임라인
class _MobileTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const _MobileTimeline({required this.data});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Column(
      children: data.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return SlideInAnimation(
          delay: Duration(milliseconds: 500 + (index * 150)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index < data.length - 1 ? constants.spacingL : 0,
            ),
            child: _TimelineItem(
              type: item['type'],
              title: item['title'],
              subtitle: item['subtitle'],
              period: item['period'],
              description: item['description'],
              icon: item['icon'],
              isLast: index == data.length - 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 타임라인 아이템
class _TimelineItem extends StatefulWidget {
  final String type;
  final String title;
  final String subtitle;
  final String period;
  final String description;
  final IconData icon;
  final bool isLast;

  const _TimelineItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.icon,
    required this.isLast,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    // 타입에 따른 색상
    final color = widget.type == 'education'
        ? theme.colorScheme.primary
        : theme.colorScheme.tertiary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 타임라인 라인 & 아이콘
            Column(
              children: [
                // 아이콘
                AnimatedContainer(
                  duration: constants.fastAnimation,
                  width: appController.responsive(
                    mobile: 48.r,
                    tablet: 56.r,
                    web: 64.r,
                  ),
                  height: appController.responsive(
                    mobile: 48.r,
                    tablet: 56.r,
                    web: 64.r,
                  ),
                  decoration: BoxDecoration(
                    color: _isHovered
                        ? color.withValues(alpha: 0.2)
                        : color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: color,
                      width: _isHovered ? 3 : 2,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    size: appController.responsive(
                      mobile: 24.r,
                      tablet: 28.r,
                      web: 32.r,
                    ),
                    color: color,
                  ),
                ),

                // 연결선 (마지막 아이템이 아닌 경우)
                if (!widget.isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: theme.colorScheme.outline.withValues(alpha: 0.3),
                    ),
                  ),
              ],
            ),

            SizedBox(width: constants.spacingL),

            // 콘텐츠 카드
            Expanded(
              child: AnimatedContainer(
                duration: constants.fastAnimation,
                padding: EdgeInsets.all(constants.spacingL),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(
                    constants.borderRadius(context),
                  ),
                  border: Border.all(
                    color: _isHovered
                        ? color.withValues(alpha: 0.5)
                        : theme.colorScheme.outline.withValues(alpha: 0.2),
                    width: _isHovered ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? color.withValues(alpha: 0.15)
                          : Colors.black.withValues(alpha: 0.05),
                      blurRadius: _isHovered ? 16 : 8,
                      offset: Offset(0, _isHovered ? 6 : 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 기간
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: constants.spacingM,
                        vertical: constants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          constants.pillBorderRadius(context),
                        ),
                      ),
                      child: Text(
                        widget.period,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    SizedBox(height: constants.spacingM),

                    // 타이틀
                    Text(
                      widget.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),

                    SizedBox(height: constants.spacingXS),

                    // 서브타이틀
                    Text(
                      widget.subtitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                    ),

                    SizedBox(height: constants.spacingM),

                    // 설명
                    Text(
                      widget.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}