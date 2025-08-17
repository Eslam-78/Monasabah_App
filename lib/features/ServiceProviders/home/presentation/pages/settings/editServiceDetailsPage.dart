import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:monasbah/core/app_theme.dart';
import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/others/customDropDownForCities.dart';
import 'package:monasbah/core/others/customDropDownForSections.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/Texts/SubTitleText.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/customers/settings/presentation/widgets/edituserdetailsscreen.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/ServiceProviderMainHome.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/citiesModel.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/data/model/serviceSddressModel.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesBloc.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesEvent.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/manager/cities/citiesState.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/pages/addNewCustomerLocationPage.dart';
import 'package:monasbah/features/customers/home/data/models/mainMenuSectionsModel.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuBloc.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMenuEvent.dart';
import 'package:monasbah/features/customers/home/presentation/manager/mainMenu/mainMinuState.dart';
import 'package:monasbah/features/customers/services/data/models/serviceEditingModel.dart';
import 'package:monasbah/features/customers/services/data/models/servicesModel.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsBloc.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsEvent.dart';
import 'package:monasbah/features/customers/services/presentation/manager/servicesDetails/servicesDetailsState.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/injection_container.dart';

class EditServiceDetailsPage extends StatefulWidget {
  @override
  State<EditServiceDetailsPage> createState() => _EditServiceDetailsPageState();
}

class _EditServiceDetailsPageState extends State<EditServiceDetailsPage> {
  bool sectionsLoading = false, citiesLoading = false, requestPending = false;
  String city = '', section = '', sectionId = '', cityId = '', image = '';

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
  ServicesModel? servicesModel;
  ServiceProviderModel? serviceProviderModel;
  String imageChanged = 'no';

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
    address = ServiceAddressModel(
        address: servicesModel!.address,
        description: servicesModel!.description,
        long: servicesModel!.long.toString(),
        lat: servicesModel!.lat.toString());

    sectionId = servicesModel!.section_id.toString();
    cityId = servicesModel!.city_id.toString();

