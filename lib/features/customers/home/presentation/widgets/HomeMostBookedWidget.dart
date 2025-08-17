import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

class HomeMostBookedWidget extends StatelessWidget {
  late double mediaHeight, mediaWidth;
  String serviceName;
  Function? onTap;
  Color? containerColor, imageContainerColor;
  bool withBorder;
  String imageUrl;

  HomeMostBookedWidget(
      {required this.serviceName,
      required this.onTap,
      this.containerColor = Colors.white,
      this.imageContainerColor = AppTheme.primaryColor,
      this.withBorder = false,
      this.imageUrl = 'shimmer'
      });

  @override
  Widget build(BuildContext context) {
    checkOrientation(context);

    ScreenUtil().init(context);
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: Container(
        margin: EdgeInsets.only(right: 10, left: 10),
        height: mediaHeight / 3.5,
        width: mediaWidth / 2.5,
        decoration: BoxDecoration(
          color: containerColor,
          border:
              withBorder ? Border.all(color: Colors.black45, width: 2) : null,
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
                        color: imageContainerColor,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: imageUrl == 'shimmer'
                          ? FlutterLogo()
                          : ClipRRect(
                              child: cachedNetworkImage(imageUrl,
                                  imagePath: imageUrl),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20.0),
                                  topRight: Radius.circular(20.0)),
                            ),
                    ),
                    SizedBox(
                        child: Icon(
                          Icons.favorite_border,
                          color: kMyGrey,
                        ),
                        height: mediaHeight / 20,
                        width: mediaWidth / 10)
                  ],
                )),
            Expanded(
              flex: 1,
              child: Center(
                child: SubTitleText(
                  text: serviceName,
                  textColor: AppTheme.primaryColor,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.normal,
                ),
              ),
            )
          ],
        ),
      ),
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
