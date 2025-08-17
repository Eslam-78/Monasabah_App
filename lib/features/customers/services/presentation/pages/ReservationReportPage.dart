
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import '../../../../../core/others/MyFlashBar.dart';
import '../../../../../core/util/ScreenUtil.dart';

import '../../../../../core/widgets/errorScreen.dart';
import '../../../../../dataProviders/network/data_source_url.dart';
import '../../../../../injection_container.dart';
import '../../../../users/data/models/customerModel.dart';
import '../manager/ReservationsReport/ReservationsReportBloc.dart';
import '../manager/ReservationsReport/ReservationsReportEvent.dart';
import '../manager/ReservationsReport/ReservationsReportState.dart';

import 'package:monasbah/features/ServiceProviders/home/presentation/pages/serviceReservations/ServiceProviderMyReserves.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';

import 'package:monasbah/features/customers/services/presentation/widgets/shimmer/ReportShimmer.dart';

class ReservationsReportPage extends StatefulWidget {
  final String serviceId;

  ReservationsReportPage({required this.serviceId});

  @override
  State<ReservationsReportPage> createState() => _ReservationsReportPageState();
}

class _ReservationsReportPageState extends State<ReservationsReportPage> {
  ScreenUtil screenUtil = ScreenUtil();
  CustomerModel? customerModel;
  ServiceProviderModel? serviceProviderModel;
  bool inErrorState = false;
  String errorMessage = '';
  ServicesModel? servicesModel;
  Widget serviceReservationsWidget = Container();

  @override
  void initState() {
    super.initState();
    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return SafeArea(
      child: !inErrorState
          ? Scaffold(

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
            create: (context) => sl<ReservationsReportBloc>()
              ..add(GetReservationsReport(
                service_id: widget.serviceId,
              )),
            child: BlocConsumer<ReservationsReportBloc,
                ReservationsReportState>(
              listener: (_context, state) {
                if (state is ReservationsReportError) {
                  MyFlashBar(
                    title: 'خطأ',
                    context: context,
                    icon: Icons.error,
                    iconColor: Colors.white,
                    backgroundColor: Colors.red,
                    message: state.message,
                    thenDo: () {
                      print(state.message);
                    },
                  ).showFlashBar();
                  setState(() {
                    inErrorState = true;
                    errorMessage = state.message;
                  });
                }
              },
              builder: (_context, state) {
                if (state is ReservationsReportInitial) {
                  BlocProvider.of<ReservationsReportBloc>(_context).add(
                      GetReservationsReport(
                          service_id: widget.serviceId.toString()));
                } else if (state is ReservationsReportLoading) {
                  return ListView.builder(
                      itemCount: 10,
                      itemBuilder: (context, index) => ShimmerWidget()); // عرض الشيمر أثناء التحميل
                } else if (state is ReservationsReportLoaded) {
                  if (state.reservationReportModel != null && state.reservationReportModel.isNotEmpty) {
                    // تحقق إذا كانت قائمة الحجوزات غير فارغة
                    serviceReservationsWidget = SingleChildScrollView(
                      child: Column(
                        children: [
                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: state.reservationReportModel.length,
                            itemBuilder: (context, index) {
                              final reservation = state.reservationReportModel[index];

                              return Column(
                                children: [
                                  Card(
                                    elevation: 4.0,
                                    margin: EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30.0, // تكبير حجم الصورة
                                          backgroundImage: reservation.image != null
                                              ? CachedNetworkImageProvider(
                                              DataSourceURL.baseImagesUrl + reservation.image!)
                                              : AssetImage('assets/images/logo.png')
                                          as ImageProvider,
                                          backgroundColor: Colors.transparent,
                                        ),
                                        title: Text(
                                          'Customer Name: ${reservation.userName ?? 'No Name'}',
                                          style: TextStyle(fontStyle: FontStyle.normal),
                                        ),
                                        subtitle: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(height: 5),
                                            Divider(),
                                            Text('Service: ${reservation.serviceName ?? 'No Service Name'}'),
                                            Text('Price: ${reservation.service_reservation_price ?? 'No Price'}'),
                                            Text('Date: ${reservation.reserveDate}'),
                                            Text('Status: ${reservation.status}'),
                                            Text('Phone Number: ${reservation.phoneNumber}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Divider(),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    // عرض رسالة "لم يقوم أحد بحجز خدمتك بعد" إذا كانت قائمة الحجوزات فارغة
                    return Center(
                      child: ErrorScreen(
                        height: screenUtil.orientation == Orientation.portrait ? 400 : 200,
                        width: screenUtil.orientation == Orientation.portrait ? 400 : 200,
                        imageName: 'empty.png',
                        message: 'لم يقوم أحد بحجز خدمتك بعد!!',
                        withButton: false,
                      ),
                    );
                  }
                } else if (state is ReservationsReportError) {
                  print('Error: ${state.message}');
                  return Center(
                    child: ErrorScreen(
                      height: screenUtil.orientation == Orientation.portrait ? 400 : 200,
                      width: screenUtil.orientation == Orientation.portrait ? 400 : 200,
                      imageName: 'noInternet.png',
                      message: errorMessage,
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ServiceProviderMyReserves(),
                          ),
                        );
                      },
                      buttonTitle: 'إعاده المحاوله',
                      withButton: true,
                    ),
                  );
                }
                return serviceReservationsWidget; // Default return in case of other states
              },
            ),
          ),
        ),
      )
          : Center(
        child: ErrorScreen(
          height:
          screenUtil.orientation == Orientation.portrait ? 400 : 200,
          width:
          screenUtil.orientation == Orientation.portrait ? 400 : 200,
          imageName: 'noInternet.png',
          message: errorMessage,
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ServiceProviderMyReserves(),
              ),
            );
          },
          buttonTitle: 'إعاده المحاوله',
          withButton: true,
        ),
      ),
    );
  }
}
