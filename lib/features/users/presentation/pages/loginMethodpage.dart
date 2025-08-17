import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/users/presentation/pages/LoginRoute.dart';

import '../../../../core/app_theme.dart';
import '../../../../core/widgets/Buttons/primaryButton.dart';
import '../../../customers/home/presentation/pages/customerMainHomeRoute.dart';
import '../../../onboarding/widgets/Onboarding_illustraion.dart';

class LoginMethodPage extends StatelessWidget {
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
                    heign: 300,
                    width: 300,
                  )),
              Expanded(
                  flex: 1,
                  child: SubTitleText(
                      text: 'يمكنك تحديد دخولك للتطبيق كـ',
                      textColor: AppTheme.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold)),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    PrimaryButton(
                      marginTop: .01,
                      title: "عميل",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage(userBrand: 'customer');
                        }));
                      },
                    ),
                    PrimaryButton(
                      marginTop: .01,
                      title: "مزود خدمه",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginPage(userBrand: 'serviceProvider');
                        }));
                      },
                    ),
                    PrimaryButton(
                      marginTop: .01,
                      title: "زائر",
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return CustomerMainHomeRoute(currentIndex: 1);
                        }));
                      },
                    )
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
