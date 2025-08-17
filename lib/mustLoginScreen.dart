import 'package:flutter/material.dart';

class MustLoginScreen extends StatelessWidget {
  const MustLoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('must log in ')
          ],
        ),
      ),
    );
  }
}
