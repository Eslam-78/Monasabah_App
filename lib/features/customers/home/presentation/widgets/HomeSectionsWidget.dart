import 'package:flutter/cupertino.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';

class HomeSectionsWidget extends StatelessWidget {
  String title;
  Function? onTap;
  Color? containerColor;
  String imageUri;
  bool withBorder;

  HomeSectionsWidget(
      {required this.title,
      required this.onTap,
      this.containerColor = AppTheme.primaryColor,
        this.withBorder=false,
      this.imageUri = 'shimmer'});

  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10.0, left: 10.0),
        height: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenHeight / 5
            : screenUtil.screenWidth / 5,
        width: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenWidth / 3
            : screenUtil.screenHeight / 3,
        decoration: BoxDecoration(
          color: containerColor,
          border:withBorder? Border.all(color: Colors.black45,width: 2):null,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: imageUri == 'shimmer'
                      ? FlutterLogo()
                      : ClipRRect(

                    borderRadius: BorderRadius.only(topLeft: Radius.circular(20.0),topRight: Radius.circular(20.0)),

                    child: cachedNetworkImage(imageUri,
                              imagePath: DataSourceURL.baseImagesUrl),
                        ),
                )),
            Expanded(
                flex: 1,
                child: Center(
                  child: SubTitleText(
                    fontSize: 20,
                    text: title,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.normal,
                    textColor: Colors.white,
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
