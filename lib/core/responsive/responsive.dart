import 'package:flutter/material.dart';

/// Context-driven responsive layer.
///
/// The legacy app used `flutter_screenutil` (a fixed design-size scaler) and
/// hit its limits on mobile web (see README trouble-shooting notes), forcing
/// a manual `BuildContext`-based workaround bolted on afterwards. This layer
/// is built on `MediaQuery` from the start instead, so there is no scaler to
/// fight with.
enum DeviceType { mobile, tablet, desktop }

class Responsive {
  Responsive._();

  static const double mobileBreakpoint = 600;
  static const double desktopBreakpoint = 1200;

  static DeviceType deviceTypeOf(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width < mobileBreakpoint) return DeviceType.mobile;
    if (width < desktopBreakpoint) return DeviceType.tablet;
    return DeviceType.desktop;
  }
}

extension ResponsiveContext on BuildContext {
  DeviceType get deviceType => Responsive.deviceTypeOf(this);
  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Picks a value for the current breakpoint. `tablet` falls back to
  /// `desktop` when omitted, since most of this app only needs a two-way
  /// mobile/desktop split.
  T responsive<T>({required T mobile, T? tablet, required T desktop}) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? desktop;
      case DeviceType.desktop:
        return desktop;
    }
  }

  double get horizontalPadding =>
      responsive(mobile: 20.0, tablet: 40.0, desktop: 96.0);

  double get sectionPaddingVertical =>
      responsive(mobile: 64.0, tablet: 96.0, desktop: 140.0);

  double get maxContentWidth =>
      responsive(mobile: double.infinity, tablet: 900.0, desktop: 1280.0);

  int get bentoColumns => responsive(mobile: 1, tablet: 2, desktop: 3);
}
