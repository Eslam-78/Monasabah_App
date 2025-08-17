import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/customers/adds/data/model/addsModel.dart';
import 'package:shimmer/shimmer.dart';

class MySliderBarShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
    highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
    enabled: true,
    child:CarouselSlider.builder(
      itemCount:10,
      options: CarouselOptions(
          height: 200,
          autoPlay: true,
          autoPlayAnimationDuration: Duration(seconds: 4),
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height
      ),
      itemBuilder: (context, index, realIndex) {
        return Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: FlutterLogo(),
            ),
            Container(
              width: double.infinity,

              margin: EdgeInsets.symmetric(horizontal: 12),

              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: AppTheme.primarySwatch.shade700,
              ),
              child: Center(child: SubTitleText(text:'إعلان',fontSize: 20, textColor: Colors.white)),
            )
          ],
        );
      },
    )

    );
  }
}
