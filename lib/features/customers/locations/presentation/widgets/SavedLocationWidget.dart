import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/widgets/Texts/OverFlowText.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';


class SavedLocationWidget extends StatelessWidget {
   String locationName, locationDescription;
   Function ?onPressedRemoveIcon, onTap;
   bool withRemoveIcon;
   ScreenUtil screenUtil=ScreenUtil();

  SavedLocationWidget(
      {required this.locationName,
      required this.locationDescription,
      required this.onTap,
      this.onPressedRemoveIcon=null,
      required this.withRemoveIcon
    });

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Column(
      children: [
        Container(
          height: screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight*.1:screenUtil.screenHeight*.2,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
          ),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                flex: 2,
                child: ListTile(
                  onTap: (){
                    onTap!();
                  },
                  title: SubTitleText(
                    text: locationName,
                    fontSize: 20,
                    textColor: AppTheme.primaryColor,
                    textAlign: TextAlign.right,
                    fontWeight: FontWeight.bold,
                  ),
                  subtitle:OverFlowText(
                    title:
                    locationDescription,
                    maxLine: 1,
                  ),
                  trailing: SvgPicture.asset("${kIconsPath}/gps.svg"),
                ),
              ),
              Visibility(
                visible: withRemoveIcon,
                child: Expanded(
                  flex: 1,
                  child: GestureDetector(
                    child: SvgPicture.asset("${kIconsPath}/Delete.svg"),
                    onTap: () {
                      onPressedRemoveIcon!();
                    },
                  ),
                ),
              )
            ],
          ),
        ),

       Container(
         height: 2,
         color: Colors.black26,
       )
      ],
    );
  }

}
