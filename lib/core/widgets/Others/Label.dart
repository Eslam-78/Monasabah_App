import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:flutter/material.dart';

class Label extends StatelessWidget {
   String labelText;
   double fontSize;


  Label({required this.labelText,this.fontSize=20});

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);


    return Container(
      height: 40,
      width: 100,


      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: AppTheme.primaryColor,
      ),
      child:Center(
        child: Flexible(
          child: SubTitleText(
            textColor: Colors.white,
            fontWeight: FontWeight.normal,
            textAlign: TextAlign.center,
            text: labelText,
            fontSize: fontSize,
          ),
        ),
      ) ,
    );
  }


}
