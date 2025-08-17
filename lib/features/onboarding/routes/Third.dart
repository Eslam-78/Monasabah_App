import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/onboarding/widgets/Onboarding_illustraion.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/users/presentation/pages/singupRoute.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Third extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
              flex: 3,
              child: oNboardingillustraion(
                  illustrationPath: "assets/illustrations/onboarding3.png")),
          Expanded(
              flex: 1,
              child: SubTitleText(
                  text: 'يمكنك تحديد دخولك للتطبيق كـ',
                  textColor: AppTheme.primaryColor,
                  fontSize: 15,
                  fontWeight: FontWeight.bold)),
          PrimaryButton(
            marginTop: .01,
            title: "عميل",
            onPressed: () {
              LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
                  .cacheData(key: 'onbordingShowen', data: 'true');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignupPage(userBrand: 'customer');
              }));
            },
          ),
          PrimaryButton(
            marginTop: .01,
            title: "مزود خدمه",
            onPressed: () {
              LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
                  .cacheData(key: 'onbordingShowen', data: 'true');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return SignupPage(userBrand: 'serviceProvider');
              }));
            },
          ),
          PrimaryButton(
            marginTop: .01,
            title: "زائر",
            onPressed: () {
              LocalDataProvider(sharedPreferences: sl<SharedPreferences>())
                  .cacheData(key: 'onbordingShowen', data: 'true');
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return CustomerMainHomeRoute(currentIndex: 1);
              }));
            },
          )
        ],
      ),
    );
  }

  cachOnboarding(BuildContext context) async {}
}
