
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/AppSpecialContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';

class HomeTrendWidget extends StatelessWidget {

   String serviceName;
   int servicePrice,ratingValue;
   Function ?onTap;
   Color ?containersColor;



  HomeTrendWidget({required this.serviceName,required this.servicePrice,required this.ratingValue,required this.onTap,this.containersColor=Colors.white});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onTap!();
      },
      child: AppSpecialContainer(
        image: 'images/servicesImages/hm.jpg',
        containersColor: containersColor,
        marginTop: 20,


        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            SubTitleText(
              text: serviceName,
              textColor: AppTheme.primaryColor,
              fontSize: 20,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.normal,
            ),
            SizedBox(
              height: 10,
            ),
            SubTitleText(
              text: "RY ${servicePrice}",
              textColor: AppTheme.primaryColor,
              fontSize: 15,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.normal,
            ),

            RatingBar.builder(

              initialRating: 4.5,
              direction: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, _) =>
                  Icon(
                    Icons.star,
                    color: Colors.yellow,
                    size: 10,
                  ),
              onRatingUpdate:
                  (double value) {},
            )
          ],
        ),
      )
    );
  }



}
