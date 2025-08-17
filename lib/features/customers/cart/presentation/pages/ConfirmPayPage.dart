import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/cart/data/models/cartModel.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';
import 'package:monasbah/features/customers/cart/data/models/newOrderModel.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartBloc.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartEvent.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartState.dart';
import 'package:monasbah/features/customers/cart/presentation/widget/ConfirmReservationDetails.dart';
import 'package:monasbah/features/customers/cart/presentation/widget/Invoice.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/home/presentation/manager/myOrders/myOrdersBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/myOrders/myOrdersEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/myOrders/myOrdersState.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

class ConfirmReservationPage extends StatefulWidget {
  String payMethode, delivery_date;
  CustomerLocationsModel? customerLocationsModel;

  @override
  State<ConfirmReservationPage> createState() => _ConfirmReservationPageState();

  ConfirmReservationPage(
      {required this.customerLocationsModel,
      required this.payMethode,
      required this.delivery_date});
}

class _ConfirmReservationPageState extends State<ConfirmReservationPage> {
  late int total, reservedAmount;
  ScreenUtil screenUtil = ScreenUtil();
  Widget invoiceWidget = Container();
  CustomerModel? customerModel;
  var totalPrice = 0;
  List<CartModel> cartList = [
    CartModel(
      id: 1,
      category_id: 1,
      name: 'name',
      unit: 'unit',
      unitPrice: 1,
      image: 'image',
      quantity: 1,
      totalPrice: 1,
    )
  ];
  bool requestPending = false;
  DateTime? dateTimeAfterSelect;

  @override
  void initState() {
    super.initState();
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });

    dateTimeAfterSelect = DateTime.parse(widget.delivery_date);
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return ScreenStyle(
      onTapRightSideIcon: () {},
      child: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Container(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              textDirection: TextDirection.rtl,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Label(labelText: "تأكيد الحجز"),
                SizedBox(
                  height: 20,
                ),

                ///Start User Information Container

                Container(
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      )),
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleText(
                        text: "معلومات المستخدم : ",
                        textColor: AppTheme.primaryColor,
                        fontSize: 20,
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),
                      ConfirmReservationDetails(
                        title: "إسم المستخدم : ",
                        subTitle: 'اسلام العجل',
                      ),
                      ConfirmReservationDetails(
                        title: "العنوان : ",
                        subTitle:
                            '${widget.customerLocationsModel!.locationName}'
                            '  '
                            '${widget.customerLocationsModel!.description}',
                      ),
                    ],
                  ),
                ),

                ///End User Information Container

                ///Start Invoice Information Container

                BlocProvider(
                  create: (context) => sl<CartBloc>(),
                  child: BlocConsumer<CartBloc, CartState>(
                    listener: (_context, state) {
                      print("state listener is $state");
                      if (state is CartListError) {
                        MyFlashBar(
                            title: 'خطأ',
                            context: context,
                            icon: Icons.error,
                            iconColor: Colors.white,
                            backgroundColor: Colors.red,
                            message: state.errorMessage,
                            thenDo: () {
                              print(state.errorMessage);
                            }).showFlashBar();
                      }
                    },
                    builder: (_context, state) {
                      if (state is CartInitial) {
                        BlocProvider.of<CartBloc>(_context).add(
                          GetCart(),
                        );
                      } else if (state is CartLoaded) {
                        if (state.cartList == null) {
                          invoiceWidget = Text('السله فارغه');
                        } else {
                          cartList = state.cartList;

                          cartList.forEach((e) => {
                                totalPrice += e.unitPrice * e.quantity,
                              });

                          invoiceWidget = Column(
                            children: [
                              Invoice(
                                cartList: state.cartList,
                              ),
                              Container(
                                padding: EdgeInsets.all(10),
                                margin: EdgeInsets.all(10.0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(20),
                                    )),
                                child: Column(
                                  textDirection: TextDirection.rtl,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SubTitleText(
                                      text: "تفاصيل الطلب : ",
                                      textColor: AppTheme.primaryColor,
                                      fontSize: 20,
                                      textAlign: TextAlign.right,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ConfirmReservationDetails(
                                        title: "الاجمالي : ",
                                        subTitle: '$totalPrice'),
                                    ConfirmReservationDetails(
                                        title: "رسوم التوصيل : ",
                                        subTitle: "مجاناً"),
                                    ConfirmReservationDetails(
                                        title: "تاريخ التوصيل : ",
                                        subTitle:
                                            '${dateTimeAfterSelect!.year} / ${dateTimeAfterSelect!.month} / ${dateTimeAfterSelect!.day} - ${dateTimeAfterSelect!.hour} - ${dateTimeAfterSelect!.minute} ',
                                        textDirection: TextDirection.ltr),
                                    ConfirmReservationDetails(
                                        title: "طريقه الدفع : ",
                                        subTitle: widget.payMethode),
                                    ConfirmReservationDetails(
                                      title: "المبلغ المتوجب دفعه :  ",
                                      subTitle: totalPrice.toString(),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }
                      }
                      return invoiceWidget;
                    },
                  ),
                ),

                ///End Invoice Information Container
                ///start confirm process

                BlocProvider(
                  create: (context) => sl<MyOrdersBloc>(),
                  child: BlocConsumer<MyOrdersBloc, MyOrdersState>(
                    listener: (_context, state) {
                      if (state is NewOrdersLoaded) {
                        setState(() {
                          requestPending = false;
                        });
                        MyFlashBar(
                            title: 'تم',
                            context: context,
                            icon: state.message == 'ok'
                                ? Icons.check
                                : Icons.error,
                            iconColor: Colors.white,
                            backgroundColor: Colors.green.shade600,
                            message: state.message,
                            thenDo: () {
                              Navigator.pop(context);
                            }).showFlashBar();
                      } else if (state is MyOrdersError) {
                        setState(() {
                          requestPending = false;
                        });
                        MyFlashBar(
                            title: 'خطأ',
                            context: context,
                            icon: Icons.error,
                            iconColor: Colors.white,
                            backgroundColor: Colors.red,
                            message: state.errorMessage,
                            thenDo: () {
                              Navigator.pop(context);
                            }).showFlashBar();
                      }
                    },
                    builder: (_context, state) {
                      return Center(
                        child: PrimaryButton(
                          backgroundColor: AppTheme.primaryColor,
                          textColor: Colors.white,
                          pending: requestPending,
                          title: "تأكيد العمليه",
                          onPressed: () {
                            setState(() {
                              requestPending = true;
                            });
                            BlocProvider.of<MyOrdersBloc>(_context).add(
                              NewOrderEvent(
                                newOrderModel: NewOrderModel(
                                    total: totalPrice.toString(),
                                    delivery_date: widget.delivery_date,
                                    location_id: widget
                                        .customerLocationsModel!.id
                                        .toString(),
                                    payMethode: widget.payMethode,
                                    orders: jsonEncode(cartList),
                                    token: customerModel!.token),
                              ),
                            );
                          },
                          marginTop: .01,
                        ),
                      );
                    },
                  ),
                )

                ///end confirm process
              ],
            ),
          ),
        ),
      ),
    );
  }
}