    serviceName = servicesModel!.name;
    phoneNumber = servicesModel!.phoneNumber;
    price = servicesModel!.price.toString();
    discount = servicesModel!.discount.toString();
    scale = servicesModel!.scale.toString();
    image = servicesModel!.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return EditUserDetailsScreen(
      headerText: '"قم بتعديل البيانات الخاصه بخدمتك"',
      child: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => sl<ServicesDetailsBloc>(),
          child: BlocConsumer<ServicesDetailsBloc, ServicesDetailsState>(
            listener: (_context, state) {
              if (state is EditServiceDetailsDone) {
                MyFlashBar(
                    title: 'تم',
                    context: context,
                    icon: Icons.check,
                    iconColor: Colors.white,
                    backgroundColor: Colors.green,
                    message: state.message,
                    thenDo: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return ServiceProviderMainHomeRoute(
                            currentIndex: 2,
                          );
                        }),
                      );
                    }).showFlashBar();
                setState(() {
                  requestPending = false;
                });
              }

              if (state is ServicesDetailsError) {
                MyFlashBar(
                    title: 'خطأ',
                    context: context,
                    icon: Icons.error,
                    iconColor: Colors.white,
                    backgroundColor: Colors.red,
                    message: state.errorMessage,
                    thenDo: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return ServiceProviderMainHomeRoute(
                          currentIndex: 2,
                        );
                      }));
                    }).showFlashBar();
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

                    GestureDetector(
                      child: Center(
                        child: Container(
                          height: 150,
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                          ),
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
                                    color: Colors.white,
                                    child: image == null
                                        ? Icon(
                                            Icons.camera_alt_outlined,
                                            size: 50,
                                            color: AppTheme.primaryColor,
                                          )
                                        : ClipOval(
                                            child: cachedNetworkImage(
                                              image,
                                              imagePath: '',
                                              height: 160.0,
                                              width: 160.0,
                                            ),
                                          ),
                                  ),
                          ),
                        ),
                      ),
                      onTap: () async {
                        FilePickerResult? result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['jpg', 'jpeg', 'png', 'gif'],
                        );

                        if (result != null) {
                          String? filePath = result.files.single.path;
                          String fileExtension =
                              filePath!.split('.').last.toLowerCase();

                          if (['jpg', 'jpeg', 'png', 'gif']
                              .contains(fileExtension)) {
                            setState(() {
                              galleryImage = File(filePath);
                              image = base64
                                  .encode(galleryImage!.readAsBytesSync());
                              imageChanged = 'yes';
                            });
                          } else {
                            MyFlashBar(
                              title: 'خطأ',
                              context: context,
                              icon: Icons.error,
                              iconColor: Colors.white,
                              backgroundColor: Colors.red,
                              message:
                                  'الرجاء اختيار صورة من الأنواع المسموح بها (jpg, jpeg, png, gif)',
                              thenDo: () {},
                            ).showFlashBar();
                          }
                        } else {
                          // User canceled the picker
                        }
                      },
                    ),

                    ///service name
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        withInitialValue: true,
                        initialValue: serviceName,
                        hint: "إسم الخدمه",
                        onChange: (newValue) {
                          serviceName = newValue.trim();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'الرجاء تعبئة الحقل';
                          } else if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$')
                              .hasMatch(value.toString())) {
                            return 'يجب أن يحتوي إسم الخدمة على أحرف فقط';
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
                            // getSectionId(state.mainMenuSectionsModel);
                            setState(() {
                              sections = state.mainMenuSectionsModel;
                              sectionsLoading = false;
                              section = servicesModel!.sectionName;
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
                        withInitialValue: true,
                        initialValue: phoneNumber,
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
                        withInitialValue: true,
                        initialValue: price.toString(),
                        hint: "السعر",
                        maxLength: 10,
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
                          withInitialValue: true,
                          initialValue: scale.toString(),
                          hint: "السعه",
                          onChange: (newValue) {
                            scale = newValue.trim();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'يجب إدخال سعر الخدمه';
                            }
                            int priceValue = int.parse(value);
                            if (priceValue <= 0 || priceValue > 3000000) {
                              return 'القيمة التي أدخلتها غير صالحة. يجب أن يكون السعر بين 0 و 3000000';
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
                        withInitialValue: true,
                        initialValue: discount.toString(),
                        hint: "الخصم",
                        onChange: (newValue) {
                          discount = newValue.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يجب إدخال الخصم';
                          }
                          int discountValue = int.parse(value);
                          if (discountValue < 0 || discountValue > 50) {
                            return 'القيمة التي أدخلتها غير صالحة. يجب أن يكون الخصم بين 0 و 50%';
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
                              city = servicesModel!.city;
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
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
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
                                    text: 'تعديل موقع خدمتك',
                                    textColor: AppTheme.primaryColor,
                                    fontSize: 15),
                                CircleAvatar(
                                  child: Image.asset(
                                      'assets/images/marked_map.png'),
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
                                      if (value!.isEmpty) {
                                        return 'يجب إدخال رابط فيس بوك';
                                      }
                                      if (!value.startsWith('https://') &&
                                          !value.startsWith('http://')) {
                                        return 'يجب أن يبدأ الرابط بـ https:// أو http://';
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
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
                                      if (value!.isEmpty) {
                                        return 'يجب إدخال رابط انستقرام';
                                      }
                                      if (!value.startsWith('https://') &&
                                          !value.startsWith('http://')) {
                                        return 'يجب أن يبدأ الرابط بـ https:// أو http://';
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
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
                                      if (value!.isEmpty) {
                                        return 'يجب إدخال رابط تويتر';
                                      }
                                      if (!value.startsWith('https://') &&
                                          !value.startsWith('http://')) {
                                        return 'يجب أن يبدأ الرابط بـ https:// أو http://';
                                      }
                                      return null;
                                    },
                                    textInputType: TextInputType.text,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 10,
                    ),

                    PrimaryButton(
                        title: "تعديل",
                        textColor: Colors.white,
                        backgroundColor: AppTheme.primaryColor,
                        marginTop: .01,
                        pending: requestPending,
                        onPressed: () {
                          if (addNewServiceFormKey.currentState!.validate()) {
                            setState(() {
                              requestPending = true;
                            });

                            BlocProvider.of<ServicesDetailsBloc>(_context)
                                .add(EditServiceDetails(
                                    editServiceModel: EditServiceModel(
                              id: servicesModel!.id.toString(),
                              name: serviceName,
                              section_id: sectionId.toString(),
                              image: image,
                              imageChanged: imageChanged,
                              phoneNumber: phoneNumber,
                              price: price,
                              scale: section != 'صالات' ? 'null' : scale,
                              discount: discount.toString(),
                              address_id: servicesModel!.address_id.toString(),
                              city_id: cityId.toString(),
                              address: address.address,
                              description: address.description,
                              lat: address.lat.toString(),
                              long: address.long.toString(),
                              token: serviceProviderModel!.token,
                              facebook: facebook,
                              instagram: instagram,
                              twitter: instagram,
                              youtube: youtube,
                            )));
                          }
                        })
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
