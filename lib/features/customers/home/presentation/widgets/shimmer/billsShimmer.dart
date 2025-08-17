import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/cart/presentation/widget/Invoice.dart';
import 'package:monasbah/features/customers/home/data/models/myOrders/myOrdersModel.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/billInvoice.dart';
import 'package:shimmer/shimmer.dart';

class BillsShimmer extends StatelessWidget {

  ScreenUtil screenUtil = ScreenUtil();

  // List<dynamic> myOrdersModel=[MyOrdersModel(id: 1,long:  '',lat: '', delivery_date: DateTime.now(),status:  'مكتمله',orders:  [{2,  1,  'منتج', unit: 'كرتون', unitPrice: 1000, quantity: 2, totalPrice: 2000}, {id: 2, bill_id: 1, name: 'منتج', unit: 'كرتون', unitPrice: 1000, quantity: 2, totalPrice: 2000}], description: '',total: 4000,locationName: '',)];

  List<CartModel> cart = [
    CartModel(
        id: 1,
        category_id: '',
        name: 'منتج',
        unit: 'كرتون',
        unitPrice: 1000,
        image: '',
        quantity: 2,
        totalPrice: 2000),
    CartModel(
        id: 1,
        category_id: '',
        name: 'منتج',
        unit: 'كرتون',
        unitPrice: 1000,
        image: '',
        quantity: 2,
        totalPrice: 2000),
    CartModel(
        id: 1,
        category_id: '',
        name: 'منتج',
        unit: 'كرتون',
        unitPrice: 1000,
        image: '',
        quantity: 2,
        totalPrice: 2000),
    CartModel(
        id: 1,
        category_id: '',
        name: 'منتج',
        unit: 'كرتون',
        unitPrice: 1000,
        image: '',
        quantity: 2,
        totalPrice: 2000)
  ];

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SizedBox(
        height: screenUtil.orientation == Orientation.portrait
            ? screenUtil.screenHeight
            : screenUtil.screenWidth / 1.5,
        child: Shimmer.fromColors(
          baseColor: Colors.grey.withOpacity(.8),
          highlightColor: AppTheme.scaffoldBackgroundColor.withOpacity(.1),
          enabled: true,
          child: ListView.builder(
            itemCount: 5,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return Container(
                width: screenUtil.orientation == Orientation.portrait
                    ? screenUtil.screenWidth
                    : screenUtil.screenHeight,
                margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white10
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0,vertical: 5),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(text: 'رقم الفاتوره #', textColor: Colors.black54, fontSize: 15),
                          SubTitleText(text: 'حاله الطلب ###', textColor: Colors.black54, fontSize: 15),
                        ],
                      ),
                    ),

                    Invoice(cartList: cart,backgroundColor: null),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SubTitleText(
                              text: 'الإجمالي',
                              textColor: Colors.black54,
                              fontSize: 15),
                          SubTitleText(
                              text: '4000 ريال ',
                              textColor: Colors.black54,
                              fontSize: 15),
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
                        //TODO:here change the path to kIconPath variable
                        "assets/icons/down.svg",
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}

