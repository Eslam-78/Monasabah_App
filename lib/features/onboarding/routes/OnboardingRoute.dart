
import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

import 'First.dart';
import 'Second.dart';
import 'Third.dart';

class OnboardingRoute extends StatelessWidget {
  final controller = PageController(initialPage: 1);

   late String title;
   late Widget child;
   late double mediaHeight, mediaWidth;

  @override
  Widget build(BuildContext context) {
    checkOrientation(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            //Expanded Containers
            Row(
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

            Column(
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
                    height: mediaHeight / 6,
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: Container(

                    // margin: EdgeInsets.only(top: 170),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(200),
                      ),
                    ),

                    child: PageView(
                      children: [
                        First(),
                        Second(),
                        Third()

                      ],
                    ),


                  )
                )
              ],
            ),
          ],
        ),
      ),
    );
  }




  checkOrientation(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;
    if (orientation == Orientation.landscape) {
      mediaHeight = MediaQuery.of(context).size.width;
      mediaWidth = MediaQuery.of(context).size.height;
    } else {
      mediaHeight = MediaQuery.of(context).size.height;
      mediaWidth = MediaQuery.of(context).size.width;
    }
  }
}
