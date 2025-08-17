import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:shimmer/shimmer.dart';

import '../moreServiceImagesContainer.dart';

class MoreServiceImagesContainerShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height: 200,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        child: GridView.count(
          reverse: true,
          scrollDirection: Axis.horizontal,
          crossAxisCount: 2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 20,
          semanticChildCount: 2,
          children: List.generate(screenUtil.orientation==Orientation.portrait?6:12, (index) {
            return MoreServiceImagesContainer();
          }),
        ),
      ),
    );
  }
}
