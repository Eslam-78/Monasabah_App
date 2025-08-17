import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/HomeSectionsWidget.dart';
import 'package:shimmer/shimmer.dart';

class HomeSectionSimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();
  String title;

  HomeSectionSimmer({required this.title});

  @override
  Widget build(BuildContext context) {
      screenUtil.init(context);
    return SizedBox(
      height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight/5:screenUtil.screenWidth/5,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        enabled: true,
        child: ListView.builder(

          itemCount: 10,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return HomeSectionsWidget(title: title, onTap: null,containerColor: null,withBorder: true,);
          },
        ),
      ),
    );
  }
}
