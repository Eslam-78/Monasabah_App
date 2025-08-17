import 'dart:developer';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/customers/adds/data/model/addsModel.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class MySliderBar extends StatefulWidget {
   final List<AddsModel> addsModel;

  MySliderBar({required this.addsModel});

  @override
  State<MySliderBar> createState() => _MySliderBarState();
}

class _MySliderBarState extends State<MySliderBar> {
  CarouselController controller=CarouselController();

  int searchMethodIndexColor = 0;
  int activIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CarouselSlider.builder(
          carouselController: controller,
          itemCount: widget.addsModel.length,
          options: CarouselOptions(

              onPageChanged: (index, reason) {
                setState(() {
                  searchMethodIndexColor = index;
                  activIndex=index;
                });
              },
              height: 200,
              autoPlay:widget.addsModel.length>1? true:false,
              autoPlayAnimationDuration: Duration(seconds: 4),
              enlargeCenterPage: true,
              enlargeStrategy: CenterPageEnlargeStrategy.height),
          itemBuilder: (context, index, realIndex) {
            return GestureDetector(
              onTap: () {
                if (widget.addsModel[index].url.isNotEmpty) {
                  launchUrls(url: widget.addsModel[index].url);
                  // print(widget.addsModel[index].url);
                }
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: cachedNetworkImage(widget.addsModel[index].image,
                          imagePath: ''),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: searchMethodIndexColor == index
                          ? AppTheme.primarySwatch.shade800
                          : AppTheme.primarySwatch.shade300,
                    ),
                    child: Center(
                        child: SubTitleText(
                            text: widget.addsModel[index].description,
                            fontSize: 20,
                            textColor: Colors.white)),
                  ),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 15,),
        AnimatedSmoothIndicator(
          /*onDotClicked: (value){
            controller.jumpToPage(value);

            // setState(() {
            //   activIndex=value;
            //   searchMethodIndexColor=value;
            // });


          },*/
          activeIndex: activIndex,
          count: widget.addsModel.length,
          effect: JumpingDotEffect(
            activeDotColor: AppTheme.primaryColor,
            dotColor: AppTheme.primarySwatch.shade500,
          ),
        ),
      ],
    );
  }

  void launchUrls({required String url}) async {
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (_) {
      log("can't open url sth happened");
    }
  }

}
