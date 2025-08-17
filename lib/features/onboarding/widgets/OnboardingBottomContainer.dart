
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class OnboardingBottomContainer extends StatelessWidget {
   late double mediaHeight, mediaWidth;
   late String illustrationPath,illustrationText,containerText,containerImagePath;
   String iconPath;


  OnboardingBottomContainer({required this.containerText,required this.containerImagePath,this.iconPath=''});

  @override
  Widget build(BuildContext context) {
    checkOrientation(context);

    return Column(
      children: [

        Container(
          padding: EdgeInsets.only(top: mediaHeight/20,right: mediaWidth/20,left: mediaWidth/20),
          margin: EdgeInsets.only(top: mediaHeight / 15),
          height: mediaHeight / 3,
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(50),
              topRight: Radius.circular(50),
            ),
          ),
          child: Column(
            children: [
              SubTitleText(
                text: containerText,
                textColor: Colors.white,
                fontSize: 20,
              ),
              Image.asset(iconPath,height: 20,)
            ],
          ),
        ),
      ],
    );
  }

  checkOrientation(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      mediaHeight = MediaQuery.of(context).size.width;
      mediaWidth = MediaQuery.of(context).size.height;
    } else {
      mediaHeight = MediaQuery.of(context).size.height;
      mediaWidth = MediaQuery.of(context).size.width;
    }
  }
}
