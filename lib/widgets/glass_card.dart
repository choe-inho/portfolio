import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

/// The skill's "Double-Bezel" pattern translated to Flutter: an outer glass
/// shell (thin hairline, soft fill, large outer radius) wrapping an inner
/// core with its own background and a slightly smaller, concentric radius.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.outerRadius = 32,
    this.innerColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double outerRadius;
  final Color? innerColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final innerRadius = outerRadius - 6;
    final content = Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(outerRadius),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Container(
        padding: padding,
        width: double.infinity,
        decoration: BoxDecoration(
          color: innerColor ?? AppColors.surface,
          borderRadius: BorderRadius.circular(innerRadius),
          border: Border.all(color: AppColors.glassBorderStrong, width: 0.6),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 24,
              offset: Offset(0, 12),
            ),
          ],
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(innerRadius),
          border: const Border(
            top: BorderSide(color: AppColors.glassHighlight, width: 1),
          ),
        ),
        child: child,
      ),
    );

    if (onTap == null) return content;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(onTap: onTap, child: content),
    );
  }
}

/// Tiny pill-shaped label preceding a headline (the skill's "eyebrow tag").
class EyebrowTag extends StatelessWidget {
  const EyebrowTag({super.key, required this.text, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final tint = color ?? AppColors.emerald;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: tint.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: tint.withValues(alpha: 0.3)),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 2.5,
          color: tint,
        ),
      ),
    );
  }
}
