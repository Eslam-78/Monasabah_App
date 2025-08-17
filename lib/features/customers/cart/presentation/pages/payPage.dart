import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/Label.dart';
import 'package:monasbah/core/widgets/Others/ScreenLine.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/errorScreen.dart';
import 'package:monasbah/core/widgets/screens/ScreenStyle.dart';
import 'package:monasbah/features/customers/cart/data/models/customerLocationsModel.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsBloc.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsEvent.dart';
import 'package:monasbah/features/customers/locations/presentation/manager/customerLocationsState.dart';
import 'package:monasbah/features/customers/locations/presentation/pages/addNewCustomerLocationPage.dart';
import 'package:monasbah/features/customers/cart/presentation/widget/PayMethodRadioButton.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/SavedLocationWidget.dart';
import 'package:monasbah/features/customers/locations/presentation/widgets/shimmer/savedLocationShimmer.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/injection_container.dart';

import 'ConfirmPayPage.dart';

class ReservationPage extends StatefulWidget {
  @override
  State<ReservationPage> createState() => _ReservationPageState();
}

class _ReservationPageState extends State<ReservationPage> {
  bool savedLocationVisible = false;
  int radioGroup = 1;
  ScreenUtil screenUtil = ScreenUtil();
  String choseLocation = 'اختيار عنوان',payMethod='عند الإستلام كاش';
  CustomerLocationsModel ?customerLocationsModel;
  Widget locationsWidget = Container();
  bool requestPending = false;
  Color addLocationColor=AppTheme.primarySwatch.shade500,
      addLocationTextColor=Colors.white,deliveryDateColor=Colors.white,deliveryDateTextColor=AppTheme.primaryColor;

  String addressString='',delivery_date='';

