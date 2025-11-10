import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';
import 'package:portfolio/util/theme/App_Colors.dart';

class QuickNavigationCards extends StatelessWidget {
  final Function(int)? onCardTap;

  const QuickNavigationCards({
    super.key,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileQuickNavigation(onCardTap: onCardTap);
      } else {
        return _DesktopQuickNavigation(onCardTap: onCardTap);
      }
    });
  }
}

/// 데스크톱/태블릿 - 카드 그리드
class _DesktopQuickNavigation extends StatelessWidget {
  final Function(int)? onCardTap;

  const _DesktopQuickNavigation({this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final appController = Get.find<AppController>();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingXXL,
      ),
      child: Column(
        children: [
          // 섹션 타이틀
          _SectionTitle(),

          SizedBox(height: constants.spacingXL),

          // 카드 그리드
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: appController.responsive(
                mobile: 1,
                tablet: 2,
                web: 4,
              ),
              crossAxisSpacing: constants.spacingL,
              mainAxisSpacing: constants.spacingL,
              childAspectRatio: 1.0,
            ),
            itemCount: _cardData.length,
            itemBuilder: (context, index) {
              final data = _cardData[index];
              return _QuickNavigationCard(
                icon: data['icon'] as IconData,
                title: data['title'] as String,
                description: data['description'] as String,
                color: data['color'] as Color Function(BuildContext),
                onTap: () => onCardTap?.call(index + 1),
              );
            },
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _cardData = [
    {
      'icon': LucideIcons.user,
      'title': 'About Me',
      'description': '저에 대해 알아보세요',
      'color': (BuildContext context) => Theme.of(context).colorScheme.primary,
    },
    {
      'icon': LucideIcons.code,
      'title': 'Skills',
      'description': '보유한 기술 스택',
      'color': (BuildContext context) => Theme.of(context).colorScheme.secondary,
    },
    {
      'icon': LucideIcons.briefcase,
      'title': 'Projects',
      'description': '진행한 프로젝트들',
      'color': (BuildContext context) => Theme.of(context).colorScheme.tertiary,
    },
    {
      'icon': LucideIcons.mail,
      'title': 'Contact',
      'description': '연락처 정보',
      'color': (BuildContext context) => Theme.of(context).colorScheme.success,
    },
  ];
}

/// 모바일 - 하단 네비게이션 바 스타일
class _MobileQuickNavigation extends StatelessWidget {
  final Function(int)? onCardTap;

  const _MobileQuickNavigation({this.onCardTap});

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
        vertical: constants.spacingL,
      ),
      child: Column(
        children: [
          // 섹션 타이틀
          Text(
            '빠른 탐색',
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),

          SizedBox(height: constants.spacingM),

          // 네비게이션 바 스타일
          Container(
            padding: EdgeInsets.all(constants.spacingS),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(_mobileNavData.length, (index) {
                final data = _mobileNavData[index];
                return _MobileNavItem(
                  icon: data['icon'] as IconData,
                  label: data['label'] as String,
                  color: data['color'] as Color Function(BuildContext),
                  onTap: () => onCardTap?.call(index + 1),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  static final List<Map<String, dynamic>> _mobileNavData = [
    {
      'icon': LucideIcons.user,
      'label': 'About',
      'color': (BuildContext context) => Theme.of(context).colorScheme.primary,
    },
    {
      'icon': LucideIcons.code,
      'label': 'Skills',
      'color': (BuildContext context) => Theme.of(context).colorScheme.secondary,
    },
    {
      'icon': LucideIcons.briefcase,
      'label': 'Projects',
      'color': (BuildContext context) => Theme.of(context).colorScheme.tertiary,
    },
    {
      'icon': LucideIcons.mail,
      'label': 'Contact',
      'color': (BuildContext context) => Theme.of(context).colorScheme.success,
    },
  ];
}

/// 모바일 네비게이션 아이템
class _MobileNavItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color Function(BuildContext) color;
  final VoidCallback? onTap;

  const _MobileNavItem({
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  State<_MobileNavItem> createState() => _MobileNavItemState();
}

class _MobileNavItemState extends State<_MobileNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final itemColor = widget.color(context);

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap?.call();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: constants.fastAnimation,
        padding: EdgeInsets.symmetric(
          horizontal: constants.spacingS,
          vertical: constants.spacingS,
        ),
        decoration: BoxDecoration(
          color: _isPressed
              ? itemColor.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(
            constants.borderRadius(context),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 아이콘
            Icon(
              widget.icon,
              size: 24.r,
              color: _isPressed
                  ? itemColor
                  : theme.colorScheme.onSurface,
            ),

            SizedBox(height: constants.spacingXS),

            // 라벨
            Text(
              widget.label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: _isPressed
                    ? itemColor
                    : theme.colorScheme.onSurface,
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

    return Column(
      children: [
        Text(
          '빠른 탐색',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: constants.spacingS),
        Text(
          '원하는 섹션으로 바로 이동하세요',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}

/// Quick Navigation 카드 (데스크톱/태블릿)
class _QuickNavigationCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color Function(BuildContext) color;
  final VoidCallback? onTap;

  const _QuickNavigationCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    this.onTap,
  });

  @override
  State<_QuickNavigationCard> createState() => _QuickNavigationCardState();
}

class _QuickNavigationCardState extends State<_QuickNavigationCard>
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
    final cardColor = widget.color(context);

    return MouseRegion(
      onEnter: (_) => _onHoverChanged(true),
      onExit: (_) => _onHoverChanged(false),
      cursor: SystemMouseCursors.click,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: GestureDetector(
          onTap: widget.onTap,
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
                    ? cardColor.withValues(alpha: 0.5)
                    : theme.colorScheme.outline.withValues(alpha: 0.2),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: _isHovered
                      ? cardColor.withValues(alpha: 0.2)
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
                  icon: widget.icon,
                  color: cardColor,
                  isHovered: _isHovered,
                ),

                SizedBox(height: constants.spacingM),

                // 타이틀
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                SizedBox(height: constants.spacingS),

                // 설명
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),

                SizedBox(height: constants.spacingM),

                // 화살표 아이콘
                AnimatedRotation(
                  turns: _isHovered ? 0.125 : 0,
                  duration: constants.fastAnimation,
                  child: Icon(
                    LucideIcons.arrowRight,
                    size: constants.iconSize(context),
                    color: cardColor,
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
    return AnimatedContainer(
      duration: constants.fastAnimation,
      width: 64.r,
      height: 64.r,
      decoration: BoxDecoration(
        color: isHovered
            ? color.withValues(alpha: 0.2)
            : color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32.r,
          color: color,
        ),
      ),
    );
  }
}