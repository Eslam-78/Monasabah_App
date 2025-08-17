import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/serviceSddressModel.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsEvent.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsState.dart';
import 'package:monasbah/features/customers/locations/presentation/pages/savedLocationPage.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

class AddNewServiceAddressPage extends StatefulWidget {
  @override
  _AddNewServiceAddressPageState createState() =>
      _AddNewServiceAddressPageState();
}

class _AddNewServiceAddressPageState
    extends State<AddNewServiceAddressPage> {
  Completer<GoogleMapController> _controller = Completer();
  double lat=15.3694, long=44.1910; //15.3694
  // var myMarkers = HashSet<Marker>();
  List<Marker> markers = [];
  ScreenUtil screenUtil = ScreenUtil();
  bool requestPending = false;
  LatLng latLng = LatLng(15.3694, 44.1910);
  String markerId = '1';
  final _locationFormKey = GlobalKey<FormState>();
  String address='', description='';

  static final CameraPosition sanaa = CameraPosition(
    target: LatLng(15.3694, 44.1910),
    zoom: 18.4746,
  );
  late CustomerModel? customerModel;
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
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              height: screenUtil.orientation == Orientation.portrait
                  ? screenUtil.screenHeight / 6
                  : screenUtil.screenWidth / 6,
              width: double.infinity,
              color: AppTheme.primaryColor,
              child: Center(
                child: SubTitleText(
                  text: "إضافه عنوان",
                  textColor: Colors.white,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: screenUtil.orientation == Orientation.portrait
                      ? screenUtil.screenHeight / 7
                      : screenUtil.screenWidth / 7),
              padding: EdgeInsets.only(),
              width: double.infinity,
              height: screenUtil.screenHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  /// start google map
                  GoogleMap(

                    initialCameraPosition: sanaa,
                    mapType: MapType.hybrid,

                    onTap: (tappedPoint) {
                      _handleTap(tappedPoint);
                      setState(() {

                        lat = tappedPoint.latitude;
                        long = tappedPoint.longitude;
                      });
                      print('latlan is ${tappedPoint}');
                      print('lat is ${lat}');
                      print('long is ${long}');
                    },
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                    },
                    markers: Set.from(markers),
                  ),

                  Container(
                      padding: EdgeInsets.only(
                          top: 10,
                          right: screenUtil.screenWidth / 10,
                          left: screenUtil.screenWidth / 10),
                      width: screenUtil.screenWidth,
                      height: screenUtil.orientation == Orientation.portrait
                          ? screenUtil.screenHeight / 3
                          : screenUtil.screenWidth / 3,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
                          ),
                          color: Colors.white),
                      child: Form(
                        key: _locationFormKey,
                        child: Column(
                          children: [
                            TextFormFieldContainer(
                              hint: "اسم الموقع",
                              textInputType: TextInputType.text,
                              autofocus: true,
                              onChange: (newValue) {
                                address = newValue.trim();
                              },
                              validator: (validatorValue) {
                                if (validatorValue!.isEmpty) {
                                  return 'يرجى كتابة اسم الموقع';
                                }
                                if (!RegExp(r'^[a-zA-Z\u0621-\u064A]{3}[a-zA-Z0-9\u0621-\u064A\s]{0,17}$').hasMatch(validatorValue)) {
                                  return 'يجب أن يبدأ الاسم على الأقل بثلاثة أحر،';
                                }
                                return null;
                              },


                              maxLength: 20,
                            ),
                            TextFormFieldContainer(
                              hint: "وصف الموقع",
                              textInputType: TextInputType.text,
                              onChange: (newValue) {
                                description = newValue.trim();
                              },
                              validator: (validatorValue) {
                                if (validatorValue!.isEmpty) {
                                  return 'يرجى كتابة اسم الموقع';
                                }
                                if (!RegExp(r'^[a-zA-Z\u0621-\u064A]{3}[a-zA-Z0-9\u0621-\u064A\s]{0,17}$').hasMatch(validatorValue)) {
                                  return 'يجب أن يبدأ الوصف على الأقل بثلاثة أحرف، ';
                                }
                                return null;
                              },
                              maxLength: 20,
                            ),


                            PrimaryButton(
                              pending: requestPending,
                              title: "إضافه",
                              onPressed: () {
                                if (_locationFormKey.currentState!
                                    .validate()) {

                                  Navigator.of(context).pop(ServiceAddressModel(address: address, description: description, long: long, lat: lat));
                                }
                              },
                              marginTop: .01,
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleTap(LatLng tappedPoint) {
    setState(() {
      latLng = tappedPoint;
      markers = [];
      markers.add(
        Marker(
            markerId: MarkerId(latLng.toString()),
            position: tappedPoint,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              setState(() {
                latLng = dragEndPosition;
                print(latLng);
              });
            }),
      );
    });
  }
}
