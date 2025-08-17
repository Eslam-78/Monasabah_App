import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

class ServicePreviewsWidget extends StatelessWidget {
  String name, date, image, preview;
  Color? backgroundColor;
  Function onPress;

  ServicePreviewsWidget(
      {required this.name,
      required this.date,
      required this.image,
      required this.preview,
      this.backgroundColor = Colors.white,
      required this.onPress});

  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              height: screenUtil.orientation == Orientation.portrait
                  ? screenUtil.screenHeight * .1
                  : screenUtil.screenWidth * .15,
              width: 500,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(50)),
              child: ClipRRect(
                child: image != null
                    ? cachedNetworkImage(
                        image,
                        imagePath: '',
                      )
                    : CircleAvatar(
                        child: Image.asset('assets/images/logo.png'),
                        radius: 50,
                        backgroundColor: Colors.white),
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    children: [
                      Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(
                            text: name,
                            textColor: AppTheme.primaryColor,
                            fontSize: 20,
                          ),
                          SubTitleText(
                            text: DateTime.parse(date).toString(),
                            textColor: AppTheme.primaryColor,
                            fontSize: 10,
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SubTitleText(
                          text: preview,
                          textColor: Colors.black54,
                          fontSize: 15,
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ],
                  ),
                ),

                // الأيقونة فوق الكونتينر مباشرة
                /* Positioned(
                  top: -16,
                  left: -16,
                  child: IconButton(
                    onPressed: () => onPress(), // ✅ صح
                    icon: Icon(Icons.delete, color: Colors.red, size: 20),
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
