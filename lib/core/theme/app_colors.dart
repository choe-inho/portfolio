import 'package:flutter/material.dart';

/// Ethereal Glass palette (high-end-visual-design skill, Vibe Archetype A.1):
/// deep OLED black background with translucent glass surfaces and a
/// purple/blue/emerald mesh-gradient accent family.
class AppColors {
  AppColors._();

  static const Color background = Color(0xFF050505);
  static const Color surface = Color(0xFF0D0D0F);
  static const Color surfaceElevated = Color(0xFF17171A);

  static const Color glassFill = Color(0x0DFFFFFF); // white @ 5%
  static const Color glassFillStrong = Color(0x14FFFFFF); // white @ 8%
  static const Color glassBorder = Color(0x1AFFFFFF); // white @ 10%
  static const Color glassBorderStrong = Color(0x33FFFFFF); // white @ 20%
  static const Color glassHighlight = Color(0x26FFFFFF); // white @ 15%

  static const Color textPrimary = Color(0xFFF5F5F7);
  static const Color textSecondary = Color(0xFFA1A1AA);
  static const Color textTertiary = Color(0xFF6B6B70);

  static const Color emerald = Color(0xFF10B981);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFFA855F7);

  static const Color error = Color(0xFFEF4444);
  static const Color success = emerald;

  static const List<Color> meshGradient = [purple, blue, emerald];
}
