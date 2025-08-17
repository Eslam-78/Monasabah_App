import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';

import '../../../../../../core/app_theme.dart';
import '../../../../../../core/others/MyFlashBar.dart';
import '../../../../../../core/widgets/Texts/SubTitleText.dart';
import '../../../../../../core/widgets/errorScreen.dart';
import '../../../../../../injection_container.dart';
import '../../../../services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import '../../../../services/presentation/manager/serviceReservations/servicesReservationsState.dart';
import '../../../../services/presentation/widgets/myReservationsWidget.dart';
import '../../../../services/presentation/widgets/shimmer/myReservationsShimmer.dart';
import '../customerMainHomeRoute.dart';

class MyRequestsPage extends StatefulWidget {
  @override
  State<MyRequestsPage> createState() => _MyRequestsPageState();
}

class _MyRequestsPageState extends State<MyRequestsPage> {
  ScreenUtil screenUtil = ScreenUtil();
  Widget myReservationsWidget = Container();
  CustomerModel? customerModel;
  bool inErrorState = false;
  String errorMessage = '';

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

    return SafeArea(
      child: !inErrorState
          ? Column(
              children: [
                Expanded(
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize:
                          Size.fromHeight(50.0), // تعيين الارتفاع الثابت
                      child: AppBar(
                        backgroundColor: AppTheme.primaryColor,
                        automaticallyImplyLeading: false,
                        title: Center(
                          child: SubTitleText(
                            text: 'حجوزاتي',
                            textColor: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    backgroundColor: Colors.white,
                    body: Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/background.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
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
                                  print(state.errorMessage);
                                },
                              ).showFlashBar();
                              setState(() {
                                inErrorState = true;
                                errorMessage = state.errorMessage;
                              });
                            }
                          },
                          builder: (_context, state) {
                            if (state is ServicesReservationsInitial) {
                              BlocProvider.of<ServicesReservationsBloc>(
                                      _context)
                                  .add(
                                GetServiceReservationsOfCustomer(
                                    token: customerModel?.token ?? ''),
                              );
                            } else if (state
                                is GetServicesReservationsLoading) {
                              myReservationsWidget = MyReservationsShimmer();
                            } else if (state is GetServicesReservationsLoaded) {
                              if (state.servicesReservationsModel != null) {
                                if (state
                                    .servicesReservationsModel.isNotEmpty) {
                                  myReservationsWidget = SizedBox(
                                    height: screenUtil.orientation ==
                                            Orientation.portrait
                                        ? screenUtil.screenHeight
                                        : screenUtil.screenWidth / 1.5,
                                    child: ListView.builder(
                                      itemCount: state
                                          .servicesReservationsModel.length,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        return MyReservationWidget(
                                          serviceName: state
                                              .servicesReservationsModel[index]
                                              .serviceName,
                                          date: state
                                              .servicesReservationsModel[index]
                                              .reserveDate,
                                          status: state
                                              .servicesReservationsModel[index]
                                              .status,
                                          cancelReason: state
                                              .servicesReservationsModel[index]
                                              .cancelReason,
                                          service_reservation_price: state
                                              .servicesReservationsModel[index]
                                              .service_reservation_price
                                              .toString(),
                                        );
                                      },
                                    ),
                                  );
                                } else {
                                  myReservationsWidget = Center(
                                    child: ErrorScreen(
                                      height: screenUtil.orientation ==
                                              Orientation.portrait
                                          ? 400
                                          : 200,
                                      width: screenUtil.orientation ==
                                              Orientation.portrait
                                          ? 400
                                          : 200,
                                      imageName: 'empty.png',
                                      message: 'لا يوجد لديك أي حجزوات بعد',
                                      withButton: false,
                                    ),
                                  );
                                }
                              }
                            }
                            return myReservationsWidget;
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          : ErrorScreen(
              height:
                  screenUtil.orientation == Orientation.portrait ? 400 : 200,
              width: screenUtil.orientation == Orientation.portrait ? 400 : 200,
              imageName: 'noInternet.png',
              message: errorMessage,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CustomerMainHomeRoute(currentIndex: 2),
                  ),
                );
              },
              buttonTitle: 'إعاده المحاوله',
              withButton: true,
            ),
    );
  }
}
