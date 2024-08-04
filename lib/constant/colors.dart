import'package:flutter/material.dart';
import 'dart:ui';
Color primaryColor =const Color.fromRGBO(5, 16, 58, 1);
Color indicatorColor = const Color(0XFF4CCDEB);

class CustomStyleText {
  static TextStyle header({Color? color, double? height}) {
    return TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white,
      height: height,
    );
  }

  static TextStyle subheader({Color? color, FontWeight? fontWeight, double? height}) {
    return TextStyle(
      fontSize: 16.0,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? Colors.white,
      height: height,
    );
  }
}
