import 'package:flutter/material.dart';

import '../../app_theme.dart';

// ignore: must_be_immutable
class ScreenStyle extends StatelessWidget {
  Widget child;
  bool isCart, withFloatActionButton;
  Function? onPressFloatActionButton, onTap, onTapRightSideIcon;
  String rightSideIcon;

  ScreenStyle(
      {Key? key,
      required this.child,
      this.isCart = false,
      this.onPressFloatActionButton,
      this.withFloatActionButton = false,
      this.rightSideIcon = 'notificationsWaite.svg',
      required this.onTapRightSideIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: withFloatActionButton
            ? FloatingActionButton(
                onPressed: () {
                  onPressFloatActionButton!();
                },
                child: const Icon(Icons.alternate_email,
                    color: Colors.blue, size: 40),
                backgroundColor: Colors.white,
              )
            : const SizedBox.shrink(),
        backgroundColor: AppTheme.primarySwatch.shade500,
        body: Column(
          children: [
            Expanded(
              flex: 10,
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                        'assets/images/background.jpg',
                      ),
                      fit: BoxFit.cover),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: child,
              ),
            )
          ],
        ),
      ),
    );
  }
}
