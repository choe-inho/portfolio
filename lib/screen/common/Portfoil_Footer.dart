import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioFooter extends StatelessWidget {
  const PortfolioFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(constants.spacingXL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withValues(alpha: 0.5),
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          // 소셜 링크
          _SocialLinks(),

          SizedBox(height: constants.spacingL),

          // 구분선
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),

          SizedBox(height: constants.spacingM),

          // 저작권 정보
          _CopyrightText(),
        ],
      ),
    );
  }
}

/// 소셜 링크
class _SocialLinks extends StatelessWidget {
  const _SocialLinks();

  static final List<Map<String, dynamic>> _socialData = [
    {
      'icon': LucideIcons.github,
      'label': 'GitHub',
      'url': 'https://github.com',
    },
    {
      'icon': LucideIcons.linkedin,
      'label': 'LinkedIn',
      'url': 'https://linkedin.com',
    },
    {
      'icon': LucideIcons.mail,
      'label': 'Email',
      'url': 'mailto:example@email.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Wrap(
      spacing: constants.spacingM,
      runSpacing: constants.spacingM,
      alignment: WrapAlignment.center,
      children: _socialData.map((data) {
        return _SocialButton(
          icon: data['icon'] as IconData,
          label: data['label'] as String,
          url: data['url'] as String,
        );
      }).toList(),
    );
  }
}

/// 소셜 버튼
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  bool _isHovered = false;

  Future<void> _launchUrl() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _launchUrl,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          padding: EdgeInsets.symmetric(
            horizontal: constants.spacingM,
            vertical: constants.spacingS,
          ),
          decoration: BoxDecoration(
            color: _isHovered
                ? theme.colorScheme.primaryContainer
                : theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(
              constants.pillBorderRadius(context),
            ),
            border: Border.all(
              color: _isHovered
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: constants.smallIconSize(context),
                color: _isHovered
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              SizedBox(width: constants.spacingS),
              Text(
                widget.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: _isHovered
                      ? theme.colorScheme.primary
                      : theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 저작권 텍스트
class _CopyrightText extends StatelessWidget {
  const _CopyrightText();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Column(
      children: [
        Text(
          '© 2025 Portfolio. All rights reserved.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
        SizedBox(height: constants.spacingXS),
        Text(
          'Made with Flutter 💚',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }
}