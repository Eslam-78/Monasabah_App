import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class SettingsListTile extends StatelessWidget {

  String title;
  String iconPath;
  Function onTap;

  SettingsListTile({required this.title,required this.iconPath,required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(

      title: SubTitleText(
        textAlign: TextAlign.start,
        textColor: Colors.grey,
        fontSize: 20,
        text: title,
      ),
      trailing:SvgPicture.asset(iconPath),
      onTap: (){
        onTap();
      },
    );
  }
}
