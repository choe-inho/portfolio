import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/config/App_Constants.dart';

class PortfolioNavigationBar extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const PortfolioNavigationBar({
    super.key,
    this.onItemSelected,
    this.currentIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      if (appController.isMobile) {
        return _MobileNavigationBar(
          currentIndex: currentIndex,
          onItemSelected: onItemSelected,
        );
      } else {
        return _DesktopNavigationBar(
          currentIndex: currentIndex,
          onItemSelected: onItemSelected,
        );
      }
    });
  }
}

/// 데스크톱/태블릿 네비게이션 바
class _DesktopNavigationBar extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const _DesktopNavigationBar({
    required this.currentIndex,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Container(
      height: constants.appBarHeight(context),
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 로고
          _LogoSection(),

          const Spacer(),

          // 네비게이션 메뉴
          _NavigationMenu(
            currentIndex: currentIndex,
            onItemSelected: onItemSelected,
          ),

          SizedBox(width: constants.spacingL),

          // 다크모드 토글
          _ThemeToggleButton(),
        ],
      ),
    );
  }
}

/// 모바일 네비게이션 바
class _MobileNavigationBar extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const _MobileNavigationBar({
    required this.currentIndex,
    this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Container(
      height: constants.appBarHeight(context),
      padding: EdgeInsets.symmetric(
        horizontal: constants.horizontalPadding(context),
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.95),
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          // 로고
          _LogoSection(),

          const Spacer(),

          // 다크모드 토글
          _ThemeToggleButton(),

          SizedBox(width: constants.spacingS),

          // 햄버거 메뉴 (Drawer)
          _MobileMenuButton(
            currentIndex: currentIndex,
            onItemSelected: onItemSelected,
          ),
        ],
      ),
    );
  }
}

/// 로고 섹션
class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          'assets/icon/icon_only_logo.png',
          height: constants.iconSize(context),
          width: constants.iconSize(context),
        ),
        SizedBox(width: constants.spacingS),
        Text(
          'ICONODING',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

/// 네비게이션 메뉴 (데스크톱/태블릿)
class _NavigationMenu extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const _NavigationMenu({
    required this.currentIndex,
    this.onItemSelected,
  });

  static const List<String> _menuItems = [
    'Home',
    'About Me',
    'Skills',
    'Projects',
    'Contact',
  ];

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_menuItems.length, (index) {
        return Padding(
          padding: EdgeInsets.only(
            left: index > 0 ? constants.spacingL : 0,
          ),
          child: _NavigationMenuItem(
            label: _menuItems[index],
            isSelected: currentIndex == index,
            onTap: () => onItemSelected?.call(index),
          ),
        );
      }),
    );
  }
}

/// 네비게이션 메뉴 아이템
class _NavigationMenuItem extends StatefulWidget {
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavigationMenuItem({
    required this.label,
    required this.isSelected,
    this.onTap,
  });

  @override
  State<_NavigationMenuItem> createState() => _NavigationMenuItemState();
}

class _NavigationMenuItemState extends State<_NavigationMenuItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: constants.fastAnimation,
          padding: EdgeInsets.symmetric(
            horizontal: constants.spacingM,
            vertical: constants.spacingS,
          ),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? theme.colorScheme.primaryContainer
                : _isHovered
                ? theme.colorScheme.surfaceVariant
                : Colors.transparent,
            borderRadius: BorderRadius.circular(constants.smallBorderRadius(context)),
          ),
          child: Text(
            widget.label,
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: widget.isSelected ? FontWeight.w600 : FontWeight.w500,
              color: widget.isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

/// 다크모드 토글 버튼
class _ThemeToggleButton extends StatelessWidget {
  const _ThemeToggleButton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return IconButton(
      icon: Icon(
        isDark ? LucideIcons.sun : LucideIcons.moon,
        size: constants.iconSize(context),
      ),
      color: theme.colorScheme.onSurface,
      onPressed: () {
        Get.changeThemeMode(
          isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
    );
  }
}

/// 모바일 메뉴 버튼 (Drawer)
class _MobileMenuButton extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const _MobileMenuButton({
    required this.currentIndex,
    this.onItemSelected,
  });

  static const List<String> _menuItems = [
    'Home',
    'About Me',
    'Skills',
    'Projects',
    'Contact',
  ];

  static const List<IconData> _menuIcons = [
    LucideIcons.home,
    LucideIcons.user,
    LucideIcons.code,
    LucideIcons.briefcase,
    LucideIcons.mail,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return IconButton(
      icon: Icon(
        LucideIcons.menu,
        size: constants.iconSize(context),
      ),
      color: theme.colorScheme.onSurface,
      onPressed: () {
        Scaffold.of(context).openEndDrawer();
      },
    );
  }
}

/// Navigation Drawer (모바일)
class NavigationDrawer extends StatelessWidget {
  final Function(int)? onItemSelected;
  final int currentIndex;

  const NavigationDrawer({
    super.key,
    required this.currentIndex,
    this.onItemSelected,
  });

  static const List<String> _menuItems = [
    'Home',
    'About Me',
    'Skills',
    'Projects',
    'Contact',
  ];

  static const List<IconData> _menuIcons = [
    LucideIcons.home,
    LucideIcons.user,
    LucideIcons.code,
    LucideIcons.briefcase,
    LucideIcons.mail,
  ];

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return Drawer(
      backgroundColor: theme.colorScheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Drawer 헤더
            _DrawerHeader(),

            SizedBox(height: constants.spacingL),

            // 메뉴 아이템들
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: constants.spacingM,
                ),
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  return _DrawerMenuItem(
                    icon: _menuIcons[index],
                    label: _menuItems[index],
                    isSelected: currentIndex == index,
                    onTap: () {
                      Navigator.pop(context);
                      onItemSelected?.call(index);
                    },
                  );
                },
              ),
            ),

            // Footer
            _DrawerFooter(),
          ],
        ),
      ),
    );
  }
}

/// Drawer 헤더
class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.spacingL),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icon/icon_only_logo.png',
            height: 32.r,
            width: 32.r,
          ),
          SizedBox(width: constants.spacingM),
          Text(
            'ICONODING',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

/// Drawer 메뉴 아이템
class _DrawerMenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerMenuItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: constants.spacingS),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(constants.borderRadius(context)),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: constants.spacingM,
            vertical: constants.spacingM,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primaryContainer
                : Colors.transparent,
            borderRadius: BorderRadius.circular(constants.borderRadius(context)),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: constants.iconSize(context),
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface,
              ),
              SizedBox(width: constants.spacingM),
              Text(
                label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
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

/// Drawer Footer
class _DrawerFooter extends StatelessWidget {
  const _DrawerFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final constants = AppConstants.of(context);

    return Container(
      padding: EdgeInsets.all(constants.spacingL),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Column(
        children: [
          Text(
            '© 2025 Portfolio',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          SizedBox(height: constants.spacingXS),
          Text(
            'Made with Flutter 💚',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }
}