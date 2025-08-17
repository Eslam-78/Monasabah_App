import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';

class PrimaryButton extends StatelessWidget {

  Color? backgroundColor;
  Color textColor;
  String title;
  Function onPressed;
  double marginTop;
  bool pending;
  ScreenUtil screenUtil = ScreenUtil();


  PrimaryButton({
    this.backgroundColor = AppTheme.primaryColor,
    this.textColor = Colors.white,
    this.pending = false,
    required this.title,
    required this.onPressed,
    required this.marginTop
  });


  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return Container(
      height: screenUtil.orientation == Orientation.portrait
          ? screenUtil.screenHeight * .06
          : screenUtil.screenWidth * .06,
      width: screenUtil.screenWidth * .5,
      margin: EdgeInsets.only(
          top: screenUtil.screenHeight * marginTop, bottom: 20),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
        ),
        onPressed: () {
          pending ? null : onPressed();
        },
        child: pending
            ? Padding(
          padding: const EdgeInsets.all(5.0),
          child: SpinKitThreeBounce(
            color: AppTheme.scaffoldBackgroundColor,
            size: 15.0,
          ),
        )
            : SubTitleText(
          text: title,
          textColor: textColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
