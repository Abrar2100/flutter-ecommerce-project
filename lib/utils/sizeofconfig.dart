import 'package:flutter/material.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  static late double screenWidth;
  static late double screenHeight;

  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
  }

  static double width(double inputWidth) {
    return (inputWidth / 1080) * screenWidth; // 375 عرض الايفون X
  }

  static double height(double inputHeight) {
    return (inputHeight / 1920) * screenHeight; // 812 طول الايفون X
  }
}
