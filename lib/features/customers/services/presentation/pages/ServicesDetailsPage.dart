import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/Constants.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Others/Taped_Icon.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsState.dart';
import 'package:monasbah/features/customers/services/presentation/pages/servicePreviewPage.dart';
import 'package:monasbah/features/customers/services/presentation/pages/serviceReservationsPage.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/moreServiceImagesContainer.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/serviceAdreessWidget.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/shimmer/moreServiceImagesContainerShimmer.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/socialMediaWidget.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';
import 'package:monasbah/mapPage.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:monasbah/features/users/presentation/pages/LoginRoute.dart';

class ServiceDetailsPage extends StatefulWidget {
  ServicesModel servicesModel;

  ServiceDetailsPage({required this.servicesModel});

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  String downUpIcon = "down.svg";
  bool moreDetailsContainerVisibility = false;
  ScreenUtil screenUtil = ScreenUtil();
  Widget serviceImagesWidget = Container(),
      serviceAddressWidget = Container(),
      serviceRatingWidget = Container(),
      customerServiceRatingWidget = Container();
  bool requestPending = false;
  late BuildContext customerRatingSpinKitThreeBounceContext;

  late CustomerModel? customerModel;
  String numberOFRaters = '#';
  int totla = 0;

  @override
  void initState() {
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    print(widget.servicesModel.facebook);
    return ScreenStyle(
      onTapRightSideIcon: () {},
      withFloatActionButton:
          true, //يستخدم لتفعيل او تعطيل الزر @ الخاص بالاسوشل ميديا
      onPressFloatActionButton: () {
        showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return Column(
              children: [
                Expanded(
                  child: Container(
                    height: MediaQuery.of(context).size.height *
                        0.5, // ارتفاع الشيت يمكن تعديله
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:
                                Colors.white.withOpacity(0.9), // شفافية الخلفية
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.withOpacity(.8),
                                highlightColor: AppTheme.scaffoldBackgroundColor
                                    .withOpacity(.1),
                                enabled: true,
                                child: ClipRect(
                                  child: Align(
                                    alignment: Alignment.center,
                                    heightFactor: 1,
                                    widthFactor: 1,
                                    child: Column(
                                      children: [
                                        Text(
                                          '   وسائل التواصل الاجتماعي الخاصة ب:   ',
                                          style: TextStyle(
                                            fontSize: 14,
                                            backgroundColor: Colors
                                                .transparent, // لجعل النص شفاف
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          widget.servicesModel.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            // لجعل النص شفاف
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 20),
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(
                                    0.8), // شفافية خلفية وسائل التواصل الاجتماعي
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Column(
                                children: [
                                  widget.servicesModel.facebook != null
                                      ? SocialMediaWidget(
                                          title: 'Facebook',
                                          iconName: 'facebook.svg',
                                          backgroundColor:
                                              Colors.blue.withOpacity(0.5),
                                          onTap: () {
                                            launchUrls(
                                                url: widget
                                                    .servicesModel.facebook);
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  widget.servicesModel.instagram != null
                                      ? SocialMediaWidget(
                                          title: 'Instagram',
                                          iconName: 'instagram.svg',
                                          backgroundColor: Colors
                                              .orange.shade500
                                              .withOpacity(0.5),
                                          onTap: () {
                                            launchUrls(
                                                url: widget
                                                    .servicesModel.instagram);
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  widget.servicesModel.twitter != null
                                      ? SocialMediaWidget(
                                          title: 'Twitter',
                                          iconName: 'twitter.svg',
                                          backgroundColor: Colors
                                              .lightBlue.shade200
                                              .withOpacity(0.5),
                                          onTap: () {
                                            launchUrls(
                                                url: widget
                                                    .servicesModel.twitter);
                                          },
                                        )
                                      : SizedBox.shrink(),
                                  widget.servicesModel.youtube != null
                                      ? SocialMediaWidget(
                                          title: 'Youtube',
                                          iconName: 'youtube.svg',
                                          backgroundColor:
                                              Colors.red.withOpacity(0.5),
                                          onTap: () {
                                            launchUrls(
                                                url: widget
                                                    .servicesModel.youtube);
                                          },
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Label(fontSize: 12, labelText: 'تفاصيل  الخدمه '),
            //TODO: here there will be editing in label text size
            Container(
              margin: EdgeInsets.only(
                  top: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenHeight * .02
                      : screenUtil.screenWidth * .02,
                  bottom: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenHeight * .01
                      : screenUtil.screenWidth * .01,
                  left: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenWidth * .06
                      : screenUtil.screenHeight * .06,
                  right: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenWidth * .06
                      : screenUtil.screenHeight * .06),
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
                          showImagesDialog(context, widget.servicesModel.image);
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
                              child: cachedNetworkImage(
                                  widget.servicesModel.image,
                                  imagePath: widget.servicesModel.image),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SubTitleText(
                        text: "${widget.servicesModel.name}",
                        textColor: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      SubTitleText(
                        text: " سعر الخدمة:${widget.servicesModel.price} RY",
                        textColor: Colors.black87,
                        fontSize: 15,
                      ),
                      /* SubTitleText(
                        text:
                            " تتسع الصاله لـ ${widget.servicesModel.scale} شخص ",
                        textColor: Colors.black87,
                        fontSize: 15,
                      ),*/
                      SubTitleText(
                        text: 'خصم يصل ال ${widget.servicesModel.discount}%',
                        textColor: Colors.black87,
                        fontSize: 15,
                      ),

                      SubTitleText(
                        text:
                            'رقم هاتف الخدمه: ${widget.servicesModel.phoneNumber}',
                        textColor: Colors.black87,
                        fontSize: 15,
                      ),

                      ///service rating bar bloc provider
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
                                    setState(() {
                                      numberOFRaters = '#';
                                    });
                                  }).showFlashBar();
                            }
                          },
                          builder: (_context, state) {
                            if (state is ServicesDetailsInitial) {
                              BlocProvider.of<ServicesDetailsBloc>(_context)
                                  .add(GetServicesRating(
                                      service_id:
                                          widget.servicesModel.id.toString()));
                            }
                            if (state is ServicesDetailsLoading) {
                              numberOFRaters = '#';
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
                                      // color: Colors.amber,
                                      color: AppTheme.primaryColor,
                                    ),
                                    itemCount: 5,
                                    itemSize: 20.0,
                                    textDirection: TextDirection.ltr,
                                    unratedColor: Colors.amber.withAlpha(100),
                                    direction: Axis.horizontal,
                                  ),
                                  /*  RatingBar.builder(
                                    initialRating: double.parse(
                                        state.serviceRatingModel[0].rating),
                                    minRating: .5,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 4.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),*/
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
                                                  id: widget.servicesModel.id);
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

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: double.infinity,
                        height: screenUtil.orientation == Orientation.portrait
                            ? screenUtil.screenHeight * .1
                            : screenUtil.screenWidth * .1,
                        margin: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ServiceAddressWidget(
                            city: widget.servicesModel.city,
                            description: widget.servicesModel.description,
                            address: widget.servicesModel.address,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return MapPage(
                                    lat: widget.servicesModel.lat.toString(),
                                    long: widget.servicesModel.long.toString(),
                                    locationName: widget.servicesModel.name,
                                    locationDescription:
                                        widget.servicesModel.address,
                                  );
                                }));
                              },
                              child: CircleAvatar(
                                child:
                                    Image.asset('assets/images/marked_map.png'),
                              ),
                            ),
                          ),
                        ),
                      ),

                      Visibility(
                        visible: moreDetailsContainerVisibility,
                        child: Column(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0),
                                child: BlocProvider(
                                  create: (context) =>
                                      sl<ServicesDetailsBloc>(),
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
                                              service_id: widget
                                                  .servicesModel.id
                                                  .toString()),
                                        );
                                      } else if (state
                                          is ServicesDetailsLoading) {
                                        serviceImagesWidget =
                                            MoreServiceImagesContainerShimmer();
                                      } else if (state
                                          is GetServicesImagesLoaded) {
                                        if (state.servicesImagesModel != null) {
                                          print(
                                              'data in main menu is not null');
                                          if (state
                                              .servicesImagesModel.isNotEmpty) {
                                            serviceImagesWidget = SizedBox(
                                              height: 200,
                                              child: GridView.count(
                                                reverse: true,
                                                scrollDirection:
                                                    Axis.horizontal,
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
                                                        .servicesImagesModel[
                                                            index]
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
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            SubTitleText(
                              text: "من فضلك إعطائنا تقييمك للخدمه",
                              textColor: AppTheme.primaryColor,
                              fontSize: 15,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.bold,
                            ),

                            customerModel != null
                                ? BlocProvider(
                                    create: (context) =>
                                        sl<ServicesDetailsBloc>(),
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
                                          log(widget.servicesModel.id
                                              .toString());
                                          BlocProvider.of<ServicesDetailsBloc>(
                                                  _context)
                                              .add(GetCustomerServiceRating(
                                                  service_id: widget
                                                      .servicesModel.id
                                                      .toString(),
                                                  token: customerModel!.token));
                                        }
                                        if (state is ServicesDetailsLoading) {
                                          customerServiceRatingWidget =
                                              Shimmer.fromColors(
                                                  baseColor: Colors.grey
                                                      .withOpacity(.8),
                                                  highlightColor: AppTheme
                                                      .scaffoldBackgroundColor
                                                      .withOpacity(.1),
                                                  enabled: true,
                                                  child: RatingBar.builder(
                                                    initialRating: 5,
                                                    direction: Axis.horizontal,
                                                    itemCount: 5,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 4.0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                    ),
                                                    onRatingUpdate:
                                                        (double value) {},
                                                  ));
                                        } else if (state
                                            is GetCustomerServiceRateLoaded) {
                                          log(state.rate);
                                          customerServiceRatingWidget = Column(
                                            children: [
                                              RatingBar.builder(
                                                initialRating:
                                                    double.parse(state.rate),
                                                minRating: .5,
                                                direction: Axis.horizontal,
                                                allowHalfRating: true,
                                                itemCount: 5,
                                                itemPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                itemBuilder: (context, _) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                onRatingUpdate: (rating) {
                                                  BlocProvider.of<ServicesDetailsBloc>(
                                                          customerRatingSpinKitThreeBounceContext)
                                                      .add(
                                                          //TODO: here change the token of the user
                                                          AddCustomerServicesRate(
                                                              service_id: widget
                                                                  .servicesModel
                                                                  .id
                                                                  .toString(),
                                                              token:
                                                                  customerModel!
                                                                      .token,
                                                              rate: rating
                                                                  .toString()));
                                                  setState(() {
                                                    requestPending = true;
                                                  });
                                                },
                                              ),
                                            ],
                                          );
                                        }
                                        return customerServiceRatingWidget;
                                      },
                                    ),
                                  )
                                : SizedBox.shrink(),

                            SizedBox(
                              height: 15,
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            /// test test
                            BlocProvider(
                              create: (context) => sl<ServicesDetailsBloc>(),
                              child: BlocConsumer<ServicesDetailsBloc,
                                  ServicesDetailsState>(
                                listener: (_context, state) {
                                  if (state is AddCustomerServiceRate) {
                                    setState(() {
                                      requestPending = false;
                                    });
                                    MyFlashBar(
                                        title: 'تم',
                                        context: context,
                                        icon: Icons.check,
                                        iconColor: Colors.white,
                                        backgroundColor: Colors.green.shade600,
                                        message: state.message,
                                        thenDo: () {
                                          print(state.message);
                                        }).showFlashBar();
                                  } else if (state is ServicesDetailsError) {
                                    setState(() {
                                      requestPending = false;
                                    });
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
                                  customerRatingSpinKitThreeBounceContext =
                                      _context;
                                  return Visibility(
                                    visible: requestPending,
                                    child: SpinKitThreeBounce(
                                      color: AppTheme.primaryColor,
                                      size: 15.0,
                                    ),
                                  );
                                },
                              ),
                            ),

                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: screenUtil.orientation == Orientation.portrait
                            ? screenUtil.screenHeight / 15
                            : screenUtil.screenWidth / 15,
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                screenUtil.orientation == Orientation.portrait
                                    ? screenUtil.screenWidth / 6
                                    : screenUtil.screenHeight / 6,
                            vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: ListTile(
                          title: SubTitleText(
                            text:
                                "المزيد من المعلومات حول${widget.servicesModel.name}",
                            textColor: Colors.black87,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          trailing: SvgPicture.asset(
                            //TODO:here change the path to kIconPath variable
                            "assets/icons/$downUpIcon",
                          ),
                          onTap: () {
                            setState(() {
                              if (downUpIcon == "down.svg") {
                                downUpIcon = "up.svg";
                                moreDetailsContainerVisibility = true;
                              } else {
                                downUpIcon = "down.svg";
                                moreDetailsContainerVisibility = false;
                              }
                            });
                          },
                        ),
                      ),
                      Center(
                        child: PrimaryButton(
                          marginTop: .01,
                          onPressed: () {
                            if (customerModel != null) {
                              // المستخدم مسجل دخوله
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ServiceReservationsPage(
                                  servicesModel: widget.servicesModel,
                                );
                              }));
                            } else {
                              // المستخدم غير مسجل دخوله
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LoginPage(userBrand: 'customer');
                              }));
                            }
                          },
                          title: "حـجـز",
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TapedIcon(
                      iconPath: '$kImagesPath/notifications.svg',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
