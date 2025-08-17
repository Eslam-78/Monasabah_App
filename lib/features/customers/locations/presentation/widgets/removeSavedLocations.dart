import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsEvent.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsState.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

import '../pages/savedLocationPage.dart';

class RemoveSavedLocations extends StatefulWidget {

  String id;

  RemoveSavedLocations({required this.id});

  @override
  State<RemoveSavedLocations> createState() => _RemoveSavedLocationsState();
}

class _RemoveSavedLocationsState extends State<RemoveSavedLocations> {
  bool requestPending=false;
  ScreenUtil screenUtil=ScreenUtil();

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
    return BlocProvider(
      create: (context) => sl<CustomerLocationsBloc>(),
      child:
      BlocConsumer<CustomerLocationsBloc, CustomerLocationsState>(
        listener: (_context, state) {
          if (state is RemoveCustomerLocationDone) {
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return SavedLocationPage();
                  }));
                }).showFlashBar();
          } else if (state is RemoveCustomerLocationError) {
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
                  Navigator.pop(context);
                }).showFlashBar();
          }
        },
        builder: (_context, state) {
          return Container(
            padding: EdgeInsets.all(20),
            height: screenUtil.screenHeight / 5,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              children: [
                SubTitleText(
                    text: 'هل انت متأكد من حذف الموقع',
                    textColor: AppTheme.primaryColor,
                    fontSize: 15),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: PrimaryButton(
                          pending: requestPending,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          title: 'حذف',
                          onPressed: () {
                            setState(() {
                              requestPending = true;
                            });

                            BlocProvider.of<CustomerLocationsBloc>(
                                _context)
                                .add(RemoveCustomerLocation(
                                token: customerModel!.token, id: widget.id));
                          },
                          marginTop: .001),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                      flex: 1,
                      child: PrimaryButton(
                          title: 'إالفاء',
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          marginTop: .001),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
