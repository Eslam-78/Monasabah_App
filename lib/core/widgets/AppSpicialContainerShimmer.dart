import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../app_theme.dart';
import '../others/constants.dart';
import 'Others/Taped_Icon.dart';
import 'Texts/SubTitleText.dart';

class AppSpecialContainerShimmer extends StatelessWidget {

  Color? containersColor;
  ScreenUtil screenUtil = ScreenUtil();
  double sizedBoxHeight,sizedBoxWidth;
  Axis scrollOrientation;


  AppSpecialContainerShimmer({required this.sizedBoxHeight,required this.sizedBoxWidth,required this.scrollOrientation});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return SizedBox(
      height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight*sizedBoxHeight:screenUtil.screenWidth*sizedBoxWidth,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Shimmer.fromColors(
          baseColor:Colors.grey.withOpacity(.8) ,
          highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
          child: ListView.builder(

            itemCount: 10,
            scrollDirection: scrollOrientation,
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.only(top: 50, right: 15, left: 15),
                width: screenUtil.orientation == Orientation.portrait
                    ? screenUtil.screenWidth / 1.2
                    : screenUtil.screenHeight / 1,
                height: screenUtil.orientation == Orientation.portrait
                    ? screenUtil.screenHeight * .2
                    : screenUtil.screenWidth * .2,
                decoration: BoxDecoration(
                  color: containersColor,
                  border: Border.all(color: Colors.black26, width: 2),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Stack(
                  textDirection: TextDirection.rtl,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -20.0,
                      child: Container(
                          alignment: Alignment.center,
                          width: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenWidth / 2.5
                              : screenUtil.screenHeight / 2,
                          height: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenHeight * .2
                              : screenUtil.screenWidth * .2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black26,width: 1),

                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: FlutterLogo(size: 200)),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Positioned(
                        top: -40.0,
                        child: Container(
                          alignment: Alignment.center,
                          width: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenWidth / 2.5
                              : screenUtil.screenHeight / 2.1,
                          height: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenHeight * .2
                              : screenUtil.screenWidth * .2,
                          decoration: BoxDecoration(
                              color: containersColor,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SubTitleText(
                                    text: 'خدمه',
                                    textColor: AppTheme.primaryColor,
                                    fontSize: 20,
                                    textAlign: TextAlign.center,
                                    fontWeight: FontWeight.normal,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SubTitleText(
                                    text: "RY 1000",
                                    textColor: AppTheme.primaryColor,
                                    fontSize: 15,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                  child: TapedIcon(
                                    iconPath: '$kImagesPath/heart.svg',
                                    onTap: () {},
                                  ),
                                  alignment: Alignment.topLeft,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              );
            },
          ),
        ),
      ),
    );



  }
}
