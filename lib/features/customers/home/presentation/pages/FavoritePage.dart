import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/home/presentation/manager/favorite/favoriteBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/favorite/favoriteEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/favorite/favoriteState.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/FavoritesContainerItems.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/services/presentation/pages/ServicesDetailsPage.dart';
import 'package:monasbah/injection_container.dart';

import '../../../../users/data/models/customerModel.dart';

class FavoritePage extends StatefulWidget {
  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  ScreenUtil screenUtil = ScreenUtil();
  CustomerModel? customerModel;

  Widget favoriteWidget = Container(); // الحاوية التي ستظهر في منتصف الشاشه

  @override
  void initState() {
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return ScreenStyle(
        onTapRightSideIcon: () {},
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            textDirection: TextDirection.rtl,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  Label(labelText: "المفضله"),
                ],
              ),
              SizedBox(
                height: 20,
              ),

              BlocProvider(
                create: (context) => sl<FavoriteBloc>(),
                child: BlocConsumer<FavoriteBloc, FavoriteState>(
                  listener: (_context, state) {
                    print("state listener is $state");
                    if (state is FavoriteListError) {
                      favoriteWidget = Center(
                        child: ErrorScreen(
                          onPressed: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) {
                              return CustomerMainHomeRoute(
                                currentIndex: 2,
                              );
                            }));
                          },
                          buttonTitle: 'حسنا',
                          height: 400,
                          width: 400,
                          imageName: 'empty.png',
                          message: ' المفضله فارغه اضف خدماتك المفضله',
                        ),
                      );
                    }
                  },
                  builder: (_context, state) {
                    if (state is FavoriteInitial) {
                      BlocProvider.of<FavoriteBloc>(_context).add(
                        GetFavorite(customerId: customerModel!.id),
                      );
                    } else if (state is FavoriteLoaded) {
                      if (state.favoriteList != null) {
                        if (state.favoriteList.isNotEmpty) {
                          favoriteWidget = Expanded(
                            flex: 6,
                            /* screenUtil.orientation == Orientation.portrait
                            ? 6
                            : 4,*/
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SizedBox(
                                height:
                                    300, // يمكنك تعيين الارتفاع حسب احتياجاتك
                                child: ListView.builder(
                                  itemCount: state.favoriteList.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    return FavoritesContainerItems(
                                      height:
                                          150, // يمكنك تعيين ارتفاع ثابت لكل عنصر
                                      serviceName:
                                          state.favoriteList[index].name,
                                      servicePrice:
                                          state.favoriteList[index].price,
                                      ratingValue: 5,

                                      image: state.favoriteList[index].image,
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ServiceDetailsPage(
                                              servicesModel:
                                                  state.favoriteList[index]);
                                        }));
                                      },
                                      onTapFavoriteIcon: () {
                                        AppDialog(
                                          context: context,
                                          svgImage: 'assets/icons/wonder.svg',
                                          message:
                                              'هل انت متأكد من إلغاء الخدمه من المفضله',
                                          onYesClicked: () {
                                            setState(() {
                                              state.favoriteList.remove(
                                                  state.favoriteList[index]);
                                              BlocProvider.of<FavoriteBloc>(
                                                      _context)
                                                  .add(UpdateFavorite(
                                                      customerId:
                                                          customerModel!.id,
                                                      favorite:
                                                          state.favoriteList));
                                              BlocProvider.of<FavoriteBloc>(
                                                      _context)
                                                  .add(GetFavorite(
                                                      customerId:
                                                          customerModel!.id));
                                            });
                                            Navigator.pop(context);
                                          },
                                          onNoClicked: () {
                                            Navigator.pop(
                                                context); // لاغلاق الديالوغ او النافذه المنبثقه
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        } else {
                          favoriteWidget = Center(
                            child: ErrorScreen(
                              onPressed: () {
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CustomerMainHomeRoute(
                                    currentIndex: 2,
                                  );
                                }));
                              },
                              buttonTitle: 'حسنا',
                              height: 400,
                              width: 400,
                              imageName: 'empty.png',
                              message: ' المفضله فارغه اضف خدماتك المفضله',
                            ),
                          );
                        }
                      }
                    }
                    return favoriteWidget;
                  },
                ),
              )

              // AppSpecialContainerShimmer(sizedBoxHeight: .7,sizedBoxWidth: .7,scrollOrientation: Axis.vertical,)
            ],
          ),
        ));
  }
}
