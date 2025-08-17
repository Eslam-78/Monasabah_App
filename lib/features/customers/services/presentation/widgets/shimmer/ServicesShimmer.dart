import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../services/presentation/widgets/ServicesWidget.dart';

class ServicesShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();
  String title;

  ServicesShimmer({required this.title});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight*.6:screenUtil.screenWidth*.43,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        enabled: true,
        child: GridView.count(
          scrollDirection: Axis.vertical,
          crossAxisCount: screenUtil.orientation==Orientation.portrait?2:3,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: List.generate(20, (index) {
            return ServicesWidget(
              containerColor: null,
              borderColor: Colors.black26,
              onTap: (){

              },
              serviceName: "صاله التطيف",
              servicePrice: '100000',
            );
          }),
        ),
      ),
    );
  }
}
