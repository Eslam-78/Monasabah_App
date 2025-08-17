import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class ErrorScreen extends StatelessWidget {
  String imageName, // Error screen pic
      message, //Error screen message
      buttonTitle; //error screen button title
  Function? onPressed; // error screen button event
  double height, width;
  bool withButton; // error screen button visibility

  ErrorScreen(
      {required this.imageName,
      required this.message,
      required this.height,
      required this.width,
      this.buttonTitle = '',
      this.onPressed,
      this.withButton = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),

        // ignore: sized_box_for_whitespace
        Container(
          height: height,
          width: width,
          child: Image.asset('assets/illustrations/$imageName'),
        ),

        SubTitleText(
            text: message, textColor: AppTheme.primaryColor, fontSize: 20),

        SizedBox(
          height: 10,
        ),

        Visibility(
            visible: withButton,
            child: PrimaryButton(
                title: buttonTitle,
                onPressed: () {
                  onPressed!();
                },
                marginTop: .01))
      ],
    );
  }
}
