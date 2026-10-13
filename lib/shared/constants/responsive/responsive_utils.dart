import 'package:flutter/material.dart';

enum DeviceType {
  mobileSmall,
  mobile,
  tablet,
  desktop,
}

class ResponsiveUtils {

  static const double baseWidth = 375;
  static const double baseHeight = 812;


  static double screenWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double screenHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static Orientation orientation(BuildContext context) =>
      MediaQuery.of(context).orientation;

  static bool isLandscape(BuildContext context) =>
      orientation(context) == Orientation.landscape;

  static double shortestSide(BuildContext context) =>
      MediaQuery.of(context).size.shortestSide;


  static DeviceType getDeviceType(BuildContext context) {
    final width = screenWidth(context);
    final shortSide = shortestSide(context);

    final isTablet = shortSide >= 600;

    if (width < 360) return DeviceType.mobileSmall;
    if (width < 600 && !isTablet) return DeviceType.mobile;
    if (width < 1024) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static bool isMobile(BuildContext context) =>
      getDeviceType(context) == DeviceType.mobile ||
      getDeviceType(context) == DeviceType.mobileSmall;

  static bool isTablet(BuildContext context) =>
      getDeviceType(context) == DeviceType.tablet;

  static bool isDesktop(BuildContext context) =>
      getDeviceType(context) == DeviceType.desktop;

  // ================= SCALE METHODS =================
  static double scaleW(BuildContext context, double size) {
    return (screenWidth(context) / baseWidth) * size;
  }

  static double scaleH(BuildContext context, double size) {
    return (screenHeight(context) / baseHeight) * size;
  }

  static double scaleSp(BuildContext context, double size) {
    final scale = screenWidth(context) / baseWidth;
    return size * scale.clamp(0.85, 1.3);
  }

  // ================= PERCENTAGE =================
  static double wp(BuildContext context, double percent) =>
      screenWidth(context) * percent / 100;

  static double hp(BuildContext context, double percent) =>
      screenHeight(context) * percent / 100;

  // ================= COMMON UI HELPERS =================

  static double getHorizontalPadding(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobileSmall:
        return scaleW(context, 12);
      case DeviceType.mobile:
        return scaleW(context, 16);
      case DeviceType.tablet:
        return scaleW(context, 20);
      case DeviceType.desktop:
        return scaleW(context, 40);
    }
  }

  static double getSpacing(BuildContext context, double size) {
    return scaleW(context, size);
  }

  static double getIconSize(BuildContext context, {double base = 24}) {
    return scaleW(context, base);
  }

  static double getButtonHeight(BuildContext context) {
    switch (getDeviceType(context)) {
      case DeviceType.mobileSmall:
        return scaleH(context, 44);
      case DeviceType.mobile:
        return scaleH(context, 48);
      case DeviceType.tablet:
        return scaleH(context, 52);
      case DeviceType.desktop:
        return scaleH(context, 56);
    }
  }

  static EdgeInsets getPadding(BuildContext context) {
    final p = getHorizontalPadding(context);
    return EdgeInsets.symmetric(horizontal: p, vertical: p * 0.6);
  }

  static double getBorderRadius(BuildContext context, double radius) {
    return scaleW(context, radius);
  }
}