import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

class BottomNavyBarItemsText extends StatelessWidget {

   String title;


  BottomNavyBarItemsText({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontFamily: AppTheme.fontFamily,
      ),
    );
  }
}
