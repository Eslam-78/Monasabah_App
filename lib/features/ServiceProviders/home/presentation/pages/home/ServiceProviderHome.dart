import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsState.dart';
import 'package:monasbah/features/customers/services/presentation/pages/servicePreviewPage.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/moreServiceImagesContainer.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/shimmer/moreServiceImagesContainerShimmer.dart';
import 'package:monasbah/injection_container.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/home/addNewServiceImage.dart';
import 'package:shimmer/shimmer.dart';

class ServiceProviderHome extends StatefulWidget {
  @override
  State<ServiceProviderHome> createState() => _ServiceProviderHomeState();
}

class _ServiceProviderHomeState extends State<ServiceProviderHome> {
  ScreenUtil screenUtil = ScreenUtil();

  ServicesModel? servicesModel;
  Widget serviceRatingWidget = Container(), serviceImagesWidget = Container();
  File? galleryImage;
  bool requestPending = false;
  String image = '';
  String numberOFRaters = '#';

  @override
  void initState() {
    checkCachedService().fold((l) {
      servicesModel = l;
    }, (r) {
      servicesModel = null;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Container(
      padding: const EdgeInsets.only(top: 10.0),
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                  top: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenHeight / 15
                      : screenUtil.screenWidth / 15,
                  bottom: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenHeight / 15
                      : screenUtil.screenWidth / 15,
                  left: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenWidth / 15
                      : screenUtil.screenHeight / 10,
                  right: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenWidth / 15
                      : screenUtil.screenHeight / 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(
                  Radius.circular(40),
                ),
              ),
              child: Stack(
                children: [
                  Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showImagesDialog(context, servicesModel!.image);
                        },
                        child: Container(
                            height:
                                screenUtil.orientation == Orientation.portrait
                                    ? screenUtil.screenHeight / 3
                                    : screenUtil.screenWidth / 3,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20)),
                              child: cachedNetworkImage(servicesModel!.image,
                                  imagePath: servicesModel!.image),
                            )),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SubTitleText(
                        text: "تقييم الخدمه",
                        textColor: AppTheme.primaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),

                      ///service rating
                      BlocProvider(
                        create: (context) => sl<ServicesDetailsBloc>(),
                        child: BlocConsumer<ServicesDetailsBloc,
                            ServicesDetailsState>(
                          listener: (_context, state) {
                            if (state is ServicesDetailsError) {
                              MyFlashBar(
                                  title: 'خطأ',
                                  context: context,
                                  icon: Icons.error,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  message: state.errorMessage,
                                  thenDo: () {
                                    print(state.errorMessage);
                                  }).showFlashBar();
                            }
                          },
                          builder: (_context, state) {
                            if (state is ServicesDetailsInitial) {
                              BlocProvider.of<ServicesDetailsBloc>(_context)
                                  .add(GetServicesRating(
                                      service_id: servicesModel!.id
                                          .toString()
                                          .toString()));
                            }
                            if (state is ServicesDetailsLoading) {
                              serviceRatingWidget = Shimmer.fromColors(
                                  baseColor: Colors.grey.withOpacity(.8),
                                  highlightColor: AppTheme
                                      .scaffoldBackgroundColor
                                      .withOpacity(.1),
                                  enabled: true,
                                  child: RatingBar.builder(
                                    initialRating: 5,
                                    direction: Axis.horizontal,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                    ),
                                    onRatingUpdate: (double value) {},
                                  ));
                            } else if (state is GetServiceRateLoaded) {
                              numberOFRaters = state
                                  .serviceRatingModel[0].numberOfRaters
                                  .toString();

                              serviceRatingWidget = Column(
                                children: [
                                  RatingBarIndicator(
                                    rating: double.parse(
                                        state.serviceRatingModel[0].rating),
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star_rate_rounded,
                                      color: AppTheme.primaryColor,
                                    ),
                                    itemCount: 5,
                                    itemSize: 35.0,
                                    textDirection: TextDirection.ltr,
                                    unratedColor: Colors.amber.withAlpha(100),
                                    direction: Axis.horizontal,
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SubTitleText(
                                          text:
                                              'عدد المقيمين : ${numberOFRaters}',
                                          textColor: AppTheme.primaryColor,
                                          fontSize: 12),
                                      GestureDetector(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return ServicePreviewPage(
                                                  id: servicesModel!.id);
                                            }));
                                          },
                                          child: SubTitleText(
                                              text: 'المراجعات',
                                              textColor: AppTheme.primaryColor,
                                              fontSize: 12)),
                                    ],
                                  ),
                                ],
                              );
                            }
                            return serviceRatingWidget;
                          },
                        ),
                      ),

                      ///service rating

                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: [
                          SubTitleText(
                            text: "صور أخرى للخدمه",
                            textColor: AppTheme.primaryColor,
                            fontSize: 15,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: BlocProvider(
                              create: (context) => sl<ServicesDetailsBloc>(),
                              child: BlocConsumer<ServicesDetailsBloc,
                                  ServicesDetailsState>(
                                listener: (_context, state) {
                                  if (state is ServicesDetailsError) {
                                    MyFlashBar(
                                        title: 'خطأ',
                                        context: context,
                                        icon: Icons.error,
                                        iconColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        message: state.errorMessage,
                                        thenDo: () {
                                          print(state.errorMessage);
                                        }).showFlashBar();
                                  }
                                },
                                builder: (_context, state) {
                                  if (state is ServicesDetailsInitial) {
                                    BlocProvider.of<ServicesDetailsBloc>(
                                            _context)
                                        .add(
                                      GetServiceImages(
                                          service_id:
                                              servicesModel!.id.toString()),
                                    );
                                  } else if (state is ServicesDetailsLoading) {
                                    serviceImagesWidget =
                                        MoreServiceImagesContainerShimmer();
                                  } else if (state is GetServicesImagesLoaded) {
                                    if (state.servicesImagesModel != null) {
                                      print('data in main menu is not null');
                                      if (state
                                          .servicesImagesModel.isNotEmpty) {
                                        serviceImagesWidget = SizedBox(
                                          height: 200,
                                          child: GridView.count(
                                            reverse: true,
                                            scrollDirection: Axis.horizontal,
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 5,
                                            mainAxisSpacing: 20,
                                            semanticChildCount: 2,
                                            children: List.generate(
                                                state.servicesImagesModel
                                                    .length, (index) {
                                              return MoreServiceImagesContainer(
                                                onTapImage: () {
                                                  showImagesDialog(
                                                      context,
                                                      state
                                                          .servicesImagesModel[
                                                              index]
                                                          .image);
                                                },
                                                image: state
                                                    .servicesImagesModel[index]
                                                    .image,
                                                imagePath: '',
                                              );
                                            }),
                                          ),
                                        );
                                      } else {
                                        serviceImagesWidget = Center(
                                            child: ErrorScreen(
                                          height: screenUtil.orientation ==
                                                  Orientation.portrait
                                              ? 200
                                              : 200,
                                          width: screenUtil.orientation ==
                                                  Orientation.portrait
                                              ? 200
                                              : 200,
                                          imageName: 'empty.png',
                                          message:
                                              'لا بوجد صور إضافيه للخدمه حالياً',
                                          onPressed: null,
                                          withButton: false,
                                        ));
                                      }
                                    }
                                  }
                                  return serviceImagesWidget;
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                      PrimaryButton(
                        title: "اضافه صوره اخرى للخدمه",
                        onPressed: () {
                          addImagesDialog(context);
                        },
                        marginTop: .04,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addImagesDialog(BuildContext context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              elevation: 20,
              insetAnimationDuration: Duration(seconds: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: AddNewServiceImagePage(
                id: servicesModel!.id.toString(),
              ));
        });
  }
}
