import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/customDropDownForCities.dart';
import 'package:monasbah/core/others/customDropDownForSections.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';

import 'package:monasbah/core/util/ScreenUtil.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/features/customers/settings/presentation/widgets/edituserdetailsscreen.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/citiesModel.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/serviceSddressModel.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesBloc.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesEvent.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesState.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/pages/addNewCustomerLocationPage.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/pages/serviceProviderMainMenuPage.dart';

import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMinuState.dart';
import 'package:monasbah/features/customers/services/data/models/addNewServiceModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/services/servicesState.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/injection_container.dart';

class AddNewServicePage extends StatefulWidget {
  @override
  State<AddNewServicePage> createState() => _AddNewServicePageState();
}

class _AddNewServicePageState extends State<AddNewServicePage> {
  bool sectionsLoading = false, citiesLoading = false, requestPending = false;
  String city = '', section = '', sectionId = '', cityId = '';

  late String serviceName, price, discount, phoneNumber;
  String scale = 'null',
      facebook = 'null',
      instagram = 'null',
      twitter = 'null',
      youtube = 'null';

  Color cityColor = Colors.transparent;

  ///initial mainMenu
  List<MainMenuSectionsModel> sections = [
    MainMenuSectionsModel(
        sectionImage: 'asdsdfsdf', sectionName: 'fasdfasdf', id: 1)
  ];

  ///initial cities
  List<CitiesModel> cities = [CitiesModel(city: 'sana\'a', id: 1)];

  final addNewServiceFormKey = GlobalKey<FormState>();
  late ServiceAddressModel address;
  bool selectAddress = false;
  File? galleryImage;
  Color addLocationColor = Colors.white;
  Color addLocationTextColor = AppTheme.primaryColor;

