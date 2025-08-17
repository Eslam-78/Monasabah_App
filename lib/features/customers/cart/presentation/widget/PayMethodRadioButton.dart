import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class PayMethodRadioButton extends StatelessWidget {
  var onChange = (newValue) {};
   int value, groupValue;
   String payMethod;

  PayMethodRadioButton(
      {required this.onChange,
        required this.value,
        required this.groupValue,
        required this.payMethod,
      });

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Radio(value: value, groupValue: groupValue, onChanged: onChange),
        SubTitleText(
          text: payMethod,
          textColor: Colors.black54,
          fontSize: 15,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.normal,
        ),
      ],
    );
  }
}
