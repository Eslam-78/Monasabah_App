import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class ConfirmReservationDetails<int,string> extends StatelessWidget {

   String title,subTitle;
   late TextDirection textDirection;



  ConfirmReservationDetails({required this.title,required this.subTitle,this.textDirection=TextDirection.rtl});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        SubTitleText(
          text: "${title}",
          textColor: AppTheme.primaryColor,
          fontSize: 15,
          textAlign: TextAlign.right,
          fontWeight: FontWeight.bold,
        ),

        SizedBox(width: 10,),
        SubTitleText(
          text: "${subTitle}",
          textColor: AppTheme.primaryColor,
          fontSize: 15,
          textAlign: TextAlign.right,
          fontWeight: FontWeight.normal,
          textDirection:textDirection ,
        ),

      ],
    );
  }
}
