import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

class HomeMostRatedWidget extends StatelessWidget {
  String serviceName,image;
  int ratingValue;
  Function? onTap;
  Color ?containerColor,imageContainerColor;
  ScreenUtil screenUtil = ScreenUtil();

  HomeMostRatedWidget(
      {required this.serviceName,
        required this.image,
      required this.ratingValue,
      required this.onTap,
      this.containerColor=Colors.white,
      });

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10),
        height: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenHeight / 3.5
            : screenUtil.screenWidth / 3.5,
        width: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenWidth / 2.5
            : screenUtil.screenHeight / 2.5,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(width: 2,color: Colors.black26),
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: image=='shimmer'?FlutterLogo():ClipRRect(borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),child: cachedNetworkImage(image, imagePath: image)),
                    ),
                    SizedBox(
                      child: Icon(
                        Icons.favorite_border,
                        color: kMyGrey,
                      ),
                      height: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenHeight / 20
                          : screenUtil.screenWidth / 20,
                      width: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenWidth / 10
                          : screenUtil.screenHeight / 10,
                    ),
                  ],
                )),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SubTitleText(
                      text: serviceName,
                      textColor: AppTheme.primaryColor,
                      fontSize: 20,
                      textAlign: TextAlign.center,
                      fontWeight: FontWeight.normal,
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}
