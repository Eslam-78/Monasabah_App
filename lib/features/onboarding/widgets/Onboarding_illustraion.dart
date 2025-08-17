import 'package:flutter/material.dart';

// ignore: camel_case_types
class oNboardingillustraion extends StatelessWidget {
  String illustrationPath;
  double heign, width;

  oNboardingillustraion(
      {required this.illustrationPath, this.heign = 200, this.width = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          child: Image(
            image: AssetImage(
              illustrationPath,
            ),
            height: heign,
            width: width,
          ),
        ),
      ],
    );
  }
}
