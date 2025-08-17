import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

class SubTitleText extends StatelessWidget {
  late String text;
  late Color textColor;
  late double fontSize;
  late TextAlign textAlign;
  late FontWeight fontWeight;
  late TextDirection textDirection;

  SubTitleText(
      {required this.text,
      required this.textColor,
      required this.fontSize,
      this.textAlign = TextAlign.center,
      this.fontWeight = FontWeight.normal,
      this.textDirection=TextDirection.rtl
      });

  SubTitleText.secondary(
      {required this.text, required this.textColor, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Text(

      text,
      style: TextStyle(
        color: textColor,
        fontSize: fontSize,
        fontFamily: AppTheme.fontFamily,

      ),
      textDirection: textDirection,
      textAlign: textAlign,

    );
  }
}
