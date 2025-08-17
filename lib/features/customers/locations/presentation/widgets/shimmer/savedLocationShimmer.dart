import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/SavedLocationWidget.dart';
import 'package:shimmer/shimmer.dart';

class SavedLocationShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight/4:screenUtil.screenWidth/4,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        enabled: true,
        child: ListView.builder(

          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return SavedLocationWidget(locationName: 'اسم الموقع', locationDescription: '######', onTap: null, onPressedRemoveIcon: null,withRemoveIcon: true,);
          },
        ),
      ),
    );
  }
}
