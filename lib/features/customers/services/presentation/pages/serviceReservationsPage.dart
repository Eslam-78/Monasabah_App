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
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsState.dart';
import 'package:monasbah/features/customers/services/presentation/widgets/shimmer/serviceReservationDatesShimmer.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';
import 'package:monasbah/mustLoginScreen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../data/models/servicesReservationsModel.dart';

class ServiceReservationsPage extends StatefulWidget {
  ServicesModel servicesModel;

  ServiceReservationsPage({required this.servicesModel});

  // إعداد الحزمة في initState()
  @override
  State<ServiceReservationsPage> createState() =>
      _ServiceReservationsPageState();
}

class _ServiceReservationsPageState extends State<ServiceReservationsPage> {
  Widget serviceReservationsWidget = Container();
  List<DateTime> eventsDates = []; //تواريح الحجز
  List<DateTime> highLighteDates = []; // تواريخ مميزة
  List<DateTime> disabledDates = []; //تواريخ معطلة

  int cancelPressCounter = 0; // عداد لإلغاء الحجز
  bool cancelReasonVisibility = false; // عرض سبب الإلغاء
  late String cancelReason; // نص يوضح سبب الالغاء

  ScreenUtil screenUtil = ScreenUtil();
  bool buttonVisibility = false;
  DateTime selectedDate = DateTime.now(); // التاريخ المحدد التلقائي في التقويم
  late CustomerModel? customerModel;
  bool requestPending = false;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin(); // للإشعارات المحلية

  @override
  void initState() {
    super.initState();
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
// تهيئة إعدادات الإشعارات
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context); // تهيئة أحجام الشاشة

