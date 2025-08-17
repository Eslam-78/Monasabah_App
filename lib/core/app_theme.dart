import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF149F82);
  static  MaterialColor primarySwatch = MaterialColor(const Color(0xFF149F82).value, {
    50 : const Color(0xFF149F82).withOpacity(.05),
    100: const Color(0xFF149F82).withOpacity(.1),
    200: const Color(0xFF149F82).withOpacity(.2),
    300: const Color(0xFF149F82).withOpacity(.3),
    400: const Color(0xFF149F82).withOpacity(.4),
    500: const Color(0xFF149F82).withOpacity(.5),
    600: const Color(0xFF149F82).withOpacity(.6),
    700: const Color(0xFF149F82).withOpacity(.7),
    800: const Color(0xFF149F82).withOpacity(.8),
    900: const Color(0xFF149F82).withOpacity(.9)
  });

  static Color scaffoldBackgroundColor = Color(0xfff0e5f5);
  static Color scaffolBackgroundColors =Color(0xFF149F82);
  static String fontFamily = 'El Messiri';

  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(fontSize: 24.0, fontFamily: fontFamily, color: scaffoldBackgroundColor),
    headline2: TextStyle(fontSize: 18.0, fontFamily: fontFamily),
    headline3: TextStyle(fontSize: 18.0, fontFamily: fontFamily, color: primaryColor),
    headline4: TextStyle(fontSize: 12.0, fontFamily: fontFamily, color: primaryColor),
    headline5: TextStyle(fontSize: 18.0, fontFamily: fontFamily, color: scaffoldBackgroundColor),
    headline6: TextStyle(fontSize: 24.0, fontFamily: fontFamily, color: primaryColor),
    bodyText1: TextStyle(fontSize: 14.0, fontFamily: fontFamily, color: primaryColor,fontWeight: FontWeight.bold),
    bodyText2: TextStyle(fontSize: 12.0, fontFamily: fontFamily, color: Colors.black.withOpacity(.6)),  );

}
