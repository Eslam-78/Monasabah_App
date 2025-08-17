import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

class AppSpecialContainer extends StatelessWidget {
  Widget child;
  double marginTop;
  String image;
  Color? containersColor, borderColor;
  ScreenUtil screenUtil = ScreenUtil();

  AppSpecialContainer(
      {required this.child,
      required this.marginTop,
      this.containersColor = Colors.white,
      this.borderColor = Colors.transparent,
      this.image = 'shimmer'});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
//هذا عبارة عن الكونتينر المستطيل الاساسي الابيض
    return Container(
      margin: EdgeInsets.only(top: marginTop, right: 15, left: 15, bottom: 10),
      width: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenWidth / 1.2
          : screenUtil.screenHeight / 1,
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight * .2
          : screenUtil.screenWidth * .2,
      decoration: BoxDecoration(
        color: containersColor,
        border: Border.all(color: borderColor!, width: 2),
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Stack(
        textDirection: TextDirection.rtl,
        clipBehavior: Clip.none,
        children: [
          //هذا الكونتينر الخاص بالصورة فقط
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
                color: containersColor,
                border: Border.all(color: borderColor!, width: 1),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: GestureDetector(
                // يظهر الصورة عند النقر عليا
                onTap: () {
                  showImagesDialog(context, image);
                },
                child: image == 'shimmer'
                    ? Image.asset(
                        'assets/images/logo.png',
                        height: 200,
                        width: 200,
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: cachedNetworkImage(image, imagePath: ''),
                      ),
              ),
            ),
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
                  child: child),
            ),
          ),
        ],
      ),
    );
  }
}
