// lib/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'App_Colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'Pretendard',

      colorScheme: const ColorScheme.light(
        // Primary
        primary: AppColors.primaryLight,
        onPrimary: AppColors.onPrimaryLight,
        primaryContainer: AppColors.primaryContainerLight,
        onPrimaryContainer: AppColors.onPrimaryContainerLight,

        // Secondary
        secondary: AppColors.secondaryLight,
        onSecondary: AppColors.onSecondaryLight,
        secondaryContainer: AppColors.secondaryContainerLight,
        onSecondaryContainer: AppColors.onSecondaryContainerLight,

        // Tertiary
        tertiary: AppColors.tertiaryLight,
        onTertiary: AppColors.onTertiaryLight,
        tertiaryContainer: AppColors.tertiaryContainerLight,
        onTertiaryContainer: AppColors.onTertiaryContainerLight,

        // Error
        error: AppColors.errorLight,
        onError: AppColors.onErrorLight,
        errorContainer: AppColors.errorContainerLight,
        onErrorContainer: AppColors.onErrorContainerLight,

        // Surface
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
        surfaceVariant: AppColors.surfaceVariantLight,
        onSurfaceVariant: AppColors.onSurfaceVariantLight,

        // Background
        background: AppColors.backgroundLight,
        onBackground: AppColors.onBackgroundLight,

        // Others
        outline: AppColors.outlineLight,
        outlineVariant: AppColors.outlineVariantLight,
        shadow: AppColors.shadowLight,
        inverseSurface: AppColors.inverseSurfaceLight,
        onInverseSurface: AppColors.onInverseSurfaceLight,
        inversePrimary: AppColors.inversePrimaryLight,
      ),

      // Text Theme
      textTheme: TextTheme(
        // Display
        displayLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 57.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          height: 1.12,
          color: AppColors.onBackgroundLight,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 45.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.16,
          color: AppColors.onBackgroundLight,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 36.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.22,
          color: AppColors.onBackgroundLight,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 32.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.25,
          color: AppColors.onBackgroundLight,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 28.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.29,
          color: AppColors.onBackgroundLight,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 24.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.33,
          color: AppColors.onBackgroundLight,
        ),

        // Title
        titleLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 22.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0,
          height: 1.27,
          color: AppColors.onBackgroundLight,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.15,
          height: 1.50,
          color: AppColors.onBackgroundLight,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.onBackgroundLight,
        ),

        // Label
        labelLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.onBackgroundLight,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.33,
          color: AppColors.onBackgroundLight,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
          color: AppColors.onBackgroundLight,
        ),

        // Body
        bodyLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
          color: AppColors.onBackgroundLight,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
          color: AppColors.onBackgroundLight,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
          color: AppColors.onBackgroundLight,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        leadingWidth: 45.w,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundLight,
        ),
        toolbarHeight: 56.h,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: AppColors.surfaceLight,
        margin: EdgeInsets.all(8.w),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.onPrimaryLight,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(88.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          foregroundColor: AppColors.primaryLight,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          minimumSize: Size(64.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          side: BorderSide(color: AppColors.primaryLight, width: 1.w),
          foregroundColor: AppColors.primaryLight,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(88.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.outlineLight),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.outlineLight),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryLight, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.errorLight),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.errorLight, width: 2.w),
        ),
        contentPadding: EdgeInsets.all(16.w),
        hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceLight.withValues(alpha:0.6),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceLight,
        ),
        errorStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.errorLight,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.onPrimaryLight,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primaryLight,
        unselectedItemColor: AppColors.onSurfaceLight.withValues(alpha:0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceLight,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 24,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceLight,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceLight,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurfaceLight,
        contentTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onInverseSurfaceLight,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'Pretendard',

      colorScheme: const ColorScheme.dark(
        // Primary
        primary: AppColors.primaryDark,
        onPrimary: AppColors.onPrimaryDark,
        primaryContainer: AppColors.primaryContainerDark,
        onPrimaryContainer: AppColors.onPrimaryContainerDark,

        // Secondary
        secondary: AppColors.secondaryDark,
        onSecondary: AppColors.onSecondaryDark,
        secondaryContainer: AppColors.secondaryContainerDark,
        onSecondaryContainer: AppColors.onSecondaryContainerDark,

        // Tertiary
        tertiary: AppColors.tertiaryDark,
        onTertiary: AppColors.onTertiaryDark,
        tertiaryContainer: AppColors.tertiaryContainerDark,
        onTertiaryContainer: AppColors.onTertiaryContainerDark,

        // Error
        error: AppColors.errorDark,
        onError: AppColors.onErrorDark,
        errorContainer: AppColors.errorContainerDark,
        onErrorContainer: AppColors.onErrorContainerDark,

        // Surface
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        surfaceVariant: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,

        // Background
        background: AppColors.backgroundDark,
        onBackground: AppColors.onBackgroundDark,

        // Others
        outline: AppColors.outlineDark,
        outlineVariant: AppColors.outlineVariantDark,
        shadow: AppColors.shadowDark,
        inverseSurface: AppColors.inverseSurfaceDark,
        onInverseSurface: AppColors.onInverseSurfaceDark,
        inversePrimary: AppColors.inversePrimaryDark,
      ),

      // Text Theme
      textTheme: TextTheme(
        // Display
        displayLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 57.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.25,
          height: 1.12,
          color: AppColors.onBackgroundDark,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 45.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.16,
          color: AppColors.onBackgroundDark,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 36.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.22,
          color: AppColors.onBackgroundDark,
        ),

        // Headline
        headlineLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 32.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.25,
          color: AppColors.onBackgroundDark,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 28.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.29,
          color: AppColors.onBackgroundDark,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 24.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
          height: 1.33,
          color: AppColors.onBackgroundDark,
        ),

        // Title
        titleLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 22.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0,
          height: 1.27,
          color: AppColors.onBackgroundDark,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
          height: 1.50,
          color: AppColors.onBackgroundDark,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.onBackgroundDark,
        ),

        // Label
        labelLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
          height: 1.43,
          color: AppColors.onBackgroundDark,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.33,
          color: AppColors.onBackgroundDark,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
          height: 1.45,
          color: AppColors.onBackgroundDark,
        ),

        // Body
        bodyLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
          height: 1.50,
          color: AppColors.onBackgroundDark,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
          height: 1.43,
          color: AppColors.onBackgroundDark,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
          height: 1.33,
          color: AppColors.onBackgroundDark,
        ),
      ),

      // AppBar Theme
      appBarTheme: AppBarTheme(
        leadingWidth: 45.w,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.onBackgroundDark,
        ),
        toolbarHeight: 56.h,
      ),

      // Card Theme
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        color: AppColors.surfaceDark,
        margin: EdgeInsets.all(8.w),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          backgroundColor: AppColors.primaryDark,
          foregroundColor: AppColors.onPrimaryDark,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(88.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          foregroundColor: AppColors.primaryDark,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          minimumSize: Size(64.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          side: BorderSide(color: AppColors.primaryDark, width: 1.w),
          foregroundColor: AppColors.primaryDark,
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
          minimumSize: Size(88.w, 36.h),
          textStyle: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.outlineDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.outlineDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.primaryDark, width: 2.w),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.errorDark),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(color: AppColors.errorDark, width: 2.w),
        ),
        contentPadding: EdgeInsets.all(16.w),
        hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceDark.withValues(alpha:0.6),
        ),
        labelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceDark,
        ),
        errorStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.errorDark,
        ),
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.onPrimaryDark,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primaryDark,
        unselectedItemColor: AppColors.onSurfaceDark.withValues(alpha:0.6),
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        elevation: 24,
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceDark,
        ),
        contentTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurfaceDark,
        ),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.inverseSurfaceDark,
        contentTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: AppColors.onInverseSurfaceDark,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

}