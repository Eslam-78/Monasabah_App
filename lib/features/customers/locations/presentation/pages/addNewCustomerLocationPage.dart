import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsEvent.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsState.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

class AddNewCustomerLocationPage extends StatefulWidget {
  @override
  _AddNewCustomerLocationPageState createState() =>
      _AddNewCustomerLocationPageState();
}

class _AddNewCustomerLocationPageState
    extends State<AddNewCustomerLocationPage> {
  Completer<GoogleMapController> _controller = Completer();
  double lat=15.3694, long=44.1910; //15.3694
  // var myMarkers = HashSet<Marker>();
  List<Marker> markers = [];
  ScreenUtil screenUtil = ScreenUtil();
  bool requestPending = false;
  LatLng selectedLocation = LatLng(15.3694, 44.1910);
  String markerId = '1';
  final _locationFormKey = GlobalKey<FormState>();
  late String locationName, description;
  late LocationData currentLocation;
  // late LatLng ?selectedLocation;
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
    _getUserLocation();
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
                    mapType: MapType.normal,
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
                    onCameraMove: (cameraPosition) {
                      setState(() {
                        selectedLocation = cameraPosition.target;
                        print('on camera move $selectedLocation');
                      });
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
                      child: BlocProvider(
                        create: (context) => sl<CustomerLocationsBloc>(),
                        child: BlocConsumer<CustomerLocationsBloc,
                            CustomerLocationsState>(
                          listener: (_context, state) {
                            if (state is CustomerLocationsAdded) {
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
                                    Navigator.pop(context);
                                  }).showFlashBar();
                            } else if (state is AddNewCustomerLocationsError) {
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
                            return SingleChildScrollView(
                              child: Form(
                                key: _locationFormKey,
                                child: Column(
                                  children: [
                                    TextFormFieldContainer(
                                      hint: "اسم الموقع",
                                      textInputType: TextInputType.text,
                                      autofocus: true,
                                      onChange: (newValue) {
                                        locationName = newValue.trim();
                                      },
                                      validator: (validatorValue) {
                                        if (validatorValue!.isEmpty) {
                                          return 'يرجى كتابه اسم الموقع';
                                        }
                                        return null;
                                      },
                                      maxLength: 50,
                                    ),
                                    TextFormFieldContainer(
                                      hint: "وصف الموقع",
                                      textInputType: TextInputType.text,
                                      onChange: (newValue) {
                                        description = newValue.trim();
                                      },
                                      validator: (validatorValue) {
                                        if (validatorValue!.isEmpty) {
                                          return 'يرجى كتابه وصف الموقع';
                                        }
                                        return null;
                                      },
                                    ),
                                    PrimaryButton(
                                      pending: requestPending,
                                      title: "إضافه",
                                      onPressed: () {
                                        if (_locationFormKey.currentState!
                                            .validate()) {
                                          BlocProvider.of<
                                                      CustomerLocationsBloc>(
                                                  _context)
                                              .add(AddNewCustomerLocation(
                                                  api_token: customerModel!.token,
                                                  locationName: locationName,
                                                  description: description,
                                                  lat: lat.toString(),
                                                  long: long.toString()
                                          )
                                          );
                                          setState(() {
                                            requestPending =true;
                                          });
                                        }
                                      },
                                      marginTop: .01,
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
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
      selectedLocation = tappedPoint;
      markers = [];
      markers.add(
        Marker(
            markerId: MarkerId(selectedLocation.toString()),
            position: tappedPoint,
            draggable: true,
            onDragEnd: (dragEndPosition) {
              setState(() {
                selectedLocation = dragEndPosition;
                print(selectedLocation);
              });
            }),
      );
    });
  }

  void _getUserLocation() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    location.getLocation().then((value) {
      setState(() {
        currentLocation = value;
        LatLng temp = LatLng(
          currentLocation.latitude as double,
          currentLocation.longitude as double,
        );
        selectedLocation = temp;

        animateTo(currentLocation.latitude as double, currentLocation.longitude as double);
      });
    });
  }

  Future<void> animateTo(double lat, double lng) async {
    final c = await _controller.future;
    final p = CameraPosition(target: LatLng(lat, lng), zoom: 18.0);
    c.animateCamera(CameraUpdate.newCameraPosition(p));
  }

}
