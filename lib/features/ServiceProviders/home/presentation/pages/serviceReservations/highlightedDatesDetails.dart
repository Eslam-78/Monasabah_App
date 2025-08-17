import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/ServiceProviderMainHome.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/widget/highlightedDatesShimmer.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsState.dart';
import 'package:monasbah/injection_container.dart';

import '../../../../../users/data/models/serviceProviderModel.dart';

class HighlightedDates extends StatefulWidget {
  String id;
  DateTime reserveDate;

  HighlightedDates({required this.id, required this.reserveDate});

  @override
  State<HighlightedDates> createState() => _HighlightedDatesState();
}

class _HighlightedDatesState extends State<HighlightedDates> {
  Widget highlightedDatesWidget = Container();

  ScreenUtil screenUtil = ScreenUtil();

  bool acceptRequestPending = false, declineRequestPending = false;
  ServiceProviderModel? serviceProviderModel;

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/images/background.jpg',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              BlocProvider(
                create: (context) => sl<ServicesReservationsBloc>(),
                child: BlocConsumer<ServicesReservationsBloc,
                    ServicesReservationsState>(
                  listener: (_context, state) {
                    if (state is AddServiceReservationsLoaded) {
                      MyFlashBar(
                        title: 'تمت',
                        context: context,
                        icon: Icons.check,
                        iconColor: Colors.white,
                        backgroundColor: Colors.green,
                        message: state.message,
                        thenDo: () {
                          setState(() {
                            acceptRequestPending = false;
                            declineRequestPending = false;
                          });
                          Navigator.pop(context);
                        },
                      ).showFlashBar();
                    }
                    if (state is AcceptReservationLoaded) {
                      MyFlashBar(
                        title: 'تمت',
                        context: context,
                        icon: Icons.check,
                        iconColor: Colors.white,
                        backgroundColor: Colors.green,
                        message: state.message,
                        thenDo: () {
                          setState(() {
                            acceptRequestPending = false;
                            declineRequestPending = false;
                          });
                          Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                            return ServiceProviderMainHomeRoute(
                              currentIndex: 9,
                            );
                          }));
                        },
                      ).showFlashBar();
                    }
                    if (state is ServicesReservationsError) {
                      MyFlashBar(
                        title: 'خطأ',
                        context: context,
                        icon: Icons.error,
                        iconColor: Colors.white,
                        backgroundColor: Colors.red,
                        message: state.errorMessage,
                        thenDo: () {
                          setState(() {
                            acceptRequestPending = false;
                            declineRequestPending = false;
                          });
                        },
                      ).showFlashBar();
                    }
                  },
                  builder: (_context, state) {
                    if (state is ServicesReservationsInitial) {
                      BlocProvider.of<ServicesReservationsBloc>(_context)
                          .add(GetHighlightedDates(
                        service_id: widget.id.toString(),
                        reserveDate: widget.reserveDate.toString(),
                      ));
                    } else if (state is GetServicesReservationsLoading) {
                      highlightedDatesWidget = HighlightedDatesShimmer();
                    } else if (state is GetServicesReservationsLoaded) {
                      if (state.servicesReservationsModel != null) {
                        if (state.servicesReservationsModel.isNotEmpty) {
                          highlightedDatesWidget = SizedBox(
                            height:
                                screenUtil.orientation == Orientation.portrait
                                    ? screenUtil.screenHeight * .8
                                    : screenUtil.screenWidth / 1.7,
                            child: ListView.builder(
                              itemCount: state.servicesReservationsModel.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30, vertical: 20),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: Container(
                                                height: screenUtil
                                                            .orientation ==
                                                        Orientation.portrait
                                                    ? screenUtil.screenHeight *
                                                        .1
                                                    : screenUtil.screenWidth *
                                                        .15,
                                                width: 500,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: ClipRRect(
                                                  child: state
                                                              .servicesReservationsModel[
                                                                  index]
                                                              .image !=
                                                          null
                                                      ? cachedNetworkImage(
                                                          state
                                                              .servicesReservationsModel[
                                                                  index]
                                                              .image,
                                                          imagePath: '')
                                                      : CircleAvatar(
                                                          child: Image.asset(
                                                              'assets/images/logo.png'),
                                                          radius: 50,
                                                          backgroundColor:
                                                              Colors.white),
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Container(
                                                width: screenUtil.orientation ==
                                                        Orientation.portrait
                                                    ? screenUtil.screenWidth *
                                                        .1
                                                    : screenUtil.screenHeight *
                                                        .1,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    children: [
                                                      Row(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Expanded(
                                                            flex: 2,
                                                            child: SubTitleText(
                                                              text: state
                                                                  .servicesReservationsModel[
                                                                      index]
                                                                  .userName,
                                                              textColor: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 20,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 1,
                                                            child: SubTitleText(
                                                              text: DateTime(
                                                                      DateTime.parse(state
                                                                              .servicesReservationsModel[
                                                                                  index]
                                                                              .reserveDate)
                                                                          .year,
                                                                      DateTime.parse(state
                                                                              .servicesReservationsModel[
                                                                                  index]
                                                                              .reserveDate)
                                                                          .month,
                                                                      DateTime.parse(state
                                                                              .servicesReservationsModel[index]
                                                                              .reserveDate)
                                                                          .day)
                                                                  .toString(),
                                                              textColor: AppTheme
                                                                  .primaryColor,
                                                              fontSize: 10,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SubTitleText(
                                          text:
                                              'رقم هاتف العميل : ${state.servicesReservationsModel[index].phoneNumber}',
                                          textColor: AppTheme.primaryColor,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        PrimaryButton(
                                          title: 'موافقه',
                                          pending: acceptRequestPending,
                                          onPressed: () {
                                            BlocProvider.of<
                                                        ServicesReservationsBloc>(
                                                    _context)
                                                .add(AcceptReservation(
                                              service_id: widget.id.toString(),
                                              customer_id: state
                                                  .servicesReservationsModel[
                                                      index]
                                                  .customer_id
                                                  .toString(),
                                              reserveDate:
                                                  widget.reserveDate.toString(),
                                            ));
                                          },
                                          marginTop: .01,
                                        ),
                                        PrimaryButton(
                                          pending: declineRequestPending,
                                          title: 'رفض',
                                          backgroundColor: Colors.red.shade900,
                                          onPressed: () {
                                            BlocProvider.of<
                                                        ServicesReservationsBloc>(
                                                    _context)
                                                .add(DeclineReservation(
                                              id: state
                                                  .servicesReservationsModel[
                                                      index]
                                                  .id
                                                  .toString(),
                                              token: 'api_token',
                                            ));

                                            MyFlashBar(
                                              title: 'تم',
                                              context: context,
                                              icon: Icons.check,
                                              iconColor: Colors.white,
                                              backgroundColor: Colors.green,
                                              message: 'تمت عملية الرفض بنجاح',
                                              thenDo: () {
                                                // Navigate to the main home page
                                                Navigator.pushReplacement(
                                                    context, MaterialPageRoute(
                                                        builder: (context) {
                                                  return ServiceProviderMainHomeRoute(
                                                      currentIndex: 1);
                                                }));
                                              },
                                            ).showFlashBar();
                                          },
                                          marginTop: .01,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        }
                      }
                    }
                    return highlightedDatesWidget;
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
