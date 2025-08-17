import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monasbah/core/app_theme.dart';

import 'package:monasbah/core/others/MyFlashBar.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/core/widgets/Buttons/primaryButton.dart';
import 'package:monasbah/core/widgets/Others/TextFormFieldContainer.dart';
import 'package:monasbah/core/widgets/cachedNetworkImage.dart';
import 'package:monasbah/features/customers/settings/presentation/widgets/edituserdetailsscreen.dart';
import 'package:monasbah/features/ServiceProviders/mainMenu/presintaion/pages/serviceProviderMainMenuPage.dart';
import 'package:monasbah/features/customers/home/presentation/pages/customerMainHomeRoute.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'package:monasbah/features/users/data/models/editUserDetailsModel.dart';
import 'package:monasbah/features/users/data/models/serviceProviderModel.dart';
import 'package:monasbah/features/users/presentation/manager/editUserDetails/editUsersDetailsBloc.dart';
import 'package:monasbah/features/users/presentation/manager/editUserDetails/editUsersDetailsEvent.dart';
import 'package:monasbah/features/users/presentation/manager/editUserDetails/editUsersDetailsState.dart';
import 'package:monasbah/injection_container.dart';

class EditUserDetailsPage extends StatefulWidget {
  String userBrand;
  String? image;

  EditUserDetailsPage({required this.userBrand, required this.image});

  @override
  State<EditUserDetailsPage> createState() => _EditUserDetailsPageState();
}

class _EditUserDetailsPageState extends State<EditUserDetailsPage> {
  late CustomerModel? customerModel;
  late ServiceProviderModel? serviceProviderModel;
  bool requestPending = false;
  late String userName,
      managerName,
      phoneNumber,
      image,
      email,
      password,
      confirmPassword;

