import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/config/skills_config.dart';
import '../../core/motion/motion.dart';
import '../../core/responsive/responsive.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../router/app_routes.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/page_scaffold.dart';
import '../../widgets/pill_button.dart';

class HeroPage extends StatelessWidget {
  const HeroPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      currentPath: AppRoutes.home,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: context.horizontalPadding,
            vertical: context.sectionPaddingVertical,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: context.maxContentWidth),
            child: Column(
              crossAxisAlignment: context.isMobile
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                const FadeSlideIn(child: EyebrowTag(text: 'Portfolio')),
                const SizedBox(height: 24),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 80),
                  child: Text(
                    '사용자의 니즈를 생각하는\n개발자 최인호입니다',
                    textAlign: context.isMobile
                        ? TextAlign.center
                        : TextAlign.start,
                    style: AppTextStyles.display.copyWith(
                      fontSize: context.responsive(
                        mobile: 34,
                        tablet: 52,
                        desktop: 68,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 160),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 560),
                    child: Text(
                      '사용자 경험을 최우선으로 생각하며, 깔끔하고 효율적인 앱을 만듭니다.\n'
                      '새로운 기술을 배우는 것을 즐기고, 문제 해결에 열정을 가지고 있습니다.',
                      textAlign: context.isMobile
                          ? TextAlign.center
                          : TextAlign.start,
                      style: AppTextStyles.body,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                FadeSlideIn(
                  delay: const Duration(milliseconds: 240),
                  child: Wrap(
                    alignment: context.isMobile
                        ? WrapAlignment.center
                        : WrapAlignment.start,
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      PillButton(
                        label: '프로젝트 보기',
                        onTap: () => context.go(AppRoutes.projects),
                      ),
                      PillButton(
                        label: '연락하기',
                        filled: false,
                        icon: FontAwesomeIcons.envelope,
                        onTap: () => context.go(AppRoutes.contact),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: context.sectionPaddingVertical),
                const _QuickNavBento(),
                const SizedBox(height: 96),
                const _SkillsRow(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickNavBento extends StatelessWidget {
  const _QuickNavBento();

  @override
  Widget build(BuildContext context) {
    final cards = [
      (
        icon: FontAwesomeIcons.user,
        title: 'About Me',
        desc: '저에 대해 알아보세요',
        color: AppColors.emerald,
        path: AppRoutes.aboutMe,
      ),
      (
        icon: FontAwesomeIcons.briefcase,
        title: 'Projects',
        desc: '진행한 프로젝트들',
        color: AppColors.blue,
        path: AppRoutes.projects,
      ),
      (
        icon: FontAwesomeIcons.envelope,
        title: 'Contact',
        desc: '연락처 정보',
        color: AppColors.purple,
        path: AppRoutes.contact,
      ),
    ];

    if (context.isMobile) {
      return Column(
        children: [
          for (var i = 0; i < cards.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: FadeSlideIn(
                delay: Duration(milliseconds: 300 + i * 80),
                child: _NavCard(data: cards[i]),
              ),
            ),
        ],
      );
    }

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          if (i > 0) const SizedBox(width: 20),
          Expanded(
            flex: i == 0 ? 2 : 1,
            child: FadeSlideIn(
              delay: Duration(milliseconds: 300 + i * 80),
              child: _NavCard(data: cards[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({required this.data});

  final ({FaIconData icon, String title, String desc, Color color, String path})
  data;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      child: GlassCard(
      onTap: () => context.go(data.path),
      padding: const EdgeInsets.all(28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: data.color.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: FaIcon(data.icon, color: data.color, size: 22),
          ),
          const SizedBox(height: 20),
          Text(data.title, style: AppTextStyles.title.copyWith(fontSize: 20)),
          const SizedBox(height: 6),
          Text(data.desc, style: AppTextStyles.bodySmall),
        ],
      ),
      ),
    );
  }
}

class _SkillsRow extends StatelessWidget {
  const _SkillsRow();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Tech Stack', style: AppTextStyles.eyebrow),
        const SizedBox(height: 24),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final skill in SkillsConfig.skills)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.glassFill,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.glassBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(skill.icon, width: 20, height: 20),
                    const SizedBox(width: 10),
                    Text(
                      skill.name,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
