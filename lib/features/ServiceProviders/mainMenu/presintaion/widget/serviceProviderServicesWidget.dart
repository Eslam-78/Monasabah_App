import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/Constants.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/Texts/OverFlowText.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class ServiceProviderServicesWidget extends StatelessWidget {

  String serviceName,serviceAddress,statusIcon;
  Function ?onTap,onTapEditIcon,onTapRemoveIcon;

  ServiceProviderServicesWidget(
      {required this.serviceName,
      required this.serviceAddress,
      required this.statusIcon,
      required this.onTap,
      required this.onTapEditIcon,
      required this.onTapRemoveIcon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            Row(
              textDirection: TextDirection.rtl,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset("${kIconsPath}/$statusIcon.svg"),

                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      SubTitleText(
                          text: serviceName,
                          fontSize: 20,
                          textColor: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold
                      ),
                      OverFlowText(
                        title:  serviceAddress,
                        maxLine: 1,
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Column(
                    children: [
/*
                      GestureDetector(

                        child:
                        SvgPicture.asset("${kIconsPath}/edit.svg",height: 20,width: 20,),
                        onTap: (){
                          onTapEditIcon!();
                        },
                      ),
*/
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(

                        child:
                        SvgPicture.asset("${kIconsPath}/Delete.svg"),
                        onTap: (){
                          onTapRemoveIcon!();
                        },
                      ),

                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ScreenLine()
          ],
        ),
      ),
    );
  }
}
