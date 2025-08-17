import 'package:monasbah/features/onboarding/widgets/OnboardingBottomContainer.dart';
import 'package:monasbah/features/onboarding/widgets/Onboarding_illustraion.dart';
import 'package:flutter/material.dart';

class Second extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        oNboardingillustraion(
            illustrationPath: "assets/illustrations/onboarding2.png"),
        OnboardingBottomContainer(
          iconPath: 'assets/images/step2.png',
          containerImagePath: "firstSplashImage.png",
          containerText:
              "حجز وتخفيض \n\n ستتمكن من حجز الخدمات التي تريدها من تطبيقنا وستحصل على تخفيض في كل خدمه تقوم بحجزها",
        ),
      ],
    );
  }
}
