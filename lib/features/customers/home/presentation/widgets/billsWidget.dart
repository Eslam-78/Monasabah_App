import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/customers/home/data/models/MyOrders/MyOrdersModel.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';

import 'billInvoice.dart';

class BillsWidget extends StatefulWidget {

  List<MyOrdersModel>  myOrdersModel;
  CustomerModel ?customerModel;

  BillsWidget({required this.myOrdersModel,required this.customerModel});

  @override
  State<BillsWidget> createState() => _BillsWidgetState();
}

class _BillsWidgetState extends State<BillsWidget> {
  ScreenUtil screenUtil=ScreenUtil();


  String downUpIcon = "down.svg";
  bool moreDetailsContainerVisibility = false;

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
      height: screenUtil.orientation ==
          Orientation.portrait
          ? screenUtil.screenHeight
          : screenUtil.screenWidth / 1.5,
      child: ListView.builder(
        itemCount:widget.myOrdersModel.length,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return Container(
            width: screenUtil.orientation==Orientation.portrait?screenUtil.screenWidth:screenUtil.screenHeight,
            margin: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubTitleText(text: 'رقم الفاتوره ${widget.myOrdersModel[index].id}', textColor: Colors.black54, fontSize: 15),
                      SubTitleText(text: 'حاله الطلب : ${widget.myOrdersModel[index].status}', textColor: Colors.black54, fontSize: 15),
                      GestureDetector(onTap: (){
                        if(widget.myOrdersModel[index].status=='قيد الانتظار'||widget.myOrdersModel[index].status=='تمت الموافقه'){
                          print('ok');
                        }else{
                          MyFlashBar(
                              title: 'خطأ',
                              context: context,
                              icon: Icons.error,
                              iconColor: Colors.white,
                              backgroundColor: Colors.red,
                              message: 'حاله هذا الطلب ${widget.myOrdersModel[index].status} ولا يمكن تعديله ',
                              thenDo: () {
                              }).showFlashBar();
                        }
                      },child: SubTitleText(text: 'تعديل', textColor: AppTheme.primaryColor, fontSize: 15,fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),


                BillInvoice(cartList: widget.myOrdersModel[index].orders),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 20),
                  child: Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SubTitleText(text: 'الإجمالي', textColor: Colors.black54, fontSize: 15),
                      SubTitleText(text: '${widget.myOrdersModel[index].total.toString()} ريال ', textColor: Colors.black54, fontSize: 15),
                    ],
                  ),
                ),

                ListTile(
                  title: SubTitleText(
                    text: "تفاصيل المستخدم والموقع",
                    textColor: Colors.black87,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  trailing: SvgPicture.asset(
                    //TODO:here change the path to kIconPath vareable
                    "assets/icons/$downUpIcon",
                  ),
                  onTap: () {
                    setState(() {
                      if (downUpIcon == "down.svg") {
                        downUpIcon = "up.svg";
                        moreDetailsContainerVisibility = true;
                      } else {
                        downUpIcon = "down.svg";
                        moreDetailsContainerVisibility = false;
                      }
                    });
                  },
                ),

                Visibility(
                  visible: moreDetailsContainerVisibility,
                  child: Column(
                    textDirection: TextDirection.rtl,
                    children: [
                      SubTitleText(text: 'الإسم : ${widget.customerModel!.userName}', textColor: Colors.black54, fontSize: 15,textAlign: TextAlign.right),
                      SubTitleText(text: 'رقم الهاتف : ${widget.customerModel!.phoneNumber}', textColor: Colors.black54, fontSize: 15),
                      SubTitleText(text: 'المنطقه : ${widget.myOrdersModel[index].locationName} ', textColor: Colors.black54, fontSize: 15),
                      SubTitleText(text: 'وصف العنوان : ${widget.myOrdersModel[index].description}', textColor: Colors.black54, fontSize: 15),
                      SubTitleText(text: 'تاريخ التوصيل : ${widget.myOrdersModel[index].delivery_date}', textColor: Colors.black54, fontSize: 15),
                    ],
                  ),
                )

              ],
            ),
          );
        },
      ),
    );
  }
}
