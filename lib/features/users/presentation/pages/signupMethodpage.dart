import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:monasbah/features/users/presentation/pages/singupRoute.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/Buttons/primaryButton.dart';
import '../../../../dataProviders/local_data_provider.dart';
import '../../../onboarding/widgets/Onboarding_illustraion.dart';
import '../../../../injection_container.dart';

class SignupMethodPAge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                  flex: 6,
                  child: oNboardingillustraion(
                    illustrationPath: "assets/illustrations/onboarding3.png",
                    heign: 350,
                    width: 350,
                  )),
              Expanded(
                  flex: 1,
                  child: SubTitleText(
                      text: 'إنشاء حساب كـ ',
                      textColor: AppTheme.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    PrimaryButton(
                      marginTop: .01,
                      title: "عميل",
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return SignupPage(userBrand: 'customer');
                        }));
                      },
                    ),
                    PrimaryButton(
                      marginTop: .01,
                      title: "مزود خدمه",
                      onPressed: () {
                        LocalDataProvider(
                                sharedPreferences: sl<SharedPreferences>())
                            .cacheData(key: 'onbordingShowen', data: 'true');
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) {
                          return SignupPage(userBrand: 'serviceProvider');
                        }));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
