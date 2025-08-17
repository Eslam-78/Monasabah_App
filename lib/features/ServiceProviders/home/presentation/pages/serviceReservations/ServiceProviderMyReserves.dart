import 'dart:convert';
import 'dart:developer';

import 'package:calendar_builder/calendar_builder.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';

import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';

import 'package:monasbah/features/ServiceProviders/home/presentation/pages/ServiceProviderMainHome.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesReservationsModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsState.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/shimmer/serviceReservationDatesShimmer.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/injection_container.dart';

import 'highlightedDatesDetails.dart';

class ServiceProviderMyReserves extends StatefulWidget {
  @override
  State<ServiceProviderMyReserves> createState() =>
      _ServiceProviderMyReservesState();
}

class _ServiceProviderMyReservesState extends State<ServiceProviderMyReserves> {
  ServicesModel? servicesModel;
  ServiceProviderModel? serviceProviderModel;
  Widget serviceReservationsWidget = Container();
  final _cancelReasonFormKey = GlobalKey<FormState>();

  List<DateTime> eventsDates = [];
  List<DateTime> highLighteDates = [];
  List<DateTime> disabledDates = [];
  late ServicesReservationsModel serviceReservationModel;
  int cancelPressCounter = 0;
  bool cancelReasonVisibility = false;
  late String cancelReason;
  ScreenUtil screenUtil = ScreenUtil();
  bool buttonVisibility = false;
  DateTime selectedDate = DateTime.now();

  bool acceptPending = false;
  bool declinePending = false;
  int reservationId = 0;

