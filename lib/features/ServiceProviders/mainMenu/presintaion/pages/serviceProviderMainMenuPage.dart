import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ServiceProviderScreen.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/ServiceProviderMainHome.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/widget/shimmer/serviceProviderServicesShimmer.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesState.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationBloc.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationEvent.dart';
import 'package:monasbah/features/users/presentation/manager/registration/registrationState.dart';
import 'package:monasbah/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widget/serviceProviderServicesWidget.dart';
import 'AddNewService.dart';

class ServiceProviderMainMenuPage extends StatefulWidget {
  @override
  State<ServiceProviderMainMenuPage> createState() =>
      _ServiceProviderMainMenuPageState();
}

class _ServiceProviderMainMenuPageState
    extends State<ServiceProviderMainMenuPage> {
  late BuildContext serviceContext;
  Widget servicesWidget = Container();
  ScreenUtil screenUtil = ScreenUtil();
  ServiceProviderModel? serviceProviderModel;
  bool requestPending = false;
  late String image;
  @override
  void initState() {
    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
    super.initState();
  }

  void _showFlashBar(BuildContext context, String title, String message,
      IconData icon, Color iconColor, Color backgroundColor) {
    if (ModalRoute.of(context)?.isCurrent == true) {
      MyFlashBar(
        title: title,
        context: context,
        icon: icon,
        iconColor: iconColor,
        backgroundColor: backgroundColor,
        message: message,
        thenDo: () {
          print(message);
        },
      ).showFlashBar();
    }
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);

    return ServiceProviderScreen(
      withEditImageIcon: true,
      title: serviceProviderModel!.managerName,
      subTitle: serviceProviderModel!.phoneNumber,
      image: serviceProviderModel!.image,
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          children: [
            BlocProvider(
              create: (context) => sl<ServicesBloc>(),
              child: BlocConsumer<ServicesBloc, ServicesState>(
                listener: (_context, state) {
                  if (state is GetServicesError) {
                    _showFlashBar(
                      context,
                      'خطأ',
                      state.errorMessage,
                      Icons.error,
                      Colors.white,
                      Colors.red,
                    );
                  }
                },
                builder: (_context, state) {
                  serviceContext = _context;
                  if (state is GetServicesInitial) {
                    BlocProvider.of<ServicesBloc>(_context).add(
                      GetServiceProviderServices(
                          token: serviceProviderModel!.token),
                    );
                  } else if (state is GetServicesLoading) {
                    servicesWidget = ServiceProviderServicesShimmer();
                  } else if (state is GetServicesLoaded) {
                    if (state.servicesModel != null) {
                      print('data in main menu is not null');
                      if (state.servicesModel.isNotEmpty) {
                        servicesWidget = SizedBox(
                          height: screenUtil.orientation == Orientation.portrait
                              ? screenUtil.screenHeight * .7
                              : screenUtil.screenWidth * .35,
                          child: ListView.builder(
                            itemCount: state.servicesModel.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return ServiceProviderServicesWidget(
                                serviceName: state.servicesModel[index].name,
                                serviceAddress:
                                    state.servicesModel[index].address,
                                statusIcon:
                                    state.servicesModel[index].abroval == 0
                                        ? 'redCircle'
                                        : 'greenCircle',
                                onTap: () {
                                  if (state.servicesModel[index].abroval == 0) {
                                    commonDialog(
                                        context,
                                        'assets/icons/wonder.svg',
                                        'عذراً لم يتم الموافقة على هذه الخدمة من مدير النظام');
                                  } else {
                                    BlocProvider.of<ServicesBloc>(_context).add(
                                      CacheService(
                                          servicesModel:
                                              state.servicesModel[index]),
                                    );
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ServiceProviderMainHomeRoute(
                                          currentIndex: 1);
                                    }));
                                  }
                                },
                                onTapRemoveIcon: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15.0)),
                                          side: BorderSide(
                                              color:
                                                  Colors.green.withOpacity(0.5),
                                              width: 2),
                                        ),
                                        title: Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Text(
                                            'تأكيد الحذف',
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        content: Text(
                                          'هل أنت متأكد من رغبتك في حذف هذه الخدمة؟',
                                          style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color:
                                                    Colors.red.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'لا',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              print("ضغط على نعم للحذف");
                                              if (index >= 0 &&
                                                  index <
                                                      state.servicesModel
                                                          .length) {
                                                BlocProvider.of<ServicesBloc>(
                                                        serviceContext)
                                                    .add(
                                                  RemoveService(
                                                      id: state
                                                          .servicesModel[index]
                                                          .id
                                                          .toString(),
                                                      token:
                                                          serviceProviderModel!
                                                              .token),
                                                );
                                                print(
                                                    "تم إرسال حدث الحذف"); // إضافة طباعة للتأكيد

                                                setState(() {
                                                  state.servicesModel
                                                      .removeAt(index);
                                                });
                                                Navigator.of(context).pop();
                                                _showFlashBar(
                                                  context,
                                                  'تم',
                                                  'تم حذف الخدمة بنجااح!!!',
                                                  Icons.check,
                                                  Colors.white,
                                                  Colors.green.shade600,
                                                );
                                              } else {
                                                print(
                                                    "فشل الحذف: الفهرس خارج النطاق");
                                              }
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10, horizontal: 20),
                                              decoration: BoxDecoration(
                                                color: Colors.green
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: Text(
                                                'نعم',
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                onTapEditIcon: () {
/* RemoveService(serviceId: state.servicesModel[index].id),*/
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        servicesWidget = ErrorScreen(
                          imageName: 'noItems.png',
                          message:
                              'لا تملك خدمات الى الآن قم بإضافة خدمة جديدة',
                          height: 400,
                          width: 400,
                          withButton: false,
                        );
                      }
                    }
                  }
                  return servicesWidget;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  Row(
                    textDirection: TextDirection.rtl,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          title: 'إضافة خدمة',
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddNewServicePage();
                            }));
                          },
                          marginTop: .01,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: PrimaryButton(
                          title: 'التحديث',
                          onPressed: () {
                            BlocProvider.of<ServicesBloc>(serviceContext).add(
                              GetServiceProviderServices(
                                  token: serviceProviderModel!.token),
                            );
                          },
                          marginTop: .01,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: BlocProvider(
                          create: (context) => sl<RegistrationBloc>(),
                          child:
                              BlocConsumer<RegistrationBloc, RegistrationState>(
                            listener: (_context, state) {
                              if (state is RegisterLoaded) {
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
                                    LocalDataProvider(
                                            sharedPreferences:
                                                sl<SharedPreferences>())
                                        .clearCache(
                                            key: 'SERVICE_PROVIDER_USER');
                                    Navigator.pushReplacement(context,
                                        MaterialPageRoute(builder: (context) {
                                      return CustomerMainHomeRoute(
                                          currentIndex: 4);
                                    }));
                                  },
                                ).showFlashBar();
                              } else if (state is RegisterError) {
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
                                  },
                                ).showFlashBar();
                              }
                            },
                            builder: (_context, state) {
                              return PrimaryButton(
                                title: 'تسجيل الخروج',
                                pending: requestPending,
                                onPressed: () {
                                  setState(() {
                                    requestPending = true;
                                  });
                                  BlocProvider.of<RegistrationBloc>(_context)
                                      .add(LogoutEvent(
                                          token: serviceProviderModel!.token));
                                },
                                marginTop: .01,
                                backgroundColor: Colors.red,
                              );
                            },
                          ),
                        ),
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
}
