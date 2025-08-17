import 'package:monasbah/features/onboarding/widgets/OnboardingBottomContainer.dart';
import 'package:monasbah/features/onboarding/widgets/Onboarding_illustraion.dart';
import 'package:flutter/material.dart';

class First extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        oNboardingillustraion(
            illustrationPath: "assets/illustrations/onboarding1.png"),
        OnboardingBottomContainer(
          iconPath: 'assets/images/step1.png',
          containerImagePath: "assets/images/step1.png",
          containerText:
              "سهوله الحجز \n\n ستتمكن من اختيار التاريخ المناسب لمناسبتك ومعرفة الأيام المتوفرة والأيام الشاغره",
        ),
      ],
    );
  }
}
