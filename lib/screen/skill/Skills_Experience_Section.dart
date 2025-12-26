import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class SkillsExperienceSection extends StatelessWidget {
  const SkillsExperienceSection({super.key});

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

          // 경험 카드 리스트
          _ExperienceCardList(),
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
              LucideIcons.trophy,
              size: constants.iconSize(context),
              color: theme.colorScheme.secondary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '스킬 활용 경험',
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
          '다양한 프로젝트를 통해 실전 경험을 쌓았습니다',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 경험 카드 리스트
class _ExperienceCardList extends StatelessWidget {
  const _ExperienceCardList();

  // 경험 데이터 (실제로는 Firestore에서 가져올 수 있음)
  static const List<Map<String, dynamic>> _experienceData = [
    {
      'title': 'Flutter 앱 개발',
      'description': '크로스 플랫폼 모바일 애플리케이션 개발 경험',
      'icon': LucideIcons.smartphone,
      'skills': ['Flutter', 'Dart', 'Firebase'],
      'projects': 5,
    },
    {
      'title': 'REST API 설계',
      'description': 'RESTful API 설계 및 구현 경험',
      'icon': LucideIcons.network,
      'skills': ['Node.js', 'Express', 'RESTApi'],
      'projects': 4,
    },
    {
      'title': '클라우드 서비스',
      'description': 'AWS, Firebase를 활용한 백엔드 구축',
      'icon': LucideIcons.cloud,
      'skills': ['AWS', 'Firebase', 'Database'],
      'projects': 6,
    },
    {
      'title': '상태 관리',
      'description': 'GetX, Provider를 활용한 상태 관리',
      'icon': LucideIcons.gitBranch,
      'skills': ['GetX', 'Provider', 'BLoC'],
      'projects': 5,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final constants = AppConstants.of(context);

    return Obx(() {
      if (appController.isMobile) {
        // 모바일: 세로 리스트
        return Column(
          children: _experienceData.asMap().entries.map((entry) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: entry.key < _experienceData.length - 1
                    ? constants.spacingM
                    : 0,
              ),
              child: SlideInAnimation(
                delay: Duration(milliseconds: 500 + (entry.key * 150)),
                child: _ExperienceCard(
                  data: entry.value,
                  index: entry.key,
                ),
              ),
            );
          }).toList(),
        );
      } else {
        // 데스크톱/태블릿: 그리드
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: appController.responsive(
              mobile: 1,
              tablet: 2,
              web: 2,
            ),
            crossAxisSpacing: constants.spacingL,
            mainAxisSpacing: constants.spacingL,
            childAspectRatio: 1.3,
          ),
          itemCount: _experienceData.length,
          itemBuilder: (context, index) {
            return SlideInAnimation(
              delay: Duration(milliseconds: 500 + (index * 150)),
              child: _ExperienceCard(
                data: _experienceData[index],
                index: index,
              ),
            );
          },
        );
      }
    });
  }
}

/// 경험 카드
class _ExperienceCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final int index;

  const _ExperienceCard({
    required this.data,
    required this.index,
  });

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  // 카드별 색상 (순환)
  static List<Color> _getColors(BuildContext context) {
    final theme = Theme.of(context);
    return [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      theme.colorScheme.tertiary,
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
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
          padding: EdgeInsets.all(constants.spacingL),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              constants.largeBorderRadius(context),
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
                    ? color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 아이콘 & 프로젝트 수
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 아이콘
                  Container(
                    width: 56.r,
                    height: 56.r,
                    decoration: BoxDecoration(
                      color: _isHovered
                          ? color.withValues(alpha: 0.2)
                          : color.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.data['icon'] as IconData,
                      size: 28.r,
                      color: color,
                    ),
                  ),

                  // 프로젝트 수 배지
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
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          LucideIcons.briefcase,
                          size: 14.r,
                          color: color,
                        ),
                        SizedBox(width: constants.spacingXS),
                        Text(
                          '${widget.data['projects']}개',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w600,
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
                widget.data['title'] as String,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: constants.spacingS),

              // 설명
              Text(
                widget.data['description'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  height: 1.5,
                ),
              ),

              const Spacer(),

              // 스킬 태그
              Wrap(
                spacing: constants.spacingS,
                runSpacing: constants.spacingS,
                children: (widget.data['skills'] as List<String>).map((skill) {
                  return _SkillTag(
                    label: skill,
                    color: color,
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 스킬 태그
class _SkillTag extends StatelessWidget {
  final String label;
  final Color color;

  const _SkillTag({
    required this.label,
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
        label,
        style: theme.textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w500,
          fontSize: 11.sp,
        ),
      ),
    );
  }
}