  final editUserDetailsFormKey = GlobalKey<FormState>();
  File? galleryImage;
  String imageChanged = 'no';
  @override
  void initState() {
    final customerResult = checkCustomerLoggedIn();
    final providerResult = checkServiceProviderLoggedIn();

    customerModel = customerResult.fold((l) => l, (r) => null);
    serviceProviderModel = providerResult.fold((l) => l, (r) => null);

    userName = customerModel?.userName ?? 'null';
    managerName = serviceProviderModel?.managerName ?? 'null';
    phoneNumber =
        customerModel?.phoneNumber ?? serviceProviderModel?.phoneNumber ?? '';
    email = customerModel?.email ?? serviceProviderModel?.email ?? '';
    image = widget.image ?? '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(jsonEncode(customerModel));
    return EditUserDetailsScreen(
      headerText: 'قم بتعديل بياناتك الشخصيه',
      child: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => sl<EditUserDetailsBloc>(),
          child: BlocConsumer<EditUserDetailsBloc, EditUserDetailsState>(
            listener: (_context, state) {
              if (state is EditUserDetailsLoaded) {
                setState(() {
                  requestPending = false;
                });
                MyFlashBar(
                    title: 'تم',
                    context: context,
                    icon: Icons.check,
                    iconColor: Colors.white,
                    backgroundColor: Colors.green,
                    message: state.message,
                    thenDo: () {
                      widget.userBrand == 'customer'
                          ? Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                              return CustomerMainHomeRoute(currentIndex: 0);
                            }))
                          : Navigator.pushReplacement(context,
                              MaterialPageRoute(builder: (context) {
                              return ServiceProviderMainMenuPage();
                            }));
                    }).showFlashBar();
              } else if (state is EditUserDetailsError) {
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
                        thenDo: () {})
                    .showFlashBar();
              }
            },
            builder: (_context, state) {
              return Form(
                key: editUserDetailsFormKey,
                child: Column(
                  children: [
                    SizedBox(height: 20),
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
                                    child: widget.image == null
                                        ? Icon(
                                            Icons.camera_alt_outlined,
                                            size: 50,
                                            color: AppTheme.primaryColor,
                                          )
                                        : ClipOval(
                                            child: cachedNetworkImage(
                                              widget.image ?? '',
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
                    Visibility(
                      visible: widget.userBrand == 'customer' ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextFormFieldContainer(
                          withInitialValue: true,
                          initialValue: userName,
                          hint: "اسم المستخدم",
                          maxLength: 45,
                          onChange: (newValue) {
                            userName = newValue.trim();
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'يجب إدخال إسم المستخدم';
                            } else if (!RegExp(r'^[a-zA-Z\u0621-\u064A]+$')
                                .hasMatch(value.toString())) {
                              return 'يجب أن يحتوي إسم المستخدم على أحرف فقط';
                            }
                            return null;
                          },
                          autofocus: true,
                        ),
                      ),
                    ),
                    Visibility(
                      visible:
                          widget.userBrand == 'serviceProvider' ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: TextFormFieldContainer(
                          withInitialValue: true,
                          initialValue: managerName,
                          hint: "اسم المدير",
                          maxLength: 50,
                          onChange: (newValue) {
                            managerName = newValue.trim();
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'الرجاء تعبئة الحقل';
                            } else if (!RegExp(r'^[a-zA-Z\u0621-\u064A\s]+$')
                                .hasMatch(value.toString())) {
                              return 'يجب أن يحتوي إسم المدير على أحرف فقط';
                            }
                            return null;
                          },
                          autofocus: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        withInitialValue: true,
                        initialValue: phoneNumber,
                        hint: "رقم الهاتف",
                        maxLength: 9,
                        textInputType: TextInputType.phone,
                        onChange: (newValue) {
                          phoneNumber = newValue.trim();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'الرجاء تعبئة الحقل';
                          }
                          if (value.toString().length < 9) {
                            return 'يجب أن يتكون رقم الهاتف من 9 أرقام';
                          }
                          if (!value
                              .toString()
                              .startsWith(RegExp(r'[7][7|1|3|8|0]'))) {
                            return ' يجب أن يبدا رقم الهاتف ب 73 او 70 او 71 او 77  ';
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        withInitialValue: true,
                        initialValue: email,
                        hint: "الإيميل",
                        textInputType: TextInputType.emailAddress,
                        onChange: (newValue) {
                          email = newValue.trim();
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'يجب ادخال عنوان البريد الالكتروني';
                          } else if (!RegExp(
                                  r"^[a-zA-Z]{3}[a-zA-Z0-9]{0,5}@[a-zA-Z0-9]+\.[a-zA-Z]+$")
                              .hasMatch(value)) {
                            // Handle invalid email

                            return "لقد قمت بادخال الايميل بطريقة خاطئة";
                          }

                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        hint: "كلمه المرور",
                        textInputType: TextInputType.text,
                        onChange: (newValue) {
                          password = newValue.trim();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'الرجاء تعبئة الحقل';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: TextFormFieldContainer(
                        hint: "تأكيد كلمه المرور",
                        textInputType: TextInputType.text,
                        onChange: (newValue) {
                          confirmPassword = newValue.trim();
                        },
                        validator: (value) {
                          if (value.toString().isEmpty) {
                            return 'الرجاء تعبئة الحقل';
                          }
                          if (value.toString() != password) {
                            return 'كلمة المرور غير متطابقه';
                          }
                          return null;
                        },
                        obscureText: true,
                      ),
                    ),
                    PrimaryButton(
                      title: "تعديل",
                      pending: requestPending,
                      marginTop: .01,
                      onPressed: () {
                        if (editUserDetailsFormKey.currentState!.validate()) {
                          setState(() {
                            requestPending = true;
                          });

                          BlocProvider.of<EditUserDetailsBloc>(_context).add(
                            EditUserDetails(
                              editUserDetailsModel: EditUserDetailsModel(
                                  userName: userName,
                                  password: password,
                                  phoneNumber: phoneNumber,
                                  email: email,
                                  managerName: managerName,
                                  userBrand: widget.userBrand,
                                  token: customerModel != null
                                      ? customerModel!.token
                                      : serviceProviderModel!.token,
                                  image: image,
                                  imageChanged: imageChanged),
                            ),
                          );
                        }
                      },
                    ),
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
