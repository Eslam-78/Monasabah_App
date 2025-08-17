import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/HomeMostBookedWidget.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/HomeTrendWidget.dart';
import 'package:shimmer/shimmer.dart';

class MostBookedShimmer extends StatelessWidget {

  ScreenUtil screenUtil =ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight *.25
          : screenUtil.screenWidth *.25,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        child: ListView.builder(

          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return HomeMostBookedWidget(serviceName: 'خدمه', onTap: null,containerColor: null,withBorder: true,);
          },
        ),
      ),
    );
  }
}
