import 'package:flutter_svg/flutter_svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/constants.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';

class SettingsScreen extends StatefulWidget {
  String userName, email;
  Widget child;
  Function onTapEditIcon;

  SettingsScreen(
      {required this.userName,
      required this.email,
      required this.child,
      required this.onTapEditIcon});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late double mediaHeight, mediaWidth;

  ScreenUtil screenUtil = ScreenUtil();
  late CustomerModel? customerModel;

  @override
  void initState() {
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    checkOrientation(context);
    screenUtil.init(context);

    //TODO: here we will solve the container height in landscape orientation

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
                    color: AppTheme.primaryColor /*Colors.black */,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white /* Colors.yellow*/,
                  ),
                )
              ],
            ),

            Column(
              children: [
                //Top Green Container
                Expanded(
                  flex: 2,
                  /*screenUtil.orientation == Orientation.portrait ? 2 : 3,*/
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      /*Colors.amber ,*/
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    height: screenUtil.screenHeight * 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: customerModel != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: customerModel!.image != null
                                        ? cachedNetworkImage(
                                            customerModel!.image,
                                            imagePath: '')
                                        : Image.asset(
                                            'assets/images/logo.png',
                                            height: 250,
                                            width: 250,
                                          ),
                                  )
                                : Image.asset(
                                    'assets/images/logo.png',
                                    height: 250,
                                    width: 250,
                                  )),
                        SizedBox(
                          height: 10,
                        ),
                        SubTitleText(
                          text: widget.userName,
                          textColor: Colors.white,
                          fontSize: 20,
                        ),
                        Row(
                          textDirection: TextDirection.rtl,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: mediaWidth / 10,
                            ),
                            SubTitleText(
                              text: widget.email,
                              fontSize: 15,
                              textColor: Colors.white60,
                            ),
                            SizedBox(
                              width: mediaWidth / 10,
                            ),
                            Visibility(
                              visible: customerModel != null ? true : false,
                              child: GestureDetector(
                                  onTap: () {
                                    widget.onTapEditIcon();
                                  },
                                  child: SvgPicture.asset(
                                    '$kIconsPath/editWaite.svg',
                                    height: 20,
                                    width: 20,
                                  )),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                //Bottom White Container
                Expanded(
                  flex: 4,
                  child: Container(
                      // margin: EdgeInsets.only(top: 170),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(70),
                        ),
                      ),
                      width: double.infinity,
                      child: widget.child),
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
