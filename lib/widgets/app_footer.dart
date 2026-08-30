import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/motion/motion.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../router/app_routes.dart';

class _SocialLink {
  const _SocialLink(this.icon, this.label, this.url);
  final FaIconData icon;
  final String label;
  final String url;
}

const _socialLinks = [
  _SocialLink(
    FontAwesomeIcons.github,
    'GitHub',
    'https://github.com/choe-inho',
  ),
  _SocialLink(FontAwesomeIcons.link, 'Blog', 'https://iconoding.tistory.com/'),
  _SocialLink(
    FontAwesomeIcons.envelope,
    'Email',
    'mailto:iconoding.dev@gmail.com',
  ),
];

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: context.horizontalPadding,
        vertical: 48,
      ),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              for (final link in _socialLinks)
                _FooterPill(link: link, onTap: () => _launch(link.url)),
            ],
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 24,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _TextLink('개인정보처리방침', () => context.go(AppRoutes.privacy)),
              _TextLink('이용약관', () => context.go(AppRoutes.terms)),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} iconoding · Built with Flutter',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _FooterPill extends StatelessWidget {
  const _FooterPill({required this.link, required this.onTap});
  final _SocialLink link;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MagneticTap(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.glassFill,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FaIcon(link.icon, size: 16, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(link.label, style: AppTextStyles.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  const _TextLink(this.label, this.onTap);
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
            decoration: TextDecoration.underline,
            decorationColor: AppColors.textTertiary,
          ),
        ),
      ),
    );
  }
}
