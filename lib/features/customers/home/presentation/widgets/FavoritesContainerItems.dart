import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/AppSpecialContainer.dart';
import 'package:monasbah/core/widgets/Others/Taped_Icon.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class FavoritesContainerItems extends StatelessWidget {
  String serviceName, image;
  int servicePrice, ratingValue;
  Function? onTap, onTapFavoriteIcon;
  int height;

  FavoritesContainerItems(
      {required this.serviceName,
      required this.servicePrice,
      required this.ratingValue,
      required this.image,
      required this.onTapFavoriteIcon,
      required this.onTap,
      required this.height});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap!();
      },
      child: AppSpecialContainer(
        marginTop: 50,
        image: image,
        //هنا يتم البناء الجزئية او الكونتينر الخاص باسم الخدمة وسعرها والايكونة
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
                  text: serviceName,
                  textColor: AppTheme.primaryColor,
                  fontSize: 20,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.normal,
                ),
                SizedBox(
                  height: 10,
                ),
                SubTitleText(
                  text: "RY $servicePrice",
                  textColor: AppTheme.primaryColor,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.normal,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                child: TapedIcon(
                  iconColor: Colors.red,
                  iconPath: 'assets/icons/heart.svg',
                  onTap: () {
                    onTapFavoriteIcon!();
                  },
                ),
                alignment: Alignment.bottomLeft,
              ),
            )
          ],
        ),
      ),
    );
  }
}
