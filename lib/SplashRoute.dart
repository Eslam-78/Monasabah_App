import 'dart:async';

import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/ServiceProviders/mainMenu/presintaion/pages/serviceProviderMainMenuPage.dart';
import 'features/onboarding/routes/OnboardingRoute.dart';
import 'features/users/data/models/customerModel.dart';

class SplashRoute extends StatefulWidget {
  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  late SharedPreferences preferences;
  String ?onboardingShowen;
  late CustomerModel? customerModel;
  late ServiceProviderModel ?serviceProviderModel;
  late String title;
  late Widget child;

  ScreenUtil screenUtil=ScreenUtil();
  @override
  void initState() {
    checkOnboarding().fold((l) {
      onboardingShowen = l;
    }, (r) {
      onboardingShowen = null;
    });

    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });

    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
    super.initState();

     startTime(); ///this function delay 6 second then open the next route
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    ScreenUtil().init(context);

    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Expanded Containers
            Row(
              textDirection: TextDirection.ltr,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: AppTheme.primaryColor,
                  ),
                )
              ],
            ),

            Stack(
              children: [
                Column(
                  textDirection: TextDirection.ltr,

                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                          ),
                        ),
                      ),
                    ),//the current configured flutter SDK is not known to be fully supported.please update yot SDK and restart intellij
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(200),
                            topRight: Radius.circular(200),
                          ),
                        ),
                        height: screenUtil.screenHeight / 2,
                      ),
                    ),
                    Expanded(
                        flex: 2,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: AppTheme.primaryColor,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              textDirection: TextDirection.ltr,

                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(200),
                                        topRight: Radius.circular(200),
                                      ),
                                    ),
                                    height: screenUtil.screenHeight / 2,
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppTheme.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(200),
                                        topRight: Radius.circular(400),
                                        topLeft: Radius.circular(200),
                                      ),
                                    ),
                                    height: screenUtil.screenHeight / 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                  ],
                ),
                Center(child: Image.asset('assets/images/logo.png',height: 250,width: 250,))
              ],
            )
          ],
        ),
      ),
    );
  }

  startTime() async {
    var duration = Duration(seconds: 4);
    return Timer(duration, route);
  }

  route() {


    if(onboardingShowen!=null){
      if(serviceProviderModel!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
          return ServiceProviderMainMenuPage();
        }));
      }else{
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => CustomerMainHomeRoute(currentIndex: 1)));
      }

    }else{
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => OnboardingRoute()));
    }

  }
/*

   String getData()  {
     var issf=LocalDataProvider(sharedPreferences: sl<SharedPreferences>()).getCachedData(key: 'onbordingShowen', retrievedDataType: String);
     return issf;
  }
*/


}
