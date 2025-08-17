import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/Constants.dart';
import 'package:monasbah/core/widgets/Texts/OverFlowText.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class ServiceProviderSettingsItemsWidget extends StatelessWidget {
  IconData trailingIcon;
  String title, subTitle;

  ServiceProviderSettingsItemsWidget({
      required this.trailingIcon,
      required this.title,
      required this.subTitle,
     });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            flex: 1,
            child: Icon(trailingIcon),
          ),
          Expanded(
            flex: 2,
            child: SubTitleText(
                text: title,
                textColor: AppTheme.primaryColor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            flex: 2,
            child: OverFlowText(title: subTitle, maxLine: 1),
          ),

        ],
      ),
    );
  }
}
