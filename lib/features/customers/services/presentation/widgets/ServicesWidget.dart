import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/dataProviders/network/data_source_url.dart';

class ServicesWidget extends StatelessWidget {
  String serviceName, servicePrice;
  Function? onTap,onTapFavoriteIcon;
  Color? containerColor, borderColor;
  String imageUri;
  IconData icon;


  ServicesWidget(
      {required this.serviceName,
      required this.servicePrice,
      required this.onTap,
      this.containerColor = AppTheme.primaryColor,
      this.borderColor = Colors.transparent,
      this.imageUri = 'shimmer',
        this.icon=Icons.favorite_border,
        this.onTapFavoriteIcon=null,
  

      });

  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10, top: 10),
        height: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenHeight / 3.5
            : screenUtil.screenWidth / 3.5,
        width: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenWidth / 2.5
            : screenUtil.screenHeight / 2.5,
        decoration: BoxDecoration(
          color: containerColor,
          border: Border.all(color: borderColor!, width: 2),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                      ),
                      child: imageUri == 'shimmer'
                          ? FlutterLogo()
                          : ClipRRect(
                        borderRadius: BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20),),
                              child: cachedNetworkImage(imageUri,
                                  imagePath: DataSourceURL.baseImagesUrl),
                            ),
                    ),
                    GestureDetector(
                      onTap: (){
                        onTapFavoriteIcon!();
                      },
                      child: Icon(
                        icon,
                        color: kMyGrey,
                      ),
                    ),
                  ],
                )),
            Center(
              child: SubTitleText(
                text: serviceName,
                textColor: Colors.white,
                fontSize: 20,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.normal,
              ),
            ),
            Center(
              child: SubTitleText(
                text: ' $servicePrice ريال',
                textColor: Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
