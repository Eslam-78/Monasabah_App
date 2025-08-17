import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:shimmer/shimmer.dart';

class AboutAppShimmer extends StatelessWidget {
  ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(.8),
      highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
      enabled: true,
      child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(
                    top: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenHeight * .02
                        : screenUtil.screenWidth * .02,
                    bottom: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenHeight * .01
                        : screenUtil.screenWidth * .01,
                    left: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenWidth * .06
                        : screenUtil.screenHeight * .06,
                    right: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenWidth * .06
                        : screenUtil.screenHeight * .06),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: null,
                  borderRadius: BorderRadius.all(
                    Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Container(
                            child: Image.asset('assets/images/logo.png'),
                            width: double.infinity,
                            height: screenUtil.orientation == Orientation.portrait
                                ? screenUtil.screenHeight * .3
                                : screenUtil.screenWidth * .3,
                          ),
                          ScreenLine(),
                          SizedBox(
                            height: 20,
                          ),
                          SubTitleText(
                              text: 'تطبيق مناسبه',
                              textColor: AppTheme.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 20,
                          ),
                          SubTitleText(
                              text: 'تطبيق مناسبه لتنظيم حجوزات المناسبات تطبيق مناسبه لتنظيم حجوزات المناسبات تطبيق مناسبه لتنظيم حجوزات المناسبات تطبيق مناسبه لتنظيم حجوزات المناسبات ',
                              textColor: AppTheme.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 10,
                          ),
                          SubTitleText(
                              text: 'Eslam_Alejil@gmail.com',
                              textColor: AppTheme.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                          SizedBox(
                            height: 10,
                          ),
                          SubTitleText(
                            text: '782513351',
                            textColor: AppTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          SubTitleText(
                            text: 'Arwa IT Team',
                            textColor: AppTheme.primaryColor,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ScreenLine(),
                          SizedBox(
                            height: 30,
                          ),
                          GestureDetector(
                            child: SubTitleText(
                              text: 'سيـاسـة الـخصوصيــه',
                              textColor: AppTheme.primaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                            onTap: () {
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),


  );
  }
}
