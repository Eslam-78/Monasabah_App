import 'package:monasbah/core/util/screenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginAndSignupScreen extends StatelessWidget {
  late String title;
  late Widget child;
  final LocalDataProvider?
      localDataProvider; //get the data from the local cache
  bool withScape, withBackground;

  LoginAndSignupScreen(
      {required this.title,
      required this.child,
      this.localDataProvider = null,
      this.withScape = false,
      this.withBackground = false});

  ScreenUtil screenUtil = ScreenUtil();
  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return Stack(
      alignment: Alignment.topRight,
      children: [
        SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            children: [
              //Body Container
              Container(
                padding: EdgeInsets.only(
                    right: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenWidth * .1
                        : screenUtil.screenWidth * .1,
                    left: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenWidth * .1
                        : screenUtil.screenHeight * .1,
                    top: screenUtil.orientation == Orientation.portrait
                        ? screenUtil.screenHeight * .07
                        : screenUtil.screenWidth * .07),
                height: screenUtil.screenHeight,
                width: screenUtil.screenWidth,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background.jpg',
                      ),
                      fit: BoxFit.cover),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                ),
                child: child,
              ),
            ],
          ),
        ),
        Visibility(
          visible: withScape,
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: GestureDetector(
              child: SubTitleText(
                text: "تخطي",
                textColor: Colors.white,
                fontSize: 15,
              ),
              onTap: () {
                LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
                    .cacheData(key: 'CUSTOMER_USER', data: null);
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CustomerMainHomeRoute(
                              currentIndex: 2,
                            )));
              },
            ),
          ),
        )
      ],
    );
  }
}
