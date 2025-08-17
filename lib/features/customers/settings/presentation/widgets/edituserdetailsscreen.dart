import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class EditUserDetailsScreen extends StatelessWidget {
  Widget child;
  String headerText;
  ScreenUtil screenUtil = ScreenUtil();

  EditUserDetailsScreen(
      {Key? key, required this.child, required this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            //Expanded Containers
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
                )
              ],
            ),

            Column(
              children: [
                //The Top Green Container
                Expanded(
                  flex: 1 /*screenUtil.orientation==Orientation.portrait?1:2*/,
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    height: screenUtil.screenHeight *
                        0.25, // Give me the quarter size of the screen height
                    child: Align(
                      alignment: Alignment.center,
                      child: SubTitleText(
                        text: headerText,
                        textColor: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                // The bottom white Container
                Expanded(
                  flex: 4,
                  child: Container(
                      // margin: EdgeInsets.only(top: 170),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                      ),
                      width: double.infinity,
                      child: child),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
