import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/screen/common/Hero_Image.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/config/Skills_Config.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const HeroSection({
    super.key,
    this.onViewProjects,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileHeroSection(
          onViewProjects: onViewProjects,
          onContact: onContact,
        );
      } else {
        return _DesktopHeroSection(
          onViewProjects: onViewProjects,
          onContact: onContact,
        );
      }
    });
  }
}

/// 데스크톱/태블릿 Hero Section
class _DesktopHeroSection extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const _DesktopHeroSection({
    this.onViewProjects,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL * 2,
      ),
      child: Column(
        children: [
          Row(
            children: [
              // 왼쪽: 텍스트 콘텐츠
              Expanded(
                flex: 3,
                child: _HeroTextContent(
                  onViewProjects: onViewProjects,
                  onContact: onContact,
                ),
              ),

              SizedBox(width: constants.spacingXXL),

              // 오른쪽: 이미지/일러스트
              Expanded(
                flex: 2,
                child: HeroImage(),
              ),
            ],
          ),

          SizedBox(height: constants.spacingXXL * 2),

          // Skills Section
          _SkillsSection(),
        ],
      ),
    );
  }
}

/// 모바일 Hero Section
class _MobileHeroSection extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const _MobileHeroSection({
    this.onViewProjects,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.horizontalPadding(context)),
      child: Column(
        children: [
          SizedBox(height: constants.spacingXL),

          // 이미지/일러스트
          HeroImage(),

          SizedBox(height: constants.spacingXL),

          // 텍스트 콘텐츠
          _HeroTextContent(
            onViewProjects: onViewProjects,
            onContact: onContact,
          ),

          SizedBox(height: constants.spacingXXL),

          // Skills Section
          _SkillsSection(),

          SizedBox(height: constants.spacingXL),
        ],
      ),
    );
  }
}

/// Hero 텍스트 콘텐츠
class _HeroTextContent extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const _HeroTextContent({
    this.onViewProjects,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return Column(
      crossAxisAlignment: appController.isMobile
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // 인사말
        _GreetingText(),

        SizedBox(height: constants.spacingM),

        // 메인 타이틀
        _MainTitle(),

        SizedBox(height: constants.spacingL),

        // 서브타이틀/설명
        _SubTitle(),

        SizedBox(height: constants.spacingXL),

        // CTA 버튼들
        _CTAButtons(
          onViewProjects: onViewProjects,
          onContact: onContact,
        ),
      ],
    );
  }
}

/// 인사말 텍스트
class _GreetingText extends StatelessWidget {
  const _GreetingText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return Row(
      mainAxisSize: appController.isMobile ? MainAxisSize.min : MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.handMetal,
          size: constants.iconSize(context),
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: constants.spacingS),
        Text(
          '안녕하세요,',
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// 메인 타이틀
class _MainTitle extends StatelessWidget {
  const _MainTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    final fontSize = appController.responsive(
      mobile: 32.sp,
      tablet: 40.sp,
      web: 48.sp,
    );

    return Text(
      '사용자의 니즈를 생각하는\n개발자 최인호 입니다',
      textAlign: appController.isMobile ? TextAlign.center : TextAlign.start,
      style: theme.textTheme.displayLarge?.copyWith(
        fontSize: fontSize,
        fontWeight: FontWeight.w700,
        height: 1.2,
        color: theme.colorScheme.onSurface,
      ),
    );
  }
}

/// 서브타이틀
class _SubTitle extends StatelessWidget {
  const _SubTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appController = Get.find<AppController>();

    return Text(
      '사용자 경험을 최우선으로 생각하며, 깔끔하고 효율적인 앱을 만듭니다.\n'
          '새로운 기술을 배우는 것을 즐기고, 문제 해결에 열정을 가지고 있습니다.',
      textAlign: appController.isMobile ? TextAlign.center : TextAlign.start,
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.6,
      ),
    );
  }
}

/// CTA 버튼들
class _CTAButtons extends StatelessWidget {
  final VoidCallback? onViewProjects;
  final VoidCallback? onContact;

