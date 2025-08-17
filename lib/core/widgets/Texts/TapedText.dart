import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

class TapedText extends StatelessWidget {

   String text;
   Color color;
   Function onTap;


  TapedText({required this.text,required this.color,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        text,
        style: TextStyle(
            color: color, fontWeight: FontWeight.bold,fontFamily: AppTheme.fontFamily
        ),
      ),
      onTap: () {
        onTap();
      },
    );

  }
}
