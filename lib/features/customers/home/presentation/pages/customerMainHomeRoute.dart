import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/BottomNavyBarItemsText.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'FavoritePage.dart';
import 'mainMinuPage.dart';
import 'myRequests/MyRequests.dart';
import '../../../settings/presentation/pages/settingsPage.dart';

class CustomerMainHomeRoute extends StatefulWidget {
  int currentIndex = 1;
  final customerId;

  CustomerMainHomeRoute({required this.currentIndex, this.customerId});

  @override
  _CustomerMainHomeRouteState createState() => _CustomerMainHomeRouteState();
}

class _CustomerMainHomeRouteState extends State<CustomerMainHomeRoute> {
  late CustomerModel? customerModel;
  late PageController _pageController; // للتحكم في الصفحات

  @override
  void initState() {
    super.initState();
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    // تهيئة متحكم الصفحات
    _pageController = PageController(initialPage: widget.currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.currentIndex);

    return Scaffold(
        body: SizedBox.expand(
          child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  widget.currentIndex = index;
                });
              },
              children: customerModel != null
                  ? <Widget>[
                      MyRequestsPage(),
                      FavoritePage(),
                      MainMenuPage(),
                      /*ProductsPage(),*/
                      SettingsPage(),
                      /* FavPage(customerId: widget.customerId)*/
                    ]
                  : <Widget>[
                      MainMenuPage(),
                      SettingsPage(),
                    ]),
        ),
        bottomNavigationBar: BottomNavyBar(
            animationDuration: Duration(milliseconds: 800),
            backgroundColor: AppTheme.primaryColor,
            itemCornerRadius: 20,
            selectedIndex: widget.currentIndex,
            onItemSelected: (index) {
              setState(() => widget.currentIndex = index);
              _pageController.jumpToPage(index);
            },
            showElevation: true,
            items: customerModel != null
                ? <BottomNavyBarItem>[
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "طلبات الحجز",
                        ),
                        icon: Icon(Icons.reviews)),
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "المفضله",
                        ),
                        icon: Icon(Icons.favorite_border)),
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "الرئيسيه",
                        ),
                        icon: SvgPicture.asset('$kIconsPath/Home.svg')),
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "الإعدادات",
                        ),
                        icon: Icon(Icons.settings)),
                    /* BottomNavyBarItem(
              activeColor: kBottomNavBarItemsActiveColor,
              inactiveColor: kBottomNavBarItemsInactiveColor,
              title: BottomNavyBarItemsText(title: "المفضله الثانية",),
              icon: Icon(Icons.favorite_border)

          ),*/
                  ]
                : <BottomNavyBarItem>[
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "الرئيسيه",
                        ),
                        icon: SvgPicture.asset('$kIconsPath/Home.svg')),
                    BottomNavyBarItem(
                        activeColor: kBottomNavBarItemsActiveColor,
                        inactiveColor: kBottomNavBarItemsInactiveColor,
                        title: BottomNavyBarItemsText(
                          title: "الإعدادات",
                        ),
                        icon: Icon(Icons.settings)),
                  ]));
  }
}
