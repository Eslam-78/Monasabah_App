import 'package:monasbah/core/app_theme.dart';
import 'package:flutter/material.dart';

class ScreenLine extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.primarySwatch.shade300,
      height: 5,
      width: double.infinity,
    );
  }
}
