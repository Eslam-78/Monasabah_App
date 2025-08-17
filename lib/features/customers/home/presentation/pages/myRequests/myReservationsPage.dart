import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/serviceReservations/servicesReservationsState.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

class MyReservationsPage extends StatefulWidget {

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {

  Widget servicesReservationsWidget=Container();
  ScreenUtil screenUtil=ScreenUtil();
  @override

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
  Widget build(BuildContext context) {
    screenUtil.init(context);
    return Scaffold(
      body: SizedBox(
        height: 500,
        child: Column(
          children: [

            BlocProvider(
              create: (context)=>sl<ServicesReservationsBloc>(),
              child: BlocConsumer<ServicesReservationsBloc,ServicesReservationsState>(
                listener: (_context,state){
                  if(state is ServicesReservationsError){
                    MyFlashBar(title:'خطأ', context: context,icon: Icons.error,iconColor: Colors.white,
                        backgroundColor: Colors.red,message: state.errorMessage,thenDo: (){
                          print(state.errorMessage);
                        }).showFlashBar();
                  }
                },
                builder: (_context,state){
                  if(state is ServicesReservationsInitial){
                    BlocProvider.of<ServicesReservationsBloc>(_context).add(GetServiceReservationsOfCustomer(token: customerModel!.token));
                  }else if(state is GetServicesReservationsLoading){
                    servicesReservationsWidget=Text('loading');
                  }else if(state is GetServicesReservationsLoaded){
                    if(state.servicesReservationsModel!=null){
                      if(state.servicesReservationsModel.isNotEmpty){
                        servicesReservationsWidget=SizedBox(
                          height:screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight/2:screenUtil.screenWidth/1.5,
                          child: ListView.builder(

                              itemCount: state.servicesReservationsModel.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  height: screenUtil.orientation==Orientation.portrait?screenUtil.screenHeight*.1:screenUtil.screenWidth*.1,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)
                                  ),
                                  child: Column(
                                    children: [
                                      SubTitleText(text: 'تم حجز ${state.servicesReservationsModel[index].serviceName}',textColor: AppTheme.primaryColor,fontSize: 20,),

                                      SizedBox(height: 20,),
                                      Row(
                                        textDirection: TextDirection.rtl,
                                        children: [
                                          Expanded(flex: 1,child: SubTitleText(text: 'لتاريخ : ${state.servicesReservationsModel[index].reserveDate}', textColor: Colors.black54, fontSize: 15)),
                                          Expanded(
                                              child:Row(
                                                children: [
                                                  SubTitleText(text: 'الحاله ', textColor: Colors.black54, fontSize: 15),
                                                  SubTitleText(text: '${state.servicesReservationsModel[index].status}', textColor: Colors.black54, fontSize: 15),
                                                ],
                                              )
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                      }else{
                        servicesReservationsWidget = Center(
                          child: ErrorScreen(height: screenUtil.orientation==Orientation.portrait?400:200,width: screenUtil.orientation==Orientation.portrait?400:200,imageName: 'empty.png',message: 'لا يوجد لديك أي حجزوات بعد'),
                        );
                      }
                    }
                  }
                  return servicesReservationsWidget;

                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
