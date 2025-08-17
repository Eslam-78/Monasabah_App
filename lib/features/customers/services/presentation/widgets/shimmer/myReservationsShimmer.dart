import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/myReservationsWidget.dart';

import 'package:shimmer/shimmer.dart';

class MyReservationsShimmer extends StatelessWidget {
  ScreenUtil screenUtil = ScreenUtil();

  @override
  Widget build(BuildContext context) {
    screenUtil.init(
        context); //يقوم بتهيئة الـ ScreenUtil لقراءة حجم الشاشة والاتجاه (عمودي أو أفقي)

    return SizedBox(
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight / 5
          : screenUtil.screenWidth / 5,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.withOpacity(.8),
        highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
        enabled: true,
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return MyReservationWidget(
              serviceName: 'خدمه',
              date: DateTime.now().toString(),
              status: 'مكتمل',
              backgroundColor: Colors.white24,
              cancelReason: '####',
              service_reservation_price: '####',
            );
          },
        ),
      ),
    );
  }
}
