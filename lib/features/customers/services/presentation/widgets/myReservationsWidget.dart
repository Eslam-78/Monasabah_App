import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class MyReservationWidget extends StatefulWidget {
  String serviceName, status, date, service_reservation_price;
  String? cancelReason;
  Color? backgroundColor;

  MyReservationWidget(
      {required this.serviceName,
      required this.status,
      required this.date,
      this.backgroundColor = Colors.white,
      required this.cancelReason,
      required this.service_reservation_price});

  @override
  State<MyReservationWidget> createState() => _MyReservationWidgetState();
}

class _MyReservationWidgetState extends State<MyReservationWidget> {
  ScreenUtil screenUtil = ScreenUtil();

  late Color statusColor, dateColor, cashColor;

  @override
  void initState() {
    if (widget.status == 'قيد الانتظار') {
      statusColor = Colors.yellow.shade500;
    } else if (widget.status == 'مرفوض' || widget.status == 'مكتمل') {
      statusColor = Colors.red;
    } else {
      statusColor = AppTheme.primaryColor;
    }

    if (widget.date.isNotEmpty) {
      dateColor = Colors.indigo;
    }
    if (widget.service_reservation_price.isNotEmpty) {
      cashColor = Colors.teal;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Container(
      width: double.infinity,
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight / 4
          : screenUtil.screenWidth / 4,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          SubTitleText(
            text: ' حجز ${widget.serviceName}',
            textColor: AppTheme.primaryColor,
            fontSize: 20,
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 1,
                child: SubTitleText(
                    text: 'لتاريخ : ', textColor: Colors.black54, fontSize: 15),
              ),
              Expanded(
                child: SubTitleText(
                    text: widget.date, textColor: dateColor, fontSize: 12),
              ),
              Expanded(
                  flex: 1,
                  child: SubTitleText(
                      text: 'بمبلغ وقدره :',
                      textColor: Colors.black54,
                      fontSize: 15)),
              Expanded(
                flex: 1,
                child: SubTitleText(
                    text: ' ${widget.service_reservation_price} ريال ',
                    textColor: cashColor,
                    fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              SubTitleText(
                  text: 'الحاله : ', textColor: Colors.black54, fontSize: 15),
              SubTitleText(
                  text: widget.status, textColor: statusColor, fontSize: 15),
            ],
          ),
          switchStatusText()
        ],
      ),
    );
  }

  switchStatusText() {
    switch (widget.status) {
      case 'مرفوض':
        return SubTitleText(
            text: widget.cancelReason ??
                'سيتم التواصل معك خلال لحظات لتحديد السبب',
            textColor: Colors.red.shade200,
            fontSize: 15);

      case 'قيد الانتظار':
        return SubTitleText(
            text: 'طلبك تحت المعالجة . يرجى الانتظار',
            textColor: Colors.yellow.shade200,
            fontSize: 15);

      case 'مكتمل':
        return SubTitleText(
            text: 'تم تنفيذ طلبك بنجاح.',
            textColor: Colors.teal.shade200,
            fontSize: 15);
      default:
        return SizedBox(); // عشان ما يعطي خطأ لو الحالة غير معروفة
    }
  }
}