    log('${widget.servicesModel}');
    return ScreenStyle(
        onTapRightSideIcon: () {},
        child: SingleChildScrollView(
          child: Column(
            children: [
              SingleChildScrollView(
                child: BlocProvider(
                  create: (context) => sl<ServicesReservationsBloc>(),
                  child: BlocConsumer<ServicesReservationsBloc,
                      ServicesReservationsState>(
                    listener: (_context, state) {
                      if (state is ServicesReservationsError) {
                        MyFlashBar(
                                title: 'خطأ',
                                context: context,
                                icon: Icons.error,
                                iconColor: Colors.white,
                                backgroundColor: Colors.red,
                                message: state.errorMessage,
                                thenDo: () {
                                  // Navigator.pop(_context);
                                })
                            .showFlashBar();
                        setState(() {
                          requestPending = false;
                        });
                      }

                      if (state is AddServiceReservationsLoaded) {
                        MyFlashBar(
                            title: 'تم',
                            context: context,
                            icon: Icons.check,
                            iconColor: Colors.white,
                            backgroundColor: Colors.green,
                            message: state.message,
                            thenDo: () {
                              Navigator.pop(_context);
                            }).showFlashBar();

                        setState(() {
                          requestPending = false;
                        });
                      }
                    },
                    builder: (_context, state) {
                      if (state is ServicesReservationsInitial) {
                        // طلب بيانات الحجوزات عند التهيئة
                        BlocProvider.of<ServicesReservationsBloc>(_context).add(
                            GetServiceReservations(
                                service_id:
                                    widget.servicesModel.id.toString()));
                      } else if (state is GetServicesReservationsLoading) {
                        // عرض مؤشر تحميل
                        serviceReservationsWidget =
                            ServiceReservationDatesShimmer();
                      } else if (state is GetServicesReservationsLoaded) {
                        // عرض التقويم عند تحميل البيانات
                        getEventsDates(state.servicesReservationsModel);

                        serviceReservationsWidget = SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenUtil.orientation ==
                                        Orientation.portrait
                                    ? screenUtil.screenHeight / 1.3
                                    : screenUtil.screenWidth / 2.8,
                                child: CbMonthBuilder(
                                  cbConfig: CbConfig(
                                      startDate: DateTime.now(),
                                      endDate:
                                          DateTime(DateTime.now().year + 4),
                                      selectedDate: selectedDate,
                                      selectedYear:
                                          DateTime(DateTime.now().year),
                                      weekStartsFrom: WeekStartsFrom.wednesday,

                                      ///start events dates
                                      disabledDates: disabledDates,
                                      eventDates: eventsDates,
                                      highlightedDates: getHighLightDates(
                                          state.servicesReservationsModel)),

                                  ///end events dates

                                  monthCustomizer: MonthCustomizer(
                                    padding: const EdgeInsets.all(20),
                                    monthHeaderCustomizer:
                                        MonthHeaderCustomizer(
                                      textStyle: const TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    scrollToSelectedMonth: true,
                                    monthButtonCustomizer:
                                        MonthButtonCustomizer(
                                            currentDayColor:
                                                Colors.green.shade600,
                                            borderStrokeWidth: 2,
                                            textStyleOnDisabled:
                                                const TextStyle(
                                                    color: Colors.red),
                                            highlightedColor:
                                                AppTheme.primaryColor),
                                    monthWeekCustomizer: MonthWeekCustomizer(
                                      textStyle: const TextStyle(
                                        color: AppTheme.primaryColor,
                                      ),
                                    ),
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
                                    if (onDateClicked.hasEvent ||
                                        onDateClicked.isDisabled) {
                                      if (!onDateClicked.selectedDate
                                          .isBefore(DateTime.now())) {
                                        setState(() {
                                          buttonVisibility = false;
                                          selectedDate =
                                              onDateClicked.selectedDate;
                                        });
                                      }
                                    } else {
                                      setState(() {
                                        buttonVisibility = true;
                                        selectedDate =
                                            onDateClicked.selectedDate;
                                      });
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
                                  title: 'تأكيد الحجز',
                                  pending: requestPending,
                                  onPressed: () {
                                    if (customerModel != null) {
                                      BlocProvider.of<ServicesReservationsBloc>(
                                              _context)
                                          .add(
                                        AddServiceReservation(
                                            service_id: widget.servicesModel.id
                                                .toString(),
                                            api_token: customerModel!.token,
                                            reserveDate:
                                                selectedDate.toString(),
                                            service_reservation_price: widget
                                                .servicesModel.price
                                                .toString()),
                                      );
                                      setState(() {
                                        requestPending = true;
                                      });
                                      // إرسال الإشعار
                                      _sendNotification();
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MustLoginScreen()));
                                    }
                                  },
                                  marginTop: .01,
                                ),
                              ),
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
        ));
  }

// دالة لارسال اشعار محلي للمستخدم عندما يقوم بعملية الحجز
  void _sendNotification() async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      'channel_description',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0, 'طلب حجز!', 'تم ارسال طلب حجز الى مزود!', platformChannelSpecifics);
  }

  List<DateTime> getEventsDates(List<ServicesReservationsModel> data) {
    eventsDates.clear();
    disabledDates.clear();

    for (var element in data) {
      if (element.status == 'تمت الموافقه') {
        if (element.customer_id.toString() == customerModel!.id.toString()) {
          eventsDates.add(DateTime.parse(element.reserveDate));
        } else {
          disabledDates.add(DateTime.parse(element.reserveDate));
        }
      }
    }

    return eventsDates;
  }

  List<DateTime> getHighLightDates(List<ServicesReservationsModel> data) {
    highLighteDates.clear();

    for (var element in data) {
      if (element.status == 'تمت الموافقه' &&
          element.customer_id.toString() == customerModel!.id.toString()) {
        highLighteDates.add(DateTime.parse(element.reserveDate));
      }
    }

    return highLighteDates;
  }

  List<DateTime> getDisabledDates(dynamic data) {
    List<DateTime> disabledDates = []; // تعريف القائمة داخل الدالة

    List<dynamic> event = jsonDecode(data);
    if (event != null) {
      for (var element in event) {
        if (element['status'].toString() == 'تمت الموافقه' &&
            element['customer_id'].toString() != customerModel!.id.toString()) {
          disabledDates.add(DateTime.parse(element['reserveDate']));
        }
      }
    }

    return disabledDates;
  }
}
