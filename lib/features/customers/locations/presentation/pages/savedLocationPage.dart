import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/Login_Signup_Screen.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsEvent.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsState.dart';
import 'package:monasbah/features/customers/locations/presentation/pages/addNewCustomerLocationPage.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/SavedLocationWidget.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/removeSavedLocations.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/shimmer/savedLocationShimmer.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';
import 'package:monasbah/mapPage.dart';

class SavedLocationPage extends StatefulWidget {
  @override
  State<SavedLocationPage> createState() => _SavedLocationPageState();
}

class _SavedLocationPageState extends State<SavedLocationPage> {
  Widget locationsWidget = Container();
  bool requestPending = false;
  ScreenUtil screenUtil = ScreenUtil();
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
        backgroundColor: AppTheme.primaryColor,
        body: LoginAndSignupScreen(
          title: 'المواقع السابقه',
          child: BlocProvider(
            create: (context) => sl<CustomerLocationsBloc>(),
            child: BlocConsumer<CustomerLocationsBloc, CustomerLocationsState>(
              listener: (_context, state) {
                if (state is GetCustomerLocationsError) {
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
                if (state is GetCustomerLocationsInitial) {
                  //TODO::here change the token with real token

                  BlocProvider.of<CustomerLocationsBloc>(_context).add(
                    GetCustomerLocations(api_token: customerModel!.token),
                  );
                } else if (state is GetCustomerLocationsLoading) {
                  locationsWidget = SavedLocationShimmer();
                } else if (state is GetCustomerLocationsLoaded) {
                  if (state.customerLocationsModel != null) {
                    print('data in main menu is not null');
                    if (state.customerLocationsModel.isNotEmpty) {
                      locationsWidget = SizedBox(
                        height: screenUtil.orientation == Orientation.portrait
                            ? screenUtil.screenHeight
                            : screenUtil.screenWidth,
                        child: ListView.builder(
                          itemCount: state.customerLocationsModel.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, index) {
                            return SavedLocationWidget(
                                withRemoveIcon: true,
                                locationName: state
                                    .customerLocationsModel[index].locationName,
                                locationDescription: state
                                    .customerLocationsModel[index].description,
                                onTap: () {
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return MapPage(
                                      lat: state
                                          .customerLocationsModel[index].lat
                                          .toString(),
                                      long: state
                                          .customerLocationsModel[index].long
                                          .toString(),
                                      locationName: state
                                          .customerLocationsModel[index]
                                          .locationName,
                                      locationDescription: state
                                          .customerLocationsModel[index]
                                          .description,
                                    );
                                  }));
                                },

                                ///
                                onPressedRemoveIcon: () {
                                  showSearchDialog(
                                      context,
                                      state.customerLocationsModel[index].id
                                          .toString());
                                });
                          },
                        ),
                      );
                    } else {
                      locationsWidget = Center(
                        child: ErrorScreen(
                          imageName: 'noLocation2.png',
                          message: 'لا يوجد مواقع سابقه لديك اضف موقع جديد ',
                          height: 400,
                          width: 400,
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddNewCustomerLocationPage();
                            }));
                          },
                          buttonTitle: 'إضافه موقع',
                        ),
                      );
                    }
                  }
                }
                return locationsWidget;
              },
            ),
          ),
        ),
      ),
    );
  }

  void showSearchDialog(BuildContext context, String id) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (BuildContext context1) {
          return Dialog(
              elevation: 20,
              insetAnimationDuration: Duration(seconds: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: RemoveSavedLocations(
                id: id,
              ));
        });
  }
}