  late CustomerModel? customerModel;
  DateTime dateTime=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day,DateTime.now().hour,DateTime.now().minute);
  DateTime ?dateTimeAfterSelect;
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

    return ScreenStyle(
      onTapRightSideIcon: (){

      },
        child: Padding(
      padding: EdgeInsets.only(top: 20.0),
      child: SingleChildScrollView(
        child: Column(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Label(
              labelText: "الحـجـز",
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 30.0, left: 50, right: 50, bottom: 10),
              child: Container(
                padding: EdgeInsets.all(10.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    textDirection: TextDirection.rtl,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubTitleText(
                        text: "إستلام الطلب : ",
                        textColor: AppTheme.primaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      Center(
                        child: PrimaryButton(
                          title: 'إضافه عنوان جديد',
                          onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return AddNewCustomerLocationPage();
                            }));
                          },
                          marginTop: .001,
                        ),
                      ),
                      Center(
                        child: PrimaryButton(
                          backgroundColor: addLocationColor,
                          textColor: addLocationTextColor,
                          title: choseLocation,
                          onPressed: () {
                            setState(() {
                              if (savedLocationVisible) {
                                savedLocationVisible = false;
                                choseLocation = 'اختيار عنوان';
                              } else {
                                savedLocationVisible = true;
                                choseLocation = 'اخفاء العناوين';
                              }
                            });
                          },
                          marginTop: .001,
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      //start saved location

                      Visibility(
                        visible: savedLocationVisible,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.transparent,
                              border: Border.all(
                                color: AppTheme.primaryColor,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),

                          ///saved locations shimmer and list views
                          child: BlocProvider(
                            create: (context) => sl<CustomerLocationsBloc>(),
                            child: BlocConsumer<CustomerLocationsBloc,
                                CustomerLocationsState>(
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
                                  BlocProvider.of<CustomerLocationsBloc>(
                                          _context)
                                      .add(
                                    GetCustomerLocations(api_token: customerModel!.token),
                                  );
                                } else if (state
                                    is GetCustomerLocationsLoading) {
                                  locationsWidget = SavedLocationShimmer();
                                } else if (state
                                    is GetCustomerLocationsLoaded) {
                                  if (state.customerLocationsModel != null) {
                                    print('data in main menu is not null');
                                    if (state
                                        .customerLocationsModel.isNotEmpty) {
                                      locationsWidget = SizedBox(
                                        height: screenUtil.orientation ==
                                                Orientation.portrait
                                            ? screenUtil.screenHeight / 4
                                            : screenUtil.screenWidth / 5,
                                        child: ListView.builder(
                                          itemCount: state
                                              .customerLocationsModel.length,
                                          scrollDirection: Axis.vertical,
                                          itemBuilder: (context, index) {
                                            return SavedLocationWidget(
                                              withRemoveIcon: false,
                                                locationName: state
                                                    .customerLocationsModel[
                                                        index]
                                                    .locationName,
                                                locationDescription: state
                                                    .customerLocationsModel[
                                                        index]
                                                    .description,
                                                onTap: () {
                                                  MyFlashBar(
                                                      title: 'تم',
                                                      context: context,
                                                      icon: Icons.check,
                                                      iconColor: Colors.white,
                                                      backgroundColor: Colors.green,
                                                      message: 'تم أختيار الموقع',
                                                      thenDo: () {
                                                      }).showFlashBar();
                                                setState(() {
                                                  customerLocationsModel=state.customerLocationsModel[index];
                                                  savedLocationVisible=false;
                                                  choseLocation='اختيار عنوان ';
                                                });
                                                }
                                            );
                                          },
                                        ),
                                      );
                                    } else {
                                      locationsWidget = Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(
                                          child: ErrorScreen(height: 150,width: 150,imageName: 'noLocation2.png',message: 'لا يوجد لديك عناوين سايقه قم بالإضافه',onPressed:(){
                                            Navigator.push(context, MaterialPageRoute(builder: (context){
                                              return AddNewCustomerLocationPage();
                                            }));
                                          } ,buttonTitle: 'اضافه موقع'),
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

                      //end saved location

                      SizedBox(
                        height: 20,
                      ),
                      ScreenLine(),

                      SizedBox(height: 20,),
                      SubTitleText(text:customerLocationsModel!=null? '${customerLocationsModel!.locationName} ' ' ${customerLocationsModel!.description}':'', textColor: AppTheme.primaryColor, fontSize: 15),

                      SizedBox(
                        height: 20,
                      ),

                      Container(
                        width: screenUtil.screenWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          color: deliveryDateColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                          onTap: pickDateTime,
                          title: SubTitleText(
                            text:dateTimeAfterSelect==null?'تاريخ التسليم':
                            '${dateTimeAfterSelect!.year} / ${dateTimeAfterSelect!.month} / ${dateTimeAfterSelect!.day} - ${dateTimeAfterSelect!.hour} - ${dateTimeAfterSelect!.minute} ',

                            textColor: deliveryDateTextColor,
                            fontSize: 15,
                            textDirection: TextDirection.ltr,
                          ),
                          trailing: Icon(Icons.date_range_outlined,color: deliveryDateTextColor,),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      SubTitleText(
                        text: " الدفع :",
                        textColor: AppTheme.primaryColor,
                        fontSize: 20,
                        textAlign: TextAlign.right,
                        fontWeight: FontWeight.bold,
                      ),

                      PayMethodRadioButton(
                        onChange: (newvalue) {
                          setState(() {
                            radioGroup = newvalue as int;
                            payMethod='عند الإستلام كاش';

                          });
                        },
                        value: 1,
                        groupValue: radioGroup,
                        payMethod: "عند الإستلام كاش",
                      ),
                      //TODO::remove or customer this method
                      /*PayMethodRadioButton(
                        onChange: (newvalue) {
                          setState(() {
                            radioGroup = newvalue as int;
                            payMethod='حواله عبر الكريمي';
                          });
                        },
                        value: 2,
                        groupValue: radioGroup,
                        payMethod: "أرسال حواله لحساب الكريمي",
                      ),*/
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: PrimaryButton(
                title: "متابعة الحجز",
                onPressed: () {

                  if(customerLocationsModel==null){
                    print('null');
                    checkSelectedLocation();
                  }
                  else if(dateTimeAfterSelect==null){
                    checkSelectedDateTime();
                  }else{
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ConfirmReservationPage(customerLocationsModel: customerLocationsModel,payMethode: payMethod,delivery_date: delivery_date,);
                  }));
                  }

                },
                marginTop: .01,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Future pickDateTime()async {
    DateTime ?date =await pickDate();
    if(date==null)return;
    TimeOfDay ?time=await pickTime();
    if(time==null)return;


    setState(() {


      dateTimeAfterSelect=DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute
      );
      delivery_date=dateTimeAfterSelect.toString();
    });


  }

  Future<DateTime?>pickDate()=>showDatePicker(
      context:context,
    initialDate: dateTime,
    firstDate: dateTime,
    lastDate: DateTime(2100),
    );

  Future<TimeOfDay?>pickTime() =>showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute)
  );

  checkSelectedLocation(){
    setState(() {
      addLocationColor = Colors.red.withOpacity(1);
      addLocationTextColor=Colors.white;
      Future.delayed(Duration(seconds: 1),(){
        setState(() {
          addLocationColor = AppTheme.primarySwatch.shade500;
          addLocationTextColor=Colors.white;
        });
      });
    });
  }

  checkSelectedDateTime(){
    setState(() {
      deliveryDateColor = Colors.red.withOpacity(1);
      deliveryDateTextColor=Colors.white;
      Future.delayed(Duration(seconds: 1),(){
        setState(() {
          deliveryDateColor = Colors.white;
          deliveryDateTextColor=AppTheme.primaryColor;
        });
      });
    });
  }
}