  const _CTAButtons({
    this.onViewProjects,
    this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return Wrap(
      spacing: constants.spacingM,
      runSpacing: constants.spacingM,
      alignment: appController.isMobile
          ? WrapAlignment.center
          : WrapAlignment.start,
      children: [
        _PrimaryButton(
          label: '프로젝트 보기',
          icon: LucideIcons.briefcase,
          onPressed: onViewProjects,
        ),
        _SecondaryButton(
          label: '연락하기',
          icon: LucideIcons.mail,
          onPressed: onContact,
        ),
      ],
    );
  }
}

/// Primary 버튼
class _PrimaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _PrimaryButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: constants.fastAnimation,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -2.0 : 0.0),
        child: ElevatedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: constants.iconSize(context)),
          label: Text(widget.label),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: constants.spacingL,
              vertical: constants.spacingM,
            ),
            elevation: _isHovered ? 8 : 4,
          ),
        ),
      ),
    );
  }
}

/// Secondary 버튼
class _SecondaryButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  const _SecondaryButton({
    required this.label,
    required this.icon,
    this.onPressed,
  });

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: constants.fastAnimation,
        transform: Matrix4.identity()
          ..translate(0.0, _isHovered ? -2.0 : 0.0),
        child: OutlinedButton.icon(
          onPressed: widget.onPressed,
          icon: Icon(widget.icon, size: constants.iconSize(context)),
          label: Text(widget.label),
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(
              horizontal: constants.spacingL,
              vertical: constants.spacingM,
            ),
          ),
        ),
      ),
    );
  }
}

/// Skills Section
class _SkillsSection extends StatelessWidget {
  const _SkillsSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Column(
      children: [
        // 섹션 타이틀
        Text(
          'Tech Stack',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),

        SizedBox(height: constants.spacingL),

        // Skills 가로 스크롤
        _SkillsHorizontalList(),
      ],
    );
  }
}

/// Skills 가로 스크롤 리스트
class _SkillsHorizontalList extends StatelessWidget {
  const _SkillsHorizontalList();

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final skills = SkillsConfig.skills;

    return Center(
      child: Wrap(
        spacing: constants.spacingM,
        runSpacing: constants.spacingM,
        alignment: WrapAlignment.center,
        children: skills.map((skill) {
          return _SkillCard(
            name: skill.name,
            icon: skill.icon,
            color: Color(skill.color),
            proficiency: skill.proficiency,
          );
        }).toList(),
      ),
    );
  }
}

/// Skill 카드
class _SkillCard extends StatefulWidget {
  final String name;
  final String icon;
  final Color color;
  final int proficiency;

  const _SkillCard({
    required this.name,
    required this.icon,
    required this.color,
    required this.proficiency,
  });

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard>
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

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          width: 120.w,
          padding: EdgeInsets.all(constants.spacingM),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              constants.borderRadius(context),
            ),
            border: Border.all(
              color: _isHovered
                  ? widget.color.withValues(alpha: 0.6)
                  : theme.colorScheme.outline.withValues(alpha: 0.2),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.color.withValues(alpha: 0.2)
                    : Colors.black.withValues(alpha: 0.05),
                blurRadius: _isHovered ? 16 : 8,
                offset: Offset(0, _isHovered ? 6 : 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 아이콘
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: _isHovered
                      ? widget.color.withValues(alpha: 0.15)
                      : widget.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(
                    constants.smallBorderRadius(context),
                  ),
                ),
                child: Center(
                  child: Image.asset(
                    widget.icon,
                    width: 32.r,
                    height: 32.r,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              SizedBox(height: constants.spacingS),

              // 이름
              Text(
                widget.name,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),

              SizedBox(height: constants.spacingXS),

              // Proficiency (숙련도 표시)
              _ProficiencyIndicator(
                proficiency: widget.proficiency,
                color: widget.color,
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
    final constants = AppConstants.of(context);

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
              color: isActive
                  ? color
                  : color.withValues(alpha: 0.2),
            ),
          ),
        );
      }),
    );
  }
}