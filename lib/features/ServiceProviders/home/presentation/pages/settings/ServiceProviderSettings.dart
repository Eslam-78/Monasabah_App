import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/dataProviders/local_data_provider.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/settings/editServiceDetailsPage.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/widget/ServiceProviderSettingsItemsWidget.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesState.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/injection_container.dart';

class ServiceProviderSettings extends StatefulWidget {
  @override
  State<ServiceProviderSettings> createState() =>
      _ServiceProviderSettingsState();
}

class _ServiceProviderSettingsState extends State<ServiceProviderSettings> {
  bool scaleVisible = true;
  ServicesModel? servicesModel;
  final _editFormKey = GlobalKey<FormState>();
  TextInputType textInput = TextInputType.text;

  bool textFormFieldVisible = true, requestPending = false;

  ///map items
  var marker = HashSet<Marker>();
  Completer<GoogleMapController> _controller = Completer();

  ScreenUtil screenUtil = ScreenUtil();
  bool sectionsLoading = false;
  ServiceProviderModel ?serviceProviderModel;

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

    servicesModel!.sectionName == 'صالات'
        ? scaleVisible = true
        : scaleVisible = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(jsonEncode(servicesModel));
    screenUtil.init(context);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        textDirection: TextDirection.rtl,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Label(labelText: "الإعدادات"),
          SizedBox(
            height: 10,
          ),
          Expanded(
            flex: 10,
            child: SingleChildScrollView(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: BlocProvider(
                    create: (context) => sl<ServicesBloc>(),
                    child: BlocConsumer<ServicesBloc, ServicesState>(
                      listener: (_context, state) {
                        if (state is Loaded) {
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
                                Navigator.pop(_context);
                              }).showFlashBar();
                        } else if (state is Error) {
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
                                Navigator.pop(_context);
                              }).showFlashBar();
                        }
                      },
                      builder: (_context, state) {
                        return Column(
                          children: [
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.settings_accessibility_rounded,
                              title: "أسم الخدمه",
                              subTitle: servicesModel!.name,
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.supervised_user_circle_sharp,
                              title: "نوع الخدمه",
                              subTitle: servicesModel!.sectionName,
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.phone_android,
                              title: "رقم هاتف الخدمه",
                              subTitle: servicesModel!.phoneNumber,
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.price_change_rounded,
                              title: "السعر",
                              subTitle: servicesModel!.price.toString(),
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.discount_rounded,
                              title: "الخصم للخدمه",
                              subTitle: servicesModel!.discount.toString(),
                            ),
                            Visibility(
                              visible: scaleVisible,
                              child: ServiceProviderSettingsItemsWidget(
                                trailingIcon: Icons.home,
                                title: "السعه",
                                subTitle: servicesModel!.scale.toString(),
                              ),
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.location_city_rounded,
                              title: "المحافظه",
                              subTitle: servicesModel!.city,
                            ),
                            ServiceProviderSettingsItemsWidget(
                              trailingIcon: Icons.add_business_rounded,
                              title: "العنوان",
                              subTitle: servicesModel!.address,
                            ),
                            ServiceProviderSettingsItemsWidget(
                                trailingIcon: Icons.description,
                                title: "الوصف",
                                subTitle:servicesModel!.description
                            ),
                            ServiceProviderSettingsItemsWidget(
                                trailingIcon: Icons.location_on_rounded,
                                title: "الموقع",
                                subTitle:"الموضح اسفل.."
                            ),
                            ///service map
                            Container(
                              height: 240,
                              width: 320,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(
                                        double.parse(servicesModel!.lat),
                                        double.parse(servicesModel!.long)),
                                    zoom: 28.4746,
                                  ),
                                  mapType: MapType.normal,
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                    setState(() {
                                      marker.add(
                                        Marker(
                                            markerId: MarkerId('1'),
                                            position: LatLng(
                                                double.parse(
                                                    servicesModel!.lat),
                                                double.parse(
                                                    servicesModel!.long)),
                                            infoWindow: InfoWindow(
                                                title: servicesModel!.address
                                                    .toString(),
                                                snippet: servicesModel!
                                                    .description
                                                    .toString())),
                                      );
                                    });
                                    _controller.complete(controller);
                                  },
                                  markers: marker,
                                ),
                              ),
                            ),

                            SizedBox(height: 10,),
                            PrimaryButton(
                                title: 'تعديل بينات الخدمه',
                                onPressed: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context){
                                    return EditServiceDetailsPage();
                                  }));
                                },
                                marginTop: .01,
                            ),


                          ],
                        );
                      },
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
