import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/screens/ServiceProviderScreen.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/serviceReservations/ServiceProviderMyReserves.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/settings/ServiceProviderSettings.dart';
import 'package:monasbah/features/customers/home/presentation/widgets/BottomNavyBarItemsText.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/pages/ReservationReportPage.dart';

import 'home/ServiceProviderHome.dart';

class ServiceProviderMainHomeRoute extends StatefulWidget {
  int currentIndex;


  ServiceProviderMainHomeRoute({required this.currentIndex});

  @override
  _ServiceProviderMainHomeRoute createState() =>
      _ServiceProviderMainHomeRoute();
}

class _ServiceProviderMainHomeRoute
    extends State<ServiceProviderMainHomeRoute> {

  late PageController _pageController;

  ServicesModel ?servicesModel;
  @override
  void initState() {
    _pageController = PageController();

    checkCachedService().fold((l) {
      servicesModel = l;
    }, (r) {
      servicesModel = null;
    });

    _pageController=PageController(initialPage: widget.currentIndex);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ServiceProviderScreen(
          title: servicesModel!.name,
          subTitle:  servicesModel!.sectionName,
          image:  servicesModel!.image,
          child: SizedBox(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => widget.currentIndex = index);
              },
              children: <Widget>[
              ReservationsReportPage(serviceId: servicesModel!.id.toString()),
                ServiceProviderMyReserves(),
                ServiceProviderHome(),
                ServiceProviderSettings(),

              ],
            ),
          ),
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
          items: <BottomNavyBarItem>[
           BottomNavyBarItem(
                activeColor: kBottomNavBarItemsActiveColor,
                inactiveColor: kBottomNavBarItemsInactiveColor,
                title: BottomNavyBarItemsText(
                  title: "تقرير حجوزاتي",
                ),
                icon: Icon(Icons.request_quote_rounded)),

            BottomNavyBarItem(
                activeColor: kBottomNavBarItemsActiveColor,
                inactiveColor: kBottomNavBarItemsInactiveColor,
                title: BottomNavyBarItemsText(
                  title: "حجوزاتي",
                ),
                icon: Icon(Icons.chat_bubble)),
            BottomNavyBarItem(
                activeColor: kBottomNavBarItemsActiveColor,
                inactiveColor: kBottomNavBarItemsInactiveColor,
                title: BottomNavyBarItemsText(
                  title: "الرئيسيه",
                ),
                icon: Icon(
                  Icons.home,
                )),
            BottomNavyBarItem(
                activeColor: kBottomNavBarItemsActiveColor,
                inactiveColor: kBottomNavBarItemsInactiveColor,
                title: BottomNavyBarItemsText(
                  title: "الاعدادات",
                ),
                icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}
