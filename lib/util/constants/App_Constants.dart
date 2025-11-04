import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppConstants {
  AppConstants._();

  static AppConstants of(BuildContext context) {
    return AppConstants._();
  }

  // 태블릿 여부 자동 판단
  bool _isTablet(BuildContext context) {
    return MediaQuery.of(context).size.shortestSide >= 600;
  }

  bool _isDarkMode(BuildContext context){
    return Theme.of(context).brightness == Brightness.dark;
  }

  bool _isAndroid(){
    return Platform.isAndroid;
  }

  double bottomInsets() => _isAndroid() ? 20.h : 24.h;

  double dialogIconSize(BuildContext context)=>
      _isTablet(context) ? 36.r : 24.r;


  double iconSize(BuildContext context) =>
      _isTablet(context) ? 32.r : 24.r;

  double buttonHeight(BuildContext context) =>
      _isTablet(context) ? 52.r : 48.r;

  double horizontalPadding(BuildContext context) =>
      _isTablet(context) ? 24.w : 16.w;

  double verticalPadding(BuildContext context) =>
      _isTablet(context) ? 22.h : 15.h;

  double borderRadius(BuildContext context) =>
      _isTablet(context) ? 15.r : 12.r;

  double defaultIndicatorSize(BuildContext context) =>
      _isTablet(context) ? 100.r : 80.r;

  String textLogo(BuildContext context) => _isDarkMode(context) ? 'assets/app/app_text_dark.png' : 'assets/app/app_text_light.png';


  String errorFallBack(BuildContext context) => _isDarkMode(context) ? 'assets/image/error_fall_back_dark.png': 'assets/image/error_fall_back_light.png';

  Widget logo(BuildContext context, Color? color)=> _isDarkMode(context) ? Image.asset('assets/app/app_black.png', color: color ?? const Color(0xfff1f1f1),): Image.asset('assets/app/app_black.png', color: color ?? const Color(0xff2e2e2e),);
  double screenSize(BuildContext context){
    return MediaQuery.of(context).size.width;
  }
}

extension AppConstantsExtension on BuildContext {
  AppConstants get constants => AppConstants.of(this);
}
