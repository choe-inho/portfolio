import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum DeviceType {
  mobile,   // < 600px
  tablet,   // 600px ~ 1200px
  web,      // > 1200px
  unknown
}

class AppController extends GetxController {
  // 디바이스 타입 상태
  final Rx<DeviceType> device = DeviceType.unknown.obs;

  // 화면 너비 상태
  final RxDouble screenWidth = 0.0.obs;

  // 화면 높이 상태
  final RxDouble screenHeight = 0.0.obs;

  // 반응형 브레이크포인트
  static const double mobileBreakpoint = 600.0;
  static const double tabletBreakpoint = 1200.0;

  @override
  void onInit() {
    super.onInit();
    _initializeAppController();
  }

  /// 앱 컨트롤러 초기화
  void _initializeAppController() {
    debugPrint('🎮 [AppController] 초기화 시작...');

    // 초기 디바이스 체크
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDevice();
    });

    debugPrint('✅ [AppController] 초기화 완료');
  }

  /// 화면 크기 변경 리스너 등록 (BuildContext 필요)
  void attachListener(BuildContext context) {
    // MediaQuery를 통한 초기 화면 크기 설정
    final size = MediaQuery.of(context).size;
    _updateScreenSize(size.width, size.height);

    debugPrint('📱 [AppController] 리스너 등록 완료 - ${device.value}');
  }

  /// 화면 크기 업데이트 및 디바이스 타입 판단
  void _updateScreenSize(double width, double height) {
    screenWidth.value = width;
    screenHeight.value = height;
    _checkDevice();
  }

  /// 디바이스 타입 확인
  void _checkDevice() {
    final width = screenWidth.value;

    DeviceType newDeviceType;

    if (width < mobileBreakpoint) {
      newDeviceType = DeviceType.mobile;
    } else if (width < tabletBreakpoint) {
      newDeviceType = DeviceType.tablet;
    } else {
      newDeviceType = DeviceType.web;
    }

    // 디바이스 타입이 변경된 경우에만 업데이트
    if (device.value != newDeviceType) {
      device.value = newDeviceType;
      debugPrint('🔄 [AppController] 디바이스 타입 변경: ${device.value} (${width.toStringAsFixed(0)}px)');
      update();
    }
  }

  /// 외부에서 화면 크기 업데이트 (LayoutBuilder 등에서 사용)
  void updateScreenSize(double width, double height) {
    _updateScreenSize(width, height);
  }

  // === 편의 메서드 ===

  /// 현재 모바일인지 확인
  bool get isMobile => device.value == DeviceType.mobile;

  /// 현재 태블릿인지 확인
  bool get isTablet => device.value == DeviceType.tablet;

  /// 현재 웹인지 확인
  bool get isWeb => device.value == DeviceType.web;

  /// 모바일 또는 태블릿인지 확인
  bool get isMobileOrTablet => isMobile || isTablet;

  /// 디바이스별 값 반환
  T responsive<T>({
    required T mobile,
    required T tablet,
    required T web,
  }) {
    switch (device.value) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet;
      case DeviceType.web:
        return web;
      default:
        return mobile;
    }
  }

  /// 디바이스별 패딩 값
  double get horizontalPadding {
    return responsive(
      mobile: 16.0,
      tablet: 24.0,
      web: 32.0,
    );
  }

  /// 디바이스별 수직 패딩 값
  double get verticalPadding {
    return responsive(
      mobile: 12.0,
      tablet: 16.0,
      web: 24.0,
    );
  }

  /// 디바이스별 컨텐츠 최대 너비
  double get maxContentWidth {
    return responsive(
      mobile: double.infinity,
      tablet: 900.0,
      web: 1200.0,
    );
  }

  @override
  void onClose() {
    debugPrint('👋 [AppController] 종료');
    super.onClose();
  }
}