import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:go_router/go_router.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/motion/motion.dart';
import '../core/responsive/responsive.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../router/app_routes.dart';

class _NavItem {
  const _NavItem(this.label, this.path);
  final String label;
  final String path;
}

const _navItems = [
  _NavItem('Home', AppRoutes.home),
  _NavItem('About', AppRoutes.aboutMe),
  _NavItem('Projects', AppRoutes.projects),
  _NavItem('Contact', AppRoutes.contact),
];

/// The skill's "Fluid Island" nav: a floating glass pill detached from the
/// top edge, collapsing to a hamburger-to-X morph with a full-screen glass
/// overlay on mobile.
class AppNavBar extends StatefulWidget {
  const AppNavBar({super.key, required this.currentPath});

  final String currentPath;

  @override
  State<AppNavBar> createState() => _AppNavBarState();
}

class _AppNavBarState extends State<AppNavBar> {
  bool _open = false;

  void _navigate(String path) {
    setState(() => _open = false);
    if (path != widget.currentPath) context.go(path);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: context.isMobile
                ? _mobileBar(context)
                : _desktopBar(context),
          ),
        ),
        if (_open && context.isMobile) _mobileOverlay(context),
      ],
    );
  }

  Widget _glassShell({required Widget child, EdgeInsetsGeometry? padding}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding:
              padding ?? const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: AppColors.glassBorder),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _desktopBar(BuildContext context) {
    return _glassShell(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Text(
              '최인호',
              style: AppTextStyles.button.copyWith(letterSpacing: -0.2),
            ),
          ),
          for (final item in _navItems) _navPill(item),
        ],
      ),
    );
  }

  Widget _navPill(_NavItem item) {
    final active = item.path == widget.currentPath;
    return MagneticTap(
      onTap: () => _navigate(item.path),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppColors.glassFillStrong : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          item.label,
          style: AppTextStyles.bodySmall.copyWith(
            color: active ? AppColors.textPrimary : AppColors.textSecondary,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Widget _mobileBar(BuildContext context) {
    return _glassShell(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text('최인호', style: AppTextStyles.button),
          ),
          MagneticTap(
            onTap: () => setState(() => _open = !_open),
            child: Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.glassFillStrong,
                shape: BoxShape.circle,
              ),
              child: AnimatedSwitcher(
                duration: AppMotion.fast,
                child: FaIcon(
                  _open ? FontAwesomeIcons.xmark : FontAwesomeIcons.list,
                  key: ValueKey(_open),
                  size: 18,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mobileOverlay(BuildContext context) {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          color: AppColors.background.withValues(alpha: 0.85),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < _navItems.length; i++)
                  FadeSlideIn(
                    delay: Duration(milliseconds: 80 * i),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        onTap: () => _navigate(_navItems[i].path),
                        child: Text(
                          _navItems[i].label,
                          style: AppTextStyles.headline.copyWith(fontSize: 32),
                        ),
                      ),
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
