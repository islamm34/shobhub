import 'package:flutter/material.dart';

class ResponsiveHelper {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }

  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double screenPadding(BuildContext context) {
    final width = getWidth(context);
    if (isMobile(context)) {
      return 16;
    } else if (isTablet(context)) {
      return 24;
    } else {
      return 32;
    }
  }

  static int gridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) {
      return 2;
    } else if (isTablet(context)) {
      return 3;
    } else {
      return 4;
    }
  }

  static double itemAspectRatio(BuildContext context) {
    if (isMobile(context)) {
      return 0.55;
    } else if (isTablet(context)) {
      return 0.5;
    } else {
      return 0.45;
    }
  }

  static double containerMaxWidth(BuildContext context) {
    if (isMobile(context)) {
      return getWidth(context) - 32;
    } else if (isTablet(context)) {
      return 700;
    } else {
      return 1200;
    }
  }
}

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double textScaleFactor;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    textScaleFactor = _mediaQueryData.textScaleFactor;
  }

  static double getProportionateScreenWidth(double inputWidth) {
    return (inputWidth / 375.0) * screenWidth;
  }

  static double getProportionateScreenHeight(double inputHeight) {
    return (inputHeight / 667.0) * screenHeight;
  }
}

