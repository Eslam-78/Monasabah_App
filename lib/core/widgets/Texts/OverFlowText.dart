import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

class OverFlowText extends StatelessWidget {

   String title;
   int maxLine;


  OverFlowText({ required this.title,required this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: AppTheme.textTheme.bodyText2,
      maxLines: maxLine,
      textAlign: TextAlign.right,
    );
  }
}
