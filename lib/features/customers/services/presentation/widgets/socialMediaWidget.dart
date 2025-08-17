import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class SocialMediaWidget extends StatelessWidget {

  String title,iconName;
  Color backgroundColor;
  Function onTap;


  SocialMediaWidget({required this.title,required this.iconName,required this.backgroundColor,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap();
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10),
        width: double.infinity,
        height: 50,
        color: backgroundColor,
        child: ListTile(
          title: SubTitleText(text: title,fontSize: 15,textColor: Colors.white),
          leading: SvgPicture.asset(
              'assets/icons/$iconName',
              height: 30
          ),
        ),
      ),
    );
  }
}