  ServiceProviderModel? serviceProviderModel;
  @override
  void initState() {
    checkServiceProviderLoggedIn().fold((l) {
      serviceProviderModel = l;
    }, (r) {
      serviceProviderModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil().init(context);

    return EditUserDetailsScreen(
      headerText: "لإضافه خدمه الى تطبيقنا فضلاً أدخل البيانات الخاصه بخدمتك",
      child: SingleChildScrollView(
          child: BlocProvider(
        create: (context) => sl<ServicesBloc>(),
        child: BlocConsumer<ServicesBloc, ServicesState>(
          listener: (_context, state) {
            if (state is Loaded) {
              MyFlashBar(
                  title: 'تم',
                  context: context,
                  icon: Icons.check,
                  iconColor: Colors.white,
                  backgroundColor: Colors.green,
                  message: state.message,
                  thenDo: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return ServiceProviderMainMenuPage();
                    }));
                  }).showFlashBar();
              setState(() {
                requestPending = false;
              });
            }

            if (state is Error) {
              MyFlashBar(
                      title: 'خطأ',
                      context: context,
                      icon: Icons.error,
                      iconColor: Colors.white,
                      backgroundColor: Colors.red,
                      message: state.errorMessage,
                      thenDo: () {})
                  .showFlashBar();
              setState(() {
                requestPending = false;
              });
            }
          },
          builder: (_context, state) {
            return Form(
              key: addNewServiceFormKey,
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),

                  ///start image
                  GestureDetector(
                    child: Center(
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        child: ClipOval(
                          child: galleryImage != null
                              ? ClipOval(
                                  child: Image.file(
                                    galleryImage!,
                                    height: 160,
                                    width: 160,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : Container(
                                  color: AppTheme.primarySwatch.shade400,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.camera_alt_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      SubTitleText(
                                        text: 'اضف صوره لخدمتك',
                                        textColor: Colors.white,
                                        fontSize: 15,
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ),
                    ),
                    onTap: () async {
                      FilePickerResult? result =
                          await FilePicker.platform.pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpeg', 'jpg', 'gif', 'png'],
                      );

                      if (result != null) {
                        setState(() {
                          galleryImage = File(result.files.single.path ?? '');
                        });
                      } else {
                        // User canceled the picker
                      }
                    },
                  ),

                  ///end image

                  SizedBox(
                    height: 15,
                  ),

                  ///service name
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormFieldContainer(
                      hint: "إسم الخدمه",
                      onChange: (newValue) {
                        serviceName = newValue.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال إسم الخدمه';
                        }
                        return null;
                      },
                      autofocus: true,
                    ),
                  ),

                  ///service section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BlocProvider(
                      create: (context) => sl<MainMenuBloc>(),
                      child: BlocConsumer<MainMenuBloc, MainMenuState>(
                          listener: (_context, state) {
                        if (state is MainMenuError) {
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
                          setState(() {
                            sectionsLoading = false;
                          });
                        }

                        if (state is GetMainMenuSectionsLoaded) {
                          setState(() {
                            sections = state.mainMenuSectionsModel;
                            sectionsLoading = false;
                            section =
                                state.mainMenuSectionsModel[0].sectionName;
                            sectionId =
                                state.mainMenuSectionsModel[0].id.toString();
                          });
                        }
                      }, builder: (_context, state) {
                        if (state is MainMenuInitial) {
                          BlocProvider.of<MainMenuBloc>(_context).add(
                            //TODO::here change the real token
                            GetMainMenuSections(token: 'token'),
                          );
                        } else if (state is MainMenuLoading) {
                          sectionsLoading = true;
                        }
                        return AnimatedContainer(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: cityColor,
                          ),
                          duration: Duration(milliseconds: 700),
                          child: CustomDropDownForSections(
                            loading: sectionsLoading,
                            dropDownList: sections,
                            hint: "إختر نوع الخدمه",
                            dropDownValue: section,
                            onChange: (value) {
                              if (section != value) {
                                setState(() {
                                  section = value;
                                  sectionId = sections
                                      .firstWhere((element) =>
                                          element.sectionName == value)
                                      .id
                                      .toString();
                                  print(sectionId);
                                });
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  ///service phone number
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormFieldContainer(
                      hint: "رقم هاتف الخدمه",
                      onChange: (newValue) {
                        phoneNumber = newValue.trim();
                      },
                      maxLength: 9,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب ادخال رقم الهاتف';
                        } else if (!value
                            .startsWith(new RegExp(r'[7][7|1|3|7|0]'))) {
                          return 'يجب ان يبدأ رقم الهاتف ب 70 او 71 او 73 او 77';
                        } else if (value.length < 9) {
                          return 'يجب ان يكون رقم الهاتف من 9 خانات';
                        }
                        return null;
                      },
                    ),
                  ),

                  ///service price
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormFieldContainer(
                      hint: "السعر",
                      onChange: (newValue) {
                        price = newValue.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال سعر الخدمه';
                        }
                        if (int.parse(value.toString()) <= 0) {
                          return 'القيمه التي ادخلتها غير صالحه';
                        }

                        return null;
                      },
                      textInputType: TextInputType.number,
                    ),
                  ),

                  ///service scale
                  Visibility(
                    visible: section == 'صالات' ? true : false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        hint: "السعه",
                        onChange: (newValue) {
                          scale = newValue.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يجب إدخال سعر الخدمه';
                          }
                          if (int.parse(value.toString()) <= 0) {
                            return 'القيمه التي ادخلتها غير صالحه';
                          }

                          return null;
                        },
                        textInputType: TextInputType.number,
                      ),
                    ),
                  ),

                  ///service discount
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: TextFormFieldContainer(
                      hint: "التخفيض بالنسبه المئويه",
                      onChange: (newValue) {
                        discount = newValue.trim();
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'يجب إدخال سعر الخدمه';
                        }
                        if (int.parse(value.toString()) <= 0) {
                          return 'القيمه التي ادخلتها غير صالحه';
                        }
                        return null;
                      },
                      textInputType: TextInputType.number,
                    ),
                  ),

