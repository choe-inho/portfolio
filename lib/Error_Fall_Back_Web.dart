import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:portfolio/util/constants/App_Constants.dart';
import 'package:portfolio/util/theme/App_Theme.dart';

class ErrorFallBackWeb extends StatelessWidget {
  const ErrorFallBackWeb({super.key});

  @override
  Widget build(BuildContext context) {
    final con = AppConstants.of(context);
    final theme = Theme.of(context);
    return ScreenUtilInit(
        designSize: Size(1368, 738),
        builder: (context, child) {
          return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: ThemeMode.system,
              home:  Material(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 324.h,
                      width: 617.w,
                      child: Image.asset(con.errorFallBack(context)),
                    ),
                    SizedBox(height: 40.h,),
                    Text('올바르지 않은 페이지 경로입니다', style: theme.textTheme.headlineMedium,),
                    SizedBox(height: 40.h,),
                  ],
                ),
              )
          );
        }
    );
  }
}
