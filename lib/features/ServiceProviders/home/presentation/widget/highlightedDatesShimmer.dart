import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:shimmer/shimmer.dart';

class HighlightedDatesShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Container(
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight*.90
          : screenUtil.screenWidth / 1.7,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/images/background.jpg',),
            fit: BoxFit.cover
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SizedBox(
          height: screenUtil.orientation == Orientation.portrait
              ? screenUtil.screenHeight*.80
              : screenUtil.screenWidth / 1.7,
          child:  Shimmer.fromColors(
            baseColor:Colors.grey.withOpacity(.8) ,
            highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
            enabled: true,
            child:ListView.builder(
              itemCount: 8,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: null,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          textDirection: TextDirection.rtl,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                height: screenUtil.orientation ==
                                    Orientation.portrait
                                    ? screenUtil.screenHeight * .1
                                    : screenUtil.screenWidth * .15,
                                width: 500,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(50)),
                                child: ClipRRect(
                                  child:  CircleAvatar(
                                    child: Image.asset(
                                        'assets/images/logo.png'),
                                    radius: 50,
                                  ),
                                  borderRadius:
                                  BorderRadius.circular(50),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              flex: 3,
                              child: Container(
                                width: screenUtil.orientation ==
                                    Orientation.portrait
                                    ? screenUtil.screenWidth * .1
                                    : screenUtil.screenHeight * .1,
                                decoration: BoxDecoration(
                                  color: null,
                                  borderRadius:
                                  BorderRadius.circular(20),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    textDirection: TextDirection.rtl,
                                    children: [
                                      Row(
                                        textDirection:
                                        TextDirection.rtl,
                                        mainAxisAlignment:
                                        MainAxisAlignment
                                            .spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 2,
                                            child: SubTitleText(
                                                text:'عميل',
                                                textColor: AppTheme
                                                    .primaryColor,
                                                fontSize: 20),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: SubTitleText(
                                                text:DateTime.now().toString(),
                                                textColor: AppTheme
                                                    .primaryColor,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SubTitleText(
                          text:
                          'رقم هاتف العميل : ${782513351}',
                          textColor: AppTheme.primaryColor,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        SizedBox(
                          height: 15,
                        ),

                        PrimaryButton(
                            title: 'موافقه',
                            backgroundColor: null,
                            pending: true,
                            onPressed: () {

                            },
                            marginTop: .01),


                      ],
                    ),
                  ),
                );
              },
            ),
          )
      )
    );
  }
}