                  ///service cities
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: BlocProvider(
                      create: (context) => sl<CitiesBloc>(),
                      child: BlocConsumer<CitiesBloc, CitiesState>(
                          listener: (_context, state) {
                        if (state is GetCitiesError) {
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
                          setState(() {
                            citiesLoading = false;
                          });
                        }

                        if (state is GetCitiesLoaded) {
                          setState(() {
                            cities = state.citiesModel;
                            citiesLoading = false;
                            city = state.citiesModel[0].city;
                            cityId = state.citiesModel[0].id.toString();
                          });
                        }
                      }, builder: (_context, state) {
                        if (state is GetCitiesInitial) {
                          BlocProvider.of<CitiesBloc>(_context).add(
                            //TODO::here change the real token
                            GetCities(token: 'token'),
                          );
                        } else if (state is GetCitiesLoading) {
                          citiesLoading = true;
                        }
                        return AnimatedContainer(
                          margin: EdgeInsets.symmetric(vertical: 8.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 1.0, horizontal: 1.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: cityColor,
                          ),
                          duration: Duration(milliseconds: 700),
                          child: CustomDropDownForCities(
                            loading: citiesLoading,
                            dropDownList: cities,
                            hint: "إختر المدينه",
                            dropDownValue: city,
                            onChange: (value) {
                              if (cities != value) {
                                setState(() {
                                  city = value;
                                  cityId = cities
                                      .firstWhere(
                                          (element) => element.city == value)
                                      .id
                                      .toString();
                                  print(cityId);
                                });
                              }
                            },
                          ),
                        );
                      }),
                    ),
                  ),

                  ///service address
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: GestureDetector(
                      onTap: () async {
                        address = await Navigator.push(_context,
                            MaterialPageRoute(builder: (_context) {
                          return AddNewServiceAddressPage();
                        }));
                        print('the address is $address');
                        if (address.address != null &&
                            address.description != null) {
                          MyFlashBar(
                                  title: 'تم',
                                  context: context,
                                  icon: Icons.check,
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.green,
                                  message: 'تم تحديد الموقع بنجاح',
                                  thenDo: () {})
                              .showFlashBar();
                          setState(() {
                            selectAddress = true;
                          });
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: addLocationColor,
                          borderRadius: BorderRadius.circular(20.0),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(.03),
                                blurRadius: 8,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            textDirection: TextDirection.rtl,
                            children: [
                              SubTitleText(
                                  text: 'أختر موقع خدمتك',
                                  textColor: addLocationTextColor,
                                  fontSize: 15),
                              CircleAvatar(
                                child:
                                    Image.asset('assets/images/marked_map.png'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 15,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: ExpansionPanelList.radio(
                      animationDuration: Duration(seconds: 1),
                      dividerColor: Colors.red,
                      children: [
                        ExpansionPanelRadio(
                            value: '',
                            headerBuilder: (context, IsExpand) {
                              return ListTile(
                                title: SubTitleText(
                                  text: 'معلومات التواصل الإجتماعي',
                                  fontSize: 15,
                                  textColor: AppTheme.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                            body: Column(
                              textDirection: TextDirection.rtl,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: TextFormFieldContainer(
                                    hint: "رابط فيس بوك",
                                    onChange: (newValue) {
                                      facebook = newValue.trim();
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: TextFormFieldContainer(
                                    hint: "رابط انستقرام",
                                    onChange: (newValue) {
                                      instagram = newValue.trim();
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: TextFormFieldContainer(
                                    hint: "رابط تويتر",
                                    onChange: (newValue) {
                                      twitter = newValue.trim();
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 18.0),
                                  child: TextFormFieldContainer(
                                    hint: "رابط اليوتيوب",
                                    onChange: (newValue) {
                                      youtube = newValue.trim();
                                    },
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ))
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),

                  PrimaryButton(
                    title: "تأكيد الطلب",
                    textColor: Colors.white,
                    backgroundColor: AppTheme.primaryColor,
                    marginTop: .01,
                    pending: requestPending,
                    onPressed: () {
                      if (addNewServiceFormKey.currentState!.validate()) {
                        if (!selectAddress) {
                          setState(() {
                            addLocationColor = Colors.red.withOpacity(1);
                            addLocationTextColor = Colors.white;
                            Future.delayed(Duration(seconds: 1), () {
                              setState(() {
                                addLocationColor = Colors.transparent;
                                addLocationTextColor = AppTheme.primaryColor;
                              });
                            });
                          });
                        } else {
                          var fileContentBase64 =
                              base64.encode(galleryImage!.readAsBytesSync());
                          BlocProvider.of<ServicesBloc>(_context).add(
                            AddNewService(
                              addNewServiceModel: AddNewServiceModel(
                                  section_id: sectionId,
                                  description: address.description,
                                  address: address.address,
                                  long: address.long.toString(),
                                  lat: address.lat.toString(),
                                  city_id: cityId,
                                  name: serviceName,
                                  phoneNumber: phoneNumber,
                                  price: price.toString(),
                                  discount: discount.toString(),
                                  scale: section != 'صالات' ? 'null' : scale,
                                  image: fileContentBase64,
                                  token: serviceProviderModel!.token,
                                  facebook: facebook,
                                  instagram: instagram,
                                  twitter: twitter,
                                  youtube: youtube),
                            ),
                          );
                          setState(() {
                            requestPending = true;
                          });
                        }
                      }
                    },
                  )
                ],
              ),
            );
          },
        ),
      )),
    );
  }
}
