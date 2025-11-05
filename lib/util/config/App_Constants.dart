import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart' hide DeviceType;
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';

class AppConstants {
  AppConstants._();

  static AppConstants of(BuildContext context) {
    return AppConstants._();
  }

  // ============================================
  // 플랫폼 & 디바이스 감지
  // ============================================

  /// 웹 여부
  bool get isWeb => kIsWeb;

  /// 안드로이드 여부
  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// iOS 여부
  bool get isIOS => !kIsWeb && Platform.isIOS;

  /// macOS 여부
  bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Windows 여부
  bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Linux 여부
  bool get isLinux => !kIsWeb && Platform.isLinux;

  /// 모바일 플랫폼 여부 (Android or iOS)
  bool get isMobilePlatform => isAndroid || isIOS;

  /// 데스크톱 플랫폼 여부
  bool get isDesktopPlatform => isMacOS || isWindows || isLinux;

  // ============================================
  // 화면 크기 기반 판단
  // ============================================

  /// 태블릿 여부 (shortestSide >= 600)
  bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  /// 큰 태블릿 여부 (shortestSide >= 720)
  bool isLargeTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 720;
  }

  /// 작은 모바일 여부 (width < 360)
  bool isSmallPhone(BuildContext context) {
    return MediaQuery.of(context).size.width < 360;
  }

  /// 큰 모바일 여부 (width >= 414)
  bool isLargePhone(BuildContext context) {
    return MediaQuery.of(context).size.width >= 414;
  }

  /// AppController 기반 디바이스 타입
  DeviceType getDeviceType() {
    try {
      final appController = Get.find<AppController>();
      return appController.device.value;
    } catch (e) {
      return DeviceType.unknown;
    }
  }

  // ============================================
  // 테마 & 다크모드
  // ============================================

  /// 다크모드 여부
  bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// 시스템 다크모드 여부
  bool isSystemDarkMode(BuildContext context) {
    return MediaQuery.of(context).platformBrightness == Brightness.dark;
  }

  // ============================================
  // 반응형 간격 & 크기 (AppController 연동)
  // ============================================

  /// 하단 여백 (플랫폼별)
  double bottomInsets(BuildContext context) {
    if (isWeb) return 16.h;
    if (isAndroid) return 20.h;
    if (isIOS) return 24.h;
    return 20.h;
  }

  /// 상단 여백 (플랫폼별)
  double topInsets(BuildContext context) {
    if (isWeb) return 16.h;
    return MediaQuery.of(context).padding.top;
  }

  /// 안전 영역 패딩
  EdgeInsets safeAreaPadding(BuildContext context) {
    return EdgeInsets.only(
      top: topInsets(context),
      bottom: bottomInsets(context),
    );
  }

  // ============================================
  // 아이콘 크기
  // ============================================

  /// 다이얼로그 아이콘 크기
  double dialogIconSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 24.r,
        tablet: 32.r,
        web: 36.r,
      );
    } catch (e) {
      return isTablet(context) ? 32.r : 24.r;
    }
  }

  /// 기본 아이콘 크기
  double iconSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 24.r,
        tablet: 28.r,
        web: 32.r,
      );
    } catch (e) {
      return isTablet(context) ? 28.r : 24.r;
    }
  }

  /// 작은 아이콘 크기
  double smallIconSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 16.r,
        tablet: 20.r,
        web: 22.r,
      );
    } catch (e) {
      return isTablet(context) ? 20.r : 16.r;
    }
  }

  /// 큰 아이콘 크기
  double largeIconSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 32.r,
        tablet: 40.r,
        web: 48.r,
      );
    } catch (e) {
      return isTablet(context) ? 40.r : 32.r;
    }
  }

  // ============================================
  // 버튼 크기
  // ============================================

  /// 버튼 높이
  double buttonHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 48.h,
        tablet: 52.h,
        web: 56.h,
      );
    } catch (e) {
      return isTablet(context) ? 52.h : 48.h;
    }
  }

  /// 작은 버튼 높이
  double smallButtonHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 36.h,
        tablet: 40.h,
        web: 44.h,
      );
    } catch (e) {
      return isTablet(context) ? 40.h : 36.h;
    }
  }

  /// 큰 버튼 높이
  double largeButtonHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 56.h,
        tablet: 60.h,
        web: 64.h,
      );
    } catch (e) {
      return isTablet(context) ? 60.h : 56.h;
    }
  }

  /// 버튼 최소 너비
  double buttonMinWidth(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 120.w,
        tablet: 140.w,
        web: 160.w,
      );
    } catch (e) {
      return isTablet(context) ? 140.w : 120.w;
    }
  }

  // ============================================
  // 패딩 & 마진
  // ============================================

  /// 가로 패딩
  double horizontalPadding(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 16.w,
        tablet: 24.w,
        web: 32.w,
      );
    } catch (e) {
      return isTablet(context) ? 24.w : 16.w;
    }
  }

  /// 세로 패딩
  double verticalPadding(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 12.h,
        tablet: 16.h,
        web: 24.h,
      );
    } catch (e) {
      return isTablet(context) ? 16.h : 12.h;
    }
  }

  /// 작은 패딩
  double smallPadding(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 8.w,
        tablet: 12.w,
        web: 16.w,
      );
    } catch (e) {
      return isTablet(context) ? 12.w : 8.w;
    }
  }

  /// 큰 패딩
  double largePadding(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 24.w,
        tablet: 32.w,
        web: 48.w,
      );
    } catch (e) {
      return isTablet(context) ? 32.w : 24.w;
    }
  }

  /// 카드 패딩
  EdgeInsets cardPadding(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      final value = controller.responsive(
        mobile: 16.0,
        tablet: 20.0,
        web: 24.0,
      );
      return EdgeInsets.all(value);
    } catch (e) {
      return EdgeInsets.all(isTablet(context) ? 20.0 : 16.0);
    }
  }

  /// 페이지 패딩 (좌우상하 모두)
  EdgeInsets pagePadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context),
      vertical: verticalPadding(context),
    );
  }

  // ============================================
  // Border Radius
  // ============================================

  /// 기본 Border Radius
  double borderRadius(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 12.r,
        tablet: 16.r,
        web: 20.r,
      );
    } catch (e) {
      return isTablet(context) ? 16.r : 12.r;
    }
  }

  /// 작은 Border Radius
  double smallBorderRadius(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 8.r,
        tablet: 10.r,
        web: 12.r,
      );
    } catch (e) {
      return isTablet(context) ? 10.r : 8.r;
    }
  }

  /// 큰 Border Radius
  double largeBorderRadius(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 16.r,
        tablet: 20.r,
        web: 24.r,
      );
    } catch (e) {
      return isTablet(context) ? 20.r : 16.r;
    }
  }

  /// 원형 Border Radius (pill shape)
  double pillBorderRadius(BuildContext context) {
    return 999.r;
  }

  // ============================================
  // 로딩 인디케이터
  // ============================================

  /// 기본 인디케이터 크기
  double defaultIndicatorSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 60.r,
        tablet: 80.r,
        web: 100.r,
      );
    } catch (e) {
      return isTablet(context) ? 80.r : 60.r;
    }
  }

  /// 작은 인디케이터 크기
  double smallIndicatorSize(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 24.r,
        tablet: 32.r,
        web: 40.r,
      );
    } catch (e) {
      return isTablet(context) ? 32.r : 24.r;
    }
  }

  // ============================================
  // 간격 (Spacing)
  // ============================================

  /// 아주 작은 간격
  double get spacingXS => 4.w;

  /// 작은 간격
  double get spacingS => 8.w;

  /// 보통 간격
  double get spacingM => 16.w;

  /// 큰 간격
  double get spacingL => 24.w;

  /// 아주 큰 간격
  double get spacingXL => 32.w;

  /// 특대 간격
  double get spacingXXL => 48.w;

  // ============================================
  // 화면 크기 정보
  // ============================================

  /// 화면 너비
  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// 화면 높이
  double screenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// 화면 짧은 쪽
  double screenShortestSide(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide;
  }

  /// 화면 긴 쪽
  double screenLongestSide(BuildContext context) {
    return MediaQuery.of(context).size.longestSide;
  }

  /// 가로모드 여부
  bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  /// 세로모드 여부
  bool isPortrait(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.portrait;
  }

  // ============================================
  // 에셋 경로 (테마별)
  // ============================================

  /// 텍스트 로고
  String textLogo(BuildContext context) {
    return isDarkMode(context)
        ? 'assets/app/app_text_dark.png'
        : 'assets/app/app_text_light.png';
  }

  /// 에러 폴백 이미지
  String errorFallBack(BuildContext context) {
    return isDarkMode(context)
        ? 'assets/image/error_fall_back_dark.png'
        : 'assets/image/error_fall_back_light.png';
  }

  /// 로고 위젯 (색상 적용)
  Widget logo(BuildContext context, {Color? color}) {
    final isDark = isDarkMode(context);
    final defaultColor = isDark ? const Color(0xFFF1F1F1) : const Color(0xFF2E2E2E);

    return Image.asset(
      'assets/app/app_black.png',
      color: color ?? defaultColor,
    );
  }

  /// 로고 (크기 지정)
  Widget logoWithSize(BuildContext context, {double? size, Color? color}) {
    final defaultSize = iconSize(context) * 2;
    return SizedBox(
      width: size ?? defaultSize,
      height: size ?? defaultSize,
      child: logo(context, color: color),
    );
  }

  // ============================================
  // 애니메이션 Duration
  // ============================================

  /// 빠른 애니메이션
  Duration get fastAnimation => const Duration(milliseconds: 200);

  /// 보통 애니메이션
  Duration get normalAnimation => const Duration(milliseconds: 300);

  /// 느린 애니메이션
  Duration get slowAnimation => const Duration(milliseconds: 500);

  // ============================================
  // AppBar 설정
  // ============================================

  /// AppBar 높이
  double appBarHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 56.h,
        tablet: 64.h,
        web: 72.h,
      );
    } catch (e) {
      return isTablet(context) ? 64.h : 56.h;
    }
  }

  // ============================================
  // 카드 설정
  // ============================================

  /// 카드 Elevation
  double cardElevation(BuildContext context) {
    if (isWeb) return 8;
    return isDarkMode(context) ? 4 : 2;
  }

  /// 카드 마진
  EdgeInsets cardMargin(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context) / 2,
      vertical: verticalPadding(context) / 2,
    );
  }

  // ============================================
  // TextField 설정
  // ============================================

  /// TextField 높이
  double textFieldHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 48.h,
        tablet: 52.h,
        web: 56.h,
      );
    } catch (e) {
      return isTablet(context) ? 52.h : 48.h;
    }
  }

  /// TextField 패딩
  EdgeInsets textFieldPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: horizontalPadding(context),
      vertical: 12.h,
    );
  }

  // ============================================
  // 리스트 설정
  // ============================================

  /// 리스트 아이템 높이
  double listItemHeight(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 56.h,
        tablet: 64.h,
        web: 72.h,
      );
    } catch (e) {
      return isTablet(context) ? 64.h : 56.h;
    }
  }

  /// 리스트 아이템 간격
  double listItemSpacing(BuildContext context) {
    return verticalPadding(context) / 2;
  }

  // ============================================
  // 그리드 설정
  // ============================================

  /// 그리드 컬럼 수
  int gridColumnCount(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 2,
        tablet: 3,
        web: 4,
      );
    } catch (e) {
      if (isWeb) return 4;
      return isTablet(context) ? 3 : 2;
    }
  }

  /// 그리드 간격
  double gridSpacing(BuildContext context) {
    return horizontalPadding(context) / 2;
  }

  // ============================================
  // 다이얼로그 설정
  // ============================================

  /// 다이얼로그 최대 너비
  double dialogMaxWidth(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: screenWidth(context) * 0.9,
        tablet: 500.w,
        web: 600.w,
      );
    } catch (e) {
      return isTablet(context) ? 500.w : screenWidth(context) * 0.9;
    }
  }

  /// 다이얼로그 패딩
  EdgeInsets dialogPadding(BuildContext context) {
    return EdgeInsets.all(largePadding(context));
  }
}

// ============================================
// Extension
// ============================================

extension AppConstantsExtension on BuildContext {
  AppConstants get constants => AppConstants.of(this);

  // 빠른 접근을 위한 추가 extension
  bool get isDarkMode => constants.isDarkMode(this);
  bool get isTablet => constants.isTablet(this);
  bool get isLandscape => constants.isLandscape(this);
  double get screenWidth => constants.screenWidth(this);
  double get screenHeight => constants.screenHeight(this);
}