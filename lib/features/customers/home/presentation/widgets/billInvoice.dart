import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';

class BillInvoice extends StatelessWidget {

   ScreenUtil screenUtil=ScreenUtil();
   final List<dynamic> cartList;
   Color ?backgroundColor=Colors.white;
  BillInvoice(
      {required this.cartList,this.backgroundColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return Container(
      height: screenUtil.screenHeight * .1,
      margin: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(20.0),),
      ),
      child: ListView(
        children: [

          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                  flex: 2,
                  child: SubTitleText(
                    text: "أسم المنتج",
                    textColor: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    textAlign: TextAlign.center,
                  ),
              ),
              Expanded(
                child: SubTitleText(
                  text: "العدد",
                  textColor: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SubTitleText(
                  text: "الوحده",
                  textColor: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: SubTitleText(
                  text: "السعر",
                  textColor: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ),
              ),

              Expanded(
                child: SubTitleText(
                  text: "الإجمالي",
                  textColor: AppTheme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          SizedBox(
            height: screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight * .05:screenUtil.screenHeight,
            child: ListView.builder(

              itemCount: cartList.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Expanded(
                        flex: 2,
                        child: SubTitleText(
                          text: cartList[index]['name'],
                          textColor: Colors.black54,
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          textAlign: TextAlign.center,
                        ),
                    ),
                    Expanded(
                        child: SubTitleText(
                      text: "${cartList[index]['quantity']}",
                      textColor: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: SubTitleText(
                      text: cartList[index]['unit'],
                      textColor: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      textAlign: TextAlign.center,
                    )),
                    Expanded(
                        child: SubTitleText(
                      text: "${cartList[index]['unitPrice']}",
                      textColor: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      textAlign: TextAlign.center,
                    )),

                    Expanded(
                        child: SubTitleText(
                      text: "${cartList[index]['unitPrice']*cartList[index]['quantity']}",
                      textColor: Colors.black54,
                      fontWeight: FontWeight.normal,
                      fontSize: 15,
                      textAlign: TextAlign.center,
                    )),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
