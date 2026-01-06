// ============================================
// 폰트 크기 상수 (디바이스별 정의) ✨
// ============================================
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/App_Controller.dart';

class FontSizes {
  FontSizes._();

  static FontSizes of(BuildContext context) {
    return FontSizes._();
  }


  // Context 기반으로 디바이스별 폰트 크기 반환
  double displayLarge(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 28.0,    // 모바일: 고정값
        tablet: 40.0,    // 태블릿: 고정값
        web: 48.0,       // 웹: 고정값
      );
    } catch (e) {
      return 48.0;
    }
  }

  double displayMedium(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 24.0,
        tablet: 32.0,
        web: 36.0,
      );
    } catch (e) {
      return 36.0;
    }
  }

  double displaySmall(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 22.0,
        tablet: 28.0,
        web: 32.0,
      );
    } catch (e) {
      return 32.0;
    }
  }

  double headlineLarge(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 20.0,
        tablet: 24.0,
        web: 28.0,
      );
    } catch (e) {
      return 28.0;
    }
  }

  double headlineMedium(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 18.0,
        tablet: 20.0,
        web: 24.0,
      );
    } catch (e) {
      return 24.0;
    }
  }

  double headlineSmall(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 16.0,
        tablet: 20.0,
        web: 22.0,
      );
    } catch (e) {
      return 22.0;
    }
  }

  double titleLarge(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 16.0,    // 모바일: 읽기 편한 크기
        tablet: 18.0,
        web: 20.0,
      );
    } catch (e) {
      return 20.0;
    }
  }

  double titleMedium(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 15.0,
        tablet: 16.0,
        web: 18.0,
      );
    } catch (e) {
      return 18.0;
    }
  }

  double titleSmall(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 14.0,
        tablet: 15.0,
        web: 16.0,
      );
    } catch (e) {
      return 16.0;
    }
  }

  double bodyLarge(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 15.0,
        tablet: 16.0,
        web: 16.0,
      );
    } catch (e) {
      return 16.0;
    }
  }

  double bodyMedium(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 13.0,
        tablet: 14.0,
        web: 14.0,
      );
    } catch (e) {
      return 14.0;
    }
  }

  double bodySmall(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 12.0,
        tablet: 12.0,
        web: 12.0,
      );
    } catch (e) {
      return 12.0;
    }
  }

  double labelLarge(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 13.0,
        tablet: 14.0,
        web: 14.0,
      );
    } catch (e) {
      return 14.0;
    }
  }

  double labelMedium(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 12.0,
        tablet: 12.0,
        web: 12.0,
      );
    } catch (e) {
      return 12.0;
    }
  }

  double labelSmall(BuildContext context) {
    try {
      final controller = Get.find<AppController>();
      return controller.responsive(
        mobile: 11.0,
        tablet: 11.0,
        web: 11.0,
      );
    } catch (e) {
      return 11.0;
    }
  }
}
