import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/widget/serviceProviderServicesWidget.dart';
import 'package:shimmer/shimmer.dart';


class ServiceProviderServicesShimmer extends StatelessWidget {

  ScreenUtil screenUtil=ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight/1.5:screenUtil.screenWidth/1.5,
      child: Shimmer.fromColors(
        baseColor:Colors.grey.withOpacity(.8) ,
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        enabled: true,
        child: ListView.builder(

          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return ServiceProviderServicesWidget(serviceName: 'خدمه', serviceAddress: 'مـــوقـــع',onTapEditIcon:null, onTap: null, onTapRemoveIcon:  null,statusIcon: 'greenCircle',);
          },
        ),
      ),
    );
  }
}
