import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/model/Project.dart';
import 'package:portfolio/util/animation/Portfolio_Indicator.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/helper/DateTime_Utils.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({
    super.key,
    required this.project,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
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

  Future<void> _openNotionLink() async {
    final uri = Uri.parse(widget.project.notion);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Could not launch ${widget.project.notion}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final volumeColor =
    ProjectVolume.stateToTextColor(widget.project.volume, context);

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: _openNotionLink,
          child: AnimatedContainer(
            duration: constants.fastAnimation,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(
                constants.largeBorderRadius(context),
              ),
              border: Border.all(
                color: _isHovered
                    ? volumeColor.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: _isHovered ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? volumeColor.withValues(alpha: 0.2)
                      : Colors.black.withValues(alpha: 0.05),
                  blurRadius: _isHovered ? 20 : 10,
                  offset: Offset(0, _isHovered ? 8 : 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 썸네일 이미지
                _ThumbnailImage(
                  imageUrl: widget.project.thumbnail,
                  isHovered: _isHovered,
                ),

                // 콘텐츠 영역
                Padding(
                  padding: EdgeInsets.all(constants.spacingL),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 프로젝트 타입 & 기간
                      _ProjectMetadata(
                        volume: widget.project.volume,
                        startDate: widget.project.startAt,
                        endDate: widget.project.endAt,
                      ),

                      SizedBox(height: constants.spacingM),

                      // 제목
                      _ProjectTitle(title: widget.project.title),

                      SizedBox(height: constants.spacingS),

                      // 설명
                      _ProjectDescription(
                          description: widget.project.description),

                      SizedBox(height: constants.spacingM),

                      // 스킬 태그
                      _SkillTags(
                        skills: widget.project.skills,
                        volumeColor: volumeColor,
                      ),

                      SizedBox(height: constants.spacingM),

                      // 더보기 버튼
                      _ViewMoreButton(isHovered: _isHovered),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 썸네일 이미지
class _ThumbnailImage extends StatelessWidget {
  final String imageUrl;
  final bool isHovered;

  const _ThumbnailImage({
    required this.imageUrl,
    required this.isHovered,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(constants.largeBorderRadius(context)),
        topRight: Radius.circular(constants.largeBorderRadius(context)),
      ),
      child: Stack(
        children: [
          // 이미지
          AnimatedContainer(
            duration: constants.fastAnimation,
            height: appController.responsive(
              mobile: 180.h,
              tablet: 200.h,
              web: 220.h,
            ),
            width: double.infinity,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => _ImagePlaceholder(),
              errorWidget: (context, url, error) => _ImageError(),
            ),
          ),

          // 호버 오버레이
          if (isHovered)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.0),
                      Colors.black.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// 이미지 로딩 플레이스홀더
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            LucideIcons.image,
            size: 48.r,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          SizedBox(height: 8.h),
          Text(
            '이미지를 불러올 수 없습니다',
            style: TextStyle(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}

/// 프로젝트 메타데이터 (타입 & 기간)
class _ProjectMetadata extends StatelessWidget {
  final ProjectVolume volume;
  final DateTime startDate;
  final DateTime endDate;

  const _ProjectMetadata({
    required this.volume,
    required this.startDate,
    required this.endDate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final volumeColor = ProjectVolume.stateToTextColor(volume, context);
    final volumeText = ProjectVolume.stateToText(volume);

    final periodText =
        '${DateTimeUtils.timelineToText(startDate)} - ${DateTimeUtils.timelineToText(endDate)}';

    return Row(
      children: [
        // 프로젝트 타입 배지
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: constants.spacingM,
            vertical: constants.spacingXS,
          ),
          decoration: BoxDecoration(
            color: volumeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(
              constants.pillBorderRadius(context),
            ),
            border: Border.all(
              color: volumeColor.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Text(
            volumeText,
            style: theme.textTheme.bodySmall?.copyWith(
              color: volumeColor,
              fontWeight: FontWeight.w600,
              fontSize: 11.sp,
            ),
          ),
        ),

        SizedBox(width: constants.spacingS),

        // 기간
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
                LucideIcons.calendar,
                size: 12.r,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: constants.spacingXS),
              Text(
                periodText,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 프로젝트 제목
class _ProjectTitle extends StatelessWidget {
  final String title;

  const _ProjectTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      title,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.w700,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// 프로젝트 설명
class _ProjectDescription extends StatelessWidget {
  final String description;

  const _ProjectDescription({required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      description,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
    );
  }
}

/// 스킬 태그들
class _SkillTags extends StatelessWidget {
  final List<String> skills;
  final Color volumeColor;

  const _SkillTags({
    required this.skills,
    required this.volumeColor,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Wrap(
      spacing: constants.spacingS,
      runSpacing: constants.spacingS,
      children: skills.take(5).map((skill) {
        return _SkillTag(skill: skill, color: volumeColor);
      }).toList(),
    );
  }
}

/// 스킬 태그
class _SkillTag extends StatelessWidget {
  final String skill;
  final Color color;

  const _SkillTag({
    required this.skill,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.spacingS,
        vertical: constants.spacingXS / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(
          constants.pillBorderRadius(context),
        ),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Text(
        skill,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}

/// 더보기 버튼
class _ViewMoreButton extends StatelessWidget {
  final bool isHovered;

  const _ViewMoreButton({required this.isHovered});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Row(
      children: [
        Icon(
          LucideIcons.externalLink,
          size: 16.r,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: constants.spacingXS),
        Text(
          'Notion에서 자세히 보기',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: constants.spacingXS),
        AnimatedRotation(
          turns: isHovered ? 0.125 : 0,
          duration: constants.fastAnimation,
          child: Icon(
            LucideIcons.arrowRight,
            size: 16.r,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}