  late BuildContext detailsDialogContext;
  late BuildContext declineDialogContext;
  bool requestPending = false;
  String blockUnBlockButtonTitle = 'حضر التاريخ';
  Color blockUnBlocButtonColor = Colors.red;
  @override
  void initState() {
    checkCachedService().fold((l) {
      servicesModel = l;
    }, (r) {
      servicesModel = null;
    });

    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    log('test is ${servicesModel!.id.toString()}');
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(
                'assets/images/background.jpg',
              ),
              fit: BoxFit.cover),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: BlocProvider(
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
                                requestPending = false;
                              });
                              Navigator.pushReplacement(context,
                                  MaterialPageRoute(builder: (context) {
                                return ServiceProviderMainHomeRoute(
                                    currentIndex: 0);
                              }));
                            }).showFlashBar();
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
                                requestPending = false;
                              });
                            }).showFlashBar();
                      }
                    },
                    builder: (_context, state) {
                      if (state is ServicesReservationsInitial) {
                        BlocProvider.of<ServicesReservationsBloc>(_context).add(
                            GetServiceReservations(
                                service_id: servicesModel!.id.toString()));
                      } else if (state is GetServicesReservationsLoading) {
                        serviceReservationsWidget =
                            ServiceReservationDatesShimmer();
                      } else if (state is GetServicesReservationsLoaded) {
                        serviceReservationsWidget = SingleChildScrollView(
                          child: Column(
                            children: [
                              // هنا الكود الموجود
                              // إضافة زر التقرير
                              SizedBox(height: 20),

                              SizedBox(
                                height: screenUtil.orientation ==
                                        Orientation.portrait
                                    ? screenUtil.screenHeight / 2
                                    : screenUtil.screenWidth / 2.8,
                                child: CbMonthBuilder(
                                  cbConfig: CbConfig(
                                      startDate: DateTime.now(),
                                      endDate:
                                          DateTime(DateTime.now().year + 4),
                                      selectedDate: selectedDate,
                                      selectedYear:
                                          DateTime(DateTime.now().year),
                                      weekStartsFrom: WeekStartsFrom.saturday,

                                      /*  disabledDates: [
                                        for (DateTime d = DateTime(2000);
                                        d.isBefore(DateTime.now());
                                        d = d.add(Duration(days: 1))) d
                                      ],*/
                                      ///start events dates
                                      /*disabledDates: getDisabledDates(jsonEncode(
                                        state.servicesReservationsModel)),*/
                                      eventDates: getEventsDates(jsonEncode(
                                          state.servicesReservationsModel)),
                                      highlightedDates: getHighLightDates(
                                          jsonEncode(state
                                              .servicesReservationsModel))),

                                  ///end events dates

                                  monthCustomizer: MonthCustomizer(
                                      padding: const EdgeInsets.all(20),
                                      monthHeaderCustomizer:
                                          MonthHeaderCustomizer(
                                        width: 300.0,
                                        textStyle: const TextStyle(
                                          color: AppTheme.primaryColor,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      scrollToSelectedMonth: true,
                                      monthButtonCustomizer:
                                          MonthButtonCustomizer(
                                              eventColor: Colors.black,
                                              eventColorOnDisabled: Colors.pink,
                                              borderColorOnEnabled:
                                                  Colors.black.withOpacity(.3),
                                              colorOnDisabled: Colors.redAccent
                                                  .withOpacity(.3),
                                              colorOnSelected:
                                                  Colors.black.withOpacity(.3),
                                              currentDayColor: Colors.orange,
                                              borderStrokeWidth: 2,
                                              textStyleOnDisabled:
                                                  const TextStyle(
                                                      color: Colors.black),
                                              highlightedColor:
                                                  AppTheme.primaryColor),
                                      monthWeekCustomizer: MonthWeekCustomizer(
                                          textStyle: const TextStyle(
                                              color: AppTheme.primaryColor))
                                      // monthWidth: 500,
                                      // monthHeight: 200
                                      ),
                                  yearDropDownCustomizer:
                                      YearDropDownCustomizer(
                                          yearButtonCustomizer:
                                              YearButtonCustomizer(
                                            borderColorOnSelected:
                                                AppTheme.primarySwatch.shade500,
                                          ),
                                          yearHeaderCustomizer:
                                              YearHeaderCustomizer(
                                                  titleTextStyle:
                                                      const TextStyle(
                                                          color: AppTheme
                                                              .primaryColor))),
                                  onYearHeaderExpanded: (isExpanded) {
                                    print(
                                        'isExpanded ' + isExpanded.toString());
                                  },
                                  onDateClicked: (onDateClicked) {
                                    if (onDateClicked.isDisabled) {
                                      Null;
                                    } else if (onDateClicked.hasEvent) {
                                      checkVisibleDate(
                                          // يخفي الزر الخاص بالحجز
                                          date: DateTime(
                                              onDateClicked.selectedDate.year,
                                              onDateClicked.selectedDate.month,
                                              onDateClicked.selectedDate.day),
                                          visibility: false);

                                      getReservationModelForThisDate(
                                          // يجلب تفاصيل الحجز لهذا التاريخ
                                          jsonEncode(
                                              state.servicesReservationsModel),
                                          selectedDate.toString());

                                      if (serviceReservationModel.customer_id !=
                                          null) {
                                        //اذا كان هذا التاريخ مرتبط بمستخدم معين
                                        showDetailsDialog(
                                          // اظهرلي الكارت الخاص بالمستخدم
                                          _context,
                                        );
                                      } else {
                                        // طالما الزر لا يمثل حجز فما زر قام بحضره المزود فيظهر الرسالة
                                        MyFlashBar(
                                            title: 'تنويه',
                                            context: context,
                                            icon: Icons.info_outline,
                                            iconColor: Colors.white,
                                            backgroundColor: Colors.red,
                                            message: 'لقد قمت بحضر هذا التاريخ',
                                            thenDo: () {
                                              setState(() {
                                                requestPending = false;
                                                blockUnBlockButtonTitle =
                                                    'فك الحضر';
                                                blockUnBlocButtonColor =
                                                    AppTheme.primaryColor;
                                                checkVisibleDate(
                                                  // يظهر الزر ويعرض التاريخ
                                                  date: DateTime(
                                                      onDateClicked
                                                          .selectedDate.year,
                                                      onDateClicked
                                                          .selectedDate.month,
                                                      onDateClicked
                                                          .selectedDate.day),
                                                  visibility: true,
                                                );
                                              });
                                            }).showFlashBar();
                                      }
                                    } else if (onDateClicked.isHighlighted) {
                                      //اذا كان التاريخ المختار مميز
                                      checkVisibleDate(
                                        //اخفي الزر
                                        date: DateTime(
                                            onDateClicked.selectedDate.year,
                                            onDateClicked.selectedDate.month,
                                            onDateClicked.selectedDate.day),
                                        visibility: false,
                                      );
                                      // التواريخ المميزة
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (context) {
                                        return HighlightedDates(
                                            id: servicesModel!.id.toString(),
                                            reserveDate: selectedDate);
                                      }));
                                    } else {
                                      // اذا كان التواريخ عادية لا هي حدث ولا معطلة ولا مميزة
                                      setState(() {
                                        blockUnBlockButtonTitle = 'حضر التاريخ';
                                        blockUnBlocButtonColor = Colors.red;
                                      }); // اعرض الزر حضر التاريخ بلون احمر
                                      checkVisibleDate(
                                          date: DateTime(
                                            onDateClicked.selectedDate.year,
                                            onDateClicked.selectedDate.month,
                                            onDateClicked.selectedDate.day,
                                          ),
                                          visibility: true);
                                      print(servicesModel!.id);
                                    }
                                  },
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              SubTitleText(
                                  text: buttonVisibility == false
                                      ? '${selectedDate.year} : ${selectedDate.month} : ${selectedDate.day} غير متاح '
                                      : '${selectedDate.year} : ${selectedDate.month} : ${selectedDate.day} متاح ',
                                  textColor: buttonVisibility == false
                                      ? Colors.red
                                      : AppTheme.primaryColor,
                                  fontSize: 15),
                              Visibility(
                                  visible: buttonVisibility,
                                  child: PrimaryButton(
                                      title: blockUnBlockButtonTitle,
                                      pending: requestPending,
                                      backgroundColor: blockUnBlocButtonColor,
                                      onPressed: () {
                                        BlocProvider.of<
                                                    ServicesReservationsBloc>(
                                                _context)
                                            .add(
                                          BlockDateReservation(
                                              service_id:
                                                  servicesModel!.id.toString(),
                                              reserveDate:
                                                  selectedDate.toString(),
                                              service_reservation_price:
                                                  servicesModel!.price
                                                      .toString(),
                                              blockUnBlock:
                                                  blockUnBlockButtonTitle ==
                                                          'حضر التاريخ'
                                                      ? 'block'
                                                      : 'unBloc'),
                                        );
                                        setState(() {
                                          requestPending = true;
                                        });
                                      },
                                      marginTop: .01)),
                            ],
                          ),
                        );
                      }

                      return serviceReservationsWidget;
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<DateTime> getEventsDates(dynamic data) {
    List<dynamic> event = jsonDecode(data);
    event.forEach((element) {
      if (element['status'].toString() == 'تمت الموافقه') {
        eventsDates.add(DateTime.parse(element['reserveDate']));
      }
    });
    return eventsDates;
  }

  List<DateTime> getHighLightDates(dynamic data) {
    List<dynamic> event = jsonDecode(data);
    event.forEach((element) {
      if (element['status'].toString() == 'قيد الانتظار') {
        highLighteDates.add(DateTime.parse(element['reserveDate']));
      }
    });
    return highLighteDates;
  }

  List<DateTime> getDisabledDates(dynamic data) {
    List<dynamic> event = jsonDecode(data);
    event.forEach((element) {
      if (element['status'].toString() == 'مرفوض' ||
          element['status'].toString() == 'مكتمل' ||
          element['غير متاح'] == true) {
        disabledDates.add(DateTime.parse(element['reserveDate']));
      }
    });
    return disabledDates;
  }

  void getReservationModelForThisDate(dynamic data, String dateTime) {
    List<dynamic> event = jsonDecode(data);
    event.forEach((element) {
      if (DateTime.parse(element['reserveDate']) == DateTime.parse(dateTime) &&
          (element['status'].toString() == 'تمت الموافقه')) {
        setState(() {
          serviceReservationModel = ServicesReservationsModel.fromJson(
              jsonDecode(jsonEncode(element)));
        });
        print(jsonEncode(element));
      }
    });
  }

//وهي الدالة التي تعرض كارت الخاص بالعميل الذي تم موافقة على طلب حجزه
  void showDetailsDialog(BuildContext _context) {
    showDialog(
        barrierDismissible: true,
        context: _context,
        builder: (BuildContext context) {
          detailsDialogContext = context;
          return Dialog(
              elevation: 20,
              insetAnimationDuration: Duration(seconds: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      textDirection: TextDirection.rtl,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Container(
                            height:
                                screenUtil.orientation == Orientation.portrait
                                    ? screenUtil.screenHeight * .1
                                    : screenUtil.screenWidth * .15,
                            width: 500,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50)),
                            child: ClipRRect(
                              child: serviceReservationModel.image != null
                                  ? cachedNetworkImage(
                                      serviceReservationModel.image,
                                      imagePath: '')
                                  : CircleAvatar(
                                      child:
                                          Image.asset('assets/images/logo.png'),
                                      radius: 50,
                                      backgroundColor: Colors.white),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 3,
                          child: Container(
                            width:
                                screenUtil.orientation == Orientation.portrait
                                    ? screenUtil.screenWidth * .1
                                    : screenUtil.screenHeight * .1,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                textDirection: TextDirection.rtl,
                                children: [
                                  Row(
                                    textDirection: TextDirection.rtl,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: SubTitleText(
                                            text: serviceReservationModel
                                                .userName,
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 20),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: SubTitleText(
                                            text: DateTime(
                                                    selectedDate.year,
                                                    selectedDate.month,
                                                    selectedDate.day)
                                                .toString(),
                                            textColor: AppTheme.primaryColor,
                                            fontSize: 10),
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
                          'رقم هاتف العميل : ${serviceReservationModel.phoneNumber}',
                      textColor: AppTheme.primaryColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ));
        });
  }

  void checkVisibleDate({required DateTime date, required bool visibility}) {
    setState(() {
      buttonVisibility = visibility;
      selectedDate = date;
    });
  }
}
