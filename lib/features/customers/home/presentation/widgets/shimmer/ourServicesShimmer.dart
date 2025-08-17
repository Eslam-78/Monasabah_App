import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/AppSpecialContainer.dart';
import 'package:monasbah/core/widgets/Others/Taped_Icon.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class ourServicesShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Shimmer.fromColors(
      baseColor:Colors.grey.withOpacity(.8) ,
      highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: 10,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return GestureDetector(

              child: AppSpecialContainer(
                borderColor: Colors.black26,
                containersColor: null,
                marginTop: 50,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 10,
                        ),

                        Expanded(
                            flex: 2,
                            child: Column(
                              children: [
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
                                  text: " سعر الوحده :  RY 1000",
                                  textColor: AppTheme.primaryColor,
                                  fontSize: 15,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.normal,
                                ),
                                SubTitleText(
                                  text: "نوع الوحده : ####",
                                  textColor: AppTheme.primaryColor,
                                  fontSize: 15,
                                  textAlign: TextAlign.center,
                                  fontWeight: FontWeight.normal,
                                ),
                              ],
                            )
                        ),
                        Expanded(
                          child: Row(
                            textDirection: TextDirection.rtl,
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                  child: SubTitleText(
                                    text: "RY 1000",
                                    textColor: AppTheme.primaryColor,
                                    fontSize:13 ,
                                    textAlign:TextAlign.center ,
                                    fontWeight: FontWeight.normal,

                                  )
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: SvgPicture.asset("${kIconsPath}up.svg"),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: SubTitleText(
                                  text: '1',
                                  textColor:AppTheme.primaryColor,
                                  fontSize: 15,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  child: SvgPicture.asset(
                                    "${kIconsPath}down.svg",
                                  ),

                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        child: TapedIcon(iconPath: '$kImagesPath/heart.svg',onTap: (){

                        },),
                        alignment: Alignment.topLeft,
                      ),
                    )
                  ],
                ),
              )
          );
        },
      ),
    );



  }


}
