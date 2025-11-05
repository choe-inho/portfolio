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
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

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
    final appController = Get.find<AppController>();

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

          // 햄버거 메뉴
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
        Image.asset('assets/icon/icon_only_logo.png', height: constants.iconSize(context), width: constants.iconSize(context),),
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
        // TODO: 다크모드 토글 구현
        Get.changeThemeMode(
          isDark ? ThemeMode.light : ThemeMode.dark,
        );
      },
    );
  }
}

/// 모바일 메뉴 버튼
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
        showModalBottomSheet(
          context: context,
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(constants.largeBorderRadius(context)),
            ),
          ),
          builder: (context) => _MobileMenuSheet(
            currentIndex: currentIndex,
            onItemSelected: (index) {
              Navigator.pop(context);
              onItemSelected?.call(index);
            },
            menuItems: _menuItems,
            menuIcons: _menuIcons,
          ),
        );
      },
    );
  }
}

/// 모바일 메뉴 시트
class _MobileMenuSheet extends StatelessWidget {
  final Function(int) onItemSelected;
  final int currentIndex;
  final List<String> menuItems;
  final List<IconData> menuIcons;

  const _MobileMenuSheet({
    required this.onItemSelected,
    required this.currentIndex,
    required this.menuItems,
    required this.menuIcons,
  });

  @override
  Widget build(BuildContext context) {
    final constants = AppConstants.of(context);
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.all(constants.spacingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 핸들
            Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: theme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(height: constants.spacingL),

            // 메뉴 아이템들
            ...List.generate(menuItems.length, (index) {
              return _MobileMenuSheetItem(
                icon: menuIcons[index],
                label: menuItems[index],
                isSelected: currentIndex == index,
                onTap: () => onItemSelected(index),
              );
            }),

            SizedBox(height: constants.spacingM),
          ],
        ),
      ),
    );
  }
}

/// 모바일 메뉴 시트 아이템
class _MobileMenuSheetItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileMenuSheetItem({
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