import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/About_Me_Controller.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/model/Time_Line.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/helper/DateTime_Utils.dart';

import '../../util/animation/Portfolio_Indicator.dart';
import '../../util/config/Font_Sizes.dart';

class AboutMeTimelineSection extends StatelessWidget {
  const AboutMeTimelineSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final controller = Get.find<AboutMeController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: Obx(() {
        // 타임라인 데이터 로딩 중
        if (!controller.timelineFetching.value) {
          return _LoadingState();
        }

        // 타임라인 데이터가 없을 때
        if (controller.timeLine == null || controller.timeLine!.isEmpty) {
          return _EmptyState();
        }

        // 정상 상태 - 타임라인 표시
        return Column(
          children: [
            // 섹션 타이틀
            FadeInAnimation(
              delay: const Duration(milliseconds: 300),
              child: _SectionTitle(),
            ),

            SizedBox(height: constants.spacingXL),

            // 타임라인
            _Timeline(timelines: controller.timeLine!),
          ],
        );
      }),
    );
  }
}

/// 로딩 상태
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final fontSizes = FontSizes.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          PortfolioLoadingIndicator(
            style: IndicatorStyle.codingAnimation,
            size: constants.smallIndicatorSize(context),
          ),
          SizedBox(height: constants.spacingM),
          Text(
            '경력 & 학력 정보를 불러오는 중...',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              fontSize: fontSizes.bodyMedium(context)
            ),
          ),
        ],
      ),
    );
  }
}

/// 빈 상태
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final fontSizes = FontSizes.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(constants.largePadding(context)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              LucideIcons.calendar,
              size: 48,
              color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
            ),
            SizedBox(height: constants.spacingM),
            Text(
              '등록된 경력 & 학력 정보가 없습니다',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                fontSize: fontSizes.bodyMedium(context)
              ),
            ),
          ],
        ),
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
    final fontSizes = FontSizes.of(context);

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
                fontSize: fontSizes.headlineMedium(context)
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
            fontSize: fontSizes.bodyLarge(context)
          ),
        ),
      ],
    );
  }
}

/// 타임라인
class _Timeline extends StatelessWidget {
  final List<TimeLine> timelines;

  const _Timeline({required this.timelines});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileTimeline(timelines: timelines);
      } else {
        return _DesktopTimeline(timelines: timelines);
      }
    });
  }
}

/// 데스크톱 타임라인
class _DesktopTimeline extends StatelessWidget {
  final List<TimeLine> timelines;

  const _DesktopTimeline({required this.timelines});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Column(
      children: timelines.asMap().entries.map((entry) {
        final index = entry.key;
        final timeline = entry.value;

        return SlideInAnimation(
          delay: Duration(milliseconds: 500 + (index * 150)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index < timelines.length - 1 ? constants.spacingXL : 0,
            ),
            child: _TimelineItem(
              timeline: timeline,
              isLast: index == timelines.length - 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 모바일 타임라인
class _MobileTimeline extends StatelessWidget {
  final List<TimeLine> timelines;

  const _MobileTimeline({required this.timelines});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Column(
      children: timelines.asMap().entries.map((entry) {
        final index = entry.key;
        final timeline = entry.value;

        return SlideInAnimation(
          delay: Duration(milliseconds: 500 + (index * 150)),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: index < timelines.length - 1 ? constants.spacingL : 0,
            ),
            child: _TimelineItem(
              timeline: timeline,
              isLast: index == timelines.length - 1,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 타임라인 아이템
class _TimelineItem extends StatefulWidget {
  final TimeLine timeline;
  final bool isLast;

  const _TimelineItem({
    required this.timeline,
    required this.isLast,
  });

  @override
  State<_TimelineItem> createState() => _TimelineItemState();
}

class _TimelineItemState extends State<_TimelineItem> {
  bool _isHovered = false;

  // 기간 문자열 생성
  String _getPeriodString() {
    final startStr = DateTimeUtils.timelineToText(widget.timeline.startDate);
    final endStr = DateTimeUtils.timelineToText(widget.timeline.endDate);
    return '$startStr - $endStr';
  }

  // 기간 계산 (개월 수)
  String _getDuration() {
    final start = widget.timeline.startDate;
    final end = widget.timeline.endDate;

    final months = (end.year - start.year) * 12 + (end.month - start.month);

    if (months < 12) {
      return '$months개월';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      if (remainingMonths == 0) {
        return '$years년';
      } else {
        return '$years년 $remainingMonths개월';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();
    final fontSizes = FontSizes.of(context);

    // 타입에 따른 색상
    final color = widget.timeline.type == TimeLineType.education
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
                    widget.timeline.iconData,
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
                    // 기간 및 타입 배지
                    Row(
                      children: [
                        // 기간 배지
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
                            _getPeriodString(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                              fontSize: fontSizes.bodySmall(context)
                            ),
                          ),
                        ),

                        SizedBox(width: constants.spacingS),

                        // 기간 표시
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: constants.spacingM,
                            vertical: constants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(
                              constants.pillBorderRadius(context),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                LucideIcons.clock,
                                size: 12.r,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              SizedBox(width: constants.spacingXS),
                              Text(
                                _getDuration(),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                  fontSize: fontSizes.bodySmall(context)
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: constants.spacingM),

                    // 타이틀
                    Text(
                      widget.timeline.title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                        fontSize: fontSizes.titleLarge(context)
                      ),
                    ),

                    SizedBox(height: constants.spacingXS),

                    // 서브타이틀
                    Text(
                      widget.timeline.subTitle,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        fontSize: fontSizes.bodyLarge(context)
                      ),
                    ),

                    SizedBox(height: constants.spacingM),

                    // 설명
                    Text(
                      widget.timeline.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                        height: 1.6,
                        fontSize: fontSizes.bodyMedium(context)
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