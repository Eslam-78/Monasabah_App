import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

class MyFlashBar{

  late String title,message;
  late Function thenDo;
  late BuildContext context;
  late IconData icon;
  late Color iconColor;
  late Color backgroundColor;

  MyFlashBar({required this.title, required this.message,required this.thenDo,required this.context,required this.icon,required this.iconColor,required this.backgroundColor});

  showFlashBar() {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      boxShadows: [
        BoxShadow(
            color: Colors.black.withOpacity(.03),
            blurRadius: 20.0,
            spreadRadius: 20.0)
      ],
      dismissDirection: FlushbarDismissDirection.HORIZONTAL,
      titleText: Text(
        title,
        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      messageText: Text(message,style: TextStyle(color: Colors.white),),
      margin: EdgeInsets.all(12.0),
      borderRadius: 8,
      icon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(
          icon,
          color: iconColor,
          // size: ScreenUtil.orientation == Orientation.portrait ? ScreenUtil.screenWidth * .1 : ScreenUtil.screenHeight * .1,
          size: 20,
        ),
      ),

      backgroundColor: backgroundColor,
      duration: Duration(seconds: 2),
    ).show(context).then((value) {
      return thenDo();
    });
  }

}