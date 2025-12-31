import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/model/Skill.dart';
import 'package:portfolio/util/animation/Portfolio_Animation.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/config/Skills_Config.dart';

class AboutMeSkillsSection extends StatelessWidget {
  const AboutMeSkillsSection({super.key});

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

          // 스킬 카테고리 그리드/리스트
          _SkillCategoryContent(),
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
              LucideIcons.code2,
              size: constants.iconSize(context),
              color: theme.colorScheme.secondary,
            ),
            SizedBox(width: constants.spacingS),
            Text(
              '기술 스택',
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
          '프로젝트에 활용한 기술들입니다',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// 스킬 카테고리 콘텐츠
class _SkillCategoryContent extends StatelessWidget {
  const _SkillCategoryContent();

  // 스킬을 카테고리별로 분류
  Map<String, List<Skill>> _categorizeSkills() {
    final skills = SkillsConfig.skills;
    final Map<String, List<Skill>> categorized = {
      'Frontend': [],
      'Backend': [],
      'Database & Cloud': [],
      'Tools & Others': [],
    };

    for (final skill in skills) {
      if (skill.name == 'Flutter') {
        categorized['Frontend']!.add(skill);
      } else if (skill.name == 'Node' || skill.name == 'Python' || skill.name == 'RESTApi') {
        categorized['Backend']!.add(skill);
      } else if (skill.name == 'Firebase' || skill.name == 'AWS') {
        categorized['Database & Cloud']!.add(skill);
      } else {
        categorized['Tools & Others']!.add(skill);
      }
    }

    return categorized;
  }

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final categorizedSkills = _categorizeSkills();

    return Column(
      children: categorizedSkills.entries.map((entry) {
        final category = entry.key;
        final skills = entry.value;

        if (skills.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: EdgeInsets.only(bottom: constants.spacingL),
          child: SlideInAnimation(
            delay: Duration(milliseconds: 500 + (categorizedSkills.keys.toList().indexOf(category) * 150)),
            child: _SkillCategoryCard(
              category: category,
              skills: skills,
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// 스킬 카테고리 카드
class _SkillCategoryCard extends StatelessWidget {
  final String category;
  final List<Skill> skills;

  const _SkillCategoryCard({
    required this.category,
    required this.skills,
  });

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Frontend':
        return LucideIcons.layout;
      case 'Backend':
        return LucideIcons.server;
      case 'Database & Cloud':
        return LucideIcons.database;
      case 'Tools & Others':
        return LucideIcons.wrench;
      default:
        return LucideIcons.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(constants.spacingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(
          constants.largeBorderRadius(context),
        ),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 카테고리 헤더
          Row(
            children: [
              Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(
                    constants.smallBorderRadius(context),
                  ),
                ),
                child: Icon(
                  _getCategoryIcon(category),
                  size: 20.r,
                  color: theme.colorScheme.secondary,
                ),
              ),
              SizedBox(width: constants.spacingM),
              Text(
                category,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),

          SizedBox(height: constants.spacingL),

          // 스킬 그리드
          Wrap(
            spacing: constants.spacingM,
            runSpacing: constants.spacingM,
            children: skills.map((skill) {
              return _SkillChip(skill: skill);
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// 스킬 칩
class _SkillChip extends StatefulWidget {
  final Skill skill;

  const _SkillChip({required this.skill});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip>
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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
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
    final skillColor = Color(widget.skill.color);

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          width: appController.responsive(
            mobile: 100.w,  // 모바일: 작은 너비
            tablet: 140.w,
            web: 140.w,
          ),
          padding: EdgeInsets.all(
            appController.responsive(
              mobile: constants.spacingS,
              tablet: constants.spacingM,
              web: constants.spacingM,
            ),
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? skillColor.withValues(alpha: 0.1)
                : theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(
              constants.borderRadius(context),
            ),
            border: Border.all(
              color: _isHovered
                  ? skillColor.withValues(alpha: 0.6)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: _isHovered ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? skillColor.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isHovered ? 12 : 6,
                offset: Offset(0, _isHovered ? 4 : 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 아이콘
              Container(
                width: appController.responsive(
                  mobile: 40.r,
                  tablet: 48.r,
                  web: 48.r,
                ),
                height: appController.responsive(
                  mobile: 40.r,
                  tablet: 48.r,
                  web: 48.r,
                ),
                decoration: BoxDecoration(
                  color: _isHovered
                      ? skillColor.withValues(alpha: 0.15)
                      : skillColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    constants.smallBorderRadius(context),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    widget.skill.icon,
                    width: appController.responsive(
                      mobile: 28.r,
                      tablet: 32.r,
                      web: 32.r,
                    ),
                    height: appController.responsive(
                      mobile: 28.r,
                      tablet: 32.r,
                      web: 32.r,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: constants.spacingS),

              // 이름
              Text(
                widget.skill.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: appController.responsive(
                    mobile: 12.sp,
                    tablet: 14.sp,
                    web: 14.sp,
                  ),
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: constants.spacingXS),

              // 숙련도 표시
              _ProficiencyIndicator(
                proficiency: widget.skill.proficiency,
                color: skillColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 숙련도 표시 위젯
class _ProficiencyIndicator extends StatelessWidget {
  final int proficiency;
  final Color color;

  const _ProficiencyIndicator({
    required this.proficiency,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isActive = index < proficiency;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 2.w),
          child: Container(
            width: 6.w,
            height: 6.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? color : color.withValues(alpha: 0.2),
            ),
          ),
        );
      }),
    );
  }
}