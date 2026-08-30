// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors - Emerald Green 포인트
  static const Color primaryEmerald = Color(0xFF10B981);
  static const Color lightBackground = Color(0xFFFAFAFA);

  // Light Theme Colors - 무채색 중심, 포인트 컬러 사용
  static const Color primaryLight = primaryEmerald;
  static const Color onPrimaryLight = Colors.white;
  static const Color primaryContainerLight = Color(0xFFD1FAE5); // 연한 민트
  static const Color onPrimaryContainerLight = Color(0xFF064E3B);

  static const Color secondaryLight = Color(0xFF6B7280); // 그레이 - 무채색
  static const Color onSecondaryLight = Colors.white;
  static const Color secondaryContainerLight = Color(0xFFF3F4F6);
  static const Color onSecondaryContainerLight = Color(0xFF374151);

  static const Color tertiaryLight = Color(0xFF059669); // 포인트 컬러의 어두운 톤
  static const Color onTertiaryLight = Colors.white;
  static const Color tertiaryContainerLight = Color(0xFFA7F3D0);
  static const Color onTertiaryContainerLight = Color(0xFF065F46);

  static const Color errorLight = Color(0xFFEF4444);
  static const Color onErrorLight = Colors.white;
  static const Color errorContainerLight = Color(0xFFFEE2E2);
  static const Color onErrorContainerLight = Color(0xFF991B1B);

  static const Color backgroundLight = lightBackground;
  static const Color onBackgroundLight = Color(0xFF1F2937); // 진한 그레이
  static const Color surfaceLight = Colors.white;
  static const Color onSurfaceLight = Color(0xFF1F2937);
  static const Color surfaceVariantLight = Color(0xFFF9FAFB); // 아주 연한 그레이
  static const Color onSurfaceVariantLight = Color(0xFF6B7280);

  static const Color outlineLight = Color(0xFFD1D5DB);
  static const Color outlineVariantLight = Color(0xFFE5E7EB);
  static const Color shadowLight = Colors.black12;
  static const Color inverseSurfaceLight = Color(0xFF374151);
  static const Color onInverseSurfaceLight = Color(0xFFF9FAFB);
  static const Color inversePrimaryLight = Color(0xFF6EE7B7);

  // Dark Theme Colors - 다크모드용 무채색 + 포인트
  static const Color primaryDark = Color(0xFF34D399); // 밝은 에메랄드
  static const Color onPrimaryDark = Color(0xFF064E3B);
  static const Color primaryContainerDark = Color(0xFF059669);
  static const Color onPrimaryContainerDark = Color(0xFFD1FAE5);

  static const Color secondaryDark = Color(0xFF9CA3AF); // 밝은 그레이
  static const Color onSecondaryDark = Color(0xFF1F2937);
  static const Color secondaryContainerDark = Color(0xFF4B5563);
  static const Color onSecondaryContainerDark = Color(0xFFF3F4F6);

  static const Color tertiaryDark = Color(0xFF6EE7B7); // 밝은 민트
  static const Color onTertiaryDark = Color(0xFF065F46);
  static const Color tertiaryContainerDark = Color(0xFF047857);
  static const Color onTertiaryContainerDark = Color(0xFFA7F3D0);

  static const Color errorDark = Color(0xFFFCA5A5);
  static const Color onErrorDark = Color(0xFF991B1B);
  static const Color errorContainerDark = Color(0xFFDC2626);
  static const Color onErrorContainerDark = Color(0xFFFEE2E2);

  static const Color backgroundDark = Color(0xFF0F172A); // 진한 네이비 그레이
  static const Color onBackgroundDark = Color(0xFFF1F5F9);
  static const Color surfaceDark = Color(0xFF1E293B); // 미디엄 다크 그레이
  static const Color onSurfaceDark = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF334155);
  static const Color onSurfaceVariantDark = Color(0xFFCBD5E1);

  static const Color outlineDark = Color(0xFF475569);
  static const Color outlineVariantDark = Color(0xFF334155);
  static const Color shadowDark = Colors.black54;
  static const Color inverseSurfaceDark = Color(0xFFF1F5F9);
  static const Color onInverseSurfaceDark = Color(0xFF1E293B);
  static const Color inversePrimaryDark = primaryEmerald;
}

// Extension for additional custom colors
extension AppColorScheme on ColorScheme {
  // Success colors - Emerald 계열
  Color get success => brightness == Brightness.light
      ? const Color(0xFF10B981)
      : const Color(0xFF34D399);

  Color get onSuccess => brightness == Brightness.light
      ? Colors.white
      : const Color(0xFF064E3B);

  Color get successContainer => brightness == Brightness.light
      ? const Color(0xFFD1FAE5)
      : const Color(0xFF059669);

  Color get onSuccessContainer => brightness == Brightness.light
      ? const Color(0xFF064E3B)
      : const Color(0xFFD1FAE5);

  // Warning colors - 무채색에 잘 어울리는 앰버 톤
  Color get warning => brightness == Brightness.light
      ? const Color(0xFFF59E0B)
      : const Color(0xFFFBBF24);

  Color get onWarning => brightness == Brightness.light
      ? Colors.white
      : const Color(0xFF78350F);

  Color get warningContainer => brightness == Brightness.light
      ? const Color(0xFFFEF3C7)
      : const Color(0xFFD97706);

  Color get onWarningContainer => brightness == Brightness.light
      ? const Color(0xFF78350F)
      : const Color(0xFFFEF3C7);

  // Info colors - 무채색 블루 그레이
  Color get info => brightness == Brightness.light
      ? const Color(0xFF0EA5E9)
      : const Color(0xFF38BDF8);

  Color get onInfo => brightness == Brightness.light
      ? Colors.white
      : const Color(0xFF075985);

  // Neutral colors - 무채색 강조
  Color get neutral => brightness == Brightness.light
      ? const Color(0xFF6B7280)
      : const Color(0xFF9CA3AF);

  Color get neutralVariant => brightness == Brightness.light
      ? const Color(0xFFE5E7EB)
      : const Color(0xFF374151);

  // Text colors - 가독성 중심의 무채색
  Color get mainText => brightness == Brightness.light
      ? const Color(0xFF111827) // 거의 검정
      : const Color(0xFFF9FAFB); // 거의 하양

  Color get subText => brightness == Brightness.light
      ? const Color(0xFF4B5563) // 미디엄 그레이
      : const Color(0xFFD1D5DB); // 밝은 그레이

  Color get disabledText => brightness == Brightness.light
      ? const Color(0xFF9CA3AF)
      : const Color(0xFF6B7280);
}