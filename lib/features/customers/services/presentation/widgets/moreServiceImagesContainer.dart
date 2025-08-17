import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

class MoreServiceImagesContainer extends StatelessWidget {
  String image, imagePath;
  Function ?onTapImage;

  MoreServiceImagesContainer({this.image = '', this.imagePath = '',this.onTapImage=null});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTapImage!();
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: cachedNetworkImage(image, imagePath: imagePath),
        ),
      ),
    );
  }
}
