import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartBloc.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartEvent.dart';
import 'package:monasbah/features/customers/cart/presentation/manager/cart/cartState.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/OurServicesContainerItems.dart';
import 'package:monasbah/features/customers/cart/presentation/pages/payPage.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/injection_container.dart';

class CartPage extends StatefulWidget {
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  ScreenUtil screenUtil = ScreenUtil();

  Widget cartWidget=Container();
  bool confirmVisibility = true;

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return ScreenStyle(
      onTapRightSideIcon: (){

      },
      isCart: true,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(labelText: "السله"),
            SizedBox(
              height: 20,
            ),

            ///shimmer and list view
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
                    if (state.cartList != null) {
                      if (state.cartList.isNotEmpty) {
                        cartWidget = Expanded(
                          flex: screenUtil.orientation == Orientation.portrait
                              ? 6
                              : 4,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: ListView.builder(
                                    itemCount: state.cartList.length,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return OurServicesContainerItems(
                                        withRemoveIcon: true,
                                        initialValue: state.cartList[index]
                                            .quantity.toString(),
                                        productName:
                                        state.cartList[index].name,
                                        unitPrice: state.cartList[index]
                                            .unitPrice,
                                        quantity: state.cartList[index]
                                            .quantity,
                                        total: state.cartList[index].quantity *
                                            state.cartList[index].unitPrice,
                                        unit: state.cartList[index].unit,
                                        imageUrl:
                                        state.cartList[index].image,
                                        onChange: (value) {
                                          setState(() {
                                            state.cartList[index].quantity =
                                                int.parse(value);
                                          });
                                        },
                                        onTap: () {},
                                        onTapUp: () {
                                          setState(() {
                                            state.cartList[index].quantity++;
                                          });
                                          BlocProvider.of<CartBloc>(_context)
                                              .add(
                                              UpdateCart(cart: state.cartList));
                                        },
                                        onTapDown: () {
                                          setState(() {
                                            state.cartList[index].quantity > 1
                                                ? state.cartList[index]
                                                .quantity--
                                                : null;
                                          });
                                          BlocProvider.of<CartBloc>(_context)
                                              .add(
                                              UpdateCart(cart: state.cartList));
                                        },
                                        onTepRemove: () {
                                          AppDialog
                                            (context: context,
                                            svgImage: 'assets/icons/wonder.svg',
                                            message: 'هل انت متأكد من حذف العنصر من السله',
                                            onYesClicked: (){
                                              setState(() {
                                                state.cartList.remove(state.cartList[index]);
                                                BlocProvider.of<CartBloc>(_context).add(UpdateCart(cart: state.cartList));
                                                BlocProvider.of<CartBloc>(_context).add(
                                                  GetCart(),
                                                );
                                              });
                                              Navigator.pop(context);

                                            },
                                            onNoClicked: (){
                                            Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: PrimaryButton(
                                      title: "متابعه الحجز",
                                      marginTop: .01,
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                                  return ReservationPage();
                                                }));
                                      },
                                    ),
                                  ),
                                )

                              ],
                            ),
                          ),
                        );
                      } else {
                        cartWidget = Center(
                          child: ErrorScreen(
                            height: screenUtil.orientation ==
                                Orientation.portrait ? 400 : 200,
                            width: screenUtil.orientation ==
                                Orientation.portrait ? 400 : 200,
                            imageName: 'empty.png',
                            message: ' السله فارغه اطلب الان',
                            onPressed: () {
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                    return CustomerMainHomeRoute(currentIndex: 3);
                                  }));
                            },
                            buttonTitle: 'حسنا',
                            withButton: true,),
                        );
                      }
                    }
                  }
                  return cartWidget;
                },
              ),
            ),

            //TODO::remove this comment
            /*Expanded(
              flex:screenUtil.orientation==Orientation.portrait? 6:4,
              child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),

              child: OurServiceContainerItemsShimmer()
            ),
            ),*/

          ],
        ),
      ),
    );
  }
}
