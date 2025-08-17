import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';

class ServiceAddressWidget extends StatelessWidget {

  String city,description,address;
  Widget child;

  ServiceAddressWidget({required this.city,required this.description,required this.address,required this.child});

  @override
  Widget build(BuildContext context) {
    return Row(
      textDirection: TextDirection.rtl,
      children: [
        Expanded(
          flex: 2,
          child: SubTitleText(
            text: "${city} - ${address} - ${description} ",
            textColor: Colors.black87,
            fontSize: 12,
          ),
        ),
        Expanded(

          child: child
        )
      ],
    );
  }
}
