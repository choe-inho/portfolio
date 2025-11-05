import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:portfolio/controller/App_Controller.dart';
import 'package:portfolio/screen/hero/Hero_Page.dart';
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
          home: const ResponsiveWrapper(
            child: HeroPage(),
          ),
        );
      },
    );
  }
}

/// 반응형 래퍼 - 화면 크기 변경을 감지하고 AppController에 전달
class ResponsiveWrapper extends StatelessWidget {
  final Widget child;

  const ResponsiveWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 크기가 변경될 때마다 AppController 업데이트
        WidgetsBinding.instance.addPostFrameCallback((_) {
          appController.updateScreenSize(
            constraints.maxWidth,
            constraints.maxHeight,
          );
        });

        return child;
      },
    );
  }
}