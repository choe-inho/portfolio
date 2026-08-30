import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/util/route/App_Routes.dart';
import 'package:portfolio/util/theme/App_Theme.dart';

class Portfolio extends StatelessWidget {
  const Portfolio({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1368, 738),
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          // GetX 라우팅 설정
          initialRoute: AppRoutes.home,
          getPages: AppRoutes.routes,
          // IMPORTANT: ResponsiveWrapper로 각 페이지를 감싸야 함
          builder: (context, widget) {
            return ResponsiveWrapper(
              child: widget ?? const SizedBox(),
            );
          },
        );
      },
    );
  }
}

/// 반응형 래퍼 - 화면 크기 변경을 감지하고 AppController에 전달
class ResponsiveWrapper extends StatefulWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  State<ResponsiveWrapper> createState() => _ResponsiveWrapperState();
}

class _ResponsiveWrapperState extends State<ResponsiveWrapper> {
  @override
  void initState() {
    super.initState();
    // AppController가 초기화되어 있는지 확인하고 없으면 생성
    try {
      Get.find<AppController>();
    } catch (e) {
      // AppController가 없으면 생성
      Get.put(AppController(), permanent: true);
      debugPrint('✅ [ResponsiveWrapper] AppController 초기화 완료');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 크기가 변경될 때마다 AppController 업데이트
        WidgetsBinding.instance.addPostFrameCallback((_) {
          try {
            final appController = Get.find<AppController>();
            appController.updateScreenSize(
              constraints.maxWidth,
              constraints.maxHeight,
            );
          } catch (e) {
            debugPrint('⚠️ [ResponsiveWrapper] AppController를 찾을 수 없음: $e');
          }
        });

        return widget.child;
      },
    );
  }
}