import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class SearchMethodeWidget extends StatelessWidget {
  String searchMethode;
  Color textColor, backgroundColor;
  Function onTap;
  ScreenUtil screenUtil = ScreenUtil();

  SearchMethodeWidget(
      {required this.searchMethode,
      required this.textColor,
      required this.backgroundColor,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 50,
        width: 150,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(
            Radius.circular(50.0),
          ),
        ),
        child: Center(
          child: SubTitleText(
            text: searchMethode,
            textColor: textColor,
            fontSize: 15,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
