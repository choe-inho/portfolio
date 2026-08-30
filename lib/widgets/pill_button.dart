import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/motion/motion.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

/// Pill CTA with a nested circular trailing-icon well — the skill's
/// "button-in-button" pattern — plus a slow pulsing glow on filled
/// (primary) buttons so the main CTA never sits static on the page.
class PillButton extends StatefulWidget {
  const PillButton({
    super.key,
    required this.label,
    this.onTap,
    this.icon = FontAwesomeIcons.arrowUpRightFromSquare,
    this.filled = true,
    bool? glow,
  }) : glow = glow ?? filled;

  final String label;
  final VoidCallback? onTap;
  final FaIconData icon;
  final bool filled;
  final bool glow;

  @override
  State<PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<PillButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.only(left: 24, right: 8, top: 8, bottom: 8),
      decoration: BoxDecoration(
        color: widget.filled ? AppColors.textPrimary : AppColors.glassFill,
        borderRadius: BorderRadius.circular(999),
        border: widget.filled
            ? null
            : Border.all(color: AppColors.glassBorderStrong),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: AppTextStyles.button.copyWith(
              color: widget.filled ? Colors.black : AppColors.textPrimary,
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: widget.filled
                  ? Colors.black.withValues(alpha: 0.08)
                  : AppColors.glassFillStrong,
              shape: BoxShape.circle,
            ),
            child: FaIcon(
              widget.icon,
              size: 16,
              color: widget.filled ? Colors.black : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );

    if (!widget.glow) {
      return MagneticTap(onTap: widget.onTap, child: content);
    }

    return MagneticTap(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _pulse,
        builder: (context, child) {
          final t = _pulse.value;
          return DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: AppColors.emerald.withValues(alpha: 0.16 + t * 0.14),
                  blurRadius: 18 + t * 14,
                  spreadRadius: t * 2,
                ),
              ],
            ),
            child: child,
          );
        },
        child: content,
      ),
    );
  }
}
